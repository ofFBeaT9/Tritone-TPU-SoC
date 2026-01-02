# Intel Quartus Build Script for Ternary ALU
# Phase 3: FPGA ALU Prototype - Intel Quartus Variant
# Automates synthesis, fitting, and bitstream generation

# Project settings
set PROJECT_NAME "ternary_alu"
set TOP_MODULE "ternary_alu_top"
set DEVICE_FAMILY "Cyclone V"
set DEVICE_PART "5CSEMA5F31C6"

puts "========================================"
puts "Ternary ALU - Intel Quartus Build Flow"
puts "========================================"

# Create new project
project_new $PROJECT_NAME -overwrite

# Set device and family
set_global_assignment -name FAMILY "$DEVICE_FAMILY"
set_global_assignment -name DEVICE $DEVICE_PART
set_global_assignment -name TOP_LEVEL_ENTITY $TOP_MODULE

# Add source files
puts "Adding source files..."
set_global_assignment -name SYSTEMVERILOG_FILE ../hdl/rtl/ternary_pkg.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../hdl/rtl/btfa.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../hdl/rtl/ternary_adder.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../hdl/rtl/ternary_alu.sv
set_global_assignment -name SYSTEMVERILOG_FILE ../fpga/src/ternary_alu_top.sv

# Add constraint file
set_global_assignment -name SDC_FILE ../fpga/constraints/ternary_alu_quartus.sdc

# Compilation settings
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON

# Run Analysis & Synthesis
puts "\nRunning Analysis & Synthesis..."
if {[catch {execute_module -tool map} result]} {
    puts "ERROR: Analysis & Synthesis failed"
    project_close
    exit 1
} else {
    puts "Analysis & Synthesis completed successfully"
}

# Run Fitter (Place & Route)
puts "\nRunning Fitter..."
if {[catch {execute_module -tool fit} result]} {
    puts "ERROR: Fitter failed"
    project_close
    exit 1
} else {
    puts "Fitter completed successfully"
}

# Run Timing Analysis
puts "\nRunning Timing Analysis..."
if {[catch {execute_module -tool sta} result]} {
    puts "WARNING: Timing Analysis had issues"
} else {
    puts "Timing Analysis completed"
}

# Run Assembler (Bitstream generation)
puts "\nRunning Assembler..."
if {[catch {execute_module -tool asm} result]} {
    puts "ERROR: Assembler failed"
    project_close
    exit 1
} else {
    puts "Assembler completed successfully"
}

# Generate reports
puts "\nGenerating reports..."
load_report

# Timing report
puts "\n=== Timing Summary ==="
set panel_name {*Timing Analyzer||Slow 1200mV 85C Model||Fmax Summary}
if {[catch {set fmax_panel [get_report_panel_data -name $panel_name]} result]} {
    puts "Timing report not available"
} else {
    puts $fmax_panel
}

# Resource utilization
puts "\n=== Resource Utilization ==="
set panel_name {*Fitter||Resource Section||Resource Usage Summary}
if {[catch {set resource_panel [get_report_panel_data -name $panel_name]} result]} {
    puts "Resource report not available"
} else {
    puts $resource_panel
}

unload_report

# Close project
project_close

puts "\n========================================"
puts "Build completed successfully!"
puts "Bitstream: output_files/${PROJECT_NAME}.sof"
puts "========================================"
