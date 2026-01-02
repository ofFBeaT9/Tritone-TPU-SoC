# Tritone TPU SoC - ASAP7 7nm Configuration
# Complete hybrid SoC: Ternary CPU + TPU Accelerator
# Target: 1.0 GHz baseline (conservative for larger design)
# Date: Dec 2025

export PLATFORM               = asap7

# Clock period in picoseconds
# FLOW_VARIANT controls target frequency:
#   - maxperf:    500 ps = 2.0 GHz (maximum performance, requires USE_2GHZ_PIPELINE)
#   - aggressive: 667 ps = 1.5 GHz (aggressive)
#   - baseline:   1000 ps = 1.0 GHz (default, recommended)
ifeq ($(FLOW_VARIANT),maxperf)
export CLOCK_PERIOD           = 500
else ifeq ($(FLOW_VARIANT),aggressive)
export CLOCK_PERIOD           = 667
else
export CLOCK_PERIOD           = 1000
endif

export DESIGN_NICKNAME        = tritone_soc
# For maxperf, use v2 SoC with 2 GHz pipelined TPU
ifeq ($(FLOW_VARIANT),maxperf)
export DESIGN_NAME            = tritone_soc_v2
else
export DESIGN_NAME            = tritone_soc
endif

# Source files - CPU + TPU modules
export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tritone_soc/*.sv))
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/tritone_soc
export SDC_FILE_CLOCK_PORTS = clk

# Use slang for full SystemVerilog 2017 support
export SYNTH_HDL_FRONTEND = slang

# Define for synthesis: use integer-only TPU modules (no trit types in TPU)
# For maxperf (2 GHz), enable the 2-stage pipelined MAC
ifeq ($(FLOW_VARIANT),maxperf)
export SYNTH_DEFINES = TPU_INT_ONLY SYNTHESIS USE_2GHZ_PIPELINE=1
else
export SYNTH_DEFINES = TPU_INT_ONLY SYNTHESIS
endif

# SDC file selection based on variant
ifeq ($(FLOW_VARIANT),maxperf)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_2ghz.sdc
else ifeq ($(FLOW_VARIANT),aggressive)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_1500mhz.sdc
else
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_1ghz.sdc
endif

# Floorplan settings - larger design needs more area
# TPU systolic array dominates area (~75%)
export CORE_UTILIZATION       = 45
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 3
export PLACE_DENSITY_LB_ADDON = 0.10

# Timing optimization
export TNS_END_PERCENT        = 100
export ENABLE_DPO             = 1

# Fanout control
export MAX_FANOUT             = 12

# Allow large memories as registers (SRAMs synthesized as registers)
# TPU buffers: weight 16KB, activation 8KB, output 4KB
export SYNTH_MEMORY_MAX_BITS  = 200000

# CTS tuning
export CTS_CLUSTER_SIZE       = 30
export CTS_CLUSTER_DIAMETER   = 80
