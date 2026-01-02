# Ternary ALU Intel Quartus Constraints
# Phase 3: FPGA ALU Prototype - Intel Quartus Variant
# Target: Intel Cyclone V / Arria / Stratix (adjust for your specific device)

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
# Max delay constraints on critical ALU paths

# Binary-to-ternary conversion path
set_max_delay -from [get_pins {gen_input_conv[*].u_bin2tern|trit_out*}] \
              -to [get_pins {u_alu|a[*]}] 2.0

# Ternary ALU internal computation path
set_max_delay -from [get_pins {u_alu|a[*]}] \
              -to [get_pins {result_tern[*]}] 6.0

# Ternary-to-binary conversion path
set_max_delay -from [get_pins {result_tern[*]}] \
              -to [get_pins {gen_output_conv[*].u_tern2bin|bin_out*}] 2.0

# Carry propagation path
set_max_delay -from [get_pins {u_alu|gen_adders[0].*|carry_out}] \
              -to [get_pins {carry_bin[*]}] 8.0

# I/O standards (adjust for your board voltage levels)
# Note: Set in Quartus Pin Planner or assignment file
# set_instance_assignment -name IO_STANDARD "1.8 V" -to *

# Timing exceptions for multicycle paths (if needed)
# set_multicycle_path -setup -from [get_registers *] -to [get_registers *] 2
# set_multicycle_path -hold -from [get_registers *] -to [get_registers *] 1

# Optimization directives
derive_pll_clocks
derive_clock_uncertainty
