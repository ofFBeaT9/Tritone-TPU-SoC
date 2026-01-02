# Tritone HDL Makefile
# Supports both Icarus Verilog and Verilator simulation
#
# Usage:
#   make test-adder      - Run adder testbench
#   make test-alu        - Run ALU testbench
#   make test-btfa       - Run BTFA testbench
#   make test-cla        - Run CLA testbench
#   make test-all        - Run all testbenches
#   make test-icarus     - Run Icarus-compatible testbenches
#   make verilator-cpu   - Run CPU testbench with Verilator
#   make clean           - Clean generated files
#
# Simulator Selection:
#   SIMULATOR=iverilog (default) or verilator

SIMULATOR ?= iverilog

# Directories
RTL_DIR = rtl
TB_DIR = tb
BUILD_DIR = build

# RTL source files
RTL_COMMON = $(RTL_DIR)/ternary_pkg.sv
RTL_CELLS = $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv $(RTL_DIR)/ternary_alu.sv
RTL_CLA = $(RTL_DIR)/ternary_cla.sv $(RTL_DIR)/ternary_adder_configurable.sv $(RTL_DIR)/ternary_adder_8trit_cla.sv
RTL_CPU = $(RTL_DIR)/ternary_cpu.sv $(RTL_DIR)/ternary_regfile.sv $(RTL_DIR)/ternary_memory.sv \
          $(RTL_DIR)/btisa_decoder.sv $(RTL_DIR)/ternary_branch_predictor.sv \
          $(RTL_DIR)/ternary_forward_unit.sv $(RTL_DIR)/ternary_hazard_unit.sv

# TPU RTL source files
RTL_TPU = $(RTL_DIR)/tpu/ternary_mac.sv $(RTL_DIR)/tpu/ternary_pe.sv \
          $(RTL_DIR)/tpu/ternary_systolic_array.sv $(RTL_DIR)/tpu/ternary_systolic_controller.sv \
          $(RTL_DIR)/tpu/tpu_top.sv

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# ============================================================
# Icarus Verilog Targets (Default)
# ============================================================

# Hello World test (basic sanity check)
test-hello: $(BUILD_DIR)
	iverilog -g2012 -o $(BUILD_DIR)/tb_hello $(TB_DIR)/tb_hello_world.sv
	vvp $(BUILD_DIR)/tb_hello

# BTFA testbench
test-btfa: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_btfa \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(TB_DIR)/tb_btfa.sv
	vvp $(BUILD_DIR)/tb_btfa

# Adder testbench (Icarus-compatible)
test-adder: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_adder_icarus \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv \
		$(TB_DIR)/tb_ternary_adder_icarus.sv
	vvp $(BUILD_DIR)/tb_adder_icarus

# Adder testbench (SystemVerilog - may not work on older Icarus)
test-adder-sv: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_adder \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv \
		$(TB_DIR)/tb_ternary_adder.sv
	vvp $(BUILD_DIR)/tb_adder

# ALU testbench (Icarus-compatible) - includes CLA for 8-trit adder
test-alu: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_alu_icarus \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv \
		$(RTL_CLA) $(RTL_DIR)/ternary_alu.sv $(TB_DIR)/tb_ternary_alu_icarus.sv
	vvp $(BUILD_DIR)/tb_alu_icarus

# ALU testbench (SystemVerilog) - includes CLA for 8-trit adder
test-alu-sv: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_alu \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv \
		$(RTL_CLA) $(RTL_DIR)/ternary_alu.sv $(TB_DIR)/tb_ternary_alu.sv
	vvp $(BUILD_DIR)/tb_alu

# CLA testbench
test-cla: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_cla \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv \
		$(RTL_DIR)/ternary_cla.sv $(TB_DIR)/tb_ternary_cla.sv
	vvp $(BUILD_DIR)/tb_cla

# CPU testbench (requires more advanced SystemVerilog support)
test-cpu: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -DSIMULATION -o $(BUILD_DIR)/tb_cpu \
		$(RTL_COMMON) $(RTL_CELLS) $(RTL_CLA) $(RTL_CPU) \
		$(RTL_DIR)/ternary_cpu_system.sv $(TB_DIR)/tb_ternary_cpu.sv
	vvp $(BUILD_DIR)/tb_cpu

# ============================================================
# TPU Testbenches
# ============================================================

# TPU MAC testbench
test-mac: $(BUILD_DIR)
	"C:/iverilog/bin/iverilog" -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_mac \
		$(RTL_COMMON) $(RTL_CLA) $(RTL_DIR)/tpu/ternary_mac.sv \
		$(TB_DIR)/tpu/tb_ternary_mac.sv
	"C:/iverilog/bin/vvp" $(BUILD_DIR)/tb_mac

# TPU PE testbench
test-pe: $(BUILD_DIR)
	"C:/iverilog/bin/iverilog" -g2012 -I$(RTL_DIR) -o $(BUILD_DIR)/tb_pe \
		$(RTL_COMMON) $(RTL_CLA) $(RTL_DIR)/tpu/ternary_mac.sv \
		$(RTL_DIR)/tpu/ternary_pe.sv $(TB_DIR)/tpu/tb_ternary_pe.sv
	"C:/iverilog/bin/vvp" $(BUILD_DIR)/tb_pe

# TPU Top testbench (uses integer versions with TPU_INT_ONLY)
test-tpu: $(BUILD_DIR)
	"C:/iverilog/bin/iverilog" -g2012 -I$(RTL_DIR) -DTPU_INT_ONLY -o $(BUILD_DIR)/tb_tpu \
		$(RTL_COMMON) $(RTL_DIR)/tpu/ternary_pe.sv $(RTL_DIR)/tpu/ternary_systolic_array.sv \
		$(RTL_DIR)/tpu/ternary_systolic_controller.sv $(RTL_DIR)/tpu/tpu_top.sv \
		$(TB_DIR)/tpu/tb_tpu_top.sv
	"C:/iverilog/bin/vvp" $(BUILD_DIR)/tb_tpu

# All TPU tests
test-tpu-all: test-mac test-tpu
	@echo ""
	@echo "=============================================="
	@echo "All TPU tests completed"
	@echo "=============================================="

# ============================================================
# Icarus-Compatible Test Suite
# ============================================================

test-icarus: test-btfa test-adder test-alu test-cla
	@echo ""
	@echo "=============================================="
	@echo "All Icarus-compatible tests completed"
	@echo "=============================================="

# ============================================================
# All Tests
# ============================================================

test-all: test-icarus test-cpu
	@echo ""
	@echo "=============================================="
	@echo "All tests completed"
	@echo "=============================================="

# ============================================================
# Verilator Targets (for faster simulation)
# ============================================================

verilator-cpu: $(BUILD_DIR)
	verilator --cc --exe --build -j 0 \
		-I$(RTL_DIR) \
		--top-module tb_ternary_cpu \
		-DSIMULATION \
		$(RTL_COMMON) $(RTL_CELLS) $(RTL_CLA) $(RTL_CPU) \
		$(RTL_DIR)/ternary_cpu_system.sv $(TB_DIR)/tb_ternary_cpu.sv \
		-o $(BUILD_DIR)/Vtb_ternary_cpu
	./$(BUILD_DIR)/Vtb_ternary_cpu

# ============================================================
# Waveform Generation
# ============================================================

# Add +define+DUMP_VCD to enable VCD generation
test-adder-vcd: $(BUILD_DIR)
	iverilog -g2012 -I$(RTL_DIR) -DDUMP_VCD -o $(BUILD_DIR)/tb_adder_vcd \
		$(RTL_COMMON) $(RTL_DIR)/btfa.sv $(RTL_DIR)/ternary_adder.sv \
		$(TB_DIR)/tb_ternary_adder_icarus.sv
	vvp $(BUILD_DIR)/tb_adder_vcd
	@echo "VCD file generated: dump.vcd"
	@echo "View with: gtkwave dump.vcd"

# ============================================================
# Lint / Static Analysis
# ============================================================

lint:
	verilator --lint-only -I$(RTL_DIR) \
		$(RTL_COMMON) $(RTL_CELLS) $(RTL_CLA) $(RTL_CPU)

# ============================================================
# Clean
# ============================================================

clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd
	rm -f *.log

.PHONY: test-hello test-btfa test-adder test-adder-sv test-alu test-alu-sv \
        test-cla test-cpu test-icarus test-all verilator-cpu \
        test-adder-vcd lint clean test-mac test-pe test-tpu test-tpu-all
