# Vivado Build Script for Ternary ALU
# Phase 3: FPGA ALU Prototype
# Automates synthesis, implementation, and bitstream generation

# Project settings
set project_name "ternary_alu"
set part "xcvu9p-flga2104-2L-e"  # UltraScale+ VU9P (adjust for your board)
set top_module "ternary_alu_top"

# Create project directory structure
file mkdir ./build
file mkdir ./build/reports

# Create project
create_project $project_name ./build -part $part -force

# Add source files (relative to project directory)
add_files -norecurse {
    ../../hdl/rtl/ternary_pkg.sv
    ../../hdl/rtl/btfa.sv
    ../../hdl/rtl/ternary_adder.sv
    ../../hdl/rtl/ternary_alu.sv
    ../src/ternary_alu_top.sv
}

# Set SystemVerilog file type
set_property file_type SystemVerilog [get_files *.sv]

# Add constraints
add_files -fileset constrs_1 -norecurse ../constraints/ternary_alu.xdc

# Set top module
set_property top $top_module [current_fileset]

# Update compile order
update_compile_order -fileset sources_1

puts "\n=== Starting Synthesis ==="

# Run synthesis
synth_design -top $top_module -part $part

# Report utilization after synthesis
report_utilization -file ./build/reports/synth_utilization.rpt
report_timing_summary -file ./build/reports/synth_timing.rpt
report_power -file ./build/reports/synth_power.rpt

puts "\n=== Synthesis Complete ==="
puts "=== Starting Implementation ==="

# Run implementation
opt_design
place_design
route_design

# Generate final reports
report_utilization -file ./build/reports/impl_utilization.rpt
report_timing_summary -file ./build/reports/impl_timing.rpt
report_power -file ./build/reports/impl_power.rpt
report_drc -file ./build/reports/impl_drc.rpt

puts "\n=== Implementation Complete ==="
puts "=== Generating Bitstream ==="

# Generate bitstream
write_bitstream -force ../bitstreams/$project_name.bit

# Export hardware for SDK (optional)
# write_hw_platform -fixed -force -file ./build/${project_name}.xsa

puts "\n=== Build Complete ==="
puts "Bitstream: ../bitstreams/${project_name}.bit"
puts "Reports: ./build/reports/"

# Display key metrics
set util_report [report_utilization -return_string]
set timing_report [report_timing_summary -return_string]

puts "\n=== Summary ==="
puts "Check reports for detailed metrics:"
puts "  - Utilization: ./build/reports/impl_utilization.rpt"
puts "  - Timing: ./build/reports/impl_timing.rpt"
puts "  - Power: ./build/reports/impl_power.rpt"

exit