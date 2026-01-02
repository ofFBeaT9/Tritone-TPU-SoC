# BTISA Instruction Set Coverage Report

## Executive Summary

**Total Instructions Defined:** 24
**Instructions Tested:** 22 (92%)
**Instructions Fully Implemented:** 21 (88%)
**Test Programs:** 19

---

## Coverage Matrix

### Arithmetic Instructions (6)

| Instruction | Opcode | Description | Tested | Implemented | Test File |
|-------------|--------|-------------|--------|-------------|-----------|
| ADD | 000 | Addition | ✅ | ✅ | test_arithmetic.btasm |
| SUB | 00+ | Subtraction | ✅ | ✅ | test_arithmetic.btasm |
| NEG | 00- | Negation | ✅ | ✅ | test_arithmetic.btasm |
| MUL | 0+0 | Multiplication | ✅ | ⚠️ Fallback | test_mul.btasm |
| SHL | 0++ | Shift Left (*3) | ✅ | ✅ | test_shift.btasm |
| SHR | 0+- | Shift Right (/3) | ✅ | ✅ | test_shift.btasm |

**Notes:**
- MUL currently uses ADD as fallback (`alu_op = 3'b000`). A dedicated ternary multiplier needs implementation.
- SHL/SHR operate on single trit positions (multiply/divide by 3 in ternary).

### Branch Instructions (3)

| Instruction | Opcode | Description | Tested | Implemented | Test File |
|-------------|--------|-------------|--------|-------------|-----------|
| BEQ | 0-0 | Branch if Equal | ✅ | ✅ | test_control_flow.btasm, test_branch_prediction.btasm |
| BNE | 0-+ | Branch if Not Equal | ✅ | ✅ | test_control_flow.btasm, test_branch_prediction.btasm |
| BLT | 0-- | Branch if Less Than | ✅ | ✅ | test_blt.btasm |

**Notes:**
- All branch types supported with static backward-taken predictor
- Branch prediction integrated in dual-issue pipeline
- Misprediction detection signals: `mispredicted_a`, `mispredicted_b`

### Logic Instructions (6)

| Instruction | Opcode | Description | Tested | Implemented | Test File |
|-------------|--------|-------------|--------|-------------|-----------|
| MIN | +00 | Ternary Minimum | ✅ | ✅ | test_logical.btasm |
| MAX | +0+ | Ternary Maximum | ✅ | ✅ | test_logical.btasm |
| XOR | +0- | Ternary XOR | ✅ | ✅ | test_bitwise.btasm |
| INV | ++0 | Ternary Inversion | ✅ | ✅ | test_logical.btasm |
| PTI | +++ | Positive Trit Isolation | ✅ | ✅ | test_bitwise.btasm |
| NTI | ++- | Negative Trit Isolation | ✅ | ✅ | test_bitwise.btasm |

**Notes:**
- MIN/MAX implement trit-wise minimum/maximum (AND/OR equivalents)
- XOR implemented as addition modulo 3
- PTI/NTI use NEG ALU operation with special handling

### Jump Instructions (3)

| Instruction | Opcode | Description | Tested | Implemented | Test File |
|-------------|--------|-------------|--------|-------------|-----------|
| JAL | +-0 | Jump and Link | ✅ | ✅ | test_jumps.btasm |
| JALR | +-+ | Jump and Link Register | ✅ | ✅ | test_jumps.btasm |
| JR | +-- | Jump Register (Return) | ✅ | ✅ | test_jumps.btasm |

**Notes:**
- JAL saves PC+1 to Rd, jumps to target
- JALR for register-indirect jumps
- JR for function returns

### Memory Instructions (5)

| Instruction | Opcode | Description | Tested | Implemented | Test File |
|-------------|--------|-------------|--------|-------------|-----------|
| LD | -00 | Load Word | ✅ | ✅ | test_memory_edge_cases.btasm |
| ST | -0+ | Store Word | ✅ | ✅ | test_memory_stress.btasm |
| LDT | -0- | Load Trit | ✅ | ✅ | test_data_movement.btasm |
| STT | -+0 | Store Trit | ✅ | ✅ | test_data_movement.btasm |
| LUI | -++ | Load Upper Immediate | ✅ | ✅ | test_lui.btasm |

**Notes:**
- LD/ST operate on full 27-trit words
- LDT/STT for partial word (trit) access
- LUI shifts immediate to upper bits

### System Instructions (3)

| Instruction | Opcode | Description | Tested | Implemented | Test File |
|-------------|--------|-------------|--------|-------------|-----------|
| NOP | --0 | No Operation | ✅ | ✅ | test_system_ops.btasm |
| ECALL | --- | Environment Call | ❌ | ⚠️ Decoded only | - |
| HALT | --+ | Halt Execution | ✅ | ✅ | All test files |

**Notes:**
- NOP decoded but sets no control signals (advances PC)
- ECALL decoded but not implemented (future syscall support)
- HALT stops CPU execution

---

## Test Programs Inventory

| # | Test File | Category | Instructions Covered |
|---|-----------|----------|---------------------|
| 1 | test_arithmetic.btasm | Arithmetic | ADD, SUB, NEG |
| 2 | test_logical.btasm | Logic | MIN, MAX, INV |
| 3 | test_bitwise.btasm | Logic | XOR, PTI, NTI |
| 4 | test_shift.btasm | Arithmetic | SHL, SHR |
| 5 | test_shift_extended.btasm | Arithmetic | SHL, SHR (extended) |
| 6 | test_data_movement.btasm | Memory | LDT, STT |
| 7 | test_memory_edge_cases.btasm | Memory | LD, edge cases |
| 8 | test_memory_stress.btasm | Memory | ST, stress test |
| 9 | test_control_flow.btasm | Branch | BEQ, BNE, BEQZ, BNEZ |
| 10 | test_blt.btasm | Branch | BLT |
| 11 | test_branch_prediction.btasm | Branch | BEQ, BNE, predictor |
| 12 | test_jumps.btasm | Jump | JAL, JALR, JR |
| 13 | test_lui.btasm | Memory | LUI |
| 14 | test_hazards.btasm | Pipeline | Data hazards, forwarding |
| 15 | test_system_ops.btasm | System | NOP, HALT |
| 16 | test_invalid_encodings.btasm | Edge | Invalid opcodes |
| 17 | test_mul.btasm | Arithmetic | MUL (fallback behavior) |
| 18 | test_comprehensive.btasm | All | Full regression suite |
| 19 | benchmark_*.btasm | Performance | DSP, NN workloads |

---

## Coverage Gaps

### 1. MUL Instruction (Partial Implementation)

**Status:** Decoded but uses ADD fallback

**Location:** `hdl/rtl/btisa_decoder.sv:106`
```systemverilog
op_is_mul: alu_op = 3'b000;  // MUL (use ADD for now, needs multiplier)
```

**Resolution:**
- Implement dedicated ternary multiplier in `hdl/rtl/ternary_multiplier.sv`
- Add MUL-specific ALU operation
- Update decoder to use new multiplier

### 2. ECALL Instruction (Decoded Only)

**Status:** Opcode decoded, no implementation

**Location:** `hdl/rtl/btisa_decoder.sv:72`
```systemverilog
wire op_is_ecall= (opcode == {T_NEG_ONE, T_NEG_ONE, T_NEG_ONE}); // ---
```

**Resolution:**
- Define system call interface
- Implement exception handling
- Add privileged mode support (future enhancement)

### 3. Formal Coverage Testbench

**Status:** Not implemented

**Proposed File:** `hdl/tb/tb_isa_coverage.sv`

**Purpose:**
- Collect functional coverage metrics
- Use SystemVerilog covergroups
- Generate coverage reports for all opcodes

---

## Pseudo-Instructions

The following pseudo-instructions are supported by the assembler:

| Pseudo | Expansion | Notes |
|--------|-----------|-------|
| LDI Rd, imm | ADD Rd, R0, imm | Load immediate |
| MOV Rd, Rs | ADD Rd, Rs, 0 | Register copy |
| BEQZ Rs, label | BEQ Rs, R0, label | Branch if zero |
| BNEZ Rs, label | BNE Rs, R0, label | Branch if not zero |
| RET | JR R8 | Return from function |

---

## Pipeline Coverage

### Hazard Detection

| Hazard Type | Tested | Test File |
|-------------|--------|-----------|
| RAW (Read After Write) | ✅ | test_hazards.btasm |
| Data Forwarding (EX-EX) | ✅ | test_hazards.btasm |
| Data Forwarding (MEM-EX) | ✅ | test_hazards.btasm |
| Load-Use Hazard | ✅ | test_hazards.btasm |
| Control Hazard (Branch) | ✅ | test_branch_prediction.btasm |

### Dual-Issue Coverage

| Scenario | Tested | Test File |
|----------|--------|-----------|
| Independent instructions | ✅ | benchmark_basic.btasm |
| Dependent pair (stall) | ✅ | test_hazards.btasm |
| Branch in slot A | ✅ | test_branch_prediction.btasm |
| Branch in slot B | ✅ | test_branch_prediction.btasm |
| Memory + ALU pair | ✅ | benchmark_fir.btasm |

---

## Recommendations

### Priority 1: Complete MUL Implementation
- Design ternary multiplier using shift-add or Booth's algorithm variant
- Integrate as new ALU operation (OP_MUL = 3'b111 suggested)
- Add multiply benchmark for performance characterization

### Priority 2: Formal Coverage Collection
- Create `tb_isa_coverage.sv` with SystemVerilog covergroups
- Cover all opcode combinations
- Report line coverage, toggle coverage, FSM coverage

### Priority 3: Extended Testing
- Add corner cases for balanced ternary overflow
- Test maximum/minimum representable values
- Verify carry propagation across all 27 trits

---

## Verification Summary

```
Total Instructions:    24
Fully Implemented:     21 (88%)
Partially Implemented: 2  (MUL, ECALL)
Not Implemented:       1  (ECALL functional behavior)

Test Coverage:         92% (22/24 instructions exercised)
Test Programs:         19 files
Branch Prediction:     Implemented and tested
Pipeline Hazards:      All detected and handled
```

**Last Updated:** December 2025
**Tritone Version:** v0.9 (pre-publication)
