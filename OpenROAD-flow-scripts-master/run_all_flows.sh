#!/bin/bash
# ============================================================
# Tritone TPU SoC - Parallel OpenROAD Flow Execution
# ============================================================
# Runs all 5 flow variants in parallel using Docker containers
#
# Usage: ./run_all_flows.sh [cores_per_job]
#   cores_per_job: CPU cores per container (default: 4)
#
# Date: Jan 2026
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORES_PER_JOB="${1:-4}"
DOCKER_IMAGE="openroad/orfs:latest"

# Handle Windows paths in MSYS/Git Bash
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    MOUNT_PATH="/${SCRIPT_DIR//\\//}"
    MOUNT_PATH="${MOUNT_PATH/:/}"
    export MSYS_NO_PATHCONV=1
else
    MOUNT_PATH="$SCRIPT_DIR"
fi

echo "============================================================"
echo "Tritone TPU SoC - Parallel Physical Implementation"
echo "============================================================"
echo "Docker Image:      ${DOCKER_IMAGE}"
echo "Cores per Job:     ${CORES_PER_JOB}"
echo "Mount Path:        ${MOUNT_PATH}"
echo ""
echo "Starting 5 parallel flows:"
echo "  - ASAP7 1.0 GHz (baseline)"
echo "  - ASAP7 1.5 GHz (aggressive)"
echo "  - ASAP7 2.0 GHz (maxperf)"
echo "  - Sky130 150 MHz (baseline)"
echo "  - Sky130 200 MHz (aggressive)"
echo ""

# Pull latest image if needed
echo "Ensuring Docker image is available..."
docker pull ${DOCKER_IMAGE} 2>/dev/null || true

# Create results directory
mkdir -p "${SCRIPT_DIR}/asic_results"

# Start ASAP7 variants
echo ""
echo "[1/5] Starting ASAP7 1.0 GHz baseline..."
docker run --rm -d --name tritone_asap7_1ghz \
    -v "${MOUNT_PATH}":/work \
    -w /work/flow \
    ${DOCKER_IMAGE} \
    bash -c "make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk FLOW_VARIANT=baseline -j${CORES_PER_JOB} 2>&1 | tee /work/asic_results/asap7_1ghz.log"

echo "[2/5] Starting ASAP7 1.5 GHz aggressive..."
docker run --rm -d --name tritone_asap7_1500mhz \
    -v "${MOUNT_PATH}":/work \
    -w /work/flow \
    ${DOCKER_IMAGE} \
    bash -c "make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk FLOW_VARIANT=aggressive -j${CORES_PER_JOB} 2>&1 | tee /work/asic_results/asap7_1500mhz.log"

echo "[3/5] Starting ASAP7 2.0 GHz maxperf..."
docker run --rm -d --name tritone_asap7_2ghz \
    -v "${MOUNT_PATH}":/work \
    -w /work/flow \
    ${DOCKER_IMAGE} \
    bash -c "make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk FLOW_VARIANT=maxperf -j${CORES_PER_JOB} 2>&1 | tee /work/asic_results/asap7_2ghz.log"

# Start Sky130 variants
echo "[4/5] Starting Sky130 150 MHz baseline..."
docker run --rm -d --name tritone_sky130_150mhz \
    -v "${MOUNT_PATH}":/work \
    -w /work/flow \
    ${DOCKER_IMAGE} \
    bash -c "make DESIGN_CONFIG=designs/sky130hd/tritone_soc/config.mk FLOW_VARIANT=baseline -j${CORES_PER_JOB} 2>&1 | tee /work/asic_results/sky130_150mhz.log"

echo "[5/5] Starting Sky130 200 MHz aggressive..."
docker run --rm -d --name tritone_sky130_200mhz \
    -v "${MOUNT_PATH}":/work \
    -w /work/flow \
    ${DOCKER_IMAGE} \
    bash -c "make DESIGN_CONFIG=designs/sky130hd/tritone_soc/config.mk FLOW_VARIANT=aggressive -j${CORES_PER_JOB} 2>&1 | tee /work/asic_results/sky130_200mhz.log"

echo ""
echo "============================================================"
echo "All 5 flows started in parallel!"
echo "============================================================"
echo ""
echo "Monitor progress with:"
echo "  docker ps                              # List running containers"
echo "  docker logs -f tritone_asap7_1ghz     # Follow specific log"
echo "  docker logs -f tritone_asap7_2ghz     # Follow 2 GHz log"
echo ""
echo "Log files saved to: asic_results/*.log"
echo ""
echo "Waiting for all flows to complete..."
echo "(This may take several hours depending on your system)"
echo ""

# Wait for all containers to complete
docker wait tritone_asap7_1ghz tritone_asap7_1500mhz tritone_asap7_2ghz \
             tritone_sky130_150mhz tritone_sky130_200mhz 2>/dev/null || true

echo ""
echo "============================================================"
echo "All flows complete!"
echo "============================================================"
echo ""
echo "Run ./extract_timing.sh to generate timing summary report"
