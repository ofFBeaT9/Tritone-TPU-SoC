● Vivado FPGA Build Instructions

  The project has pre-configured scripts for Artix-7 FPGA synthesis. Here's what you need to do:

  Quick Start (Batch Mode)

  cd E:\Tritone-V2\tritone-complete\fpga\scripts
  vivado -mode batch -source build_cpu.tcl

  Custom Part Number

  vivado -mode batch -source build_cpu.tcl -tclargs xc7a35tcpg236-1

  Common FPGA targets:
  | Board         | Part Number                |
  |---------------|----------------------------|
  | Nexys A7-100T | xc7a100tcsg324-1 (default) |
  | Basys 3       | xc7a35tcpg236-1            |
  | Arty A7-35T   | xc7a35ticsg324-1L          |
  | Arty A7-100T  | xc7a100ticsg324-1L         |

  What the Build Does

  1. Synthesizes all RTL from hdl/rtl/*.sv
  2. Implements with aggressive timing optimization
  3. Generates bitstream at fpga/bitstreams/ternary_cpu_system.bit
  4. Reports in fpga/scripts/build_cpu/reports/

  Before Running

  The constraints file (fpga/constraints/ternary_cpu_system.xdc) targets 400 MHz. For first run, you may want to lower it:

  1. Open fpga/constraints/ternary_cpu_system.xdc
  2. Change line 12 from period 2.500 to:
    - period 10.000 for 100 MHz (safe)
    - period 5.000 for 200 MHz
  3. Uncomment pin assignments (lines 74-110) for your specific board

  GUI Mode (Optional)

  vivado -mode gui
  Then: File → Run Script → select build_cpu.tcl

  Would you like me to adjust the clock constraint to a safer frequency, or configure pin mappings for a specific board?
