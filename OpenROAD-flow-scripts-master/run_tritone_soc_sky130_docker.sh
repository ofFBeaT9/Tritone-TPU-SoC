#!/bin/bash
# ============================================================
# Tritone TPU SoC - Docker OpenROAD Flow (Sky130HD)
# ============================================================
# Usage: ./run_tritone_soc_sky130_docker.sh [baseline|aggressive]
#
# Variants:
#   baseline   - 150 MHz target (default, recommended for 130nm)
#   aggressive - 200 MHz target (aggressive for 130nm)
#
# Note: Sky130 is a mature 130nm process node and cannot achieve
#       the frequencies possible on ASAP7 (7nm). Maximum practical
#       frequency is typically 150-200 MHz for complex designs.
#
# Date: Jan 2026
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VARIANT="${1:-baseline}"
DOCKER_IMAGE="openroad/orfs:latest"

# Handle Windows paths in MSYS/Git Bash
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Convert Windows path to Docker-friendly format
    MOUNT_PATH="/${SCRIPT_DIR//\\//}"
    MOUNT_PATH="${MOUNT_PATH/:/}"
    # Disable path conversion for docker commands
    export MSYS_NO_PATHCONV=1
else
    MOUNT_PATH="$SCRIPT_DIR"
fi

echo "============================================================"
echo "Tritone TPU SoC - Sky130HD Physical Implementation via Docker"
echo "============================================================"
echo "Target Variant: ${VARIANT}"
echo "Docker Image:   ${DOCKER_IMAGE}"
echo "Mount Path:     ${MOUNT_PATH}"
echo ""

case "$VARIANT" in
    baseline)
        echo "Running baseline 150 MHz flow..."
        CLOCK_TARGET="6667 ps (150 MHz)"
        ;;
    aggressive)
        echo "Running aggressive 200 MHz flow..."
        echo "WARNING: 200 MHz is aggressive for 130nm; expect potential timing violations"
        CLOCK_TARGET="5000 ps (200 MHz)"
        ;;
    *)
        echo "ERROR: Unknown variant '$VARIANT'"
        echo "Valid options: baseline, aggressive"
        exit 1
        ;;
esac

echo "Clock Period: ${CLOCK_TARGET}"
echo ""

# Pull latest image if not available
echo "Checking Docker image..."
docker pull ${DOCKER_IMAGE} 2>/dev/null || true

# Run OpenROAD flow
echo ""
echo "Starting OpenROAD synthesis and P&R..."
echo "============================================================"

docker run --rm -it \
    -v "${MOUNT_PATH}":/work \
    -w /work/flow \
    ${DOCKER_IMAGE} \
    make DESIGN_CONFIG=designs/sky130hd/tritone_soc/config.mk \
         FLOW_VARIANT=${VARIANT}

# Check results
RESULT_DIR="flow/results/sky130hd/tritone_soc"
if [ -d "$SCRIPT_DIR/$RESULT_DIR" ]; then
    echo ""
    echo "============================================================"
    echo "Flow Complete!"
    echo "============================================================"
    echo ""
    echo "Results directory: ${RESULT_DIR}/"
    echo ""
    echo "Key output files:"
    echo "  - 6_final.gds    : Final layout"
    echo "  - 6_final.def    : Final DEF"
    echo "  - 6_final.v      : Final netlist"
    echo ""
    echo "Reports:"
    ls -la "$SCRIPT_DIR/$RESULT_DIR"/*.rpt 2>/dev/null || echo "  (reports in logs directory)"
    echo ""

    # Display timing summary if available
    TIMING_REPORT="$SCRIPT_DIR/$RESULT_DIR/base/6_report.log"
    if [ -f "$TIMING_REPORT" ]; then
        echo "Timing Summary:"
        grep -E "WNS|TNS|Slack" "$TIMING_REPORT" | head -10
    fi
else
    echo ""
    echo "WARNING: Results directory not found. Check logs for errors."
fi
