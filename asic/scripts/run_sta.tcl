# ==============================================================================
# GT-LOGIC Ternary - OpenSTA Multi-Corner Analysis
# ==============================================================================
#
# Runs static timing analysis across TT/SS/FF corners using custom Liberty libs
#
# Prerequisites:
#   - OpenSTA installed (from OpenROAD or standalone)
#   - Gate-level netlist from synthesis
#   - Liberty files in asic/lib/
#
# Usage:
#   sta -exit run_sta.tcl
#   OR within OpenSTA: source run_sta.tcl
#
# Output:
#   - Timing reports for each corner
#   - Setup/hold slack summary
#   - Critical path analysis
# ==============================================================================

puts ""
puts "=============================================="
puts "GT-LOGIC Ternary - OpenSTA Analysis"
puts "=============================================="
puts ""

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Paths (relative to asic/scripts/)
set lib_dir "../lib"
set netlist_dir "../../OpenLane/designs/ternary_cpu_system/runs/tritone_v6_300mhz/results/synthesis"

# Design parameters
set design_name "ternary_cpu_system"
set clock_period 3.33  ;# 300 MHz target

# Corner definitions
set corners {
    {TT gt_logic_ternary.lib       1.80 27}
    {SS gt_logic_ternary_ss.lib    1.62 125}
    {FF gt_logic_ternary_ff.lib    1.98 -40}
}

# ==============================================================================
# HELPER PROCEDURES
# ==============================================================================

proc analyze_corner {corner_name lib_file voltage temp clock_period} {
    puts ""
    puts "====== Corner: $corner_name ($voltage V, $temp C) ======"
    puts ""

    # Read liberty
    read_liberty $lib_file

    # Read netlist (gate-level Verilog)
    # Note: Requires synthesized netlist
    if {[catch {read_verilog $::netlist_file} err]} {
        puts "Warning: Could not read netlist: $err"
        puts "Skipping netlist-based analysis"
        return
    }

    # Link design
    link_design $::design_name

    # Create clock
    create_clock -name clk -period $clock_period [get_ports clk]

    # Set input/output delays
    set_input_delay -clock clk [expr $clock_period * 0.2] [all_inputs]
    set_output_delay -clock clk [expr $clock_period * 0.2] [all_outputs]

    # Run timing analysis
    puts "Setup Analysis:"
    report_checks -path_delay max -format full_clock

    puts ""
    puts "Hold Analysis:"
    report_checks -path_delay min -format full_clock

    # Report worst slack
    puts ""
    puts "Slack Summary:"
    set setup_slack [sta::worst_slack -max]
    set hold_slack [sta::worst_slack -min]
    puts "  Setup slack: $setup_slack ns"
    puts "  Hold slack:  $hold_slack ns"

    if {$setup_slack < 0} {
        puts "  WARNING: Setup violation detected!"
    }
    if {$hold_slack < 0} {
        puts "  WARNING: Hold violation detected!"
    }

    # Clear for next corner
    remove_from_collection [all_clocks] [all_clocks]
}

# ==============================================================================
# LIBRARY-ONLY ANALYSIS (No netlist required)
# ==============================================================================

proc analyze_library_only {corner_name lib_file} {
    puts ""
    puts "====== Library Analysis: $corner_name ======"
    puts ""

    # Read liberty
    if {[catch {read_liberty $lib_file} err]} {
        puts "Error reading library: $err"
        return
    }

    # Report library statistics
    puts "Library: $lib_file"
    puts ""

    # List cells
    puts "Cells in library:"
    foreach cell [get_lib_cells *] {
        set cell_name [get_attribute $cell name]
        set area [get_attribute $cell area]
        puts "  $cell_name (area: $area)"
    }
}

# ==============================================================================
# MAIN ANALYSIS
# ==============================================================================

puts "Target frequency: [expr 1000.0/$clock_period] MHz"
puts "Clock period: $clock_period ns"
puts ""

# Check for netlist
set netlist_file "$netlist_dir/$design_name.v"
if {[file exists $netlist_file]} {
    puts "Netlist found: $netlist_file"
    set has_netlist 1
} else {
    puts "Netlist not found: $netlist_file"
    puts "Running library-only analysis"
    set has_netlist 0
}

# Run analysis for each corner
foreach corner $corners {
    set corner_name [lindex $corner 0]
    set lib_file "$lib_dir/[lindex $corner 1]"
    set voltage [lindex $corner 2]
    set temp [lindex $corner 3]

    if {![file exists $lib_file]} {
        puts "Warning: Library not found: $lib_file"
        continue
    }

    if {$has_netlist} {
        analyze_corner $corner_name $lib_file $voltage $temp $clock_period
    } else {
        analyze_library_only $corner_name $lib_file
    }
}

# ==============================================================================
# SUMMARY
# ==============================================================================

puts ""
puts "=============================================="
puts "Analysis Complete"
puts "=============================================="
puts ""
puts "Corners analyzed:"
foreach corner $corners {
    puts "  - [lindex $corner 0]: [lindex $corner 2]V, [lindex $corner 3]C"
}
puts ""
puts "For full netlist analysis, ensure synthesized netlist exists at:"
puts "  $netlist_dir/$design_name.v"
puts ""

# Exit if running in batch mode
if {[info exists ::env(STA_BATCH_MODE)]} {
    exit 0
}
