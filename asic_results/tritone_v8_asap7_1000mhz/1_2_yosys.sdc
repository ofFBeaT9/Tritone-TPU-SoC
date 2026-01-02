# Tritone v8 CLA - ASAP7 Timing Constraints
# Target: 1.0 GHz (1000 ps period) - Baseline Performance
# Date: Dec 2025

set clk_name core_clock
set clk_port_name clk
set clk_period 1000
set clk_io_pct 0.15

set clk_port [get_ports $clk_port_name]

# Primary clock - 1.0 GHz baseline target
create_clock -name $clk_name -period $clk_period $clk_port

# Clock uncertainty for 7nm process variation
set_clock_uncertainty 25 [get_clocks $clk_name]

# Input/output delays - 15% of period
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# Max transition
set_max_transition 60 [current_design]
