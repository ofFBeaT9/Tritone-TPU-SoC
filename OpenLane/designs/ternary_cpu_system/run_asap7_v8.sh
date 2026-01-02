#!/bin/bash
# Tritone v8 CLA - ASAP7 ORFS Build Script
# Targets: 1.5 GHz (aggressive) and 1.0 GHz (baseline)
# Date: Dec 2025

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESIGN_HOME="$SCRIPT_DIR"
RESULTS_DIR="${SCRIPT_DIR}/../../asic_results"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo " Tritone v8 CLA - ASAP7 7nm Flow"
echo "=========================================="

# Check ORFS installation
if [ -z "$ORFS_ROOT" ]; then
    echo -e "${YELLOW}Warning: ORFS_ROOT not set. Attempting to find OpenROAD-flow-scripts...${NC}"
    if [ -d "/opt/OpenROAD-flow-scripts" ]; then
        export ORFS_ROOT="/opt/OpenROAD-flow-scripts"
    elif [ -d "$HOME/OpenROAD-flow-scripts" ]; then
        export ORFS_ROOT="$HOME/OpenROAD-flow-scripts"
    else
        echo -e "${RED}Error: Cannot find OpenROAD-flow-scripts. Set ORFS_ROOT.${NC}"
        exit 1
    fi
fi

echo "Using ORFS at: $ORFS_ROOT"

# Function to run ORFS flow
run_flow() {
    local config_file=$1
    local run_name=$2
    local target_freq=$3

    echo ""
    echo -e "${GREEN}Running: $run_name ($target_freq)${NC}"
    echo "Config: $config_file"
    echo ""

    # Create results directory
    mkdir -p "$RESULTS_DIR/$run_name"

    # Run ORFS
    cd "$ORFS_ROOT/flow"
    make DESIGN_CONFIG="$DESIGN_HOME/$config_file" \
         FLOW_VARIANT="$run_name" \
         clean

    make DESIGN_CONFIG="$DESIGN_HOME/$config_file" \
         FLOW_VARIANT="$run_name" \
         2>&1 | tee "$RESULTS_DIR/$run_name/build.log"

    # Copy results
    if [ -d "results/asap7/ternary_cpu_system/$run_name" ]; then
        cp -r "results/asap7/ternary_cpu_system/$run_name"/* "$RESULTS_DIR/$run_name/"
        echo -e "${GREEN}Results copied to: $RESULTS_DIR/$run_name${NC}"
    fi

    # Generate timing summary
    if [ -f "$RESULTS_DIR/$run_name/6_final.log" ]; then
        echo ""
        echo "=== Timing Summary ==="
        grep -E "(Slack|TNS|WNS|Clock Period)" "$RESULTS_DIR/$run_name/6_final.log" || true
    fi
}

# Parse arguments
case "${1:-all}" in
    "aggressive"|"1.5ghz")
        run_flow "orfs_config_asap7.mk" "tritone_v8_asap7_1500mhz" "1.5 GHz"
        ;;
    "baseline"|"1ghz")
        run_flow "orfs_config_asap7_1ghz.mk" "tritone_v8_asap7_1000mhz" "1.0 GHz"
        ;;
    "all")
        echo "Running both configurations..."
        run_flow "orfs_config_asap7_1ghz.mk" "tritone_v8_asap7_1000mhz" "1.0 GHz"
        run_flow "orfs_config_asap7.mk" "tritone_v8_asap7_1500mhz" "1.5 GHz"
        ;;
    *)
        echo "Usage: $0 [aggressive|baseline|all]"
        echo "  aggressive: 1.5 GHz target"
        echo "  baseline:   1.0 GHz target"
        echo "  all:        Run both (default)"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo -e "${GREEN} ASAP7 Flow Complete!${NC}"
echo "=========================================="
echo "Results in: $RESULTS_DIR"
