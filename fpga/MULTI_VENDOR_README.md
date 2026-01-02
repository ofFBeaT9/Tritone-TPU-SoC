# Multi-Vendor FPGA Support

This directory contains build scripts and constraint files for multiple FPGA vendors.

## Supported Vendors

### 1. Xilinx Vivado (Default)
- **Constraint File:** constraints/ternary_alu.xdc
- **Build Script:** scripts/build.tcl
- **Target Devices:** UltraScale+, Zynq, Artix-7, Kintex-7
- **Usage:**
  ```
  cd project/fpga/scripts
  vivado -mode batch -source build.tcl
  ```

### 2. Intel Quartus
- **Constraint File:** constraints/ternary_alu_quartus.sdc
- **Build Script:** scripts/build_quartus.tcl
- **Target Devices:** Cyclone V, Arria, Stratix
- **Usage:**
  ```
  cd project/fpga/scripts
  quartus_sh -t build_quartus.tcl
  ```

### 3. Lattice Diamond
- **Constraint File:** constraints/ternary_alu_lattice.lpf
- **Build Script:** scripts/build_lattice.tcl
- **Target Devices:** ECP5, CrossLink, iCE40
- **Usage:**
  ```
  cd project/fpga/scripts
  diamondc build_lattice.tcl
  ```

## Device-Specific Adjustments

Before building, modify the following in the build scripts:

### Xilinx (build.tcl)
- Line 12: set PART "xcvu9p-flga2104-2-i" - Change to your device
- constraints/ternary_alu.xdc: Pin locations (commented out by default)

### Intel (build_quartus.tcl)
- Line 13: set DEVICE_FAMILY "Cyclone V"
- Line 14: set DEVICE_PART "5CSEMA5F31C6"
- constraints/ternary_alu_quartus.sdc: I/O standards

### Lattice (build_lattice.tcl)
- Line 13: set DEVICE "LFE5UM5G-85F"
- Line 14: set PACKAGE "CABGA381"
- constraints/ternary_alu_lattice.lpf: Pin locations (commented out by default)

## Verification

All vendors use the same RTL testbench:
```
cd project/fpga/src
# Simulator-specific command (ModelSim, VCS, Xcelium, etc.)
```

## Performance Targets

- **Clock Frequency:** 100 MHz (all vendors)
- **Resource Usage:** <1000 LUTs
- **Power:** Varies by device family

## Notes

1. RTL code is vendor-neutral (standard SystemVerilog)
2. Constraint syntax differs between vendors
3. Timing constraints include internal max_delay paths (REC-3.3)
4. All builds generate comprehensive timing and resource reports
