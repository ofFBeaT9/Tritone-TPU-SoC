# Vivado Build Script for Ternary CPU System
# Phase 3: FPGA CPU Prototype - Dual-Issue Superscalar with Branch Prediction
# Automates synthesis, implementation, and bitstream generation
#
# Usage:
#   cd fpga/scripts
#   vivado -mode batch -source build_cpu.tcl
#
# Or with custom part:
#   vivado -mode batch -source build_cpu.tcl -tclargs <part_number>

# Project settings
set project_name "ternary_cpu_system"

# Default part: Artix-7 (common development board)
# Override via command line: -tclargs xc7a100tcsg324-1
if {$argc > 0} {
    set part [lindex $argv 0]
} else {
set part "xc7a100tcsg324-1" ;# Artix-7 100T (Nexys A7, Basys 3 compatible)
}

set top_module "ternary_cpu_system_top"

puts "=== Tritone CPU FPGA Build ==="
puts "Part: $part"
puts "Top Module: $top_module"

# Create project directory structure
file mkdir ./build_cpu
file mkdir ./build_cpu/reports

# Create project
create_project $project_name ./build_cpu -part $part -force

# Add all RTL source files
set rtl_files {
    ../../hdl/rtl/ternary_pkg.sv
    ../../hdl/rtl/btfa.sv
    ../../hdl/rtl/ternary_adder.sv
    ../../hdl/rtl/ternary_alu.sv
    ../../hdl/rtl/ternary_regfile.sv
    ../../hdl/rtl/ternary_memory.sv
    ../../hdl/rtl/ternary_hazard_unit.sv
    ../../hdl/rtl/ternary_forward_unit.sv
    ../../hdl/rtl/btisa_decoder.sv
    ../../hdl/rtl/ternary_branch_predictor.sv
    ../../hdl/rtl/ternary_cpu.sv
    ../../hdl/rtl/ternary_cpu_system.sv
    ../src/ternary_cpu_system_top.sv
}

foreach f $rtl_files {
    if {[file exists $f]} {
        add_files -norecurse $f
        puts "Added: $f"
    } else {
        puts "WARNING: File not found: $f"
    }
}

# Set SystemVerilog file type for all .sv files
set_property file_type SystemVerilog [get_files *.sv]

# Add constraints
set xdc_file "../constraints/ternary_cpu_system.xdc"
if {[file exists $xdc_file]} {
    add_files -fileset constrs_1 -norecurse $xdc_file
    puts "Added constraints: $xdc_file"
} else {
    puts "WARNING: Constraints file not found: $xdc_file"
    puts "Synthesis will proceed without pin constraints."
}

# Set top module
set_property top $top_module [current_fileset]

# Update compile order
update_compile_order -fileset sources_1

puts "\n=== Starting Synthesis ==="
puts "Target: $part"
puts "Clock: 100 MHz"

# Run synthesis with timing-focused strategy
synth_design -top $top_module -part $part \
    -flatten_hierarchy rebuilt \
    -directive PerformanceOptimized

# Report utilization after synthesis
report_utilization -file ./build_cpu/reports/synth_utilization.rpt
report_timing_summary -file ./build_cpu/reports/synth_timing.rpt
report_power -file ./build_cpu/reports/synth_power.rpt

# Check synthesis critical warnings
set crit_warnings [get_msg_config -count -severity CRITICAL_WARNING]
puts "\nSynthesis Critical Warnings: $crit_warnings"

puts "\n=== Synthesis Complete ==="

# Display post-synthesis resource summary
puts "\n=== Post-Synthesis Resource Summary ==="
set util [report_utilization -return_string]
puts $util

puts "\n=== Starting Implementation ==="

# Optimization
opt_design -directive ExploreWithRemap

# Placement
place_design -directive ExtraTimingOpt

# Physical optimization (post-place)
phys_opt_design -directive AggressiveExplore

# Routing
route_design -directive AggressiveExplore

# Post-route physical optimization
phys_opt_design -directive AggressiveExplore

# Generate final reports
report_utilization -file ./build_cpu/reports/impl_utilization.rpt
report_utilization -hierarchical -file ./build_cpu/reports/impl_utilization_hier.rpt
report_timing_summary -file ./build_cpu/reports/impl_timing.rpt
report_timing -max_paths 50 -file ./build_cpu/reports/impl_timing_paths.rpt
report_power -file ./build_cpu/reports/impl_power.rpt
report_drc -file ./build_cpu/reports/impl_drc.rpt
report_methodology -file ./build_cpu/reports/impl_methodology.rpt
report_clock_utilization -file ./build_cpu/reports/impl_clocks.rpt

puts "\n=== Implementation Complete ==="

# Check timing
set timing_slack [get_property SLACK [get_timing_paths -max_paths 1]]
if {$timing_slack < 0} {
    puts "WARNING: Timing not met! WNS = $timing_slack ns"
    puts "Consider reducing clock frequency or using faster speed grade."
} else {
    puts "Timing met! WNS = $timing_slack ns"
}

puts "\n=== Generating Bitstream ==="

# Create bitstreams directory
file mkdir ../bitstreams

# Generate bitstream
write_bitstream -force ../bitstreams/${project_name}.bit

# Generate debug probes file (for ILA if used)
# write_debug_probes -force ../bitstreams/${project_name}.ltx

puts "\n=== Build Complete ==="
puts "Bitstream: ../bitstreams/${project_name}.bit"
puts "Reports: ./build_cpu/reports/"

# Display final metrics summary
puts "\n=== Final Metrics Summary ==="

# Parse timing report for key metrics
set timing_report [report_timing_summary -return_string]
set wns_line [lsearch -inline -regexp [split $timing_report "\n"] "WNS"]
puts "Timing: $wns_line"

# Display power summary
puts "\n--- Power Estimate ---"
set power_report [report_power -return_string]
puts [lindex [split $power_report "\n"] end-5]

# Display resource summary
puts "\n--- Resource Utilization ---"
puts "See: ./build_cpu/reports/impl_utilization.rpt"

puts "\n=== Tritone CPU FPGA Build Finished ==="

exit
