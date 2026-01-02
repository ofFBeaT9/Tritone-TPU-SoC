# Tritone v8 CLA - ASAP7 Timing Constraints
# Target: 2.0 GHz (500 ps period) - High Performance
# Date: Dec 2025

set clk_name core_clock
set clk_port_name clk
set clk_period 500
set clk_io_pct 0.08

set clk_port [get_ports $clk_port_name]

# Primary clock - 2.0 GHz target
create_clock -name $clk_name -period $clk_period $clk_port

# Clock uncertainty for 7nm process variation - tighter
set_clock_uncertainty 10 [get_clocks $clk_name]

# Input/output delays - 8% of period for aggressive timing
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# Max transition for ultra-high-speed design
set_max_transition 30 [current_design]
