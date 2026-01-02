# Tritone CPU Demo

This directory contains a minimal working example to verify CPU functionality.

## Files

| File | Purpose |
|------|---------|
| `counter.btasm` | Simple counter program (1 to 5) |
| `expected_output.txt` | Expected register/memory values |
| `run_demo.bat` | Windows script to run demo |
| `run_demo.sh` | Linux/macOS script to run demo |

## Quick Start

### 1. Assemble the program

```bash
cd tools
python btisa_assembler.py ../tests/demo/counter.btasm -o ../tests/demo/counter.mem
```

### 2. Run simulation

```bash
cd hdl
iverilog -g2012 -o demo.vvp \
    rtl/ternary_pkg.sv \
    rtl/btfa.sv \
    rtl/ternary_adder.sv \
    rtl/ternary_alu.sv \
    rtl/ternary_regfile.sv \
    rtl/btisa_decoder.sv \
    rtl/ternary_hazard_unit.sv \
    rtl/ternary_forward_unit.sv \
    rtl/ternary_memory.sv \
    rtl/ternary_cpu.sv \
    rtl/ternary_cpu_system.sv \
    tb/tb_ternary_cpu.sv

vvp demo.vvp
```

### 3. Verify output

Check that:
- R1 = 5 (counter reached 5)
- R2 = 5 (limit unchanged)
- Memory[0..4] = 1, 2, 3, 4, 5
- CPU halted

## What This Tests

| Feature | Tested |
|---------|--------|
| LDI (Load Immediate) | Yes |
| ADDI (Add Immediate) | Yes |
| ST (Store) | Yes |
| BNE (Branch Not Equal) | Yes |
| HALT | Yes |
| Pipeline forwarding | Yes |
| Memory write | Yes |
