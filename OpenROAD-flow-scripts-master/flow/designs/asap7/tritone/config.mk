# Tritone v8 CLA - ASAP7 7nm Configuration
# Target: Maximum performance (2.0 GHz maxperf, 1.5 GHz aggressive, 1.0 GHz baseline)
# Date: Dec 2025

export PLATFORM               = asap7

# Clock period in picoseconds
# FLOW_VARIANT controls target frequency:
#   - maxperf:    500 ps = 2.0 GHz (maximum performance)
#   - aggressive: 667 ps = 1.5 GHz
#   - baseline:   1000 ps = 1.0 GHz (default)
ifeq ($(FLOW_VARIANT),maxperf)
export CLOCK_PERIOD           = 500
else ifeq ($(FLOW_VARIANT),aggressive)
export CLOCK_PERIOD           = 667
else
export CLOCK_PERIOD           = 1000
endif

export DESIGN_NICKNAME        = tritone
export DESIGN_NAME            = ternary_cpu_system

# v8 CLA-enabled source files
export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tritone/*.sv))
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/tritone

# Use slang for full SystemVerilog 2017 support
export SYNTH_HDL_FRONTEND = slang

# SDC file selection based on variant
ifeq ($(FLOW_VARIANT),maxperf)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_2ghz.sdc
else ifeq ($(FLOW_VARIANT),aggressive)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_1500mhz.sdc
else
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_1ghz.sdc
endif

# Floorplan settings - tighter for high performance
export CORE_UTILIZATION       = 50
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON = 0.15

# Timing optimization - aggressive
export TNS_END_PERCENT        = 100
export ENABLE_DPO             = 1

# Fanout control for high frequency
export MAX_FANOUT             = 8

# Allow large memories as registers (SRAM macros not used)
export SYNTH_MEMORY_MAX_BITS  = 50000

# CTS tuning for high frequency
export CTS_CLUSTER_SIZE       = 20
export CTS_CLUSTER_DIAMETER   = 50
