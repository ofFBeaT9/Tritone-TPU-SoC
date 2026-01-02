#!/bin/bash
# Tritone v8 CLA - ASAP7 Docker Build Script
# Runs OpenROAD-flow-scripts in Docker container
# Date: Dec 2025

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="${SCRIPT_DIR}/../asic_results"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=========================================="
echo " Tritone v8 CLA - ASAP7 7nm Flow"
echo " Docker-based OpenROAD Build"
echo -e "==========================================${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker not found. Please install Docker.${NC}"
    exit 1
fi

# Parse arguments
VARIANT="${1:-aggressive}"
JOBS="${2:-$(nproc 2>/dev/null || echo 4)}"

case "$VARIANT" in
    "maxperf"|"2ghz"|"2000mhz")
        FLOW_VARIANT="maxperf"
        TARGET_FREQ="2.0 GHz"
        RUN_NAME="tritone_v8_asap7_2000mhz"
        ;;
    "aggressive"|"1.5ghz"|"1500mhz")
        FLOW_VARIANT="aggressive"
        TARGET_FREQ="1.5 GHz"
        RUN_NAME="tritone_v8_asap7_1500mhz"
        ;;
    "baseline"|"1ghz"|"1000mhz")
        FLOW_VARIANT="baseline"
        TARGET_FREQ="1.0 GHz"
        RUN_NAME="tritone_v8_asap7_1000mhz"
        ;;
    "all")
        echo -e "${YELLOW}Running all three variants...${NC}"
        $0 baseline $JOBS
        $0 aggressive $JOBS
        $0 maxperf $JOBS
        exit 0
        ;;
    *)
        echo "Usage: $0 [baseline|aggressive|maxperf|all] [jobs]"
        echo ""
        echo "Variants:"
        echo "  baseline:   1.0 GHz target"
        echo "  aggressive: 1.5 GHz target"
        echo "  maxperf:    2.0 GHz target (maximum performance)"
        echo "  all:        Run all three variants"
        echo ""
        echo "Example: $0 aggressive 8"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Configuration:${NC}"
echo "  Target Frequency: $TARGET_FREQ"
echo "  Flow Variant:     ${FLOW_VARIANT:-default}"
echo "  Parallel Jobs:    $JOBS"
echo "  Output:           $RESULTS_DIR/$RUN_NAME"
echo ""

# Create results directory
mkdir -p "$RESULTS_DIR/$RUN_NAME"

# Build Docker command
DOCKER_CMD="cd /OpenROAD-flow-scripts/flow && "
if [ -n "$FLOW_VARIANT" ]; then
    DOCKER_CMD+="make DESIGN_CONFIG=designs/asap7/tritone/config.mk FLOW_VARIANT=$FLOW_VARIANT -j$JOBS"
else
    DOCKER_CMD+="make DESIGN_CONFIG=designs/asap7/tritone/config.mk -j$JOBS"
fi

echo -e "${CYAN}Starting Docker build...${NC}"
echo "Command: $DOCKER_CMD"
echo ""

# Convert Windows paths for Docker (handle Git Bash path mangling)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ -n "$MINGW_PREFIX" ]]; then
    # Windows with Git Bash - convert paths
    DOCKER_SCRIPT_DIR=$(cygpath -w "$SCRIPT_DIR" 2>/dev/null || echo "$SCRIPT_DIR")
    DOCKER_RESULTS_DIR=$(cygpath -w "$RESULTS_DIR/$RUN_NAME" 2>/dev/null || echo "$RESULTS_DIR/$RUN_NAME")
    export MSYS_NO_PATHCONV=1
else
    DOCKER_SCRIPT_DIR="$SCRIPT_DIR"
    DOCKER_RESULTS_DIR="$RESULTS_DIR/$RUN_NAME"
fi

# Run ORFS in Docker
docker run --rm \
    -v "$DOCKER_SCRIPT_DIR:/OpenROAD-flow-scripts" \
    -v "$DOCKER_RESULTS_DIR:/output" \
    -w //OpenROAD-flow-scripts \
    openroad/orfs:latest \
    bash -c "$DOCKER_CMD && cp -r flow/results/asap7/tritone/* /output/ 2>/dev/null || true && cp -r flow/logs/asap7/tritone/* /output/logs/ 2>/dev/null || true" \
    2>&1 | tee "$RESULTS_DIR/$RUN_NAME/docker_build.log"

# Check results
if [ -f "$RESULTS_DIR/$RUN_NAME/6_final.gds" ] || [ -f "$RESULTS_DIR/$RUN_NAME/base/6_final.gds" ]; then
    echo ""
    echo -e "${GREEN}=========================================="
    echo " BUILD SUCCESSFUL!"
    echo -e "==========================================${NC}"
    echo "Results: $RESULTS_DIR/$RUN_NAME"

    # Extract timing summary
    echo ""
    echo "=== Timing Summary ==="
    grep -r "slack" "$RESULTS_DIR/$RUN_NAME" 2>/dev/null | head -10 || true
else
    echo ""
    echo -e "${YELLOW}=========================================="
    echo " Build completed - check logs for details"
    echo -e "==========================================${NC}"
    echo "Logs: $RESULTS_DIR/$RUN_NAME"
fi
