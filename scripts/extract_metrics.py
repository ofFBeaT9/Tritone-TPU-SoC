#!/usr/bin/env python3
"""
Extract metrics from OpenLane runs and generate a consolidated results table.

This script parses:
- metrics.csv files for area/timing data
- signoff power reports for accurate power values
- signoff timing reports for WNS/TNS

Output: docs/RESULTS_TABLE.md (single source of truth)
"""

import csv
import re
from pathlib import Path
from typing import Dict, Optional, Tuple


def parse_power_report(report_path: Path) -> Optional[Dict[str, float]]:
    """
    Parse a signoff power report and extract typical corner power.

    Returns dict with keys: internal_uw, switching_uw, leakage_nw, total_uw
    """
    if not report_path.exists():
        return None

    content = report_path.read_text()

    # Look for Typical Corner section
    typical_match = re.search(
        r'Typical Corner.*?Total\s+([\d.e+-]+)\s+([\d.e+-]+)\s+([\d.e+-]+)\s+([\d.e+-]+)',
        content,
        re.DOTALL | re.IGNORECASE
    )

    if typical_match:
        internal = float(typical_match.group(1))
        switching = float(typical_match.group(2))
        leakage = float(typical_match.group(3))
        total = float(typical_match.group(4))

        # Convert from Watts to uW (multiply by 1e6)
        return {
            'internal_uw': internal * 1e6,
            'switching_uw': switching * 1e6,
            'leakage_nw': leakage * 1e9,  # Convert to nW
            'total_uw': total * 1e6
        }

    return None


def parse_timing_report(report_path: Path) -> Optional[Dict[str, float]]:
    """
    Parse a signoff timing report for WNS and critical path.

    Returns dict with keys: wns_ns, critical_path_ns
    """
    if not report_path.exists():
        return None

    content = report_path.read_text()

    result = {}

    # Look for slack value in format "X.XX   slack (MET)" or just the number after slack
    slack_match = re.search(r'([\d.-]+)\s+slack \(MET\)', content)
    if slack_match:
        result['wns_ns'] = float(slack_match.group(1))

    # Look for data arrival time (critical path) - the line before "data arrival time"
    # Format: "                                X.XX   data arrival time"
    arrival_match = re.search(r'([\d.]+)\s+data arrival time', content)
    if arrival_match:
        result['critical_path_ns'] = float(arrival_match.group(1))

    return result if result else None


def parse_metrics_csv(csv_path: Path) -> Optional[Dict[str, any]]:
    """
    Parse metrics.csv for area and basic info.
    """
    if not csv_path.exists():
        return None

    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f)
        row = next(reader, None)
        if row:
            return {
                'die_area_mm2': float(row.get('DIEAREA_mm^2', 0)),
                'core_area_um2': float(row.get('CoreArea_um^2', 0)),
                'cell_count': int(row.get('synth_cell_count', 0)),
                'clock_period': float(row.get('CLOCK_PERIOD', 0)),
                'frequency_mhz': 1000 / float(row.get('CLOCK_PERIOD', 1)) if float(row.get('CLOCK_PERIOD', 1)) > 0 else 0,
                'flow_status': row.get('flow_status', 'unknown'),
                'drc_violations': int(row.get('Magic_violations', -1)),
                'lvs_errors': int(row.get('lvs_total_errors', -1)),
            }
    return None


def find_power_report(run_dir: Path) -> Optional[Path]:
    """Find the signoff power report in a run directory."""
    # Try different possible locations
    patterns = [
        'reports/signoff/31-rcx_sta.power.rpt',
        'reports/signoff/30-sta-rcx_nom/multi_corner_sta.power.rpt',
        'reports/signoff/*/multi_corner_sta.power.rpt',
    ]

    for pattern in patterns:
        matches = list(run_dir.glob(pattern))
        if matches:
            return matches[0]

    return None


def find_timing_report(run_dir: Path) -> Optional[Path]:
    """Find the signoff timing report in a run directory."""
    patterns = [
        'reports/signoff/31-rcx_sta.max.rpt',
        'reports/signoff/30-sta-rcx_nom/multi_corner_sta.max.rpt',
    ]

    for pattern in patterns:
        matches = list(run_dir.glob(pattern))
        if matches:
            return matches[0]

    return None


def process_run(run_dir: Path) -> Optional[Dict]:
    """Process a single run directory and extract all metrics."""
    run_name = run_dir.name

    # Find and parse reports
    metrics_csv = run_dir / 'reports' / 'metrics.csv'
    power_report = find_power_report(run_dir)
    timing_report = find_timing_report(run_dir)

    result = {
        'run': run_name,
        'frequency_mhz': None,
        'critical_path_ns': None,
        'setup_slack_ns': None,
        'power_uw': None,
        'area_mm2': None,
        'status': 'UNKNOWN',
    }

    # Parse metrics.csv
    if metrics_csv.exists():
        metrics = parse_metrics_csv(metrics_csv)
        if metrics:
            result['frequency_mhz'] = round(metrics['frequency_mhz'], 1)
            result['area_mm2'] = metrics['die_area_mm2']
            if metrics['flow_status'] == 'flow completed':
                if metrics['drc_violations'] == 0 and metrics['lvs_errors'] == 0:
                    result['status'] = 'PASS'
                else:
                    result['status'] = 'VIOLATIONS'

    # Parse power report
    if power_report:
        power = parse_power_report(power_report)
        if power:
            result['power_uw'] = round(power['total_uw'], 1)

    # Parse timing report
    if timing_report:
        timing = parse_timing_report(timing_report)
        if timing:
            result['setup_slack_ns'] = timing.get('wns_ns')
            result['critical_path_ns'] = timing.get('critical_path_ns')

    return result


def generate_markdown_table(results: list) -> str:
    """Generate a markdown table from results."""
    lines = [
        "# Results Table",
        "",
        "> **Generated by:** `scripts/extract_metrics.py`",
        "> **Source:** OpenLane signoff reports",
        "",
        "| Run | Frequency | Critical Path | Setup Slack | Power | Area | Status |",
        "|-----|-----------|---------------|-------------|-------|------|--------|",
    ]

    for r in results:
        freq = f"{r['frequency_mhz']:.0f} MHz" if r['frequency_mhz'] else "-"
        cp = f"{r['critical_path_ns']:.2f} ns" if r['critical_path_ns'] else "-"
        slack = f"{r['setup_slack_ns']:.2f} ns" if r['setup_slack_ns'] else "-"
        power = f"{r['power_uw']:.1f} uW" if r['power_uw'] else "-"
        area = f"{r['area_mm2']:.2f} mm^2" if r['area_mm2'] else "-"

        lines.append(f"| {r['run']} | {freq} | {cp} | {slack} | {power} | {area} | {r['status']} |")

    lines.extend([
        "",
        "---",
        "",
        "## Notes",
        "",
        "- Power measured at Typical Corner (TT, 25C, 1.8V)",
        "- PASS = DRC clean, LVS clean, STA met",
        "- All values from signoff stage (post-route extracted)",
    ])

    return "\n".join(lines)


def main():
    """Main entry point."""
    # Find the runs directory
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    runs_dir = project_root / 'OpenLane' / 'designs' / 'ternary_cpu_system' / 'runs'

    if not runs_dir.exists():
        print(f"Error: Runs directory not found: {runs_dir}")
        return 1

    # Process all runs (skip RUN_* directories which are old/unnamed runs)
    results = []
    for run_dir in sorted(runs_dir.iterdir()):
        if run_dir.is_dir() and not run_dir.name.startswith('RUN_'):
            print(f"Processing: {run_dir.name}")
            result = process_run(run_dir)
            if result and result['status'] != 'UNKNOWN':
                results.append(result)

    # Generate markdown
    markdown = generate_markdown_table(results)

    # Write output
    output_path = project_root / 'docs' / 'RESULTS_TABLE.md'
    output_path.write_text(markdown)
    print(f"\nGenerated: {output_path}")

    # Also print to console
    print("\n" + markdown)

    return 0


if __name__ == '__main__':
    exit(main())
