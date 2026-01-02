# Phase 4: Ternary CPU Core - TODO Checklist

**Phase Duration**: Weeks 15-22
**Status**: ✅ COMPLETE
**Started**: 2025-12-17
**Last Updated**: 2025-12-19

---

## Week 15: ISA Definition

### Step 15.1: ISA Specification Document
- [x] Create `docs/specs/btisa_v01.md`
- [x] Define word size (27 trits)
- [x] Define register set (9 registers, R0-R8)
- [x] Define instruction encoding (9 trits)
- [x] Document arithmetic operations
- [x] Document logic operations
- [x] Document memory operations
- [x] Document control flow operations
- [x] Document system operations
- [x] Include example assembly programs

### Step 15.2: Instruction Encoder/Decoder
- [x] Create `hdl/rtl/btisa_decoder.sv`
- [x] Implement opcode extraction
- [x] Implement register field extraction
- [x] Implement control signal generation
- [x] Support all instruction types

---

## Week 16-18: Microarchitecture Implementation

### Step 16.1: Register File
- [x] Create `hdl/rtl/ternary_regfile.sv`
- [x] Implement 9 registers × 27 trits
- [x] Implement 2 read ports
- [x] Implement 1 write port
- [x] Hardwire R0 to zero
- [x] Add ternary address decoding

### Step 16.2: CPU Core Module
- [x] Create `hdl/rtl/ternary_cpu.sv`
- [x] Implement IF stage (Instruction Fetch)
- [x] Implement ID stage (Instruction Decode)
- [x] Implement EX stage (Execute)
- [x] Implement WB stage (Write Back)
- [x] Implement PC increment logic
- [x] Implement branch target calculation
- [x] Connect decoder to register file
- [x] Connect ALU to pipeline
- [x] Implement memory interface
- [x] Implement halt detection

### Step 16.3: Memory Module
- [x] Create `hdl/rtl/ternary_memory.sv`
- [x] Implement instruction memory (243 words)
- [x] Implement data memory (729 words)
- [x] Ternary address decoding
- [x] Synchronous write, combinational read

### Step 16.4: CPU System Top-Level
- [x] Create `hdl/rtl/ternary_cpu_system.sv`
- [x] Integrate CPU and memory
- [x] Add program loading interface
- [x] Add debug interface

### Step 16.5: Testbench
- [x] Create `hdl/tb/tb_ternary_cpu.sv`
- [x] Implement instruction memory model
- [x] Implement data memory model
- [x] Create test program (basic arithmetic)
- [x] Add cycle-by-cycle debug output

### Step 16.6: Assembler Tool
- [x] Create `tools/btisa_assembler.py`
- [x] Support all instruction mnemonics
- [x] Parse registers and immediates
- [x] Support labels for branches
- [x] Generate SystemVerilog initialization
- [x] Create sample program `programs/test_arithmetic.asm`


---

## Week 19-20: Additional Features

### Hazard Detection ✅ COMPLETE
- [x] Implement data hazard detection (`ternary_hazard_unit.sv`)
- [x] Add forwarding logic (EX-EX, MEM-EX) (`ternary_forward_unit.sv`)
- [x] Implement load-use stall

### Branch Handling ✅ COMPLETE
- [x] Implement full branch condition evaluation
- [x] Support BEQ, BNE, BLT
- [ ] Add branch prediction (static) - *Optional enhancement*

### Jump Support ✅ IN DECODER
- [x] Implement JAL (Jump and Link) - *Decoder complete, CPU wiring done*
- [x] Implement JALR (Jump and Link Register) - *Decoder complete*
- [x] Implement JR (Jump Register / Return) - *Decoder complete*

---

## Week 21-22: Testing & Validation

### Comprehensive Testing ✅ ~80% COMPLETE
- [x] Test all arithmetic instructions (`test_arithmetic.btasm`)
- [x] Test all logic instructions (`test_logical.btasm`)
- [x] Test load/store operations (`test_data_movement.btasm`, `test_memory_edge_cases.btasm`)
- [x] Test branch instructions (`test_control_flow.btasm`)
- [x] Test jump instructions (`test_jumps.btasm`)
- [x] Test hazard scenarios (`test_hazards.btasm`)
- [x] Test shift operations (`test_shift.btasm`, `test_shift_extended.btasm`)
- [x] Test system operations (`test_system_ops.btasm`)
- [ ] Test nested function calls (requires stack - future enhancement)

### Performance Metrics
- [ ] Measure CPI (Cycles Per Instruction) - *Awaiting FPGA*
- [ ] Measure Fmax on FPGA - *Awaiting Vivado*
- [ ] Document resource utilization - *Awaiting Vivado*
- [ ] Compare with binary equivalent

### Documentation ✅ COMPLETE
- [x] PHASE4_VALIDATION_REPORT.md created
- [x] PHASE4_COMPLETION_SUMMARY.md created
- [x] QA gate updated (phase4-cpu-core.yml)

---

## Files Created in Phase 4

| File | Status | Description |
|------|--------|-------------|
| `docs/specs/btisa_v01.md` | ✅ Done | ISA specification |
| `hdl/rtl/btisa_decoder.sv` | ✅ Done | Instruction decoder |
| `hdl/rtl/ternary_regfile.sv` | ✅ Done | Register file |
| `hdl/rtl/ternary_cpu.sv` | ✅ Done | CPU core |
| `hdl/rtl/ternary_hazard_unit.sv` | ✅ Done | Hazard detection unit |
| `hdl/rtl/ternary_forward_unit.sv` | ✅ Done | Data forwarding unit |
| `hdl/rtl/ternary_memory.sv` | ✅ Done | Memory module |
| `hdl/rtl/ternary_cpu_system.sv` | ✅ Done | System integration |
| `hdl/tb/tb_ternary_cpu.sv` | ✅ Done | CPU testbench |
| `hdl/sim/run_cpu_sim.bat` | ✅ Done | Simulation script |
| `tools/btisa_assembler.py` | ✅ Done | BTISA assembler |
| `docs/PHASE4_VALIDATION_REPORT.md` | ✅ Done | Validation report |
| `docs/PHASE4_COMPLETION_SUMMARY.md` | ✅ Done | Completion summary |

---

## Dependencies from Previous Phases

| File | Phase | Required By |
|------|-------|-------------|
| `hdl/rtl/ternary_pkg.sv` | Phase 2 | All modules |
| `hdl/rtl/btfa.sv` | Phase 2 | ternary_adder |
| `hdl/rtl/ternary_adder.sv` | Phase 2 | ternary_alu, ternary_cpu |
| `hdl/rtl/ternary_alu.sv` | Phase 2 | ternary_cpu |

---

## Notes

1. **Current Status**: ✅ Phase 4 COMPLETE - Full 4-stage pipeline CPU with hazards and forwarding
2. **Implemented Features**:
   - ✅ Hazard detection unit (RAW hazards, load-use stalls)
   - ✅ Data forwarding unit (EX-EX, MEM-EX paths)
   - ✅ Branch condition support (BEQ, BNE, BLT)
   - ✅ Jump instruction decoding (JAL, JALR, JR)
   - ✅ Comprehensive test suite (10 test programs)
3. **Known Limitations**:
   - No interrupt support
   - No memory-mapped I/O
   - No branch prediction (optional enhancement)
4. **Next Steps**: 
   - Phase 5: System integration, benchmarks, publication
   - Phase 3: FPGA synthesis (awaiting Vivado)

---

**Last Updated**: 2025-12-19
