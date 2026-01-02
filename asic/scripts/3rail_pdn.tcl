# 3-Rail Power Delivery Network Configuration for Tritone
# Extends standard 2-rail (VDD/VSS) with VMID for ternary CMOS cells
#
# Rail Configuration:
#   VSS  = 0V    (Ground)
#   VMID = 0.9V  (Intermediate level for ternary logic)
#   VDD  = 1.8V  (Supply)
#
# Metal Layer Assignment (SKY130):
#   met1: Standard cell rails (VSS, VDD)
#   met2: Horizontal routing
#   met3: VMID distribution stripes
#   met4: VDD/VSS vertical stripes
#   met5: VDD/VSS horizontal stripes
#
# Usage:
#   In OpenLane config.json:
#     "FP_PDN_CFG": "dir::../../asic/scripts/3rail_pdn.tcl"
#     "FP_PDN_NETS": ["VPWR", "VGND", "VMID"]
#
# Reference: Tritone Roadmap Section 6.1 (Temperature Compensation)

# Source base configuration
source $::env(SCRIPTS_DIR)/openroad/common/set_global_connections.tcl

# ============================================================
# Global Connections for 3-Rail
# ============================================================

set_global_connections

# Create VMID net if it doesn't exist
set vmid_net_name "VMID"
set db_vmid_net [[ord::get_db_block] findNet $vmid_net_name]
if {$db_vmid_net == "NULL"} {
    set vmid_net [odb::dbNet_create [ord::get_db_block] $vmid_net_name]
    $vmid_net setSpecial
    $vmid_net setSigType "POWER"
    puts "Created VMID power net"
}

# ============================================================
# Voltage Domain Configuration
# ============================================================

# Primary domain with VDD/VSS
set secondary [list $vmid_net_name]
set_voltage_domain -name CORE \
    -power $::env(VDD_NET) \
    -ground $::env(GND_NET) \
    -secondary_power $secondary

# ============================================================
# PDN Grid Definition
# ============================================================

if { $::env(DESIGN_IS_CORE) == 1 } {
    # Define main PDN grid
    define_pdn_grid \
        -name stdcell_grid \
        -starts_with POWER \
        -voltage_domain CORE \
        -pins "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)"

    # ============================================================
    # Standard Cell Rails (met1)
    # ============================================================

    add_pdn_stripe \
        -grid stdcell_grid \
        -layer $::env(FP_PDN_RAIL_LAYER) \
        -width $::env(FP_PDN_RAIL_WIDTH) \
        -followpins

    # ============================================================
    # VDD/VSS Vertical Stripes (met4)
    # ============================================================

    add_pdn_stripe \
        -grid stdcell_grid \
        -layer $::env(FP_PDN_VERTICAL_LAYER) \
        -width $::env(FP_PDN_VWIDTH) \
        -pitch $::env(FP_PDN_VPITCH) \
        -offset $::env(FP_PDN_VOFFSET) \
        -starts_with POWER

    # ============================================================
    # VMID Distribution Stripes (met3)
    # ============================================================

    # VMID stripes on met3 (between met1 rails and met4 power stripes)
    # Use narrower stripes with higher pitch for lower current demand
    set vmid_width 1.6
    set vmid_pitch [expr {$::env(FP_PDN_VPITCH) * 2}]
    set vmid_offset [expr {$::env(FP_PDN_VOFFSET) + $::env(FP_PDN_VWIDTH)}]

    add_pdn_stripe \
        -grid stdcell_grid \
        -layer met3 \
        -width $vmid_width \
        -pitch $vmid_pitch \
        -offset $vmid_offset \
        -nets $vmid_net_name

    # ============================================================
    # VDD/VSS Horizontal Stripes (met5)
    # ============================================================

    add_pdn_stripe \
        -grid stdcell_grid \
        -layer $::env(FP_PDN_HORIZONTAL_LAYER) \
        -width $::env(FP_PDN_HWIDTH) \
        -pitch $::env(FP_PDN_HPITCH) \
        -offset $::env(FP_PDN_HOFFSET) \
        -starts_with POWER

    # ============================================================
    # Via Connections
    # ============================================================

    # Connect met1 rails to met4 stripes
    add_pdn_connect \
        -grid stdcell_grid \
        -layers "$::env(FP_PDN_RAIL_LAYER) $::env(FP_PDN_VERTICAL_LAYER)"

    # Connect met4 vertical to met5 horizontal
    add_pdn_connect \
        -grid stdcell_grid \
        -layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)"

    # Connect VMID on met3 to met4 for distribution
    add_pdn_connect \
        -grid stdcell_grid \
        -layers "met3 $::env(FP_PDN_VERTICAL_LAYER)"

    # ============================================================
    # Power Ring (Optional)
    # ============================================================

    if { [info exists ::env(FP_PDN_CORE_RING)] && $::env(FP_PDN_CORE_RING) == 1 } {
        add_pdn_ring \
            -grid stdcell_grid \
            -layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)" \
            -widths "$::env(FP_PDN_RING_WIDTH) $::env(FP_PDN_RING_WIDTH)" \
            -spacings "$::env(FP_PDN_RING_SPACING) $::env(FP_PDN_RING_SPACING)" \
            -core_offsets "$::env(FP_PDN_RING_OFFSET) $::env(FP_PDN_RING_OFFSET)"

        # VMID ring (inner)
        add_pdn_ring \
            -grid stdcell_grid \
            -layer met3 \
            -width [expr {$::env(FP_PDN_RING_WIDTH) * 0.5}] \
            -spacing $::env(FP_PDN_RING_SPACING) \
            -core_offset [expr {$::env(FP_PDN_RING_OFFSET) + $::env(FP_PDN_RING_WIDTH) + $::env(FP_PDN_RING_SPACING)}] \
            -nets $vmid_net_name
    }

} else {
    # Macro/block mode - simplified PDN
    define_pdn_grid \
        -name stdcell_grid \
        -starts_with POWER \
        -voltage_domain CORE

    add_pdn_stripe \
        -grid stdcell_grid \
        -layer $::env(FP_PDN_RAIL_LAYER) \
        -width $::env(FP_PDN_RAIL_WIDTH) \
        -followpins
}

# ============================================================
# IR Drop Constraints
# ============================================================

# Target: <50mV IR drop on VMID rail at max current
# VMID current estimate: ~10% of VDD current (mid-level switching)
# Formula: IR_drop = I * R_wire
# For VMID: R_wire < 50mV / I_vmid

puts "============================================================"
puts "3-Rail PDN Configuration Complete"
puts "============================================================"
puts "VDD Net:  $::env(VDD_NET)"
puts "VSS Net:  $::env(GND_NET)"
puts "VMID Net: $vmid_net_name"
puts "VMID Layer: met3"
puts "VMID Width: $vmid_width um"
puts "VMID Pitch: $vmid_pitch um"
puts "============================================================"
puts "NOTE: Run IR drop analysis after routing to verify VMID drop <50mV"
puts "============================================================"
