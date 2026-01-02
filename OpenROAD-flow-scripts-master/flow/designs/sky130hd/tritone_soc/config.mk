# Tritone TPU SoC - Sky130HD 130nm Configuration
# Complete hybrid SoC: Ternary CPU + TPU Accelerator
# Target: 150 MHz baseline (conservative for 130nm mature node)
# Date: Jan 2026

export PLATFORM               = sky130hd

# Clock period in picoseconds
# FLOW_VARIANT controls target frequency:
#   - aggressive: 5000 ps = 200 MHz (aggressive for 130nm)
#   - baseline:   6667 ps = 150 MHz (default, recommended)
ifeq ($(FLOW_VARIANT),aggressive)
export CLOCK_PERIOD           = 5000
else
export CLOCK_PERIOD           = 6667
endif

export DESIGN_NICKNAME        = tritone_soc
export DESIGN_NAME            = tritone_soc

# Source files - CPU + TPU modules (shared with ASAP7)
export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/tritone_soc/*.sv))
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/tritone_soc
export SDC_FILE_CLOCK_PORTS = clk

# Use slang for full SystemVerilog 2017 support
export SYNTH_HDL_FRONTEND = slang

# Define for synthesis: use integer-only TPU modules
# Sky130 does not use 2 GHz pipeline (too aggressive for 130nm)
export SYNTH_DEFINES = TPU_INT_ONLY SYNTHESIS

# SDC file selection based on variant
ifeq ($(FLOW_VARIANT),aggressive)
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_200mhz.sdc
else
export SDC_FILE              = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint_150mhz.sdc
endif

# Floorplan settings - larger design needs more area
# Lower utilization for 130nm (larger cells, more routing)
export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 4
export PLACE_DENSITY_LB_ADDON = 0.15

# Timing optimization
export TNS_END_PERCENT        = 100
export ENABLE_DPO             = 1

# Fanout control (less aggressive than ASAP7)
export MAX_FANOUT             = 16

# Allow large memories as registers (SRAMs synthesized as registers)
# TPU buffers: weight 16KB, activation 8KB, output 4KB
export SYNTH_MEMORY_MAX_BITS  = 200000

# CTS tuning for 130nm
export CTS_CLUSTER_SIZE       = 25
export CTS_CLUSTER_DIAMETER   = 60

# Remove ABC buffers (can cause timing issues)
export REMOVE_ABC_BUFFERS = 1
