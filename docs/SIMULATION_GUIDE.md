# Tritone Simulation Guide

## Overview

This guide covers simulation of the Tritone balanced ternary processor using various tools:
- **Icarus Verilog** - Open-source Verilog simulator (default)
- **Verilator** - Fast cycle-accurate simulator
- **Vivado Simulator** - Xilinx's built-in simulator

---

## Quick Start

```bash
cd hdl

# Run all Icarus-compatible tests
make test-icarus

# Run individual tests
make test-adder
make test-alu
make test-cla
make test-btfa
```

---

## Simulator Compatibility

### Icarus Verilog

Icarus Verilog (iverilog) is the default simulator. Version 11.0+ is recommended for best SystemVerilog support.

**Supported Features:**
- Basic SystemVerilog constructs
- Packages and imports
- Enumerated types
- Parametrized modules

**Known Limitations:**
| Feature | Status | Workaround |
|---------|--------|------------|
| `'{default: X}` array init | Not supported | Use explicit loops |
| `string` type in tasks | Not supported | Use fixed-width bit vectors |
| `int` in for loop headers | Partial | Declare `integer` outside loop |
| `automatic` keyword | Supported in v11+ | Use v11 or later |
| `unique case` | Not supported | Use regular `case` |

**Icarus-Compatible Testbenches:**
- `tb_ternary_adder_icarus.sv` - Adder test
- `tb_ternary_alu_icarus.sv` - ALU test
- `tb_btfa.sv` - Full adder test

### Verilator

Verilator is recommended for larger simulations (CPU-level).

```bash
make verilator-cpu
```

**Advantages:**
- 10-100x faster than Icarus
- Better error messages
- Built-in lint checking

**Limitations:**
- No timing simulation
- Some SystemVerilog restrictions

### Vivado Simulator

For FPGA-targeted simulations with accurate timing.

```tcl
# In Vivado
create_project -part xc7a100tcsg324-1 tritone_sim
add_files -fileset sim_1 [glob hdl/rtl/*.sv hdl/tb/*.sv]
set_property top tb_ternary_cpu [get_filesets sim_1]
launch_simulation
```

---

## Testbench Inventory

### Unit Tests

| Testbench | Module Under Test | Status |
|-----------|-------------------|--------|
| `tb_btfa.sv` | btfa | ✅ Icarus OK |
| `tb_ternary_adder_icarus.sv` | ternary_adder | ✅ Icarus OK |
| `tb_ternary_adder.sv` | ternary_adder | ⚠️ Needs SV features |
| `tb_ternary_alu_icarus.sv` | ternary_alu | ✅ Icarus OK |
| `tb_ternary_alu.sv` | ternary_alu | ⚠️ Needs SV features |
| `tb_ternary_cla.sv` | ternary_cla | ✅ Validates vs ripple |

### System Tests

| Testbench | Description | Simulator |
|-----------|-------------|-----------|
| `tb_ternary_cpu.sv` | Full CPU test | Verilator recommended |
| `tb_hello_world.sv` | Basic sanity check | Any |

---

## Writing Icarus-Compatible Code

### Array Initialization

```systemverilog
// BAD - Not supported in Icarus
trit_t [7:0] arr = '{default: T_ZERO};

// GOOD - Use explicit task
task set_all_zero;
  output trit_t [7:0] arr;
  integer i;
  begin
    for (i = 0; i < 8; i = i + 1)
      arr[i] = T_ZERO;
  end
endtask
```

### For Loop Variables

```systemverilog
// BAD - int declaration inside for
for (int i = 0; i < N; i++) begin

// GOOD - Declare outside
integer i;
for (i = 0; i < N; i = i + 1) begin
```

### String Parameters

```systemverilog
// BAD - string type not supported
task display_msg(string msg);

// GOOD - Use fixed-width vector
task display_msg;
  input [255:0] msg;
  begin
    $display("%s", msg);
  end
endtask
```

### Package Includes

```systemverilog
// In testbench - use include for Icarus
`include "../rtl/ternary_pkg.sv"

module tb_test;
  import ternary_pkg::*;
  // ...
endmodule
```

---

## Waveform Viewing

### Generate VCD

```bash
make test-adder-vcd
```

This creates `dump.vcd` which can be viewed with GTKWave:

```bash
gtkwave dump.vcd
```

### Key Signals to Monitor

**For Adder:**
- `a`, `b` - Input operands
- `cin` - Carry in
- `sum` - Result
- `cout` - Carry out

**For ALU:**
- `op` - Operation code
- `result` - ALU output
- `zero_flag`, `neg_flag` - Status flags

**For CPU:**
- `clk`, `rst` - Clock and reset
- `pc` - Program counter
- `instruction_a`, `instruction_b` - Dual-issue instructions
- `regfile` - Register contents

---

## Test Coverage

### Running Coverage Analysis

With Verilator:
```bash
verilator --coverage --cc hdl/rtl/*.sv
```

With Vivado:
```tcl
set_property -name {xsim.simulate.coverage.enable} -value {1} [get_filesets sim_1]
```

### Current Coverage Metrics

| Module | Line Coverage | Branch Coverage |
|--------|--------------|-----------------|
| ternary_adder | ~95% | ~90% |
| ternary_alu | ~90% | ~85% |
| ternary_cla | ~85% | ~80% |
| btisa_decoder | ~95% | ~90% |

---

## Performance Benchmarking

### Simulation Performance

| Simulator | Cycles/sec | Notes |
|-----------|-----------|-------|
| Icarus | ~10K | Debugging, small tests |
| Verilator | ~1M | Large simulations |
| Vivado | ~50K | Timing-accurate |

### Running Benchmarks

```bash
# Compile benchmark programs
cd tools
python btasm_assembler.py programs/benchmark_basic.btasm -o benchmark_basic.hex

# Run in simulation
cd ../hdl
make test-cpu PROGRAM=../tools/benchmark_basic.hex
```

---

## Troubleshooting

### Common Errors

**"Unknown module type: ternary_pkg"**
- Solution: Include package first in compilation order
- Use `iverilog -g2012 pkg.sv module.sv tb.sv`

**"'{default:' is not supported"**
- Solution: Use Icarus-compatible testbench (`*_icarus.sv`)

**"Variable 'i' is implicitly declared"**
- Solution: Declare `integer i;` before for loop

**"Unable to bind wire/reg"**
- Solution: Check module instantiation port names

### Debug Tips

1. Add `$display` statements at key points
2. Use `$monitor` for continuous signal tracking
3. Enable VCD dumping for waveform analysis
4. Check for uninitialized signals

---

## File Structure

```
hdl/
├── rtl/                    # RTL source files
│   ├── ternary_pkg.sv      # Package definitions
│   ├── btfa.sv             # Full adder
│   ├── ternary_adder.sv    # Ripple-carry adder
│   ├── ternary_cla.sv      # Carry-lookahead adder
│   ├── ternary_alu.sv      # ALU
│   └── ternary_cpu.sv      # CPU core
├── tb/                     # Testbenches
│   ├── tb_*_icarus.sv      # Icarus-compatible
│   └── tb_*.sv             # Full SystemVerilog
├── build/                  # Generated files
└── Makefile                # Build automation
```

---

## References

- [Icarus Verilog Manual](http://iverilog.icarus.com/)
- [Verilator Documentation](https://verilator.org/guide/latest/)
- [SystemVerilog LRM IEEE 1800-2017](https://standards.ieee.org/)

---

**Last Updated:** December 2025
