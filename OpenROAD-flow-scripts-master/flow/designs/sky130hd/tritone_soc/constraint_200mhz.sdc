# Tritone TPU SoC - Sky130HD Timing Constraints
# Target: 200 MHz (5000 ps period) - Aggressive Performance
# Date: Jan 2026
#
# Aggressive timing for 130nm mature process node.
# Requires optimization and careful timing closure.

set clk_name core_clock
set clk_port_name clk
set clk_period 5000
set clk_io_pct 0.20

set clk_port [get_ports $clk_port_name]

# Primary clock - 200 MHz aggressive target
create_clock -name $clk_name -period $clk_period $clk_port

# Clock uncertainty for 130nm process variation
set_clock_uncertainty 150 [get_clocks $clk_name]

# Input/output delays - 20% of period for SoC interfaces
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_inputs]
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# Max transition for 130nm (tighter for aggressive timing)
set_max_transition 400 [current_design]

# Max fanout
set_max_fanout 20 [current_design]

# Load assumptions for outputs
set_load 0.1 [all_outputs]
