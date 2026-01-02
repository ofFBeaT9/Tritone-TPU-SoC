# Tritone TPU SoC - ASAP7 Timing Constraints
# Target: 1.5 GHz (667 ps period) - Aggressive Performance
# Date: Dec 2025

set clk_name core_clock
set clk_port_name clk
set clk_period 667
set clk_io_pct 0.15

set clk_port [get_ports $clk_port_name]

# Primary clock - 1.5 GHz aggressive target
create_clock -name $clk_name -period $clk_period $clk_port

# Tighter clock uncertainty for aggressive timing
set_clock_uncertainty 20 [get_clocks $clk_name]

# Input/output delays
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# External interface false paths (test/debug - not timing critical)
set_false_path -from [get_ports ext_*]
set_false_path -to [get_ports ext_*]

# Max transition for high frequency
set_max_transition 50 [current_design]

# Tighter fanout for high frequency
set_max_fanout 10 [current_design]
