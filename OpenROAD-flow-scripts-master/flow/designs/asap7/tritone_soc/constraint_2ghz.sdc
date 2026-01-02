# Tritone TPU SoC - ASAP7 Timing Constraints
# Target: 2.0 GHz (500 ps period) - Maximum Performance
# Date: Jan 2026
#
# This constraint file targets the 2 GHz pipelined TPU architecture
# with USE_2GHZ_PIPELINE=1 enabled for 2-stage MAC operations.

set clk_name core_clock
set clk_port_name clk
set clk_period 500
set clk_io_pct 0.08

set clk_port [get_ports $clk_port_name]

# Primary clock - 2.0 GHz target (aggressive for SoC)
create_clock -name $clk_name -period $clk_period $clk_port

# Clock uncertainty for 7nm process variation - tight for 2 GHz
# Reduced from 30ps (1 GHz) to 10ps for high-frequency operation
set_clock_uncertainty 10 [get_clocks $clk_name]

# Input/output delays - 8% of period for aggressive timing
# This leaves 92% of the period for internal logic
set non_clock_inputs [all_inputs -no_clocks]
set_input_delay [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]

# False path for asynchronous reset
set_false_path -from [get_ports rst_n]

# External interface timing relaxation (debug/test interface)
# These interfaces don't need to meet 2 GHz timing
set_input_delay [expr $clk_period * 0.15] -clock $clk_name [get_ports ext_*] -quiet
set_output_delay [expr $clk_period * 0.15] -clock $clk_name [get_ports ext_*] -quiet

# Max transition for ultra-high-speed design
# Tight slew rate control critical for 2 GHz
set_max_transition 30 [current_design]

# Max fanout for TPU data paths
# Lower than 1 GHz (20) to reduce loading
set_max_fanout 16 [current_design]

# Clock latency estimates for CTS planning
set_clock_latency -source 50 [get_clocks $clk_name]

# TPU-specific path constraints
# The systolic array MAC chain is the critical path
# With 2-stage pipelining, each stage should fit in 250ps
# set_max_delay 250 -from [get_pins -hier */mac_*/stage1_reg*] -to [get_pins -hier */mac_*/stage2_reg*]
