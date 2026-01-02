# Lattice Diamond Build Script for Ternary ALU
# Phase 3: FPGA ALU Prototype - Lattice Diamond Variant
# Automates synthesis, mapping, and bitstream generation

# Project settings
set PROJECT_NAME "ternary_alu"
set TOP_MODULE "ternary_alu_top"
set DEVICE "LFE5UM5G-85F"
set PACKAGE "CABGA381"
set SPEEDGRADE "-8"

puts "========================================"
puts "Ternary ALU - Lattice Diamond Build Flow"
puts "========================================"

# Create new project
prj_project new -name $PROJECT_NAME -impl impl1 -dev $DEVICE -synthesis synplify

# Set device properties
prj_project set -impl impl1 -option DEVICE $DEVICE
prj_project set -impl impl1 -option PACKAGE $PACKAGE
prj_project set -impl impl1 -option SPEEDGRADE $SPEEDGRADE
prj_project set -impl impl1 -option TOP_MODULE $TOP_MODULE

# Add source files
puts "Adding source files..."
prj_src add ../hdl/rtl/ternary_pkg.sv
prj_src add ../hdl/rtl/btfa.sv
prj_src add ../hdl/rtl/ternary_adder.sv
prj_src add ../hdl/rtl/ternary_alu.sv
prj_src add ../fpga/src/ternary_alu_top.sv

# Add constraint file
prj_src add ../fpga/constraints/ternary_alu_lattice.lpf

# Set synthesis options
prj_project set -impl impl1 -option SYNTHESIS_TOOL "synplify"
prj_project set -impl impl1 -option FREQUENCY_AUTO "100"

puts "\nRunning Synthesis..."
prj_run Synthesis -impl impl1

puts "\nRunning Translation..."
prj_run Translate -impl impl1

puts "\nRunning Mapping..."
prj_run Map -impl impl1

puts "\nRunning Place & Route..."
prj_run PAR -impl impl1 -task PARTrace

puts "\nGenerating Bitstream..."
prj_run Export -impl impl1 -task Bitgen

# Generate reports
puts "\n=== Build Summary ==="

# Check for timing report
if {[file exists impl1/ternary_alu_impl1.par]} {
    puts "\nTiming analysis results in: impl1/ternary_alu_impl1.par"
}

# Check for resource utilization
if {[file exists impl1/ternary_alu_impl1.mrp]} {
    puts "Resource utilization in: impl1/ternary_alu_impl1.mrp"
}

puts "\n========================================"
puts "Build completed!"
puts "Bitstream: impl1/${PROJECT_NAME}_impl1.bit"
puts "========================================"

# Save and close project
prj_project save
prj_project close
