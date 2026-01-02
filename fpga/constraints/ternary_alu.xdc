# Ternary ALU FPGA Constraints
# Phase 3: FPGA ALU Prototype
# Target: Xilinx UltraScale+ (adjust pins for your specific board)

# Clock constraint - 100 MHz
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Input delays (2ns setup, 0.5ns hold)
set_input_delay -clock sys_clk -max 2.0 [get_ports {a_bin[*] b_bin[*] op[*] valid_in}]
set_input_delay -clock sys_clk -min 0.5 [get_ports {a_bin[*] b_bin[*] op[*] valid_in}]

# Output delays (2ns setup, 0.5ns hold)
set_output_delay -clock sys_clk -max 2.0 [get_ports {result_bin[*] carry_bin[*] zero_flag neg_flag valid_out}]
set_output_delay -clock sys_clk -min 0.5 [get_ports {result_bin[*] carry_bin[*] zero_flag neg_flag valid_out}]

# Reset is asynchronous
set_false_path -from [get_ports rst_n]

# Internal timing constraints (REC-3.3)
# Max delay constraints on critical ALU paths to guide synthesis optimizer
# Note: Adjust these paths based on actual hierarchy after synthesis

# Binary-to-ternary conversion path (8 trits, 2-cycle budget)
set_max_delay -from [get_pins {gen_input_conv[*].u_bin2tern/trit_out*}] \
              -to [get_pins {u_alu/a[*]}] 2.0

# Ternary ALU internal computation path (main datapath, 6ns budget for 100 MHz)
set_max_delay -from [get_pins {u_alu/a[*]}] \
              -to [get_pins {result_tern[*]}] 6.0

# Ternary-to-binary conversion path (output stage, 2-cycle budget)  
set_max_delay -from [get_pins {result_tern[*]}] \
              -to [get_pins {gen_output_conv[*].u_tern2bin/bin_out*}] 2.0

# Carry propagation path (critical for adder timing)
set_max_delay -from [get_pins {u_alu/gen_adders[0].*/carry_out}] \
              -to [get_pins {carry_bin[*]}] 8.0

# I/O standards (adjust for your board voltage levels)
set_property IOSTANDARD LVCMOS18 [get_ports *]

# Optional: Physical placement constraints for critical paths
# Uncomment and adjust for your specific FPGA device
# set_property LOC SLICE_X0Y0 [get_cells u_alu/gen_adders[0].u_btfa]
# set_property LOC SLICE_X1Y0 [get_cells u_alu/gen_adders[1].u_btfa]

# Timing exceptions for cross-clock domains (if applicable)
# set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]

# Power optimization (optional)
# set_property POWER_OPT_DESIGN_TARGET auto [current_design]