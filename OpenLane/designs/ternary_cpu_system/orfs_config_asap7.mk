# ORFS Configuration for Tritone v8 CLA - ASAP7 (7nm Predictive)
# Target: Maximum performance - 1.5 GHz aggressive, 1.0 GHz baseline
# Date: Dec 2025

export DESIGN_NAME = ternary_cpu_system
export PLATFORM = asap7

# Source files - use slang for full SystemVerilog support
export SYNTH_HDL_FRONTEND = slang
export VERILOG_FILES = $(wildcard $(DESIGN_HOME)/src/*.sv)
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src

# Clock configuration - 1.5 GHz aggressive target for 7nm
# ASAP7 library characterized for high-frequency operation
export CLOCK_PORT = clk
export CLOCK_PERIOD = 0.667

# Use ASAP7-specific SDC
export SDC_FILE = $(DESIGN_HOME)/src/ternary_cpu_system_asap7.sdc

# Floorplan configuration - tighter for 7nm
export CORE_UTILIZATION = 55
export CORE_ASPECT_RATIO = 1.0
export PLACE_DENSITY = 0.70

# Aggressive optimization for performance
export SYNTH_TIMING_DERATE = 3
export MAX_FANOUT = 8

# CTS configuration - tighter for high frequency
export CTS_BUF_DISTANCE = 30
export CTS_CLUSTER_SIZE = 20
export CTS_CLUSTER_DIAMETER = 50

# Routing - ASAP7 metal stack
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M7

# Power/Ground nets
export VDD_NETS = VDD
export GND_NETS = VSS

# ASAP7-specific optimizations
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 1

# Enable high-effort optimization
export SYNTH_STRATEGY = AREA 3
export PLACE_PINS_ARGS = -annealing

# Repair timing aggressively
export REPAIR_TIE_FANOUT_ARGS = -max_fanout 8
export TNS_END_PERCENT = 100
