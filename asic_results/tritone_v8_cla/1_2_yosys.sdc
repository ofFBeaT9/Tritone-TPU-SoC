# Tritone Ternary CPU System - Timing Constraints
# Clock period: 3.33ns (300 MHz) - Ultra Performance Configuration

set_units -time ns

# Primary clock - 300 MHz stretch target
create_clock [get_ports clk] -name core_clock -period 3.33

# Input delays (relative to clock) - 15% of period
set_input_delay -clock core_clock -max 0.5 [get_ports rst_n]
set_input_delay -clock core_clock -max 0.5 [get_ports prog_mode]
set_input_delay -clock core_clock -max 0.5 [get_ports prog_we]
set_input_delay -clock core_clock -max 0.5 [get_ports prog_addr*]
set_input_delay -clock core_clock -max 0.5 [get_ports prog_data*]
set_input_delay -clock core_clock -max 0.5 [get_ports debug_reg_addr*]

# Output delays (relative to clock) - 15% of period
set_output_delay -clock core_clock -max 0.5 [get_ports halted]
set_output_delay -clock core_clock -max 0.5 [get_ports valid_out]
set_output_delay -clock core_clock -max 0.5 [get_ports pc_out*]
set_output_delay -clock core_clock -max 0.5 [get_ports debug_reg_data*]
set_output_delay -clock core_clock -max 0.5 [get_ports stall_out]
set_output_delay -clock core_clock -max 0.5 [get_ports fwd_a_out]
set_output_delay -clock core_clock -max 0.5 [get_ports fwd_b_out]

# False paths for reset
set_false_path -from [get_ports rst_n]
