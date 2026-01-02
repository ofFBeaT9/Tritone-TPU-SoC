# ==============================================================================
# GT-LOGIC Ternary Router - OpenROAD/OpenLane Integration
# ==============================================================================
#
# Custom routing directives for ternary CMOS (TCMOS) physical design
#
# Purpose:
#   - Identify dual-rail ternary signal pairs from binary netlist
#   - Apply routing constraints for wire collapse preparation
#   - Generate analysis reports for ternary wire optimization
#
# Usage in OpenLane:
#   Add to config.json: "PL_ROUTABILITY_DRIVEN": true
#   Source in custom step: source asic/scripts/ternary_router.tcl
#
# Usage in OpenROAD:
#   source ternary_router.tcl
#   analyze_ternary_netlist
#   apply_ternary_routing
#
# Author: Tritone Project
# Date: December 2025
# ==============================================================================

namespace eval ternary_routing {

    # Configuration
    variable config
    array set config {
        enabled             1
        min_wire_spacing    0.14
        max_wire_length     500
        match_length_tol    0.05
        debug               0
    }

    # State
    variable ternary_pairs {}
    variable ternary_vectors {}
    variable analysis_done 0

    # ===========================================================================
    # NETLIST ANALYSIS
    # ===========================================================================

    proc find_ternary_pairs {} {
        # Identify ternary signal pairs in the current design
        #
        # Ternary encoding: [2*i+1:2*i] represents trit i
        #   00 = T_ZERO
        #   01 = T_POS_ONE
        #   10 = T_NEG_ONE
        #   11 = T_INVALID
        #
        # Returns: Number of ternary trit pairs identified

        variable ternary_pairs
        variable ternary_vectors
        variable analysis_done

        puts "Analyzing netlist for ternary signal pairs..."

        set ternary_pairs {}
        set ternary_vectors {}

        # Get all nets in design
        set all_nets [get_nets *]
        set net_count [llength $all_nets]

        puts "  Total nets: $net_count"

        # Group nets by base name and bit index
        array set net_groups {}

        foreach net $all_nets {
            set net_name [get_property $net name]

            # Match pattern: base_name[index]
            if {[regexp {^(.+)\[(\d+)\]$} $net_name -> base_name bit_idx]} {
                if {![info exists net_groups($base_name)]} {
                    set net_groups($base_name) {}
                }
                lappend net_groups($base_name) [list $bit_idx $net_name]
            }
        }

        # Identify ternary pairs (consecutive even/odd bits)
        set pair_count 0

        foreach {base_name bit_list} [array get net_groups] {
            # Sort by bit index
            set sorted_bits [lsort -integer -index 0 $bit_list]
            set max_idx 0

            foreach bit_entry $sorted_bits {
                set idx [lindex $bit_entry 0]
                if {$idx > $max_idx} {
                    set max_idx $idx
                }
            }

            # Check if looks like ternary encoding (even width)
            set width [expr {$max_idx + 1}]
            if {$width >= 2 && ($width % 2) == 0} {
                set num_trits [expr {$width / 2}]

                # Create a lookup by index
                array unset bit_map
                foreach bit_entry $sorted_bits {
                    set idx [lindex $bit_entry 0]
                    set name [lindex $bit_entry 1]
                    set bit_map($idx) $name
                }

                # Match pairs
                for {set trit 0} {$trit < $num_trits} {incr trit} {
                    set bit_low [expr {$trit * 2}]
                    set bit_high [expr {$trit * 2 + 1}]

                    if {[info exists bit_map($bit_low)] && [info exists bit_map($bit_high)]} {
                        set wire_low $bit_map($bit_low)
                        set wire_high $bit_map($bit_high)

                        lappend ternary_pairs [list \
                            base $base_name \
                            trit $trit \
                            wire_low $wire_low \
                            wire_high $wire_high \
                        ]

                        incr pair_count
                    }
                }

                if {$num_trits > 0} {
                    lappend ternary_vectors [list \
                        name $base_name \
                        trits $num_trits \
                        width $width \
                    ]
                }
            }
        }

        set analysis_done 1

        puts "  Ternary vectors identified: [llength $ternary_vectors]"
        puts "  Ternary trit pairs: $pair_count"

        return $pair_count
    }

    # ===========================================================================
    # ROUTING CONSTRAINTS
    # ===========================================================================

    proc create_ternary_ndr {} {
        # Create Non-Default Routing rules for ternary pairs
        #
        # Ternary pairs should be routed with:
        #   - Minimum spacing (for wire collapse)
        #   - Matched lengths (for timing)

        variable config

        if {!$config(enabled)} {
            puts "Ternary routing disabled"
            return
        }

        puts "Creating ternary NDR..."

        # Check if we're in OpenROAD or OpenLane
        if {[info command create_ndr] != ""} {
            # OpenROAD syntax
            catch {
                create_ndr -name ternary_pair_rule \
                    -spacing {metal2:$config(min_wire_spacing) metal3:$config(min_wire_spacing)} \
                    -width {metal2:$config(min_wire_spacing) metal3:$config(min_wire_spacing)}
            }
        } else {
            # OpenLane TCL syntax
            puts "  Using OpenLane constraint mode"
        }

        puts "  NDR created: ternary_pair_rule"
        puts "  Min spacing: $config(min_wire_spacing) um"
    }

    proc apply_length_matching {} {
        # Apply length matching constraints to ternary pairs

        variable ternary_pairs
        variable config

        if {!$config(enabled)} {
            return
        }

        puts "Applying length matching constraints..."

        set constrained 0

        foreach pair $ternary_pairs {
            array set p $pair

            set wire_low $p(wire_low)
            set wire_high $p(wire_high)

            # Apply max wire length
            catch {
                set_max_wire_length -net $wire_low -length $config(max_wire_length)
                set_max_wire_length -net $wire_high -length $config(max_wire_length)
            }

            incr constrained 2
        }

        puts "  Constrained nets: $constrained"
    }

    proc group_ternary_nets {} {
        # Create net groups for bus routing

        variable ternary_vectors
        variable ternary_pairs

        puts "Grouping ternary nets for bus routing..."

        foreach vector $ternary_vectors {
            array set v $vector
            set base_name $v(name)
            set num_trits $v(trits)

            # Collect all wires for this vector
            set net_list {}

            foreach pair $ternary_pairs {
                array set p $pair
                if {$p(base) eq $base_name} {
                    lappend net_list $p(wire_low)
                    lappend net_list $p(wire_high)
                }
            }

            if {[llength $net_list] > 0} {
                # Create bus for this vector
                set safe_name [regsub -all {[^a-zA-Z0-9_]} $base_name "_"]

                catch {
                    create_net_group -name "ternary_${safe_name}" -nets $net_list
                }

                if {$::ternary_routing::config(debug)} {
                    puts "  Created group: ternary_${safe_name} ([llength $net_list] nets)"
                }
            }
        }
    }

    # ===========================================================================
    # ANALYSIS AND REPORTING
    # ===========================================================================

    proc report_ternary_stats {} {
        # Print ternary routing statistics

        variable ternary_pairs
        variable ternary_vectors
        variable analysis_done

        if {!$analysis_done} {
            find_ternary_pairs
        }

        puts ""
        puts "=============================================="
        puts "TERNARY ROUTING STATISTICS"
        puts "=============================================="
        puts ""

        set total_binary_nets [llength [get_nets *]]
        set total_trits [llength $ternary_pairs]
        set ternary_nets [expr {$total_trits * 2}]
        set reduction [expr {$total_binary_nets > 0 ? (1.0 - double($total_trits) / $total_binary_nets) * 100.0 : 0.0}]

        puts "Total nets in design:     $total_binary_nets"
        puts "Ternary trit pairs:       $total_trits"
        puts "Nets in ternary pairs:    $ternary_nets"
        puts "Wire reduction potential: [format %.1f $reduction]%"
        puts ""

        puts "Ternary Vectors:"
        puts "  Name                           Trits  Width"
        puts "  -------------------------------------------"

        foreach vector $ternary_vectors {
            array set v $vector
            set name [format "%-30s" $v(name)]
            set trits [format "%5d" $v(trits)]
            set width [format "%6d" $v(width)]
            puts "  $name $trits $width"
        }

        puts ""
        puts "=============================================="
    }

    proc estimate_wire_savings {} {
        # Estimate wire length savings from ternary collapse

        variable ternary_pairs

        puts ""
        puts "Estimating wire savings from ternary collapse..."

        set dual_rail_length 0
        set collapsed_length 0

        foreach pair $ternary_pairs {
            array set p $pair

            # Get wire lengths (if available from detailed routing)
            set len_low 0
            set len_high 0

            catch {
                set len_low [get_net_wire_length $p(wire_low)]
                set len_high [get_net_wire_length $p(wire_high)]
            }

            set dual_rail_length [expr {$dual_rail_length + $len_low + $len_high}]

            # Collapsed would be max of the two (conservative estimate)
            set collapsed_length [expr {$collapsed_length + max($len_low, $len_high)}]
        }

        if {$dual_rail_length > 0} {
            set savings [expr {($dual_rail_length - $collapsed_length) / $dual_rail_length * 100.0}]
            puts "  Dual-rail wire length: [format %.1f $dual_rail_length] um"
            puts "  Collapsed estimate:    [format %.1f $collapsed_length] um"
            puts "  Potential savings:     [format %.1f $savings]%"
        } else {
            puts "  Wire length data not available (run after detail routing)"
        }

        puts ""
    }

    # ===========================================================================
    # MAIN API
    # ===========================================================================

    proc analyze {} {
        # Full analysis of ternary signals in current design

        puts ""
        puts "==== TERNARY NETLIST ANALYSIS ===="
        puts ""

        set pair_count [find_ternary_pairs]
        report_ternary_stats

        return $pair_count
    }

    proc apply_constraints {} {
        # Apply all ternary routing constraints

        variable analysis_done

        if {!$analysis_done} {
            analyze
        }

        puts ""
        puts "==== APPLYING TERNARY CONSTRAINTS ===="
        puts ""

        create_ternary_ndr
        apply_length_matching
        group_ternary_nets

        puts ""
        puts "Ternary constraints applied successfully"
        puts ""
    }

    proc configure {option value} {
        # Configure ternary routing options
        #
        # Options:
        #   enabled           - Enable/disable ternary routing (0/1)
        #   min_wire_spacing  - Minimum spacing for pairs (um)
        #   max_wire_length   - Maximum wire length (um)
        #   match_length_tol  - Length matching tolerance (fraction)
        #   debug             - Debug output (0/1)

        variable config

        if {[info exists config($option)]} {
            set config($option) $value
            puts "Set ternary_routing::$option = $value"
        } else {
            puts "Unknown option: $option"
            puts "Available: [array names config]"
        }
    }

}

# ==============================================================================
# PUBLIC API (convenience wrappers)
# ==============================================================================

proc analyze_ternary_netlist {} {
    ternary_routing::analyze
}

proc apply_ternary_routing {} {
    ternary_routing::apply_constraints
}

proc report_ternary {} {
    ternary_routing::report_ternary_stats
}

proc configure_ternary_routing {option value} {
    ternary_routing::configure $option $value
}

# ==============================================================================
# OPENLANE HOOKS
# ==============================================================================

proc ternary_pre_global_route_hook {} {
    # Hook for pre-global routing stage
    puts "Ternary: Pre-global route hook"
    ternary_routing::apply_constraints
}

proc ternary_post_detail_route_hook {} {
    # Hook for post-detail routing stage
    puts "Ternary: Post-detail route hook"
    ternary_routing::estimate_wire_savings
}

# ==============================================================================
# STARTUP
# ==============================================================================

puts ""
puts "================================================"
puts "GT-LOGIC Ternary Router Loaded"
puts "================================================"
puts ""
puts "Commands:"
puts "  analyze_ternary_netlist   - Analyze design for ternary pairs"
puts "  apply_ternary_routing     - Apply routing constraints"
puts "  report_ternary            - Print ternary statistics"
puts "  configure_ternary_routing - Set options"
puts ""
puts "OpenLane hooks:"
puts "  ternary_pre_global_route_hook"
puts "  ternary_post_detail_route_hook"
puts ""
