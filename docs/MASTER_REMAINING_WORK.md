# Master Remaining Work Checklist (Roadmap vs Repo State)

**Generated:** 2025-12-19 (Updated)  
**Goal:** One place that lists *everything still missing / recommended* to finish the roadmap end-to-end.

This repo already contains substantial completed work (Phase 1/2/4 core deliverables, many Phase 5 readiness items). The remaining work is mostly: **FPGA synthesis closure (tool-dependent)**, **closing ISA instruction gaps + tests**, **benchmarks/publication polish**, and (optional) **ASIC enablement + sequential cell work**.

**Update 2025-12-19:** Pre-Vivado tasks completed:
- ✅ Test programs for jumps, system ops, memory edge cases added
- ✅ Documentation synchronized (PHASE4_TODO_CHECKLIST, QA_STATUS_SUMMARY)
- ✅ Presentation generator fixed (removed absolute path dependency)
- ✅ GETTING_STARTED.md reproducibility guide created
- ✅ Assembler enhanced with pseudo-instructions (LDI, MOV, BEQZ, BNEZ, JMP, RET, FENCE)
- ✅ All 12 test programs verified to assemble correctly

---

## 0) Current Stage (High-Level)

- ✅ Phase 1 SPICE cell library + benches + results exist (`prthioject/spice/`).
- ✅ Phase 2 RTL package + ALU + synthesis tooling exist (`project/hdl/rtl/`, `project/tools/synthesis/`).
- 🟡 Phase 3 FPGA ALU wrapper is designed, but **bitstreams/metrics are missing** (blocked on FPGA tools).
- ✅ Phase 4 CPU pipeline + hazards/forwarding + multi-program tests exist.
- 🟡 Phase 5 readiness tasks are largely done (coverage expanded to ~80%+ per docs), but publication-grade benchmarking still needs to be *run and recorded*.
- ☐ Phase 6 ASIC tapeout flow is not executed in-repo (ASIC folders are mostly placeholders).

---

## 1) “Must-Do” Items (If your end goal is FPGA prototype + paper)

### 1.1 Complete Phase 3 FPGA Synthesis + Reports (External Tool Dependency)

- [ ] Install and configure FPGA toolchain (Vivado for Xilinx; optionally Quartus/Lattice if targeting those flows).
- [ ] Run synthesis + implementation for the ALU top:
  - [ ] Generate timing/utilization/power reports.
  - [ ] Generate bitstream(s) in `project/fpga/bitstreams/`.
- [ ] Validate the design beyond “structural compile”:
  - [ ] Run FPGA-simulator-level tests (Vivado xsim or your simulator).
  - [ ] Confirm constraints are accepted and timing is met at the chosen clock.
- [ ] Create **Phase 3 validation report** (currently absent as a file in `project/docs/`).

### 1.2 Close Remaining BTISA Instruction Gaps (Coverage → 95%+)

- [x] ✅ Create test programs for remaining uncovered instructions (2025-12-19)
  - [x] Jumps: `JMP`, `JAL`, `JR` → `test_jumps.btasm` created
  - [x] System: `NOP`, `FENCE` → `test_system_ops.btasm` created
- [x] ✅ Add focused test programs in `project/tools/programs/` for:
  - [x] Jump/return semantics (including register writeback for link)
  - [x] PC/flush correctness on control transfers
  - [x] Pipeline corner cases (back-to-back jumps, jump-after-load, etc.)
  - [x] Memory edge cases → `test_memory_edge_cases.btasm` created

### 1.3 Run Benchmarks and Record Results (Paper-Ready)

- [ ] Run and capture a **repeatable performance baseline**:
  - [ ] CPI/IPC from simulation logs (use `project/tools/scripts/analyze_performance.ps1`).
  - [ ] Stall/forwarding rates on representative programs.
- [ ] Fill benchmark tables in the publication docs with *measured* values:
  - [ ] Instruction coverage table.
  - [ ] CPI baselines (with/without branch prediction if implemented).
  - [ ] FPGA utilization/fmax/power (once Phase 3 synthesis is done).

### 1.4 Reproducibility / “Fresh Machine” Setup (Final Polish)

Even if the design is complete, the last-mile work for a real handoff is making the repo reproducible.

- [x] ✅ Document and verify tool prerequisites on Windows (2025-12-19):
  - [x] Python 3 (assembler/tools)
  - [x] Icarus Verilog or alternative simulator (RTL)
  - [x] ngspice/Xyce (SPICE)
  - [x] Node.js (presentation generator)
  - [x] FPGA tools (Vivado/Quartus/Radiant as applicable)
- [x] ✅ Created `GETTING_STARTED.md` quick-start guide
- [x] ✅ Document how to obtain/setup SKY130 PDK (2025-12-19)
  - [x] Bundled models work standalone
  - [x] Full PDK installation instructions in GETTING_STARTED.md
  - [x] Multi-corner simulation guidance

---

## 2) Phase-by-Phase Remaining Work (Detailed)

## Phase 1 (SPICE / Cell Library)

### 2.1 Optional but Valuable: Sequential Ternary Cells (Not Present in `project/spice/cells/`)

These are listed as Priority-2 in the cell spec but do not exist as SPICE cells in the current folder listing.

- [ ] Design + implement ternary sequential elements:
  - [ ] `TDFF` (edge-triggered)
  - [ ] `TLATCH` (level-sensitive)
  - [ ] `TSRFF` (set/reset)
- [ ] Add benches for functional verification + timing/power characterization.

### 2.2 Characterization/Library Hardening (ASIC-Useful Quality)

- [ ] Verify the Liberty (`project/asic/lib/gt_logic_ternary.lib`) is complete/consistent.
- [ ] Generate multi-corner libraries (TT/SS/FF, voltage/temp corners) if targeting ASIC flow.
- [ ] Generate/validate LEF abstracts (currently `project/asic/lef/` is empty).

---

## Phase 2 (RTL Synthesis Flow)

### 2.3 Optional: Improve Simulator Compatibility + Standalone Unit TBs

- [ ] Make `tb_ternary_adder.sv` and `tb_ternary_alu.sv` fully compatible with your chosen simulator.
  - [ ] If staying on Icarus: refactor advanced SV constructs that Icarus struggles with.
  - [ ] Alternative: validate with Verilator/Questa and document the supported tool versions.

---

## Phase 3 (FPGA ALU Prototype)

### 2.4 Correctness Testbench Improvements (Recommended)

- [x] ✅ FPGA testbenches already have assertions (verified 2025-12-19):
  - [x] `ternary_alu_tb.sv` - Has expected value verification
  - [x] `ternary_alu_pipelined_tb.sv` - Has expected value verification
  - [x] Both have `assert`/fail checks on mismatch
  - [x] Both have waveform dump option (`$dumpfile/$dumpvars`)

### 2.5 Synthesis/Implementation Closure

- [ ] Produce outputs under `project/fpga/bitstreams/`:
  - [ ] `ternary_alu.bit` (and/or pipelined variant if that is the preferred top).
- [ ] Capture reports:
  - [ ] Timing summary (fmax)
  - [ ] Utilization (LUTs/FFs/BRAM/DSP)
  - [ ] Power estimate

### 2.6 Phase 3 Documentation Completion

- [ ] Add `project/docs/PHASE3_VALIDATION_REPORT.md` (or equivalent) including:
  - [ ] Tool versions, part number, constraints used.
  - [ ] Report excerpts and key metrics.
  - [ ] Known issues + next steps.

---

## Phase 4 (CPU Core)

### 2.7 Resolve “Docs vs Reality” Inconsistencies

Some Phase 4 docs still say hazards/forwarding are missing, but Phase 4 completion/validation artifacts indicate they are implemented.

- [x] ✅ Update/align the following so they all reflect the same truth (2025-12-19):
  - [x] `project/docs/PHASE4_TODO_CHECKLIST.md` - Updated to show hazards/forwarding complete
  - [x] `project/docs/qa/QA_STATUS_SUMMARY.md` - Updated Phase 4 to 100% complete
  - [x] `project/docs/qa/gates/phase4-cpu-core.yml` - Already shows PASS status

### 2.8 Increase Functional Coverage and Robustness

- [x] ✅ Add tests for (2025-12-19):
  - [x] Jumps and returns (JMP/JAL/JR) → `test_jumps.btasm`
  - [x] System ops (NOP/FENCE semantics) → `test_system_ops.btasm`
  - [x] Memory corner cases (aliasing, same-address store/load ordering) → `test_memory_edge_cases.btasm`
  - [x] Branch corner cases (taken/not-taken with hazards) → `test_control_flow.btasm`
- [x] ✅ Add negative tests (edge cases/boundary conditions) → `test_invalid_encodings.btasm` (2025-12-19)
  - [x] Zero register write attempts (should be ignored)
  - [x] Self-referential operations (R2 = R2 + R2)
  - [x] Max/min immediate values (+4, -4)
  - [x] Back-to-back NOPs, consecutive branches, jump-after-load

---

## Phase 5 (Publication + Documentation)

### 2.9 Paper/Benchmarks Completion

- [ ] Ensure the paper draft has final, reproducible numbers:
  - [ ] Instruction coverage (target ≥95% if possible)
  - [ ] CPI/IPC on a representative set of programs
  - [ ] FPGA metrics once Phase 3 synthesis completes

### 2.10 Presentation Generator Portability Fix

`presentation/generate_presentation.js` currently imports `html2pptx` from a machine-specific absolute path.

- [x] ✅ Replace the absolute import with a repo/local dependency path (2025-12-19)
- [x] ✅ Added inline html2pptx implementation that works on any machine
- [x] ✅ Document how to install dependencies and generate PPTX (2025-12-19)
  - [x] Dependencies documented in GETTING_STARTED.md (pptxgenjs, playwright, sharp)
  - [x] `npm install && node generate_presentation.js` workflow documented

---

## Phase 6 (ASIC Fabrication) — Optional / Not Yet Executed Here

If you want an ASIC tapeout path, you still need the full ASIC enablement work:

- [ ] Decide the ASIC flow (OpenLane/OpenROAD, commercial EDA, etc.).
- [ ] Create a synthesizable top and constraints for standard-cell synthesis.
- [ ] Provide complete PDK integration + cell views:
  - [ ] Liberty timing (multi-corner), LEF, SPICE, (optionally) GDS
  - [ ] Verify `project/asic/lef/` and `project/asic/gds/` contents are generated
- [ ] Roadmap-specific OpenLane artifacts (explicitly referenced in the roadmap, currently absent in-repo):
  - [ ] `project/asic/openlane/config.json`
  - [ ] `project/asic/lef/gt_logic_cells.lef`
  - [ ] `project/asic/gds/gt_logic_cells.gds`
- [ ] Run the ASIC flow end-to-end:
  - [ ] Synthesis → floorplan → place/route → CTS → signoff
  - [ ] DRC/LVS checks
  - [ ] Timing signoff and (optional) power analysis

---

## 3) Tooling/UX Improvements (Not Required, but High Leverage)

- [x] ✅ One-command "assemble + run CPU sim" script (2025-12-19):
  - [x] `run_test.ps1` - Assembles and runs any `.btasm` file
  - [x] Automatically generates testbench with program loaded
  - [x] Runs sim and drops logs into `hdl/sim/output/`
  - [x] Includes performance analysis (CPI/IPC/stalls)

- [x] ✅ Standardize memory init format (2025-12-19):
  - [x] `batch_assemble.ps1` - Generates both `.mem` and `.sv` formats
  - [x] Memory init files output to `hdl/sim/programs/`
  - [x] SV snippet format retained for manual testbench use

- [x] ✅ CI-ish smoke checks (2025-12-19):
  - [x] `ci_smoke_test.ps1` - Validates all programs assemble
  - [x] Compiles key SV targets (pkg, ALU, full CPU)
  - [x] Runs simulation and checks for PASS/FAIL
  - [x] Reports summary with pass/fail/skip counts

---

## 4) External Dependencies / Blockers

- **FPGA synthesis:** requires vendor tools (Vivado for Xilinx; optional Quartus/Lattice flows exist but also require their tools).
- **ASIC flow:** requires a full EDA flow setup and (likely) SKY130/OpenLane integration if you want to execute it locally.
