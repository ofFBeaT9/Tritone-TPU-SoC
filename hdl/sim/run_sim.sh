#!/bin/bash
# Ternary HDL Simulation Script
# Requires Icarus Verilog (iverilog) or compatible simulator

# Set paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RTL_DIR="$SCRIPT_DIR/../rtl"
TB_DIR="$SCRIPT_DIR/../tb"
OUT_DIR="$SCRIPT_DIR/output"

# Create output directory
mkdir -p "$OUT_DIR"

echo "=========================================="
echo "Ternary HDL Simulation"
echo "=========================================="
echo ""

# Function to run a testbench
run_test() {
    local tb_name=$1
    local tb_file=$2

    echo "--- Running $tb_name ---"

    # Compile with Icarus Verilog
    iverilog -g2012 -o "$OUT_DIR/${tb_name}.vvp" \
        "$RTL_DIR/ternary_pkg.sv" \
        "$RTL_DIR/btfa.sv" \
        "$RTL_DIR/ternary_adder.sv" \
        "$RTL_DIR/ternary_alu.sv" \
        "$TB_DIR/$tb_file"

    if [ $? -eq 0 ]; then
        echo "Compilation successful."
        echo "Running simulation..."
        vvp "$OUT_DIR/${tb_name}.vvp" | tee "$OUT_DIR/${tb_name}.log"
        echo ""
    else
        echo "Compilation failed!"
        return 1
    fi
}

# Parse command line arguments
if [ $# -eq 0 ]; then
    # Run all tests
    echo "Running all testbenches..."
    echo ""

    run_test "btfa" "tb_btfa.sv"
    run_test "ternary_adder" "tb_ternary_adder.sv"
    run_test "ternary_alu" "tb_ternary_alu.sv"

    echo "=========================================="
    echo "All simulations complete!"
    echo "Logs saved to: $OUT_DIR"
    echo "=========================================="
else
    # Run specific test
    case $1 in
        btfa)
            run_test "btfa" "tb_btfa.sv"
            ;;
        adder)
            run_test "ternary_adder" "tb_ternary_adder.sv"
            ;;
        alu)
            run_test "ternary_alu" "tb_ternary_alu.sv"
            ;;
        *)
            echo "Unknown test: $1"
            echo "Available tests: btfa, adder, alu"
            exit 1
            ;;
    esac
fi
