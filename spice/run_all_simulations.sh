#!/bin/bash
# ==============================================================================
# GT-LOGIC Ternary SPICE Simulation Runner
# ==============================================================================
# Runs all SPICE testbenches and collects results
#
# Prerequisites:
#   - ngspice installed (apt install ngspice / brew install ngspice)
#   - SKY130 models in spice/models/
#
# Usage:
#   cd spice
#   chmod +x run_all_simulations.sh
#   ./run_all_simulations.sh
#
# Output:
#   - results/*.log - Simulation logs
#   - results/*.dat - Waveform data
#   - results/summary.txt - Summary of all simulations
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/results"

# Create results directory
mkdir -p "$RESULTS_DIR"

echo "=============================================="
echo "GT-LOGIC Ternary SPICE Simulation Suite"
echo "=============================================="
echo ""

# Check for ngspice
if ! command -v ngspice &> /dev/null; then
    echo "ERROR: ngspice not found. Please install ngspice first."
    echo "  Ubuntu/Debian: sudo apt install ngspice"
    echo "  macOS: brew install ngspice"
    echo "  Windows: Download from ngspice.sourceforge.io"
    exit 1
fi

echo "ngspice version:"
ngspice --version | head -n 1
echo ""

# ==============================================================================
# TESTBENCH LIST
# ==============================================================================
TESTBENCHES=(
    "testbenches/pvt_sweep_sti.spice:PVT Corner Analysis"
    "testbenches/noise_margin_analysis.spice:Noise Margin Analysis"
    "testbenches/monte_carlo_sti.spice:Monte Carlo Analysis"
    "testbenches/tb_tdff.spice:TDFF Characterization"
    "testbenches/tb_ternary_sram.spice:Ternary SRAM Characterization"
)

# ==============================================================================
# RUN SIMULATIONS
# ==============================================================================
echo "Running simulations..."
echo ""

SUMMARY_FILE="$RESULTS_DIR/summary.txt"
echo "GT-LOGIC SPICE Simulation Summary" > "$SUMMARY_FILE"
echo "==================================" >> "$SUMMARY_FILE"
echo "Date: $(date)" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

PASSED=0
FAILED=0

for entry in "${TESTBENCHES[@]}"; do
    IFS=':' read -r tb_file tb_name <<< "$entry"

    if [ ! -f "$SCRIPT_DIR/$tb_file" ]; then
        echo "  [SKIP] $tb_name - File not found: $tb_file"
        continue
    fi

    echo "  Running: $tb_name..."

    log_file="$RESULTS_DIR/$(basename "$tb_file" .spice).log"

    # Run ngspice in batch mode
    if ngspice -b "$SCRIPT_DIR/$tb_file" > "$log_file" 2>&1; then
        echo "    [PASS] Completed successfully"
        echo "[PASS] $tb_name" >> "$SUMMARY_FILE"
        ((PASSED++))
    else
        echo "    [FAIL] Error - check $log_file"
        echo "[FAIL] $tb_name - see $(basename "$log_file")" >> "$SUMMARY_FILE"
        ((FAILED++))
    fi
done

echo ""
echo "=============================================="
echo "SUMMARY: $PASSED passed, $FAILED failed"
echo "=============================================="
echo ""
echo "Summary: $PASSED passed, $FAILED failed" >> "$SUMMARY_FILE"
echo ""
echo "Results saved to: $RESULTS_DIR/"
echo "See $SUMMARY_FILE for details"

# Move any generated .dat files to results
mv *.dat "$RESULTS_DIR/" 2>/dev/null || true

exit $FAILED
