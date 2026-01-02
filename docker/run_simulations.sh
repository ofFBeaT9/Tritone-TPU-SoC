#!/bin/bash
# ============================================================================
# SKY130 BSIM4 Multi-Vth STI Simulation Runner (Linux/macOS)
# ============================================================================
# Builds Docker image and runs full PVT characterization
# ============================================================================

set -e

echo "============================================"
echo "SKY130 BSIM4 Multi-Vth STI Characterization"
echo "============================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker not found. Please install Docker."
    echo "  Ubuntu/Debian: sudo apt install docker.io"
    echo "  macOS: brew install --cask docker"
    exit 1
fi

cd "$SCRIPT_DIR"

echo "Step 1: Building Docker image..."
docker build -t tritone-spice .

echo ""
echo "Step 2: Creating results directory..."
mkdir -p "$PROJECT_DIR/spice/results"

echo ""
echo "Step 3: Running TT corner simulation..."
docker run --rm -v "$PROJECT_DIR":/tritone tritone-spice \
    /bin/bash -c "cd /tritone/spice && mkdir -p results && \
    ngspice -b testbenches/tb_sti_multivth_bsim4.spice 2>&1 | \
    tee results/sim_tt.log"

echo ""
echo "Step 4: Running all process corners..."
docker run --rm -v "$PROJECT_DIR":/tritone tritone-spice \
    /bin/bash -c "cd /tritone/spice && \
    ngspice -b testbenches/tb_sti_multicorner_bsim4.spice 2>&1 | \
    tee results/sim_multicorner.log"

echo ""
echo "Step 5: Generating plots..."
docker run --rm -v "$PROJECT_DIR":/tritone tritone-spice \
    python3 /tritone/tools/plot_pvt_results.py \
    --results-dir /tritone/spice/results \
    --output-dir /tritone/spice/results

echo ""
echo "============================================"
echo "Simulation Complete!"
echo "============================================"
echo ""
echo "Results saved to: $PROJECT_DIR/spice/results/"
echo ""
echo "Key files:"
echo "  - sim_tt.log              : TT corner full results"
echo "  - sim_multicorner.log     : All corners summary"
echo "  - dc_*.dat                : DC transfer data"
echo "  - dc_transfer_all_corners.png : DC transfer plot"
echo "  - noise_margins.png       : Noise margin comparison"
echo ""
