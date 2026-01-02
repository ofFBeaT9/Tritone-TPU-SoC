# ORFS Configuration for Tritone v8 (CLA + 3-Rail validated)
# Target: SKY130 HD standard cells at 300 MHz

export DESIGN_NAME = ternary_cpu_system
export PLATFORM = sky130hd

# Source files - use slang for full SystemVerilog support
export SYNTH_HDL_FRONTEND = slang
export VERILOG_FILES = $(wildcard $(DESIGN_HOME)/src/*.sv)
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src

# Clock configuration - 300 MHz target
export CLOCK_PORT = clk
export CLOCK_PERIOD = 3.33

# SDC constraints
export SDC_FILE = $(DESIGN_HOME)/src/ternary_cpu_system.sdc

# Floorplan configuration
export CORE_UTILIZATION = 45
export CORE_ASPECT_RATIO = 1.0
export PLACE_DENSITY = 0.60

# Optimization settings
export SYNTH_TIMING_DERATE = 5
export MAX_FANOUT = 12

# CTS configuration
export CTS_BUF_DISTANCE = 60
export CTS_CLUSTER_SIZE = 30
export CTS_CLUSTER_DIAMETER = 100

# Routing
export MIN_ROUTING_LAYER = met1
export MAX_ROUTING_LAYER = met5

# Power/Ground nets
export VDD_NETS = VDD
export GND_NETS = VSS
