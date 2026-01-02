#!/usr/bin/env python3
"""
Ternary Netlist Mapper - Dual-Rail to Single-Wire Analysis and Mapping

GT-LOGIC Tritone Project
Post-synthesis netlist analyzer to identify ternary signal pairs encoded
as dual-rail binary signals and generate routing constraints.

Ternary Encoding (2-bit per trit):
  T_ZERO    = 2'b00
  T_POS_ONE = 2'b01
  T_NEG_ONE = 2'b10
  T_INVALID = 2'b11

For a 27-trit word, the binary synthesis produces 54 wires.
This tool identifies these pairs and creates:
  1. Ternary signal mapping report
  2. DEF net grouping constraints
  3. OpenROAD routing TCL directives

Expected wire reduction: ~34% (21 ternary wires vs 32 binary for same info)

Author: Tritone Project
Date: December 2025
"""

import re
import sys
import argparse
from dataclasses import dataclass, field
from typing import Dict, List, Set, Tuple, Optional
from pathlib import Path
from collections import defaultdict


@dataclass
class TernarySignal:
    """Represents a ternary signal mapped from dual-rail binary wires."""
    name: str                           # Ternary signal name (e.g., "reg_a")
    trit_index: int                     # Trit position in vector
    wire_low: str                       # Binary wire for bit 0
    wire_high: str                      # Binary wire for bit 1
    is_vector: bool = False             # Part of a vector
    vector_name: Optional[str] = None   # Base vector name if applicable


@dataclass
class NetlistAnalysis:
    """Results of netlist analysis."""
    ternary_signals: List[TernarySignal] = field(default_factory=list)
    binary_wires: Set[str] = field(default_factory=set)
    unmatched_wires: Set[str] = field(default_factory=set)
    module_name: str = ""
    cell_count: int = 0
    wire_count: int = 0
    ternary_trit_count: int = 0

    @property
    def wire_reduction_pct(self) -> float:
        """Calculate wire reduction percentage."""
        if len(self.binary_wires) == 0:
            return 0.0
        ternary_wire_count = len(self.ternary_signals)
        binary_wire_count = len(self.binary_wires)
        return (1 - ternary_wire_count / binary_wire_count) * 100


def parse_verilog_netlist(filepath: str) -> Dict:
    """
    Parse a synthesized Verilog netlist and extract wire/port information.

    Args:
        filepath: Path to synthesized .v file

    Returns:
        Dictionary with module info, wires, ports, and instances
    """
    result = {
        'module_name': '',
        'ports': {},
        'wires': set(),
        'instances': [],
        'wire_widths': {},
    }

    with open(filepath, 'r') as f:
        content = f.read()

    # Extract module name
    module_match = re.search(r'module\s+(\w+)\s*\(', content)
    if module_match:
        result['module_name'] = module_match.group(1)

    # Extract wire declarations
    wire_pattern = re.compile(r'\bwire\s+(?:\[(\d+):(\d+)\]\s+)?(\\\S+|\w+)\s*;')
    for match in wire_pattern.finditer(content):
        high_bit = match.group(1)
        low_bit = match.group(2)
        wire_name = match.group(3)

        if high_bit and low_bit:
            width = int(high_bit) - int(low_bit) + 1
            result['wire_widths'][wire_name] = width
            # Add individual wires for vectors
            for i in range(int(low_bit), int(high_bit) + 1):
                result['wires'].add(f"{wire_name}[{i}]")
        else:
            result['wires'].add(wire_name)
            result['wire_widths'][wire_name] = 1

    # Also capture escaped wire names (common in Yosys output)
    escaped_wire_pattern = re.compile(r'\bwire\s+(\\[^\s;]+)\s*;')
    for match in escaped_wire_pattern.finditer(content):
        result['wires'].add(match.group(1))

    # Extract input/output ports with widths
    port_pattern = re.compile(r'\b(input|output)\s+(?:\[(\d+):(\d+)\]\s+)?(\w+)\s*;')
    for match in port_pattern.finditer(content):
        direction = match.group(1)
        high_bit = match.group(2)
        low_bit = match.group(3)
        port_name = match.group(4)

        width = 1
        if high_bit and low_bit:
            width = int(high_bit) - int(low_bit) + 1

        result['ports'][port_name] = {
            'direction': direction,
            'width': width,
            'high_bit': int(high_bit) if high_bit else 0,
            'low_bit': int(low_bit) if low_bit else 0,
        }

    # Count cell instances
    cell_pattern = re.compile(r'\b(sky130_\w+|NAND|NOR|INV|AND|OR|XOR|MUX|DFF|BUF)\w*\s+\w+\s*\(')
    result['instances'] = cell_pattern.findall(content)

    return result


def identify_ternary_pairs(netlist: Dict) -> NetlistAnalysis:
    """
    Analyze netlist to identify ternary signal pairs.

    Ternary signals are encoded as pairs of binary wires:
    - signal[2*i]   -> bit 0 of trit i
    - signal[2*i+1] -> bit 1 of trit i

    For 27-trit registers: reg[53:0] represents 27 trits

    Args:
        netlist: Parsed netlist dictionary

    Returns:
        NetlistAnalysis with identified ternary signals
    """
    analysis = NetlistAnalysis()
    analysis.module_name = netlist['module_name']
    analysis.cell_count = len(netlist['instances'])
    analysis.wire_count = len(netlist['wires'])
    analysis.binary_wires = netlist['wires'].copy()

    # Group wires by base name and index
    wire_groups: Dict[str, Dict[int, str]] = defaultdict(dict)

    for wire in netlist['wires']:
        # Match indexed wires: name[index]
        match = re.match(r'(.*)\[(\d+)\]$', wire)
        if match:
            base_name = match.group(1)
            index = int(match.group(2))
            wire_groups[base_name][index] = wire

    # Also process port widths for vector signals
    for port_name, port_info in netlist['ports'].items():
        if port_info['width'] > 1:
            for i in range(port_info['low_bit'], port_info['high_bit'] + 1):
                wire_groups[port_name][i] = f"{port_name}[{i}]"

    # Identify ternary pairs (even/odd bit pairs)
    matched_wires: Set[str] = set()

    for base_name, indices in wire_groups.items():
        # Check if this looks like a ternary-encoded signal
        # Ternary signals have consecutive pairs: [0,1], [2,3], [4,5], etc.
        max_idx = max(indices.keys()) if indices else -1

        # Check for 27-trit pattern (54 bits) or 8-trit pattern (16 bits)
        is_ternary_27 = max_idx >= 53 and (max_idx + 1) % 2 == 0
        is_ternary_8 = max_idx >= 15 and max_idx < 53 and (max_idx + 1) % 2 == 0
        is_ternary_any = (max_idx + 1) >= 2 and (max_idx + 1) % 2 == 0

        if is_ternary_any:
            num_trits = (max_idx + 1) // 2

            for trit_idx in range(num_trits):
                bit_low_idx = trit_idx * 2
                bit_high_idx = trit_idx * 2 + 1

                if bit_low_idx in indices and bit_high_idx in indices:
                    wire_low = indices[bit_low_idx]
                    wire_high = indices[bit_high_idx]

                    ternary_sig = TernarySignal(
                        name=f"{base_name}_t{trit_idx}",
                        trit_index=trit_idx,
                        wire_low=wire_low,
                        wire_high=wire_high,
                        is_vector=True,
                        vector_name=base_name
                    )
                    analysis.ternary_signals.append(ternary_sig)
                    analysis.ternary_trit_count += 1
                    matched_wires.add(wire_low)
                    matched_wires.add(wire_high)

    # Track unmatched wires
    analysis.unmatched_wires = analysis.binary_wires - matched_wires

    return analysis


def generate_def_constraints(analysis: NetlistAnalysis, output_path: str):
    """
    Generate DEF net grouping constraints for ternary signal routing.

    Creates non-default rules (NDR) to keep ternary pairs routed together.

    Args:
        analysis: NetlistAnalysis results
        output_path: Output file path
    """
    with open(output_path, 'w') as f:
        f.write(f"# DEF Net Grouping Constraints for Ternary Signals\n")
        f.write(f"# Module: {analysis.module_name}\n")
        f.write(f"# Generated by ternary_netlist_mapper.py\n")
        f.write(f"# Ternary trits identified: {analysis.ternary_trit_count}\n")
        f.write(f"# Wire reduction: {analysis.wire_reduction_pct:.1f}%\n\n")

        # Group by vector name
        vector_groups: Dict[str, List[TernarySignal]] = defaultdict(list)
        for sig in analysis.ternary_signals:
            if sig.vector_name:
                vector_groups[sig.vector_name].append(sig)

        f.write("# Net Groups (for OpenROAD group routing)\n")
        f.write("# Format: NETGROUP <name> <net1> <net2> ...\n\n")

        for vector_name, signals in vector_groups.items():
            safe_name = vector_name.replace('\\', '_').replace('.', '_')
            f.write(f"# Ternary vector: {vector_name} ({len(signals)} trits)\n")
            f.write(f"NETGROUP ternary_{safe_name}\n")
            for sig in sorted(signals, key=lambda s: s.trit_index):
                # Quote escaped names
                low_wire = f'"{sig.wire_low}"' if '\\' in sig.wire_low else sig.wire_low
                high_wire = f'"{sig.wire_high}"' if '\\' in sig.wire_high else sig.wire_high
                f.write(f"  {low_wire}\n")
                f.write(f"  {high_wire}\n")
            f.write(";\n\n")

        # Non-default routing rules
        f.write("# Non-Default Routing Rules for Ternary Pairs\n")
        f.write("# These keep dual-rail pairs close for potential TCMOS collapse\n")
        f.write("NONDEFAULTRULES\n")
        f.write("  LAYER metal2\n")
        f.write("    SPACING 0.14 ;  # Minimum spacing for paired routing\n")
        f.write("    WIDTH 0.14 ;\n")
        f.write("  END metal2\n")
        f.write("  LAYER metal3\n")
        f.write("    SPACING 0.14 ;\n")
        f.write("    WIDTH 0.14 ;\n")
        f.write("  END metal3\n")
        f.write("END NONDEFAULTRULES\n")

    print(f"Generated DEF constraints: {output_path}")


def generate_openroad_tcl(analysis: NetlistAnalysis, output_path: str):
    """
    Generate OpenROAD TCL script for ternary-aware routing.

    Creates constraints to route ternary pairs with matched lengths
    and minimum spacing.

    Args:
        analysis: NetlistAnalysis results
        output_path: Output file path
    """
    with open(output_path, 'w') as f:
        f.write("""# OpenROAD Ternary Routing Directives
# GT-LOGIC Tritone Project
# Generated by ternary_netlist_mapper.py
#
# Purpose: Route dual-rail ternary pairs with matched lengths and
#          minimum spacing for potential TCMOS wire collapse.
#
# Usage: source ternary_router.tcl (after floorplanning)

puts "Loading ternary routing constraints..."

""")

        f.write(f"# Module: {analysis.module_name}\n")
        f.write(f"# Ternary trits identified: {analysis.ternary_trit_count}\n")
        f.write(f"# Binary wires: {analysis.wire_count}\n")
        f.write(f"# Potential wire reduction: {analysis.wire_reduction_pct:.1f}%\n\n")

        # Create NDR for ternary pairs
        f.write("""# ==============================================================================
# NON-DEFAULT ROUTING RULES
# ==============================================================================
# Create a non-default rule for ternary signal pairs
# These nets should be routed with matched lengths

proc create_ternary_ndr {} {
    # Check if NDR already exists
    if {[llength [get_db ndr -name ternary_pair*]] > 0} {
        puts "Ternary NDR already exists, skipping creation"
        return
    }

    # Create NDR for ternary pairs - route close together
    create_ndr -name ternary_pair_rule \\
        -spacing {metal2:0.14 metal3:0.14 metal4:0.16} \\
        -width {metal2:0.14 metal3:0.14 metal4:0.16} \\
        -min_layer metal2 \\
        -max_layer metal5

    puts "Created ternary_pair_rule NDR"
}

# ==============================================================================
# NET GROUPING FOR TERNARY VECTORS
# ==============================================================================

proc group_ternary_nets {} {
    puts "Grouping ternary signal pairs..."

""")

        # Group by vector name
        vector_groups: Dict[str, List[TernarySignal]] = defaultdict(list)
        for sig in analysis.ternary_signals:
            if sig.vector_name:
                vector_groups[sig.vector_name].append(sig)

        for vector_name, signals in vector_groups.items():
            safe_name = re.sub(r'[\\.\[\]]', '_', vector_name)
            f.write(f"    # Ternary vector: {vector_name} ({len(signals)} trits)\n")
            f.write(f"    set ternary_{safe_name}_nets {{\n")
            for sig in sorted(signals, key=lambda s: s.trit_index):
                # Escape for TCL
                low_wire = sig.wire_low.replace('\\', '\\\\')
                high_wire = sig.wire_high.replace('\\', '\\\\')
                f.write(f"        {{{low_wire}}} {{{high_wire}}}\n")
            f.write(f"    }}\n\n")

        f.write("""    puts "Ternary net groups defined"
}

# ==============================================================================
# APPLY TERNARY ROUTING CONSTRAINTS
# ==============================================================================

proc apply_ternary_constraints {} {
    puts "Applying ternary routing constraints..."

    # Create NDR if not exists
    create_ternary_ndr

    # Group nets
    group_ternary_nets

    # Set max wire length for ternary pairs (for matched-length routing)
    set_max_wire_length -nets [get_nets *_t*] -length 500

    puts "Ternary routing constraints applied"
}

# ==============================================================================
# TERNARY WIRE ANALYSIS
# ==============================================================================

proc analyze_ternary_routing {} {
    puts ""
    puts "==== TERNARY ROUTING ANALYSIS ===="
    puts ""

""")

        f.write(f"    set total_trits {analysis.ternary_trit_count}\n")
        f.write(f"    set total_binary_wires {analysis.wire_count}\n")
        f.write(f"    set wire_reduction {analysis.wire_reduction_pct:.1f}\n\n")

        f.write("""    puts "Ternary trits identified: $total_trits"
    puts "Binary wires in netlist: $total_binary_wires"
    puts "Theoretical wire reduction: ${wire_reduction}%"
    puts ""

    # Analyze routing congestion
    if {[info command report_routing_congestion] != ""} {
        puts "Routing congestion analysis:"
        report_routing_congestion
    }

    puts ""
    puts "===================================="
}

# ==============================================================================
# ROUTING CALLBACKS
# ==============================================================================

proc ternary_pre_global_route {} {
    puts "Pre-global routing ternary setup..."
    apply_ternary_constraints
}

proc ternary_post_detail_route {} {
    puts "Post-detail routing ternary analysis..."
    analyze_ternary_routing
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

puts ""
puts "Ternary Routing Module Loaded"
puts "Available commands:"
puts "  create_ternary_ndr      - Create non-default routing rules"
puts "  group_ternary_nets      - Define ternary net groups"
puts "  apply_ternary_constraints - Apply all ternary constraints"
puts "  analyze_ternary_routing - Analyze routing results"
puts ""
puts "Call 'apply_ternary_constraints' before global routing"
puts ""

""")

    print(f"Generated OpenROAD TCL script: {output_path}")


def generate_mapping_report(analysis: NetlistAnalysis, output_path: str):
    """
    Generate a detailed ternary mapping report.

    Args:
        analysis: NetlistAnalysis results
        output_path: Output file path
    """
    with open(output_path, 'w') as f:
        f.write("# Ternary Netlist Mapping Report\n")
        f.write("# GT-LOGIC Tritone Project\n")
        f.write("# Generated by ternary_netlist_mapper.py\n\n")

        f.write("## Summary\n\n")
        f.write(f"| Metric | Value |\n")
        f.write(f"|--------|-------|\n")
        f.write(f"| Module Name | {analysis.module_name} |\n")
        f.write(f"| Cell Instances | {analysis.cell_count} |\n")
        f.write(f"| Binary Wires | {analysis.wire_count} |\n")
        f.write(f"| Ternary Trits Identified | {analysis.ternary_trit_count} |\n")
        f.write(f"| Wire Reduction | {analysis.wire_reduction_pct:.1f}% |\n")
        f.write(f"| Unmatched Wires | {len(analysis.unmatched_wires)} |\n\n")

        # Group by vector
        vector_groups: Dict[str, List[TernarySignal]] = defaultdict(list)
        for sig in analysis.ternary_signals:
            if sig.vector_name:
                vector_groups[sig.vector_name].append(sig)

        f.write("## Ternary Vector Signals\n\n")
        f.write("| Vector Name | Trits | Width (bits) | Type |\n")
        f.write("|-------------|-------|--------------|------|\n")

        for vector_name, signals in sorted(vector_groups.items()):
            num_trits = len(signals)
            width = num_trits * 2
            sig_type = "27-trit word" if num_trits == 27 else \
                       "8-trit byte" if num_trits == 8 else \
                       f"{num_trits}-trit"
            f.write(f"| `{vector_name}` | {num_trits} | {width} | {sig_type} |\n")

        f.write("\n## Wire Mapping Detail\n\n")
        for vector_name, signals in sorted(vector_groups.items()):
            f.write(f"### `{vector_name}` ({len(signals)} trits)\n\n")
            f.write("| Trit | Bit[1] (High) | Bit[0] (Low) | Ternary Wire |\n")
            f.write("|------|---------------|--------------|---------------|\n")
            for sig in sorted(signals, key=lambda s: s.trit_index):
                f.write(f"| {sig.trit_index} | `{sig.wire_high}` | `{sig.wire_low}` | `{sig.name}` |\n")
            f.write("\n")

        if analysis.unmatched_wires:
            f.write("## Unmatched Binary Wires\n\n")
            f.write("These wires were not matched to ternary pairs (likely control signals):\n\n")
            for wire in sorted(analysis.unmatched_wires)[:50]:
                f.write(f"- `{wire}`\n")
            if len(analysis.unmatched_wires) > 50:
                f.write(f"\n... and {len(analysis.unmatched_wires) - 50} more\n")

    print(f"Generated mapping report: {output_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Ternary Netlist Mapper - Dual-Rail to Single-Wire Analysis",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analyze synthesized netlist
  python ternary_netlist_mapper.py design.v -o output/

  # Generate only routing constraints
  python ternary_netlist_mapper.py design.v --tcl-only -o constraints/

  # Detailed report with wire mapping
  python ternary_netlist_mapper.py design.v --report -o docs/
"""
    )

    parser.add_argument('netlist', help='Synthesized Verilog netlist (.v)')
    parser.add_argument('-o', '--output', default='.',
                        help='Output directory (default: current)')
    parser.add_argument('--tcl-only', action='store_true',
                        help='Generate only TCL routing script')
    parser.add_argument('--report', action='store_true',
                        help='Generate detailed mapping report')
    parser.add_argument('--def-constraints', action='store_true',
                        help='Generate DEF net grouping constraints')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Verbose output')

    args = parser.parse_args()

    # Validate input
    netlist_path = Path(args.netlist)
    if not netlist_path.exists():
        print(f"Error: Netlist file not found: {netlist_path}")
        sys.exit(1)

    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Parse netlist
    if args.verbose:
        print(f"Parsing netlist: {netlist_path}")

    netlist = parse_verilog_netlist(str(netlist_path))

    if args.verbose:
        print(f"  Module: {netlist['module_name']}")
        print(f"  Wires: {len(netlist['wires'])}")
        print(f"  Cells: {len(netlist['instances'])}")

    # Analyze for ternary pairs
    if args.verbose:
        print("Identifying ternary signal pairs...")

    analysis = identify_ternary_pairs(netlist)

    # Summary
    print(f"\n=== Ternary Netlist Analysis ===")
    print(f"Module: {analysis.module_name}")
    print(f"Binary wires: {analysis.wire_count}")
    print(f"Ternary trits: {analysis.ternary_trit_count}")
    print(f"Wire reduction potential: {analysis.wire_reduction_pct:.1f}%")
    print()

    # Generate outputs
    base_name = netlist_path.stem

    if not args.tcl_only:
        # Generate DEF constraints
        def_path = output_dir / f"{base_name}_ternary_constraints.def"
        generate_def_constraints(analysis, str(def_path))

    # Always generate TCL
    tcl_path = output_dir / f"ternary_router.tcl"
    generate_openroad_tcl(analysis, str(tcl_path))

    if args.report or not args.tcl_only:
        # Generate mapping report
        report_path = output_dir / f"{base_name}_ternary_mapping.md"
        generate_mapping_report(analysis, str(report_path))

    print(f"\nOutputs written to: {output_dir}")


if __name__ == '__main__':
    main()
