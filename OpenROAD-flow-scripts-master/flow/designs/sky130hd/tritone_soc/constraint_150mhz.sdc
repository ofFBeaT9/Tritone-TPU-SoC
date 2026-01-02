# Tritone TPU SoC - Sky130HD Timing Constraints
# Target: 150 MHz (6667 ps period) - Baseline Performance
# Date: Jan 2026
#
# Conservative timing for 130nm mature process node.
# Achievable with standard synthesis optimization.

set clk_name core_clock
set clk_port_name clk
set clk_period 6667
set clk_io_pct 0.20

set clk_port [get_ports $clk_port_name]

# Primary clock - 150 MHz baseline target
create_clock -name $clk_name -period $clk_period $clk_port

# Clock uncertainty for 130nm process variation
# Higher than 7nm due to larger process variation
set_clock_uncertainty 200 [get_clocks $clk_name]

# Input/output delays - 20% of period for SoC interfaces
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_inputs]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# Max transition for 130nm (relaxed compared to 7nm)
set_max_transition 500 [current_design]

# Max fanout
set_max_fanout 24 [current_design]

# Load assumptions for outputs
set_load 0.1 [all_outputs]
