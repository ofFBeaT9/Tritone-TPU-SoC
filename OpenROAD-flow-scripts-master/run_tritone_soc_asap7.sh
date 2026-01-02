#!/bin/bash
# Run Tritone TPU SoC through OpenROAD flow (ASAP7 7nm)
# Usage: ./run_tritone_soc_asap7.sh [baseline|aggressive]
#
# Variants:
#   baseline   - 1.0 GHz target (default, recommended)
#   aggressive - 1.5 GHz target
#
# Date: Dec 2025

set -e

cd "$(dirname "$0")/flow"

VARIANT="${1:-baseline}"

echo "============================================================"
echo "Tritone TPU SoC - ASAP7 Physical Implementation"
echo "============================================================"
echo "Target: ${VARIANT}"
echo ""

if [ "$VARIANT" = "aggressive" ]; then
    echo "Running aggressive 1.5 GHz flow..."
    make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk FLOW_VARIANT=aggressive
else
    echo "Running baseline 1.0 GHz flow..."
    make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk
fi

echo ""
echo "============================================================"
echo "Flow complete! Check results in:"
echo "  flow/results/asap7/tritone_soc/"
echo "============================================================"
