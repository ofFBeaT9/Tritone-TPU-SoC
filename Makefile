# Tritone Ternary CPU - ASIC Build Makefile
#
# Usage:
#   make asic-300mhz   - Run 300MHz synthesis
#   make reports       - Extract metrics from runs
#   make sim           - Run RTL simulation
#   make clean         - Clean run directories
#
# Requirements:
#   - Docker installed and running
#   - PDK installed via Volare

# Docker configuration
DOCKER_IMAGE := ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69

# Platform-specific paths
ifeq ($(OS),Windows_NT)
    DESIGN_PATH := E:/ternary cmos compile/tritone-complete/OpenLane/designs/ternary_cpu_system
    PDK_PATH := C:/Users/ACER/.ciel
    DOCKER_MOUNT := -v "$(DESIGN_PATH):/openlane/designs/ternary_cpu_system" -v "$(PDK_PATH):/home/ciel/.volare"
else
    DESIGN_PATH := $(shell pwd)/OpenLane/designs/ternary_cpu_system
    PDK_PATH := $(HOME)/.volare
    DOCKER_MOUNT := -v "$(DESIGN_PATH):/openlane/designs/ternary_cpu_system" -v "$(PDK_PATH):/home/ciel/.volare"
endif

# PDK environment
DOCKER_ENV := -e PDK_ROOT=/home/ciel/.volare -e PDK=sky130A

# Design name
DESIGN := ternary_cpu_system

.PHONY: all asic-300mhz asic-baseline asic-caravel reports sim clean help

all: help

help:
	@echo "Tritone Ternary CPU - Build Targets"
	@echo ""
	@echo "  asic-300mhz   Run 300MHz synthesis (default config)"
	@echo "  asic-baseline Run baseline 50MHz synthesis"
	@echo "  asic-caravel  Harden as Caravel macro"
	@echo "  reports       Extract metrics from all runs"
	@echo "  sim           Run RTL simulation"
	@echo "  clean         Remove all run directories"
	@echo ""
	@echo "Docker Image: $(DOCKER_IMAGE)"

# 300MHz synthesis (current optimized config)
asic-300mhz:
	docker run --rm $(DOCKER_MOUNT) $(DOCKER_ENV) $(DOCKER_IMAGE) \
		./flow.tcl -design /openlane/designs/$(DESIGN) -tag tritone_v6_300mhz

# Baseline 50MHz synthesis
asic-baseline:
	docker run --rm $(DOCKER_MOUNT) $(DOCKER_ENV) $(DOCKER_IMAGE) \
		./flow.tcl -design /openlane/designs/$(DESIGN) -tag tritone_baseline \
		-config_file /openlane/designs/$(DESIGN)/config.v4-baseline.json

# Caravel macro hardening
asic-caravel:
	docker run --rm $(DOCKER_MOUNT) $(DOCKER_ENV) $(DOCKER_IMAGE) \
		./flow.tcl -design /openlane/designs/$(DESIGN) -tag tritone_caravel_macro \
		-config_file /openlane/designs/$(DESIGN)/config.caravel.json -ignore_mismatches

# Extract metrics from all runs
reports:
	python scripts/extract_metrics.py

# RTL simulation (Icarus Verilog)
sim:
	@echo "RTL Simulation not yet configured"
	@echo "TODO: Add testbench and simulation commands"

# Clean run directories
clean:
	@echo "Cleaning run directories..."
ifeq ($(OS),Windows_NT)
	powershell -Command "Remove-Item -Recurse -Force 'OpenLane/designs/$(DESIGN)/runs/*' -ErrorAction SilentlyContinue"
else
	rm -rf OpenLane/designs/$(DESIGN)/runs/*
endif
	@echo "Clean complete"

# View latest GDS (requires KLayout)
view-gds:
	@echo "Opening latest GDS in KLayout..."
ifeq ($(OS),Windows_NT)
	klayout "OpenLane/designs/$(DESIGN)/runs/tritone_v6_300mhz/results/final/gds/$(DESIGN).gds"
else
	klayout OpenLane/designs/$(DESIGN)/runs/tritone_v6_300mhz/results/final/gds/$(DESIGN).gds
endif
