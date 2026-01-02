# Tritone TPU SoC - ASAP7 Timing Constraints
# Target: 1.0 GHz (1000 ps period) - Baseline Performance
# Date: Dec 2025

set clk_name core_clock
set clk_port_name clk
set clk_period 1000
set clk_io_pct 0.20

set clk_port [get_ports $clk_port_name]

# Primary clock - 1.0 GHz baseline target
create_clock -name $clk_name -period $clk_period $clk_port

# Clock uncertainty for 7nm process variation (slightly higher for larger design)
set_clock_uncertainty 30 [get_clocks $clk_name]

# Input/output delays - 20% of period for SoC interfaces
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# External interface timing relaxation (debug/test interface)
set_input_delay [expr $clk_period * 0.3] -clock $clk_name [get_ports ext_*]
set_output_delay [expr $clk_period * 0.3] -clock $clk_name [get_ports ext_*]

# Max transition for larger design
set_max_transition 80 [current_design]

# Max fanout for TPU data paths
set_max_fanout 20 [current_design]
