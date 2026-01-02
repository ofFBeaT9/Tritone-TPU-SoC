#!/usr/bin/env python3
"""
Tritone TPU Phase 7 - Golden Benchmark Reference
=================================================
Golden reference model for TPU benchmark verification and TOPS calculation.

Benchmarks:
1. 64x64 Dense GEMM - Matrix multiplication throughput
2. FEP Energy Update - Matmul + nonlinear + reduction (Free Energy Perturbation)
3. Molecular Forces - RSQRT-based force calculations

TOPS Methodology:
- Dense TOPS = (2 * M * N * K) / runtime_seconds
- Utilization = active_cycles / total_cycles
- Report frequency, stalls, and bank conflicts separately

Author: Tritone Project
License: MIT
"""

import numpy as np
import struct
from pathlib import Path
from typing import Tuple, Dict, List, Optional
from dataclasses import dataclass
from enum import IntEnum
import math


# ============================================================
# Constants and Configuration
# ============================================================

ARRAY_SIZE = 64          # 64x64 systolic array
MAX_K = 4096             # Maximum K dimension
ACC_BITS = 32            # Accumulator bits
ACT_BITS = 16            # Activation bits
TARGET_FREQ_MHZ = 1000   # Target frequency for TOPS calculation


class TritWeight(IntEnum):
    """Ternary weight encoding (2-bit)."""
    NEG_ONE = 0b00  # -1
    ZERO = 0b01     # 0
    POS_ONE = 0b10  # +1


class ReductionOp(IntEnum):
    """Reduction operation types."""
    SUM = 0
    MAX = 1
    MIN = 2
    ABSSUM = 3


class NonlinearFunc(IntEnum):
    """Nonlinear function select."""
    SIGMOID = 0
    TANH = 1
    EXP = 2
    LOG = 3


@dataclass
class BenchmarkResult:
    """Benchmark result container."""
    name: str
    total_ops: int          # Total MAC or element operations
    total_cycles: int       # Total cycles (simulated)
    active_cycles: int      # Cycles with actual computation
    stall_cycles: int       # DMA/bank conflict stall cycles
    zero_skip_count: int    # Operations skipped due to zero weights
    utilization: float      # active_cycles / total_cycles
    tops_dense: float       # Dense TOPS (no sparsity)
    tops_effective: float   # Effective TOPS (with zero skip)
    frequency_mhz: float    # Operating frequency
    expected_output: np.ndarray  # Golden reference output


@dataclass
class GEMMConfig:
    """GEMM configuration."""
    m: int  # Output rows
    n: int  # Output columns
    k: int  # Inner dimension
    use_packing: bool = True
    use_dma: bool = True


# ============================================================
# Ternary MAC and GEMM Operations
# ============================================================

def ternary_mac(activation: int, weight: int, accumulator: int) -> Tuple[int, bool]:
    """Single ternary MAC operation."""
    if weight == TritWeight.ZERO or weight == 0b01:
        return accumulator, True  # Zero skip
    elif weight == TritWeight.NEG_ONE or weight == 0b00:
        return accumulator - activation, False
    elif weight == TritWeight.POS_ONE or weight == 0b10:
        return accumulator + activation, False
    else:
        return accumulator, True  # Invalid treated as zero


def ternary_gemm(
    activations: np.ndarray,
    weights: np.ndarray,
    config: Optional[GEMMConfig] = None
) -> Tuple[np.ndarray, Dict]:
    """
    Compute ternary GEMM: output = activations @ weights^T

    Args:
        activations: Input matrix (M, K) as signed integers
        weights: Weight matrix (N, K) with values in {-1, 0, +1}
        config: Optional GEMM configuration

    Returns:
        Tuple of (output matrix, statistics dict)
    """
    m, k = activations.shape
    n, k2 = weights.shape
    assert k == k2, f"Dimension mismatch: {k} vs {k2}"

    if config is None:
        config = GEMMConfig(m=m, n=n, k=k)

    output = np.zeros((m, n), dtype=np.int64)
    zero_skipped = 0
    total_macs = m * n * k

    for i in range(m):
        for j in range(n):
            acc = 0
            for kk in range(k):
                act = int(activations[i, kk])
                wgt = int(weights[j, kk])
                acc, skipped = ternary_mac(act, wgt, acc)
                if skipped:
                    zero_skipped += 1
            output[i, j] = acc

    stats = {
        'total_macs': total_macs,
        'zero_skipped': zero_skipped,
        'zero_skip_ratio': zero_skipped / total_macs if total_macs > 0 else 0,
        'effective_macs': total_macs - zero_skipped
    }

    return output, stats


def estimate_gemm_cycles(m: int, n: int, k: int, array_size: int = ARRAY_SIZE,
                         use_dma: bool = True, use_packing: bool = True) -> Dict:
    """
    Estimate cycle counts for GEMM on systolic array.

    Based on weight-stationary dataflow:
    - Weight load: K cycles per tile
    - Compute: M tiles * (K + array_drain) cycles
    - Output writeback: parallel with next tile (hidden if DMA enabled)
    """
    # Tile dimensions
    m_tiles = math.ceil(m / array_size)
    n_tiles = math.ceil(n / array_size)
    k_tiles = math.ceil(k / array_size)

    # Per-tile cycles
    weight_load_cycles = array_size  # Load one row per cycle
    if use_packing:
        weight_load_cycles = math.ceil(weight_load_cycles * 0.8)  # 20% reduction

    compute_cycles_per_k = array_size  # One K-slice per array_size cycles
    drain_cycles = array_size - 1  # Drain partial sums

    # DMA overlap
    if use_dma:
        dma_stall_cycles = 0  # Overlapped with compute
    else:
        dma_stall_cycles = weight_load_cycles * k_tiles  # Sequential

    # Total cycles per output tile
    cycles_per_tile = (
        weight_load_cycles +  # Initial weight load
        k * compute_cycles_per_k // array_size +  # Compute all K
        drain_cycles  # Final drain
    )

    total_tiles = m_tiles * n_tiles
    total_cycles = total_tiles * cycles_per_tile + dma_stall_cycles
    active_cycles = total_tiles * (k * compute_cycles_per_k // array_size)

    return {
        'total_cycles': total_cycles,
        'active_cycles': active_cycles,
        'stall_cycles': total_cycles - active_cycles,
        'm_tiles': m_tiles,
        'n_tiles': n_tiles,
        'k_tiles': k_tiles,
        'cycles_per_tile': cycles_per_tile
    }


# ============================================================
# Nonlinear Functions (LUT-based approximations)
# ============================================================

def sigmoid_lut(x: int, q_in: int = 8, q_out: int = 15) -> int:
    """
    LUT-based sigmoid approximation.
    Input: Q8.8 fixed-point
    Output: Q1.15 fixed-point (range 0 to ~1)
    """
    # Convert from Q8.8 to float
    x_float = x / (1 << q_in)
    # Compute sigmoid
    y_float = 1.0 / (1.0 + math.exp(-x_float)) if x_float > -20 else 0.0
    # Convert to Q1.15
    return int(y_float * (1 << q_out))


def tanh_lut(x: int, q_in: int = 8, q_out: int = 15) -> int:
    """LUT-based tanh approximation."""
    x_float = x / (1 << q_in)
    y_float = math.tanh(x_float)
    return int(y_float * (1 << q_out))


def exp_lut(x: int, q_in: int = 8, q_out: int = 15) -> int:
    """LUT-based exp approximation (clamped for stability)."""
    x_float = x / (1 << q_in)
    x_float = max(-10, min(10, x_float))  # Clamp to avoid overflow
    y_float = math.exp(x_float)
    return int(min(y_float, 32767) * (1 << (q_out - 15)))


def log_lut(x: int, q_in: int = 8, q_out: int = 15) -> int:
    """LUT-based log approximation (x > 0 required)."""
    x_float = x / (1 << q_in)
    if x_float <= 0:
        return -32768  # Minimum value for log(0)
    y_float = math.log(x_float)
    return int(y_float * (1 << q_out))


def apply_nonlinear(data: np.ndarray, func: NonlinearFunc) -> np.ndarray:
    """Apply nonlinear function to array."""
    funcs = {
        NonlinearFunc.SIGMOID: sigmoid_lut,
        NonlinearFunc.TANH: tanh_lut,
        NonlinearFunc.EXP: exp_lut,
        NonlinearFunc.LOG: log_lut
    }
    vec_func = np.vectorize(funcs[func])
    return vec_func(data)


# ============================================================
# RSQRT (Reciprocal Square Root) for Molecular Dynamics
# ============================================================

def rsqrt_newton(x: int, q_format: int = 16, iterations: int = 2) -> int:
    """
    Compute 1/sqrt(x) using Newton-Raphson iteration.

    Initial estimate from LUT, then refine with:
    y_new = y * (1.5 - 0.5 * x * y * y)
    """
    if x <= 0:
        return 0x7FFF  # Max value for invalid input

    # Convert to float for computation
    x_float = x / (1 << q_format)

    # Initial estimate (magic number approximation)
    y = 1.0 / math.sqrt(x_float) if x_float > 0 else 1e10

    # Newton-Raphson iterations
    half_x = 0.5 * x_float
    for _ in range(iterations):
        y = y * (1.5 - half_x * y * y)

    # Convert back to fixed-point
    return int(min(y * (1 << q_format), 0x7FFF))


def compute_force_rsqrt(r_squared: np.ndarray) -> np.ndarray:
    """
    Compute force scaling: f = 1/sqrt(r^2) = 1/r
    Used in molecular dynamics for inverse distance calculations.
    """
    vec_rsqrt = np.vectorize(rsqrt_newton)
    return vec_rsqrt(r_squared)


# ============================================================
# Reduction Operations
# ============================================================

def reduce_sum(data: np.ndarray) -> int:
    """Sum reduction with saturation."""
    result = np.sum(data, dtype=np.int64)
    # Saturate to 32-bit
    return int(max(-2**31, min(2**31 - 1, result)))


def reduce_max(data: np.ndarray) -> int:
    """Max reduction."""
    return int(np.max(data))


def reduce_min(data: np.ndarray) -> int:
    """Min reduction."""
    return int(np.min(data))


def reduce_abssum(data: np.ndarray) -> int:
    """Absolute sum reduction."""
    result = np.sum(np.abs(data), dtype=np.int64)
    return int(max(-2**31, min(2**31 - 1, result)))


def apply_reduction(data: np.ndarray, op: ReductionOp) -> int:
    """Apply reduction operation."""
    ops = {
        ReductionOp.SUM: reduce_sum,
        ReductionOp.MAX: reduce_max,
        ReductionOp.MIN: reduce_min,
        ReductionOp.ABSSUM: reduce_abssum
    }
    return ops[op](data)


# ============================================================
# Benchmark 1: 64x64 Dense GEMM
# ============================================================

def benchmark_gemm_64x64(seed: int = 42) -> BenchmarkResult:
    """
    64x64 Dense GEMM Benchmark.

    Tests full utilization of the systolic array with:
    - Dense weight matrix (minimal zero skip)
    - Large enough to reach steady-state
    - M=N=K=512 to hide fill/drain overhead
    """
    np.random.seed(seed)

    # Benchmark dimensions (large enough for steady-state)
    m, n, k = 512, 512, 512

    # Generate test data
    # Activations: 16-bit signed integers
    activations = np.random.randint(-1000, 1001, size=(m, k), dtype=np.int16)

    # Weights: Ternary {-1, 0, +1} with low zero density (~10%)
    weights = np.random.choice([-1, 0, 1], size=(n, k), p=[0.45, 0.10, 0.45])

    # Compute golden output
    output, stats = ternary_gemm(activations.astype(np.int64), weights)

    # Estimate cycles
    cycle_est = estimate_gemm_cycles(m, n, k, use_dma=True, use_packing=True)

    # Calculate TOPS
    total_ops = 2 * m * n * k  # 2 ops per MAC (multiply + add)
    frequency_hz = TARGET_FREQ_MHZ * 1e6
    runtime_sec = cycle_est['total_cycles'] / frequency_hz
    tops_dense = total_ops / runtime_sec / 1e12

    effective_ops = 2 * stats['effective_macs']
    tops_effective = effective_ops / runtime_sec / 1e12

    utilization = cycle_est['active_cycles'] / cycle_est['total_cycles']

    return BenchmarkResult(
        name="GEMM_64x64_Dense",
        total_ops=total_ops,
        total_cycles=cycle_est['total_cycles'],
        active_cycles=cycle_est['active_cycles'],
        stall_cycles=cycle_est['stall_cycles'],
        zero_skip_count=stats['zero_skipped'],
        utilization=utilization,
        tops_dense=tops_dense,
        tops_effective=tops_effective,
        frequency_mhz=TARGET_FREQ_MHZ,
        expected_output=output
    )


# ============================================================
# Benchmark 2: FEP Energy Update
# ============================================================

def benchmark_fep_energy(seed: int = 123) -> BenchmarkResult:
    """
    Free Energy Perturbation (FEP) Energy Update Benchmark.

    Pipeline:
    1. GEMM: Compute energy contributions (matmul)
    2. Nonlinear: Apply exp() for Boltzmann factor
    3. Reduction: Sum energies for total free energy

    Typical FEP workload: 256 configurations x 128 energy terms
    """
    np.random.seed(seed)

    # FEP dimensions
    num_configs = 256    # Number of molecular configurations
    energy_terms = 128   # Energy interaction terms
    state_dim = 64       # Internal state dimension

    # Stage 1: Energy computation (GEMM)
    config_features = np.random.randint(-500, 501, size=(num_configs, state_dim), dtype=np.int16)
    energy_weights = np.random.choice([-1, 0, 1], size=(energy_terms, state_dim), p=[0.35, 0.30, 0.35])

    energy_raw, gemm_stats = ternary_gemm(config_features.astype(np.int64), energy_weights)

    # Stage 2: Boltzmann factor (exp)
    # Scale energies to Q8.8 range for exp LUT
    energy_scaled = np.clip(energy_raw // 100, -2000, 2000).astype(np.int32)
    boltzmann = apply_nonlinear(energy_scaled, NonlinearFunc.EXP)

    # Stage 3: Reduction (sum per configuration)
    free_energies = np.array([reduce_sum(boltzmann[i, :]) for i in range(num_configs)])

    # Cycle estimation
    gemm_cycles = estimate_gemm_cycles(num_configs, energy_terms, state_dim)
    nonlinear_cycles = num_configs * energy_terms * 3  # ~3 cycles per LUT op
    reduction_cycles = num_configs * (energy_terms + math.ceil(math.log2(energy_terms)))  # Tree reduction

    total_cycles = gemm_cycles['total_cycles'] + nonlinear_cycles + reduction_cycles
    active_cycles = gemm_cycles['active_cycles'] + nonlinear_cycles + reduction_cycles // 2

    # TOPS calculation (count all operations)
    gemm_ops = 2 * num_configs * energy_terms * state_dim
    nonlinear_ops = num_configs * energy_terms  # 1 op per element
    reduction_ops = num_configs * energy_terms  # 1 op per element
    total_ops = gemm_ops + nonlinear_ops + reduction_ops

    frequency_hz = TARGET_FREQ_MHZ * 1e6
    runtime_sec = total_cycles / frequency_hz
    tops_dense = total_ops / runtime_sec / 1e12

    utilization = active_cycles / total_cycles

    return BenchmarkResult(
        name="FEP_Energy_Update",
        total_ops=total_ops,
        total_cycles=total_cycles,
        active_cycles=active_cycles,
        stall_cycles=total_cycles - active_cycles,
        zero_skip_count=gemm_stats['zero_skipped'],
        utilization=utilization,
        tops_dense=tops_dense,
        tops_effective=tops_dense * (1 - gemm_stats['zero_skip_ratio']),
        frequency_mhz=TARGET_FREQ_MHZ,
        expected_output=free_energies
    )


# ============================================================
# Benchmark 3: Molecular Forces
# ============================================================

def benchmark_molecular_forces(seed: int = 456) -> BenchmarkResult:
    """
    Molecular Dynamics Force Calculation Benchmark.

    Pipeline:
    1. Distance computation (from position delta GEMM)
    2. RSQRT for 1/r calculation
    3. Force accumulation (reduction)

    Typical MD workload: 1024 particles, cutoff neighbors ~50
    """
    np.random.seed(seed)

    num_particles = 1024
    avg_neighbors = 50
    spatial_dim = 3  # x, y, z

    # Stage 1: Position differences (simplified - normally from neighbor lists)
    # For benchmark, we compute pairwise distances for a subset
    subset_size = 256
    positions = np.random.randint(-10000, 10001, size=(subset_size, spatial_dim), dtype=np.int16)

    # Compute squared distances: r^2 = dx^2 + dy^2 + dz^2
    # Using GEMM: positions @ positions^T gives dot products
    # r^2 = |a|^2 + |b|^2 - 2*a.b
    pos_squared = np.sum(positions.astype(np.int64)**2, axis=1, keepdims=True)

    # For this benchmark, use random r^2 values in valid range
    r_squared = np.random.randint(100, 100000, size=(num_particles, avg_neighbors), dtype=np.int32)

    # Stage 2: RSQRT for 1/r
    inv_r = compute_force_rsqrt(r_squared)

    # Stage 3: Force magnitude (simplified: f = 1/r^2 for Coulomb-like)
    # In real MD: f = epsilon * (sigma/r)^12 - (sigma/r)^6
    force_mag = (inv_r.astype(np.int64) * inv_r.astype(np.int64)) >> 16

    # Stage 4: Force accumulation per particle
    total_forces = np.array([reduce_sum(force_mag[i, :]) for i in range(num_particles)])

    # Cycle estimation
    rsqrt_cycles_per_op = 9  # LUT + 2 Newton iterations
    rsqrt_total_cycles = num_particles * avg_neighbors * rsqrt_cycles_per_op
    force_compute_cycles = num_particles * avg_neighbors * 2  # multiply + shift
    reduction_cycles = num_particles * avg_neighbors

    total_cycles = rsqrt_total_cycles + force_compute_cycles + reduction_cycles
    active_cycles = total_cycles  # All operations are useful

    # Operations count
    rsqrt_ops = num_particles * avg_neighbors * 5  # LUT + 2 Newton (each ~2 ops)
    force_ops = num_particles * avg_neighbors * 2
    reduction_ops = num_particles * avg_neighbors
    total_ops = rsqrt_ops + force_ops + reduction_ops

    frequency_hz = TARGET_FREQ_MHZ * 1e6
    runtime_sec = total_cycles / frequency_hz
    tops = total_ops / runtime_sec / 1e12

    return BenchmarkResult(
        name="Molecular_Forces",
        total_ops=total_ops,
        total_cycles=total_cycles,
        active_cycles=active_cycles,
        stall_cycles=0,
        zero_skip_count=0,  # No zero skip in force calculations
        utilization=1.0,
        tops_dense=tops,
        tops_effective=tops,
        frequency_mhz=TARGET_FREQ_MHZ,
        expected_output=total_forces
    )


# ============================================================
# Test Vector Generation for RTL
# ============================================================

def generate_gemm_vectors(output_dir: Path, m: int, n: int, k: int, seed: int = 42):
    """Generate test vectors for GEMM benchmark."""
    np.random.seed(seed)

    output_dir.mkdir(parents=True, exist_ok=True)

    # Generate data
    activations = np.random.randint(-1000, 1001, size=(m, k), dtype=np.int16)
    weights = np.random.choice([-1, 0, 1], size=(n, k), p=[0.45, 0.10, 0.45])

    output, stats = ternary_gemm(activations.astype(np.int64), weights)

    # Write activations (binary format for $readmemb)
    with open(output_dir / "activations.mem", 'w') as f:
        f.write(f"// Activations: {m}x{k} matrix (16-bit signed)\n")
        for i in range(m):
            for j in range(k):
                val = int(activations[i, j])
                # Convert to unsigned 16-bit for hex output
                uval = val if val >= 0 else (val + 65536)
                f.write(f"{uval:04X}\n")

    # Write weights (2-bit encoded)
    with open(output_dir / "weights.mem", 'w') as f:
        f.write(f"// Weights: {n}x{k} matrix (ternary: 00=-1, 01=0, 10=+1)\n")
        for i in range(n):
            row_bits = ""
            for j in range(k):
                w = weights[i, j]
                if w == -1:
                    row_bits += "00"
                elif w == 0:
                    row_bits += "01"
                else:  # w == +1
                    row_bits += "10"
            # Write as hex (pad to multiple of 4 bits)
            while len(row_bits) % 4 != 0:
                row_bits += "00"
            hex_val = hex(int(row_bits, 2))[2:].upper().zfill(len(row_bits) // 4)
            f.write(f"{hex_val}\n")

    # Write expected output (32-bit signed)
    with open(output_dir / "expected.mem", 'w') as f:
        f.write(f"// Expected output: {m}x{n} matrix (32-bit signed)\n")
        for i in range(m):
            for j in range(n):
                val = output[i, j]
                uval = val if val >= 0 else (val + 2**32)
                f.write(f"{uval:08X}\n")

    # Write config
    with open(output_dir / "config.txt", 'w') as f:
        f.write(f"M={m}\n")
        f.write(f"N={n}\n")
        f.write(f"K={k}\n")
        f.write(f"TOTAL_MACS={stats['total_macs']}\n")
        f.write(f"ZERO_SKIPPED={stats['zero_skipped']}\n")

    print(f"Generated GEMM vectors: {output_dir}")
    return output, stats


def generate_fep_vectors(output_dir: Path, seed: int = 123):
    """Generate test vectors for FEP benchmark."""
    result = benchmark_fep_energy(seed)

    output_dir.mkdir(parents=True, exist_ok=True)

    # Write expected output
    with open(output_dir / "expected_free_energy.mem", 'w') as f:
        f.write(f"// Expected free energies: {len(result.expected_output)} values\n")
        for val in result.expected_output:
            uval = val if val >= 0 else (val + 2**32)
            f.write(f"{uval:08X}\n")

    # Write config
    with open(output_dir / "config.txt", 'w') as f:
        f.write(f"NUM_CONFIGS=256\n")
        f.write(f"ENERGY_TERMS=128\n")
        f.write(f"STATE_DIM=64\n")
        f.write(f"TOTAL_OPS={result.total_ops}\n")
        f.write(f"EXPECTED_CYCLES={result.total_cycles}\n")

    print(f"Generated FEP vectors: {output_dir}")
    return result


def generate_forces_vectors(output_dir: Path, seed: int = 456):
    """Generate test vectors for molecular forces benchmark."""
    result = benchmark_molecular_forces(seed)

    output_dir.mkdir(parents=True, exist_ok=True)

    # Write expected output
    with open(output_dir / "expected_forces.mem", 'w') as f:
        f.write(f"// Expected total forces: {len(result.expected_output)} values\n")
        for val in result.expected_output:
            uval = val if val >= 0 else (val + 2**32)
            f.write(f"{uval:08X}\n")

    # Write config
    with open(output_dir / "config.txt", 'w') as f:
        f.write(f"NUM_PARTICLES=1024\n")
        f.write(f"AVG_NEIGHBORS=50\n")
        f.write(f"TOTAL_OPS={result.total_ops}\n")
        f.write(f"EXPECTED_CYCLES={result.total_cycles}\n")

    print(f"Generated forces vectors: {output_dir}")
    return result


# ============================================================
# TOPS Report Generation
# ============================================================

def generate_tops_report(results: List[BenchmarkResult], output_file: Path):
    """Generate comprehensive TOPS report."""
    with open(output_file, 'w') as f:
        f.write("=" * 70 + "\n")
        f.write("TRITONE TPU Phase 7 - Benchmark TOPS Report\n")
        f.write("=" * 70 + "\n\n")

        f.write(f"Target Frequency: {TARGET_FREQ_MHZ} MHz\n")
        f.write(f"Array Size: {ARRAY_SIZE}x{ARRAY_SIZE} ({ARRAY_SIZE**2} PEs)\n")
        f.write(f"Accumulator Bits: {ACC_BITS}\n")
        f.write(f"Activation Bits: {ACT_BITS}\n")
        f.write("\n")

        f.write("-" * 70 + "\n")
        f.write(f"{'Benchmark':<25} {'Dense TOPS':>12} {'Eff. TOPS':>12} {'Util %':>10} {'Zero Skip':>10}\n")
        f.write("-" * 70 + "\n")

        for r in results:
            zero_skip_pct = r.zero_skip_count / (r.total_ops // 2) * 100 if r.total_ops > 0 else 0
            f.write(f"{r.name:<25} {r.tops_dense:>12.3f} {r.tops_effective:>12.3f} "
                    f"{r.utilization*100:>9.1f}% {zero_skip_pct:>9.1f}%\n")

        f.write("-" * 70 + "\n")
        f.write("\n")

        # Detailed breakdown per benchmark
        for r in results:
            f.write(f"\n{'='*70}\n")
            f.write(f"Benchmark: {r.name}\n")
            f.write(f"{'='*70}\n")
            f.write(f"  Total Operations:     {r.total_ops:,}\n")
            f.write(f"  Total Cycles:         {r.total_cycles:,}\n")
            f.write(f"  Active Cycles:        {r.active_cycles:,}\n")
            f.write(f"  Stall Cycles:         {r.stall_cycles:,}\n")
            f.write(f"  Zero Skip Count:      {r.zero_skip_count:,}\n")
            f.write(f"  Utilization:          {r.utilization*100:.2f}%\n")
            f.write(f"  Dense TOPS:           {r.tops_dense:.4f}\n")
            f.write(f"  Effective TOPS:       {r.tops_effective:.4f}\n")
            f.write(f"  Frequency:            {r.frequency_mhz} MHz\n")

        f.write("\n" + "=" * 70 + "\n")
        f.write("Notes:\n")
        f.write("  - Dense TOPS: 2 * MAC_count / runtime (no sparsity)\n")
        f.write("  - Effective TOPS: Accounts for zero-weight skipping\n")
        f.write("  - Utilization: Active compute cycles / total cycles\n")
        f.write("  - Stall cycles include DMA latency and bank conflicts\n")
        f.write("=" * 70 + "\n")

    print(f"Generated TOPS report: {output_file}")


# ============================================================
# Main Entry Point
# ============================================================

def run_all_benchmarks():
    """Run all Phase 7 benchmarks and generate reports."""
    print("=" * 70)
    print("Tritone TPU Phase 7 - Golden Benchmark Suite")
    print("=" * 70)
    print()

    # Run benchmarks
    results = []

    print("[1/3] Running 64x64 Dense GEMM benchmark...")
    results.append(benchmark_gemm_64x64())
    print(f"      Dense TOPS: {results[-1].tops_dense:.4f}")
    print(f"      Utilization: {results[-1].utilization*100:.1f}%")
    print()

    print("[2/3] Running FEP Energy Update benchmark...")
    results.append(benchmark_fep_energy())
    print(f"      Dense TOPS: {results[-1].tops_dense:.4f}")
    print(f"      Utilization: {results[-1].utilization*100:.1f}%")
    print()

    print("[3/3] Running Molecular Forces benchmark...")
    results.append(benchmark_molecular_forces())
    print(f"      Dense TOPS: {results[-1].tops_dense:.4f}")
    print(f"      Utilization: {results[-1].utilization*100:.1f}%")
    print()

    # Generate output directory
    script_dir = Path(__file__).parent
    output_base = script_dir.parent.parent / "hdl" / "tb" / "tpu" / "vectors" / "phase7"

    # Generate test vectors
    print("Generating test vectors...")
    generate_gemm_vectors(output_base / "gemm_64x64", m=64, n=64, k=64)
    generate_fep_vectors(output_base / "fep_energy")
    generate_forces_vectors(output_base / "molecular_forces")
    print()

    # Generate TOPS report
    report_file = output_base / "TOPS_REPORT.txt"
    generate_tops_report(results, report_file)

    print()
    print("=" * 70)
    print("Benchmark Summary")
    print("=" * 70)
    for r in results:
        print(f"  {r.name}: {r.tops_dense:.4f} Dense TOPS @ {r.frequency_mhz} MHz")
    print("=" * 70)

    return results


if __name__ == "__main__":
    run_all_benchmarks()
