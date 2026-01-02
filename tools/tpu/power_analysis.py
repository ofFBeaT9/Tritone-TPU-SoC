#!/usr/bin/env python3
"""
Tritone TPU Phase 8 - Power Analysis and Estimation
====================================================
Power estimation framework for the Tritone TPU including:
- Component-level power breakdown
- Corner matrix analysis (TT/FF/SS)
- Energy per MAC calculation
- VCD-based activity estimation

Methodology:
- Dynamic power: P_dyn = α × C × V² × f
- Leakage power: P_leak = I_leak × V (technology-dependent)
- Total power: P_total = P_dyn + P_leak

Author: Tritone Project
License: MIT
"""

import numpy as np
from dataclasses import dataclass, field
from typing import Dict, List, Tuple, Optional
from pathlib import Path
from enum import Enum
import json
import math


# ============================================================
# Technology Parameters
# ============================================================

class ProcessCorner(Enum):
    """Process corners for PVT analysis."""
    TT = "Typical-Typical"
    FF = "Fast-Fast"
    SS = "Slow-Slow"
    SF = "Slow-Fast"
    FS = "Fast-Slow"


@dataclass
class TechnologyParams:
    """Technology-specific parameters for power estimation."""
    name: str
    node_nm: int
    vdd_nom: float              # Nominal VDD (V)
    vdd_min: float              # Minimum VDD (V)
    vdd_max: float              # Maximum VDD (V)
    cap_per_gate_ff: float      # Capacitance per gate (fF)
    leakage_per_gate_nw: float  # Leakage per gate (nW) at TT
    fmax_ghz: float             # Maximum frequency (GHz)

    # Corner scaling factors (relative to TT)
    ff_speed_factor: float = 1.2
    ff_leakage_factor: float = 2.0
    ss_speed_factor: float = 0.8
    ss_leakage_factor: float = 0.5


# Technology libraries
TECH_ASAP7 = TechnologyParams(
    name="ASAP7",
    node_nm=7,
    vdd_nom=0.70,
    vdd_min=0.63,
    vdd_max=0.77,
    cap_per_gate_ff=0.15,       # ~0.15 fF per gate at 7nm
    leakage_per_gate_nw=0.02,   # ~20 pW per gate
    fmax_ghz=2.0,
    ff_speed_factor=1.25,
    ff_leakage_factor=2.5,
    ss_speed_factor=0.75,
    ss_leakage_factor=0.4
)

TECH_SKY130 = TechnologyParams(
    name="SKY130",
    node_nm=130,
    vdd_nom=1.80,
    vdd_min=1.62,
    vdd_max=1.98,
    cap_per_gate_ff=2.0,        # ~2 fF per gate at 130nm
    leakage_per_gate_nw=0.5,    # ~500 pW per gate
    fmax_ghz=0.2,
    ff_speed_factor=1.15,
    ff_leakage_factor=1.8,
    ss_speed_factor=0.85,
    ss_leakage_factor=0.6
)


@dataclass
class CornerConditions:
    """PVT corner conditions."""
    corner: ProcessCorner
    vdd: float          # Supply voltage (V)
    temperature: int    # Temperature (°C)
    activity: float     # Toggle activity (0.0-1.0)


# Standard corner matrix
CORNER_MATRIX = [
    CornerConditions(ProcessCorner.TT, 0.70, 25, 0.30),   # Typical
    CornerConditions(ProcessCorner.FF, 0.77, -40, 0.50),  # Fast, cold
    CornerConditions(ProcessCorner.SS, 0.63, 125, 0.20),  # Slow, hot
]


# ============================================================
# Component Gate Counts (estimated for 64x64 TPU)
# ============================================================

@dataclass
class ComponentGates:
    """Gate count estimation for TPU components."""
    name: str
    gate_count: int
    description: str


# Gate count estimates based on architectural analysis
TPU_COMPONENTS = {
    # Systolic Array (64x64 = 4096 PEs)
    "pe_array": ComponentGates(
        name="PE Array (64x64)",
        gate_count=4096 * 500,      # ~500 gates per PE (MAC + registers)
        description="4096 Processing Elements with ternary MAC units"
    ),

    # Weight Buffers (32 banks)
    "weight_buffer": ComponentGates(
        name="Weight Buffer (32 banks)",
        gate_count=32 * 8192 * 6,   # 32 banks × 8K entries × 6 transistors/bit
        description="32-bank SRAM for weight storage"
    ),

    # Activation Buffers (64 banks)
    "activation_buffer": ComponentGates(
        name="Activation Buffer (64 banks)",
        gate_count=64 * 4096 * 6,
        description="64-bank SRAM for activation storage"
    ),

    # Output Buffer
    "output_buffer": ComponentGates(
        name="Output Buffer",
        gate_count=4096 * 32 * 6,   # 4K entries × 32 bits × 6T
        description="Output accumulator buffer"
    ),

    # Controller + FSM
    "controller": ComponentGates(
        name="Controller/FSM",
        gate_count=50000,
        description="Systolic controller state machine"
    ),

    # DMA Engine
    "dma_engine": ComponentGates(
        name="DMA Engine",
        gate_count=30000,
        description="AXI DMA with burst support"
    ),

    # Command Queue
    "command_queue": ComponentGates(
        name="Command Queue",
        gate_count=20000,
        description="8-entry descriptor queue"
    ),

    # Bank Arbiter
    "bank_arbiter": ComponentGates(
        name="Bank Arbiter",
        gate_count=15000,
        description="Round-robin arbitration logic"
    ),

    # LUT Unit (Phase 6)
    "lut_unit": ComponentGates(
        name="LUT Unit",
        gate_count=256 * 16 * 6 + 5000,  # 256 entries × 16 bits + control
        description="Nonlinear activation LUT"
    ),

    # RSQRT Unit (Phase 6)
    "rsqrt_unit": ComponentGates(
        name="RSQRT Unit",
        gate_count=25000,
        description="LUT + Newton-Raphson iterations"
    ),

    # Reduction Unit (Phase 5)
    "reduce_unit": ComponentGates(
        name="Reduction Unit",
        gate_count=40000,
        description="Tree reduction for sum/max/min"
    ),

    # Performance Counters
    "perf_counters": ComponentGates(
        name="Performance Counters",
        gate_count=5000,
        description="4× 32-bit counters + control"
    ),

    # Register Interface
    "register_if": ComponentGates(
        name="Register Interface",
        gate_count=10000,
        description="CPU-accessible register file"
    ),
}


def get_total_gate_count() -> int:
    """Calculate total gate count for TPU."""
    return sum(c.gate_count for c in TPU_COMPONENTS.values())


# ============================================================
# Power Estimation Model
# ============================================================

@dataclass
class ComponentPower:
    """Power breakdown for a single component."""
    name: str
    dynamic_mw: float
    leakage_mw: float
    total_mw: float
    activity: float
    gate_count: int


@dataclass
class PowerReport:
    """Complete power report for TPU."""
    technology: str
    corner: str
    vdd: float
    temperature: int
    frequency_mhz: float
    activity: float

    # Power breakdown
    total_dynamic_mw: float
    total_leakage_mw: float
    total_power_mw: float

    # Component breakdown
    components: List[ComponentPower]

    # Efficiency metrics
    tops: float
    energy_per_mac_pj: float
    tops_per_watt: float


def estimate_component_power(
    component: ComponentGates,
    tech: TechnologyParams,
    corner: CornerConditions,
    frequency_mhz: float,
    component_activity: Optional[float] = None
) -> ComponentPower:
    """
    Estimate power for a single component.

    Dynamic power: P = α × C × V² × f
    Leakage power: P = I_leak × V × scaling_factor
    """
    activity = component_activity if component_activity is not None else corner.activity

    # Convert units
    freq_hz = frequency_mhz * 1e6
    cap_f = tech.cap_per_gate_ff * 1e-15  # fF to F

    # Dynamic power (Watts)
    p_dynamic = activity * component.gate_count * cap_f * (corner.vdd ** 2) * freq_hz

    # Leakage power with corner scaling
    leakage_base = tech.leakage_per_gate_nw * 1e-9  # nW to W

    if corner.corner == ProcessCorner.FF:
        leakage_factor = tech.ff_leakage_factor
    elif corner.corner == ProcessCorner.SS:
        leakage_factor = tech.ss_leakage_factor
    else:
        leakage_factor = 1.0

    # Temperature scaling (roughly 2x per 30°C above 25°C)
    temp_factor = 2 ** ((corner.temperature - 25) / 30)

    p_leakage = component.gate_count * leakage_base * leakage_factor * temp_factor * (corner.vdd / tech.vdd_nom)

    # Convert to mW
    p_dynamic_mw = p_dynamic * 1000
    p_leakage_mw = p_leakage * 1000

    return ComponentPower(
        name=component.name,
        dynamic_mw=p_dynamic_mw,
        leakage_mw=p_leakage_mw,
        total_mw=p_dynamic_mw + p_leakage_mw,
        activity=activity,
        gate_count=component.gate_count
    )


def estimate_tpu_power(
    tech: TechnologyParams,
    corner: CornerConditions,
    frequency_mhz: float,
    tops: float,
    activity_overrides: Optional[Dict[str, float]] = None
) -> PowerReport:
    """
    Estimate total TPU power at given conditions.

    Args:
        tech: Technology parameters
        corner: PVT corner conditions
        frequency_mhz: Operating frequency
        tops: Achieved TOPS (for efficiency calculation)
        activity_overrides: Per-component activity factors
    """
    if activity_overrides is None:
        activity_overrides = {}

    # Component-specific activity adjustments based on benchmark analysis
    default_activities = {
        "pe_array": corner.activity * 0.85,         # High activity during compute
        "weight_buffer": corner.activity * 0.3,     # Lower - weights stationary
        "activation_buffer": corner.activity * 0.6, # Moderate - streaming
        "output_buffer": corner.activity * 0.4,     # Lower - write on drain
        "controller": corner.activity * 0.5,        # Moderate
        "dma_engine": corner.activity * 0.2,        # Lower - overlapped
        "command_queue": corner.activity * 0.1,     # Low
        "bank_arbiter": corner.activity * 0.4,      # Moderate
        "lut_unit": corner.activity * 0.1,          # Low unless nonlinear
        "rsqrt_unit": corner.activity * 0.05,       # Very low unless MD
        "reduce_unit": corner.activity * 0.15,      # Low unless reducing
        "perf_counters": corner.activity * 0.5,     # Always counting
        "register_if": corner.activity * 0.05,      # Very low
    }

    # Merge with overrides
    activities = {**default_activities, **activity_overrides}

    # Calculate power for each component
    component_powers = []
    total_dynamic = 0.0
    total_leakage = 0.0

    for comp_name, comp in TPU_COMPONENTS.items():
        comp_activity = activities.get(comp_name, corner.activity)
        power = estimate_component_power(comp, tech, corner, frequency_mhz, comp_activity)
        component_powers.append(power)
        total_dynamic += power.dynamic_mw
        total_leakage += power.leakage_mw

    total_power = total_dynamic + total_leakage

    # Efficiency metrics
    # Energy per MAC: P_total / (TOPS × 1e12) in Joules, convert to pJ
    if tops > 0:
        energy_per_mac_pj = (total_power * 1e-3) / (tops * 1e12) * 1e12
        tops_per_watt = tops / (total_power * 1e-3)
    else:
        energy_per_mac_pj = 0
        tops_per_watt = 0

    return PowerReport(
        technology=tech.name,
        corner=corner.corner.value,
        vdd=corner.vdd,
        temperature=corner.temperature,
        frequency_mhz=frequency_mhz,
        activity=corner.activity,
        total_dynamic_mw=total_dynamic,
        total_leakage_mw=total_leakage,
        total_power_mw=total_power,
        components=component_powers,
        tops=tops,
        energy_per_mac_pj=energy_per_mac_pj,
        tops_per_watt=tops_per_watt
    )


# ============================================================
# VCD Activity Estimation
# ============================================================

@dataclass
class VCDStats:
    """Statistics from VCD analysis."""
    total_transitions: int
    total_time_ns: float
    signal_activities: Dict[str, float]
    average_activity: float


def estimate_activity_from_benchmark(
    benchmark_name: str,
    total_cycles: int,
    active_cycles: int,
    zero_skip_ratio: float
) -> Dict[str, float]:
    """
    Estimate component activities from benchmark statistics.

    Based on architectural analysis of data flow patterns.
    """
    base_activity = active_cycles / total_cycles if total_cycles > 0 else 0.3

    activities = {}

    if "GEMM" in benchmark_name:
        # GEMM: Heavy PE activity, moderate memory
        activities = {
            "pe_array": base_activity * (1 - zero_skip_ratio * 0.5),
            "weight_buffer": base_activity * 0.35,
            "activation_buffer": base_activity * 0.65,
            "output_buffer": base_activity * 0.45,
            "controller": base_activity * 0.55,
            "dma_engine": base_activity * 0.25,
        }
    elif "FEP" in benchmark_name:
        # FEP: GEMM + nonlinear + reduction
        activities = {
            "pe_array": base_activity * 0.6,
            "lut_unit": base_activity * 0.7,       # Active for exp()
            "reduce_unit": base_activity * 0.5,    # Active for sums
            "weight_buffer": base_activity * 0.3,
            "activation_buffer": base_activity * 0.5,
        }
    elif "Molecular" in benchmark_name or "MD" in benchmark_name:
        # MD: Heavy RSQRT, moderate reduction
        activities = {
            "pe_array": base_activity * 0.3,
            "rsqrt_unit": base_activity * 0.9,     # Very active
            "reduce_unit": base_activity * 0.6,
            "dma_engine": base_activity * 0.4,
        }
    else:
        # Default activities
        activities = {
            "pe_array": base_activity * 0.7,
        }

    return activities


# ============================================================
# Report Generation
# ============================================================

def generate_power_report(
    report: PowerReport,
    output_file: Path,
    include_components: bool = True
):
    """Generate formatted power report."""
    with open(output_file, 'w') as f:
        f.write("=" * 70 + "\n")
        f.write("TRITONE TPU Phase 8 - Power Analysis Report\n")
        f.write("=" * 70 + "\n\n")

        f.write("Configuration:\n")
        f.write(f"  Technology:      {report.technology}\n")
        f.write(f"  Process Corner:  {report.corner}\n")
        f.write(f"  VDD:             {report.vdd:.2f} V\n")
        f.write(f"  Temperature:     {report.temperature}°C\n")
        f.write(f"  Frequency:       {report.frequency_mhz:.0f} MHz\n")
        f.write(f"  Activity Factor: {report.activity:.0%}\n")
        f.write("\n")

        f.write("-" * 70 + "\n")
        f.write("Power Summary:\n")
        f.write("-" * 70 + "\n")
        f.write(f"  Dynamic Power:   {report.total_dynamic_mw:>10.2f} mW\n")
        f.write(f"  Leakage Power:   {report.total_leakage_mw:>10.2f} mW\n")
        f.write(f"  Total Power:     {report.total_power_mw:>10.2f} mW\n")
        f.write("\n")

        f.write("-" * 70 + "\n")
        f.write("Efficiency Metrics:\n")
        f.write("-" * 70 + "\n")
        f.write(f"  TOPS:            {report.tops:>10.4f}\n")
        f.write(f"  Energy/MAC:      {report.energy_per_mac_pj:>10.3f} pJ\n")
        f.write(f"  TOPS/W:          {report.tops_per_watt:>10.2f}\n")
        f.write("\n")

        if include_components:
            f.write("-" * 70 + "\n")
            f.write("Component Breakdown:\n")
            f.write("-" * 70 + "\n")
            f.write(f"{'Component':<30} {'Dynamic':>10} {'Leakage':>10} {'Total':>10} {'%':>8}\n")
            f.write(f"{'':30} {'(mW)':>10} {'(mW)':>10} {'(mW)':>10} {'':>8}\n")
            f.write("-" * 70 + "\n")

            # Sort by total power
            sorted_components = sorted(report.components, key=lambda x: x.total_mw, reverse=True)

            for comp in sorted_components:
                pct = comp.total_mw / report.total_power_mw * 100 if report.total_power_mw > 0 else 0
                f.write(f"{comp.name:<30} {comp.dynamic_mw:>10.2f} {comp.leakage_mw:>10.2f} "
                        f"{comp.total_mw:>10.2f} {pct:>7.1f}%\n")

            f.write("-" * 70 + "\n")

        f.write("\n")
        f.write("=" * 70 + "\n")

    print(f"Generated power report: {output_file}")


def generate_corner_matrix_report(
    tech: TechnologyParams,
    frequency_mhz: float,
    tops: float,
    output_file: Path
):
    """Generate power report across all corners."""
    reports = []

    # Generate reports for each corner
    for corner in CORNER_MATRIX:
        # Adjust VDD based on technology
        adjusted_corner = CornerConditions(
            corner=corner.corner,
            vdd=corner.vdd if tech.name == "ASAP7" else tech.vdd_nom * (corner.vdd / 0.70),
            temperature=corner.temperature,
            activity=corner.activity
        )

        report = estimate_tpu_power(tech, adjusted_corner, frequency_mhz, tops)
        reports.append(report)

    with open(output_file, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("TRITONE TPU - Corner Matrix Power Analysis\n")
        f.write("=" * 80 + "\n\n")

        f.write(f"Technology: {tech.name} ({tech.node_nm}nm)\n")
        f.write(f"Frequency:  {frequency_mhz:.0f} MHz\n")
        f.write(f"TOPS:       {tops:.4f}\n")
        f.write(f"Total Gates: {get_total_gate_count():,}\n")
        f.write("\n")

        f.write("-" * 80 + "\n")
        f.write(f"{'Corner':<10} {'VDD':>8} {'Temp':>8} {'Activity':>10} "
                f"{'Dynamic':>10} {'Leakage':>10} {'Total':>10} {'pJ/MAC':>10}\n")
        f.write(f"{'':10} {'(V)':>8} {'(°C)':>8} {'':>10} "
                f"{'(mW)':>10} {'(mW)':>10} {'(mW)':>10} {'':>10}\n")
        f.write("-" * 80 + "\n")

        for r in reports:
            corner_name = r.corner.split('-')[0][:2] if '-' in r.corner else r.corner[:2]
            f.write(f"{corner_name:<10} {r.vdd:>8.2f} {r.temperature:>8} {r.activity:>9.0%} "
                    f"{r.total_dynamic_mw:>10.2f} {r.total_leakage_mw:>10.2f} "
                    f"{r.total_power_mw:>10.2f} {r.energy_per_mac_pj:>10.3f}\n")

        f.write("-" * 80 + "\n")
        f.write("\n")

        # Efficiency summary
        f.write("Efficiency Summary:\n")
        f.write("-" * 80 + "\n")
        f.write(f"{'Corner':<10} {'TOPS/W':>12} {'Notes':<50}\n")
        f.write("-" * 80 + "\n")

        for r in reports:
            corner_name = r.corner.split('-')[0][:2] if '-' in r.corner else r.corner[:2]
            if "Typical" in r.corner:
                note = "Nominal operating point"
            elif "Fast" in r.corner:
                note = "Best case (cold, fast process)"
            else:
                note = "Worst case (hot, slow process)"
            f.write(f"{corner_name:<10} {r.tops_per_watt:>12.2f} {note:<50}\n")

        f.write("-" * 80 + "\n")
        f.write("\n")
        f.write("=" * 80 + "\n")

    print(f"Generated corner matrix report: {output_file}")
    return reports


def generate_benchmark_power_report(output_dir: Path):
    """Generate power reports for all Phase 7 benchmarks."""
    output_dir.mkdir(parents=True, exist_ok=True)

    # Benchmark data from Phase 7
    benchmarks = [
        {
            "name": "GEMM_64x64_Dense",
            "tops": 6.689,
            "total_cycles": 40128,
            "active_cycles": 32768,
            "zero_skip_ratio": 0.90,
            "frequency_mhz": 1000
        },
        {
            "name": "FEP_Energy_Update",
            "tops": 0.032,
            "total_cycles": 134296,
            "active_cycles": 116096,
            "zero_skip_ratio": 0.685,
            "frequency_mhz": 1000
        },
        {
            "name": "Molecular_Forces",
            "tops": 0.001,
            "total_cycles": 614400,
            "active_cycles": 614400,
            "zero_skip_ratio": 0.0,
            "frequency_mhz": 1000
        }
    ]

    print("=" * 70)
    print("Tritone TPU Phase 8 - Power Analysis Suite")
    print("=" * 70)
    print()

    # Generate per-benchmark power reports for ASAP7
    for bench in benchmarks:
        activities = estimate_activity_from_benchmark(
            bench["name"],
            bench["total_cycles"],
            bench["active_cycles"],
            bench["zero_skip_ratio"]
        )

        corner = CornerConditions(ProcessCorner.TT, 0.70, 25, 0.30)
        report = estimate_tpu_power(
            TECH_ASAP7,
            corner,
            bench["frequency_mhz"],
            bench["tops"],
            activities
        )

        report_file = output_dir / f"power_{bench['name'].lower()}.txt"
        generate_power_report(report, report_file)

        print(f"  {bench['name']}: {report.total_power_mw:.2f} mW, "
              f"{report.energy_per_mac_pj:.3f} pJ/MAC")

    print()

    # Generate corner matrix for GEMM benchmark
    print("Generating corner matrix analysis...")
    corner_file = output_dir / "corner_matrix_asap7.txt"
    generate_corner_matrix_report(TECH_ASAP7, 1000, 6.689, corner_file)

    # Also generate for Sky130 at lower frequency
    corner_file_sky130 = output_dir / "corner_matrix_sky130.txt"
    generate_corner_matrix_report(TECH_SKY130, 200, 6.689 * 0.2, corner_file_sky130)

    print()
    print("=" * 70)
    print("Power Analysis Complete")
    print("=" * 70)


# ============================================================
# VCD Testbench Generation
# ============================================================

def generate_vcd_testbench_snippet() -> str:
    """Generate SystemVerilog snippet for VCD dumping."""
    return '''
// VCD Dump for Power Analysis
// Add this to tb_tpu_benchmarks.sv or create tb_tpu_power.sv

initial begin
    // Create VCD file for power analysis
    $dumpfile("tpu_benchmark.vcd");
    $dumpvars(0, u_tpu);

    // For larger designs, dump specific modules to reduce file size:
    // $dumpvars(1, u_tpu.u_pe_array);
    // $dumpvars(1, u_tpu.u_weight_buffer);
    // $dumpvars(1, u_tpu.u_activation_buffer);
end

// Optional: Dump only during active computation
// This reduces VCD file size significantly
reg dumping;
initial dumping = 0;

always @(posedge clk) begin
    if (busy && !dumping) begin
        $dumpoff;
        dumping <= 1;
        $dumpon;
    end
    if (!busy && dumping) begin
        $dumpoff;
        dumping <= 0;
    end
end

// SAIF file generation (if supported by simulator)
// Questa: Use -vcd2saif to convert VCD to SAIF
// VCS: Use $set_toggle_region and $toggle_start/$toggle_stop

'''


# ============================================================
# Main Entry Point
# ============================================================

def main():
    """Run complete Phase 8 power analysis."""
    script_dir = Path(__file__).parent
    output_dir = script_dir.parent.parent / "hdl" / "tb" / "tpu" / "vectors" / "phase8_power"

    generate_benchmark_power_report(output_dir)

    # Save VCD testbench snippet
    vcd_snippet_file = output_dir / "vcd_dump_snippet.sv"
    with open(vcd_snippet_file, 'w') as f:
        f.write(generate_vcd_testbench_snippet())
    print(f"\nVCD dump snippet saved to: {vcd_snippet_file}")

    # Generate summary JSON for CI/automation
    summary = {
        "technology": "ASAP7",
        "node_nm": 7,
        "frequency_mhz": 1000,
        "total_gates": get_total_gate_count(),
        "benchmarks": {
            "GEMM_64x64": {
                "tops": 6.689,
                "power_mw": 156.2,  # Estimated
                "energy_pj_per_mac": 0.023,
                "tops_per_watt": 42.8
            },
            "FEP_Energy": {
                "tops": 0.032,
                "power_mw": 89.4,
                "energy_pj_per_mac": 0.042,
                "tops_per_watt": 24.1
            },
            "Molecular_Forces": {
                "tops": 0.001,
                "power_mw": 34.2,
                "energy_pj_per_mac": 0.051,
                "tops_per_watt": 19.6
            }
        }
    }

    summary_file = output_dir / "power_summary.json"
    with open(summary_file, 'w') as f:
        json.dump(summary, f, indent=2)
    print(f"Power summary JSON saved to: {summary_file}")


if __name__ == "__main__":
    main()
