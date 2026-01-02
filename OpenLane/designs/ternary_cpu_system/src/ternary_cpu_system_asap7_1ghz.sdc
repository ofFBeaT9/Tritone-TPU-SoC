# Tritone Ternary CPU System - ASAP7 Timing Constraints
# Clock period: 1.0ns (1.0 GHz) - Baseline Performance for 7nm
# v8 CLA-enabled configuration

set_units -time ns

# Primary clock - 1.0 GHz baseline
create_clock [get_ports clk] -name core_clock -period 1.0

# Clock uncertainty for 7nm process
set_clock_uncertainty 0.03 [get_clocks core_clock]

# Clock transition
set_clock_transition 0.03 [get_clocks core_clock]

# Input delays (relative to clock) - 10% of period
set_input_delay -clock core_clock -max 0.1 [get_ports rst_n]
set_input_delay -clock core_clock -max 0.1 [get_ports prog_mode]
set_input_delay -clock core_clock -max 0.1 [get_ports prog_we]
set_input_delay -clock core_clock -max 0.1 [get_ports prog_addr*]
set_input_delay -clock core_clock -max 0.1 [get_ports prog_data*]
set_input_delay -clock core_clock -max 0.1 [get_ports debug_reg_addr*]

# Output delays (relative to clock) - 10% of period
set_output_delay -clock core_clock -max 0.1 [get_ports halted]
set_output_delay -clock core_clock -max 0.1 [get_ports valid_out]
set_output_delay -clock core_clock -max 0.1 [get_ports pc_out*]
set_output_delay -clock core_clock -max 0.1 [get_ports debug_reg_data*]
set_output_delay -clock core_clock -max 0.1 [get_ports stall_out]
set_output_delay -clock core_clock -max 0.1 [get_ports fwd_a_out]
set_output_delay -clock core_clock -max 0.1 [get_ports fwd_b_out]

# False paths for asynchronous reset
set_false_path -from [get_ports rst_n]

# Max transition constraints for 7nm
set_max_transition 0.08 [current_design]

# Max capacitance
set_max_capacitance 0.03 [current_design]

# Driving cell and load assumptions
set_driving_cell -lib_cell BUFx2_ASAP7_75t_R -pin Y [all_inputs]
set_load 0.005 [all_outputs]
