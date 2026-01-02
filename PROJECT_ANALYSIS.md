# Balanced Ternary CMOS CPU Project - Complete Analysis

**Document Generated:** December 19, 2025  
**Project Location:** `e:\ternary cmos compile\`  
**Overall Status:** 75% Complete (Phases 1, 2, 4 Complete)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [What is Balanced Ternary?](#2-what-is-balanced-ternary)
3. [Project Architecture](#3-project-architecture)
4. [Phase 1: SPICE Cell Library](#4-phase-1-spice-cell-library)
5. [Phase 2: RTL Synthesis](#5-phase-2-rtl-synthesis)
6. [Phase 3: FPGA Prototype](#6-phase-3-fpga-prototype)
7. [Phase 4: CPU Core](#7-phase-4-cpu-core)
8. [Phase 5: Documentation & Testing](#8-phase-5-documentation--testing)
9. [File Structure Analysis](#9-file-structure-analysis)
10. [Key Achievements](#10-key-achievements)
11. [Remaining Work](#11-remaining-work)
12. [Technical Specifications](#12-technical-specifications)

---

## 1. Project Overview

### 1.1 What This Project Is

This is a **research and development project** to create a complete **balanced ternary computing system** from transistor-level circuits to a working CPU with assembler and test programs.

### 1.2 Project Goals

| Goal | Status |
|------|--------|
| Design ternary logic cells in SPICE | ✅ Complete |
| Create SystemVerilog RTL for CPU | ✅ Complete |
| Implement FPGA prototype | 🟡 75% (Design done, synthesis pending) |
| Build assembler and tools | ✅ Complete |
| Validate with comprehensive tests | ✅ 80.8% coverage |
| Prepare for publication | 🔄 In progress |
| Optional: ASIC tapeout | ☐ Future |

### 1.3 Why Ternary Computing?

**Binary computing is hitting physical limits.** Instead of making transistors smaller, this project explores encoding **more information per wire** using three voltage levels instead of two.

| Metric | Binary | Balanced Ternary | Advantage |
|--------|--------|------------------|-----------|
| States per digit | 2 | 3 | +50% states |
| Information per digit | 1.000 bits | 1.585 bits | **+58.5%** |
| 8-digit range | 256 values | 6,561 values | **25.6x larger** |
| Negation complexity | Two's complement | Flip signs | **Trivial** |

---

## 2. What is Balanced Ternary?

### 2.1 The Three Values

| Symbol | Value | Voltage (1.8V CMOS) | Description |
|--------|-------|---------------------|-------------|
| **-** | -1 | 0V (GND) | Negative one |
| **0** | 0 | 0.9V (VDD/2) | Zero |
| **+** | +1 | 1.8V (VDD) | Positive one |

### 2.2 Number Representation Examples

| Decimal | Balanced Ternary | Calculation |
|---------|------------------|-------------|
| 0 | 0 | 0 |
| 1 | + | +1 |
| 2 | +- | 3x1 + 1x(-1) = 2 |
| 5 | +-- | 9-3-1 = 5 |
| -5 | -++ | -9+3+1 = -5 |
| 13 | +++ | 9+3+1 = 13 |

### 2.3 Unique Properties

1. **Negation is trivial**: Just flip all signs (+ <-> -)
2. **No sign bit needed**: Sign is inherent in the number
3. **Symmetric range**: Equal positive and negative values
4. **Truncation = rounding**: Natural rounding to nearest

---

## 3. Project Architecture

### 3.1 System Block Diagram

```
+---------------------------------------------------------------------+
|                    BALANCED TERNARY CPU SYSTEM                       |
+---------------------------------------------------------------------+
|                                                                     |
|  +---------+    +---------+    +---------+    +---------+          |
|  |   IF    |--->|   ID    |--->|   EX    |--->|   WB    |          |
|  | Fetch   |    | Decode  |    | Execute |    | Write   |          |
|  +----+----+    +----+----+    +----+----+    +----+----+          |
|       |              |              |              |                |
|       |         +----+----+         |              |                |
|       |         | Register|<--------+--------------+                |
|       |         |  File   |                                         |
|       |         | 9x27-trit|                                         |
|       |         +----+----+                                         |
|       |              |                                              |
|  +----+----+   +----+----+   +---------+   +---------+             |
|  |  IMEM   |   |  Hazard |   |   ALU   |   |  DMEM   |             |
|  | 243x9   |   | + Fwd   |   | 8 ops   |   | 729x27  |             |
|  +---------+   +---------+   +---------+   +---------+             |
|                                                                     |
+---------------------------------------------------------------------+
```

### 3.2 Technology Stack

| Layer | Technology | Files |
|-------|------------|-------|
| Transistor | SKY130 PDK (1.8V) | `project/spice/cells/*.spice` |
| Cell Library | ngspice simulation | `project/asic/lib/gt_logic_ternary.lib` |
| RTL | SystemVerilog | `project/hdl/rtl/*.sv` |
| FPGA | Xilinx/Lattice/Intel | `project/fpga/` |
| Software | Python | `project/tools/btisa_assembler.py` |
| Testing | pytest + cocotb | `tests/*.py` |

---

## 4. Phase 1: SPICE Cell Library

**Status:** ✅ 100% Complete

### 4.1 Cells Designed and Validated

| Cell | Function | Transistors | SPICE File | Test Status |
|------|----------|-------------|------------|-------------|
| STI | Y = -A (full invert) | 6 | `sti.spice` | ✅ PASS |
| PTI | Positive threshold | 6 | `pti.spice` | ✅ PASS |
| NTI | Negative threshold | 6 | `nti.spice` | ✅ PASS |
| TMIN | Y = MIN(A,B) | 10 | `tmin.spice` | ✅ PASS |
| TMAX | Y = MAX(A,B) | 10 | `tmax.spice` | ✅ PASS |
| TNAND | Y = -MIN(A,B) | 16 | `tnand.spice` | ✅ PASS |
| TNOR | Y = -MAX(A,B) | 16 | `tnor.spice` | ✅ PASS |
| TSUM | Sum without carry | 20 | `tsum.spice` | ✅ PASS |
| TMUX3 | 3:1 Multiplexer | 24 | `tmux3.spice` | ✅ PASS |
| BTHA | Half Adder | 30 | `btha.spice` | ✅ PASS |
| BTFA | Full Adder | 42 | `btfa.spice` | ✅ PASS |

**Location:** `project/spice/cells/` (12 files)

### 4.2 Testbenches and Results

**Location:** `project/spice/testbenches/` (14 files)

| Testbench | Description | Result |
|-----------|-------------|--------|
| `tb_sti.spice` | STI DC analysis | ✅ 3 regions verified |
| `tb_inverters.spice` | Compare STI/PTI/NTI | ✅ All thresholds correct |
| `tb_btfa_cin0_dc.spice` | BTFA with Cin=0 | ✅ 9/9 pass |
| `tb_btfa_cin1_dc.spice` | BTFA with Cin=+1 | ✅ 9/9 pass |
| `tb_btfa_cin2_dc.spice` | BTFA with Cin=-1 | ✅ 9/9 pass |
| `monte_carlo_sti.spice` | Process variation | ✅ >99.7% yield |

**Results:** `project/spice/results/` (30 files - logs and CSVs)

### 4.3 Liberty Timing Library

**File:** `project/asic/lib/gt_logic_ternary.lib` (424 lines)

Contains timing data for all cells in Liberty format for EDA tool integration.

---

## 5. Phase 2: RTL Synthesis

**Status:** ✅ 100% Complete

### 5.1 RTL Modules

**Location:** `project/hdl/rtl/` (11 files)

| Module | Lines | Description |
|--------|-------|-------------|
| `ternary_pkg.sv` | 158 | Type definitions, functions |
| `btfa.sv` | 27 | Balanced Ternary Full Adder |
| `ternary_adder.sv` | ~60 | N-trit parametric adder |
| `ternary_alu.sv` | 118 | 8-operation ALU |
| `ternary_regfile.sv` | ~80 | 9x27-trit register file |
| `btisa_decoder.sv` | ~150 | Instruction decoder |
| `ternary_cpu.sv` | 496 | 4-stage pipeline CPU |
| `ternary_hazard_unit.sv` | 81 | RAW hazard detection |
| `ternary_forward_unit.sv` | 68 | Data forwarding |
| `ternary_memory.sv` | ~100 | Memory interface |
| `ternary_cpu_system.sv` | ~120 | Top-level system |

### 5.2 Testbenches

**Location:** `project/hdl/tb/` (6 files)

| Testbench | Tests | Result |
|-----------|-------|--------|
| `tb_btfa.sv` | 27 input combinations | 27/27 PASS ✅ |
| `tb_ternary_adder.sv` | Multi-trit addition | PASS ✅ |
| `tb_ternary_alu.sv` | All 8 ALU operations | PASS ✅ |
| `tb_ternary_cpu.sv` | CPU integration | PASS ✅ |

---

## 6. Phase 3: FPGA Prototype

**Status:** 🟡 75% Complete (Design done, synthesis blocked)

### 6.1 Multi-Vendor Support

**Constraints:** `project/fpga/constraints/`

| Vendor | File | Status |
|--------|------|--------|
| Xilinx | `ternary_alu.xdc` | ✅ Ready |
| Lattice | `ternary_alu_lattice.lpf` | ✅ Ready |
| Intel/Altera | `ternary_alu_quartus.sdc` | ✅ Ready |

### 6.2 Blocking Issue

⚠️ **Vivado not installed** - FPGA synthesis requires external tool installation (~40GB).

---

## 7. Phase 4: CPU Core

**Status:** ✅ 100% Complete

### 7.1 BTISA Instruction Set

**Specification:** `project/docs/specs/btisa_v01.md` (213 lines)

| Category | Instructions | Count |
|----------|--------------|-------|
| Arithmetic | ADD, SUB, NEG, ADDI, MUL, SHL, SHR | 7 |
| Logic | MIN, MAX, XOR, INV, PTI, NTI | 6 |
| Memory | LD, ST, LDT, STT, LUI | 5 |
| Control | BEQ, BNE, BLT, JAL, JALR, JR | 6 |
| System | NOP, HALT, ECALL | 3 |
| **Total** | | **26** |

### 7.2 Pipeline Architecture

| Stage | Name | Operations |
|-------|------|------------|
| IF | Instruction Fetch | Read instruction from IMEM |
| ID | Instruction Decode | Decode + register read |
| EX | Execute | ALU operation + memory access |
| WB | Write Back | Write result to register file |

**Features:**
- ✅ RAW hazard detection
- ✅ Load-use hazard stalling
- ✅ Data forwarding (EX->EX, WB->EX)
- ✅ Branch/jump flush

### 7.3 Assembler

**File:** `project/tools/btisa_assembler.py` (434 lines)

**Features:**
- All 26 instructions supported
- Pseudo-instructions: LDI, MOV, JMP, RET, BEQZ, BNEZ
- Label support
- Multiple output formats (SV, hex, binary)

### 7.4 Test Programs

**Location:** `project/tools/programs/` (14 files)

**Total Coverage:** 80.8% (21/26 instructions)

---

## 8. Phase 5: Documentation & Testing

**Status:** 🔄 60% Complete

### 8.1 Python Test Suite

**Location:** `tests/` (3 files)

| Test File | Tests | Status |
|-----------|-------|--------|
| `test_btisa_assembler.py` | 36 | ✅ All pass |
| `test_ternary_logic.py` | 23 | ✅ All pass |
| `test_hello_world.py` | 3 | ✅ All pass |
| **Total** | **62** | **100% pass** |

### 8.2 Research Paper Draft

**File:** `project/docs/papers/GT_LOGIC_Ternary_CPU_Paper.md` (582 lines)

---

## 9. File Structure Analysis

### 9.1 File Statistics

| Category | Files | Lines (approx) |
|----------|-------|----------------|
| SPICE cells | 12 | ~1,200 |
| SPICE testbenches | 14 | ~1,400 |
| SystemVerilog RTL | 11 | ~1,400 |
| SystemVerilog TB | 6 | ~600 |
| Python tools | 5+ | ~800 |
| Test programs | 14 | ~500 |
| Documentation | 20+ | ~3,000 |
| Python tests | 3 | ~700 |
| **Total** | **85+** | **~9,600** |

---

## 10. Key Achievements

### 10.1 Technical Achievements

| Achievement | Evidence |
|-------------|----------|
| **12 ternary SPICE cells** | All validated with testbenches |
| **Balanced Ternary Full Adder** | 27/27 input combinations pass |
| **4-stage pipelined CPU** | Hazard detection + forwarding working |
| **26-instruction ISA** | Complete specification + decoder |
| **Python assembler** | 434 lines, pseudo-instructions supported |
| **80.8% test coverage** | 21/26 instructions tested |
| **62 Python tests** | 100% pass rate |
| **De Morgan's laws verified** | Mathematical correctness proven |

### 10.2 Mathematical Validations

| Property | Formula | Verified |
|----------|---------|----------|
| Double negation | -(−A) = A | ✅ |
| MIN commutative | MIN(A,B) = MIN(B,A) | ✅ |
| MAX commutative | MAX(A,B) = MAX(B,A) | ✅ |
| De Morgan 1 | -MIN(A,B) = MAX(-A,-B) | ✅ |
| De Morgan 2 | -MAX(A,B) = MIN(-A,-B) | ✅ |

### 10.3 Performance Metrics

| Metric | Value |
|--------|-------|
| Information density improvement | +58.5% vs binary |
| BTFA transistor count | 42 |
| Transistors per bit | 26.5 (vs 28 for binary) |
| Pipeline stages | 4 |
| Register count | 9 x 27-trit |
| 27-trit value range | +/-3.8 trillion |

---

## 11. Remaining Work

### 11.1 High Priority

| Task | Phase | Blocker |
|------|-------|---------|
| Install Vivado | 3 | External tool (~40GB) |
| Run FPGA synthesis | 3 | Requires Vivado |
| Generate bitstream | 3 | Requires synthesis |

### 11.2 Medium Priority

| Task | Phase | Status |
|------|-------|--------|
| Expand test coverage to 90%+ | 4/5 | 5 instructions remaining |
| Finalize research paper | 5 | Draft complete |

### 11.3 Future Work

| Task | Phase | Notes |
|------|-------|-------|
| Branch prediction | Future | Proposal written |
| OpenLane ASIC flow | 6 | Optional |
| Efabless tapeout | 6 | Optional |

---

## 12. Technical Specifications

### 12.1 CPU Specifications

| Specification | Value |
|---------------|-------|
| **Architecture** | 4-stage pipeline (IF-ID-EX-WB) |
| **Word size** | 27 trits (~42.8 bits equivalent) |
| **Register file** | 9 registers x 27 trits |
| **Instruction memory** | 243 words (3^5) |
| **Data memory** | 729 words (3^6) |
| **Instruction encoding** | 9 trits per instruction |
| **Hazard handling** | Stall + forwarding |
| **ISA** | BTISA v0.1 (26 instructions) |

### 12.2 Cell Library Specifications

| Specification | Value |
|---------------|-------|
| **Technology** | SKY130 (130nm) |
| **Voltage** | 1.8V nominal |
| **Temperature** | -40C to +125C |
| **Encoding** | Voltage-mode (0V, 0.9V, 1.8V) |
| **Cell count** | 12 cells |

---

## Summary

This project has successfully implemented a **complete balanced ternary computing system** from transistor-level SPICE cells to a working 4-stage pipelined CPU with hazard detection, data forwarding, and a comprehensive test suite.

**Key Statistics:**
- 85+ source files (~9,600 lines)
- 12 SPICE cells validated
- 11 RTL modules (496-line CPU core)
- 26-instruction ISA specified
- 62 Python tests (100% pass)
- 80.8% instruction coverage
- 582-line research paper draft

The project is **75% complete** with Phases 1, 2, and 4 finished.

---

*Document generated by project analysis on December 19, 2025*