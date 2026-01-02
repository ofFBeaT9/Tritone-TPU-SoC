# Tritone CPU System FPGA Constraints
# Target: Artix-7 (Nexys A7 / Basys 3 compatible)
# Modify pin assignments for your specific board

# ============================================================
# Clock Constraints
# ============================================================

# Primary clock: 400 MHz (2.5 ns period) - Aggressive target with CLA
# Note: Actual board oscillator may be 100 MHz; use MMCM/PLL to generate
# For conservative timing, change to 10.000 ns (100 MHz) or 3.333 ns (300 MHz)
create_clock -period 2.500 -name sys_clk [get_ports sys_clk]

# Clock uncertainty for timing margin (tighter for high frequency)
set_clock_uncertainty 0.050 [get_clocks sys_clk]

# ============================================================
# CLA Critical Path Constraints
# ============================================================

# ALU adder path (CLA reduces from 8 stages to ~3)
# set_max_delay -from [get_pins -hierarchical *u_adder*] \
#               -to [get_pins -hierarchical *add_result*] 1.200

# PC incrementer paths
# set_max_delay -from [get_pins -hierarchical *pc_incrementer*] \
#               -to [get_pins -hierarchical *pc_plus*] 1.000

# Branch target calculation
# set_max_delay -from [get_pins -hierarchical *branch_adder*] \
#               -to [get_pins -hierarchical *branch_target*] 1.200

# ============================================================
# Input Delay Constraints
# ============================================================

# Reset input - synchronous to clock
set_input_delay -clock sys_clk -max 2.0 [get_ports sys_rst_n]
set_input_delay -clock sys_clk -min 0.5 [get_ports sys_rst_n]

# Debug select inputs
set_input_delay -clock sys_clk -max 2.0 [get_ports {debug_sel[*]}]
set_input_delay -clock sys_clk -min 0.5 [get_ports {debug_sel[*]}]

# ============================================================
# Output Delay Constraints
# ============================================================

# LED outputs (relaxed timing - visual only)
set_output_delay -clock sys_clk -max 5.0 [get_ports {led[*]}]
set_output_delay -clock sys_clk -min 0.5 [get_ports {led[*]}]

set_output_delay -clock sys_clk -max 5.0 [get_ports halted_led]
set_output_delay -clock sys_clk -max 5.0 [get_ports valid_a_led]
set_output_delay -clock sys_clk -max 5.0 [get_ports valid_b_led]

# Debug data outputs
set_output_delay -clock sys_clk -max 3.0 [get_ports {debug_data[*]}]
set_output_delay -clock sys_clk -min 0.5 [get_ports {debug_data[*]}]

# ============================================================
# False Paths
# ============================================================

# Reset is synchronized internally, treat as async
set_false_path -from [get_ports sys_rst_n] -to [all_registers]

# ============================================================
# Pin Assignments (Uncomment and modify for your board)
# ============================================================

# --- Nexys A7 / Artix-7 Example ---
# Clock
# set_property PACKAGE_PIN E3 [get_ports sys_clk]
# set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

# Reset (Active Low - typically a button)
# set_property PACKAGE_PIN C12 [get_ports sys_rst_n]
# set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

# LEDs (LD0-LD3)
# set_property PACKAGE_PIN H17 [get_ports {led[0]}]
# set_property PACKAGE_PIN K15 [get_ports {led[1]}]
# set_property PACKAGE_PIN J13 [get_ports {led[2]}]
# set_property PACKAGE_PIN N14 [get_ports {led[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# Status LEDs (LD4-LD6)
# set_property PACKAGE_PIN R18 [get_ports halted_led]
# set_property PACKAGE_PIN V17 [get_ports valid_a_led]
# set_property PACKAGE_PIN U17 [get_ports valid_b_led]
# set_property IOSTANDARD LVCMOS33 [get_ports halted_led]
# set_property IOSTANDARD LVCMOS33 [get_ports valid_a_led]
# set_property IOSTANDARD LVCMOS33 [get_ports valid_b_led]

# Switches for debug select (SW0-SW1)
# set_property PACKAGE_PIN J15 [get_ports {debug_sel[0]}]
# set_property PACKAGE_PIN L16 [get_ports {debug_sel[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {debug_sel[*]}]

# Debug data on PMOD JA (optional)
# set_property PACKAGE_PIN C17 [get_ports {debug_data[0]}]
# set_property PACKAGE_PIN D18 [get_ports {debug_data[1]}]
# set_property PACKAGE_PIN E18 [get_ports {debug_data[2]}]
# set_property PACKAGE_PIN G17 [get_ports {debug_data[3]}]
# set_property PACKAGE_PIN D17 [get_ports {debug_data[4]}]
# set_property PACKAGE_PIN E17 [get_ports {debug_data[5]}]
# set_property PACKAGE_PIN F18 [get_ports {debug_data[6]}]
# set_property PACKAGE_PIN G18 [get_ports {debug_data[7]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {debug_data[*]}]

# ============================================================
# Physical Constraints
# ============================================================

# Allow placement anywhere (no LOC constraints by default)
# set_property ALLOW_COMBINATORIAL_LOOPS FALSE [current_design]

# ============================================================
# Power Optimization
# ============================================================

# Enable power optimization
set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]

# ============================================================
# Configuration
# ============================================================

# Configuration voltage
# set_property CFGBVS VCCO [current_design]
# set_property CONFIG_VOLTAGE 3.3 [current_design]
