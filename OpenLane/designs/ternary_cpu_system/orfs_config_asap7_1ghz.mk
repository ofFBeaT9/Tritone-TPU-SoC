# ORFS Configuration for Tritone v8 CLA - ASAP7 (7nm Predictive)
# Target: 1.0 GHz baseline (fallback if 1.5 GHz fails timing)
# Date: Dec 2025

export DESIGN_NAME = ternary_cpu_system
export PLATFORM = asap7

# Source files - use slang for full SystemVerilog support
export SYNTH_HDL_FRONTEND = slang
export VERILOG_FILES = $(wildcard $(DESIGN_HOME)/src/*.sv)
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src

# Clock configuration - 1.0 GHz baseline for 7nm
export CLOCK_PORT = clk
export CLOCK_PERIOD = 1.0

# Use ASAP7-specific SDC (1 GHz version)
export SDC_FILE = $(DESIGN_HOME)/src/ternary_cpu_system_asap7_1ghz.sdc

# Floorplan configuration
export CORE_UTILIZATION = 50
export CORE_ASPECT_RATIO = 1.0
export PLACE_DENSITY = 0.65

# Optimization settings
export SYNTH_TIMING_DERATE = 5
export MAX_FANOUT = 10

# CTS configuration
export CTS_BUF_DISTANCE = 40
export CTS_CLUSTER_SIZE = 25
export CTS_CLUSTER_DIAMETER = 70

# Routing - ASAP7 metal stack
export MIN_ROUTING_LAYER = M2
export MAX_ROUTING_LAYER = M7

# Power/Ground nets
export VDD_NETS = VDD
export GND_NETS = VSS

# Standard optimization
export CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
export CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 1
