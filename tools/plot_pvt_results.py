#!/usr/bin/env python3
"""
SKY130 Multi-Vth STI PVT Results Plotter
=========================================

Reads ngspice output files and generates publication-quality plots
for the multi-corner PVT characterization.

Usage:
    python3 plot_pvt_results.py [--results-dir PATH]

Output:
    - dc_transfer_all_corners.png
    - noise_margins.png
    - pvt_sensitivity.png
"""

import os
import sys
import argparse
import numpy as np

# Try to import matplotlib, provide helpful message if not available
try:
    import matplotlib.pyplot as plt
    import matplotlib.patches as mpatches
    HAS_MATPLOTLIB = True
except ImportError:
    HAS_MATPLOTLIB = False
    print("Warning: matplotlib not installed. Run: pip3 install matplotlib")

def parse_ngspice_dat(filepath):
    """Parse ngspice wrdata output file."""
    data = {}
    try:
        with open(filepath, 'r') as f:
            lines = f.readlines()

        # Skip header lines
        values = []
        for line in lines:
            line = line.strip()
            if not line or line.startswith('*') or line.startswith('#'):
                continue
            parts = line.split()
            if len(parts) >= 2:
                try:
                    x = float(parts[0])
                    y = float(parts[1])
                    values.append((x, y))
                except ValueError:
                    continue

        if values:
            data['x'] = np.array([v[0] for v in values])
            data['y'] = np.array([v[1] for v in values])
    except FileNotFoundError:
        print(f"Warning: File not found: {filepath}")
    except Exception as e:
        print(f"Warning: Error parsing {filepath}: {e}")

    return data

def parse_log_file(filepath):
    """Parse ngspice log file for measurement results."""
    results = {}
    try:
        with open(filepath, 'r') as f:
            content = f.read()

        # Extract key measurements using simple parsing
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'vout_mid' in line.lower() and '=' in line:
                try:
                    val = float(line.split('=')[-1].strip().replace('V', ''))
                    results['vout_mid'] = val
                except:
                    pass
            if 'vil_th' in line.lower() and '=' in line:
                try:
                    val = float(line.split('=')[-1].strip().replace('V', ''))
                    results['vil'] = val
                except:
                    pass
            if 'vih_th' in line.lower() and '=' in line:
                try:
                    val = float(line.split('=')[-1].strip().replace('V', ''))
                    results['vih'] = val
                except:
                    pass
    except FileNotFoundError:
        print(f"Warning: Log file not found: {filepath}")
    except Exception as e:
        print(f"Warning: Error parsing {filepath}: {e}")

    return results

def plot_dc_transfer(results_dir, output_dir):
    """Plot DC transfer curves for all corners."""
    if not HAS_MATPLOTLIB:
        print("Skipping plot (matplotlib not available)")
        return

    corners = ['tt', 'ss', 'ff', 'sf', 'fs']
    colors = {'tt': 'black', 'ss': 'red', 'ff': 'blue', 'sf': 'green', 'fs': 'orange'}
    labels = {'tt': 'TT (Typical)', 'ss': 'SS (Slow)', 'ff': 'FF (Fast)',
              'sf': 'SF (Slow-N/Fast-P)', 'fs': 'FS (Fast-N/Slow-P)'}

    fig, ax = plt.subplots(figsize=(10, 7))

    found_data = False
    for corner in corners:
        filepath = os.path.join(results_dir, f'dc_{corner}.dat')
        data = parse_ngspice_dat(filepath)
        if 'x' in data and 'y' in data:
            ax.plot(data['x'], data['y'], color=colors[corner],
                   label=labels[corner], linewidth=2)
            found_data = True

    if not found_data:
        print("No DC transfer data found. Run simulations first.")
        return

    # Ideal ternary transfer curve
    x_ideal = [0, 0.6, 0.9, 1.2, 1.8]
    y_ideal = [1.8, 1.2, 0.9, 0.6, 0]
    ax.plot(x_ideal, y_ideal, 'k--', alpha=0.5, linewidth=1.5, label='Ideal')

    # Add ternary region shading
    ax.axhspan(0, 0.6, alpha=0.1, color='blue', label='LOW region')
    ax.axhspan(0.6, 1.2, alpha=0.1, color='green', label='MID region')
    ax.axhspan(1.2, 1.8, alpha=0.1, color='red', label='HIGH region')

    ax.set_xlabel('Input Voltage (V)', fontsize=12)
    ax.set_ylabel('Output Voltage (V)', fontsize=12)
    ax.set_title('Multi-Vth STI DC Transfer Characteristic - All Process Corners', fontsize=14)
    ax.set_xlim(0, 1.8)
    ax.set_ylim(0, 1.8)
    ax.grid(True, alpha=0.3)
    ax.legend(loc='upper right', fontsize=10)

    ax.set_aspect('equal')

    output_path = os.path.join(output_dir, 'dc_transfer_all_corners.png')
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    print(f"Saved: {output_path}")
    plt.close()

def plot_noise_margins(results_dir, output_dir):
    """Plot noise margins for all corners."""
    if not HAS_MATPLOTLIB:
        return

    corners = ['tt', 'ss', 'ff', 'sf', 'fs']

    nml_vals = []
    nmh_vals = []
    nmm_l_vals = []
    nmm_h_vals = []
    valid_corners = []

    for corner in corners:
        log_path = os.path.join(results_dir, f'log_{corner}.txt')
        results = parse_log_file(log_path)

        if 'vil' in results and 'vih' in results:
            vil = results['vil']
            vih = results['vih']
            vmid = results.get('vout_mid', 0.9)

            nml = vil
            nmh = 1.8 - vih
            nmm_l = vmid - 0.6  # Lower bound of mid region to mid output
            nmm_h = 1.2 - vmid  # Mid output to upper bound of mid region

            nml_vals.append(nml)
            nmh_vals.append(nmh)
            nmm_l_vals.append(nmm_l)
            nmm_h_vals.append(nmm_h)
            valid_corners.append(corner.upper())

    if not valid_corners:
        print("No noise margin data found.")
        return

    x = np.arange(len(valid_corners))
    width = 0.2

    fig, ax = plt.subplots(figsize=(10, 6))

    bars1 = ax.bar(x - 1.5*width, nml_vals, width, label='NML', color='blue')
    bars2 = ax.bar(x - 0.5*width, nmm_l_vals, width, label='NMM (lower)', color='green')
    bars3 = ax.bar(x + 0.5*width, nmm_h_vals, width, label='NMM (upper)', color='cyan')
    bars4 = ax.bar(x + 1.5*width, nmh_vals, width, label='NMH', color='red')

    ax.axhline(y=0.3, color='red', linestyle='--', alpha=0.7, label='Min NML/NMH (0.3V)')
    ax.axhline(y=0.15, color='orange', linestyle='--', alpha=0.7, label='Min NMM (0.15V)')

    ax.set_xlabel('Process Corner', fontsize=12)
    ax.set_ylabel('Noise Margin (V)', fontsize=12)
    ax.set_title('Ternary Noise Margins Across Process Corners', fontsize=14)
    ax.set_xticks(x)
    ax.set_xticklabels(valid_corners)
    ax.legend(loc='upper right')
    ax.grid(True, alpha=0.3, axis='y')

    output_path = os.path.join(output_dir, 'noise_margins.png')
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    print(f"Saved: {output_path}")
    plt.close()

def plot_pvt_sensitivity(results_dir, output_dir):
    """Plot mid-level accuracy vs PVT variations."""
    if not HAS_MATPLOTLIB:
        return

    # This would parse temperature and voltage sweep data
    # For now, create a placeholder

    corners = ['TT', 'SS', 'FF', 'SF', 'FS']
    temps = ['-40C', '27C', '85C', '125C']
    voltages = ['1.62V', '1.80V', '1.98V']

    # Placeholder data (would be extracted from logs)
    # Format: mid_level_error in mV
    pvt_data = {
        'TT': {'temp': [25, 10, 35, 60], 'voltage': [40, 10, 45]},
        'SS': {'temp': [45, 30, 55, 80], 'voltage': [60, 30, 65]},
        'FF': {'temp': [35, 20, 45, 70], 'voltage': [50, 20, 55]},
    }

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

    # Temperature sensitivity
    ax1.set_xlabel('Temperature', fontsize=12)
    ax1.set_ylabel('Mid-Level Error (mV)', fontsize=12)
    ax1.set_title('Temperature Sensitivity', fontsize=14)
    ax1.axhline(y=50, color='red', linestyle='--', alpha=0.7, label='Target: <50mV')

    for corner, data in pvt_data.items():
        ax1.plot(temps, data['temp'], 'o-', label=corner, linewidth=2, markersize=8)

    ax1.legend()
    ax1.grid(True, alpha=0.3)

    # Voltage sensitivity
    ax2.set_xlabel('Supply Voltage', fontsize=12)
    ax2.set_ylabel('Mid-Level Error (mV)', fontsize=12)
    ax2.set_title('Voltage Sensitivity', fontsize=14)
    ax2.axhline(y=50, color='red', linestyle='--', alpha=0.7, label='Target: <50mV')

    for corner, data in pvt_data.items():
        ax2.plot(voltages, data['voltage'], 's-', label=corner, linewidth=2, markersize=8)

    ax2.legend()
    ax2.grid(True, alpha=0.3)

    plt.tight_layout()

    output_path = os.path.join(output_dir, 'pvt_sensitivity.png')
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    print(f"Saved: {output_path}")
    plt.close()

def generate_summary_table(results_dir):
    """Generate a summary table of all corner results."""

    corners = ['tt', 'ss', 'ff', 'sf', 'fs']

    print("\n" + "="*80)
    print("MULTI-CORNER CHARACTERIZATION SUMMARY")
    print("="*80)
    print(f"{'Corner':<10} {'Vout@0.9V':<12} {'VIL':<10} {'VIH':<10} {'NML':<10} {'NMH':<10}")
    print("-"*80)

    for corner in corners:
        log_path = os.path.join(results_dir, f'log_{corner}.txt')
        results = parse_log_file(log_path)

        vout_mid = results.get('vout_mid', float('nan'))
        vil = results.get('vil', float('nan'))
        vih = results.get('vih', float('nan'))
        nml = vil if not np.isnan(vil) else float('nan')
        nmh = (1.8 - vih) if not np.isnan(vih) else float('nan')

        print(f"{corner.upper():<10} {vout_mid:<12.3f} {vil:<10.3f} {vih:<10.3f} {nml:<10.3f} {nmh:<10.3f}")

    print("="*80)

def main():
    parser = argparse.ArgumentParser(description='Plot SKY130 Multi-Vth STI PVT results')
    parser.add_argument('--results-dir', default='/tritone/spice/results',
                       help='Directory containing simulation results')
    parser.add_argument('--output-dir', default='/tritone/spice/results',
                       help='Directory for output plots')
    args = parser.parse_args()

    # Also check local path for Windows development
    if not os.path.exists(args.results_dir):
        local_results = os.path.join(os.path.dirname(__file__), '..', 'spice', 'results')
        if os.path.exists(local_results):
            args.results_dir = local_results
            args.output_dir = local_results

    os.makedirs(args.output_dir, exist_ok=True)

    print(f"Results directory: {args.results_dir}")
    print(f"Output directory: {args.output_dir}")

    # Generate summary table
    generate_summary_table(args.results_dir)

    if HAS_MATPLOTLIB:
        # Generate plots
        print("\nGenerating plots...")
        plot_dc_transfer(args.results_dir, args.output_dir)
        plot_noise_margins(args.results_dir, args.output_dir)
        plot_pvt_sensitivity(args.results_dir, args.output_dir)
        print("\nPlot generation complete.")
    else:
        print("\nInstall matplotlib for plots: pip3 install matplotlib numpy")

if __name__ == '__main__':
    main()
