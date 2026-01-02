
# Repository Analysis — Balanced Ternary CMOS CPU/Toolchain

**Date:** 2025-12-18  
**Scope:** What this repo contains, what it does, and how to run/use it.

---

## 1) What you have built (high-level)

This repository is an end-to-end **balanced ternary computing platform** that spans:

1. **Ternary CMOS cell library (SPICE)** targeting standard CMOS (SKY130-class) voltage-mode ternary.
2. **SystemVerilog RTL models** of balanced ternary arithmetic, an ALU, and a **4-stage pipelined CPU** implementing **BTISA v0.1**.
3. A **BTISA assembler** (Python) and a growing **test program suite**.
4. **Simulation scripts** for Windows/Linux using Icarus Verilog.
5. **FPGA-oriented wrappers** (including a pipelined ALU) and vendor scripts/constraints.
6. Documentation: roadmap, phase reports, and a research-style paper draft.

In practical terms: you can **simulate a ternary CPU** (27-trit datapath, 9-trit instructions) running small programs, measure stalls/forwarding/CPI, and you also have SPICE-validated ternary cells that correspond to the logic primitives used conceptually by the RTL.

---

## 2) Core concepts: how ternary is represented here

### 2.1 Balanced ternary values

Balanced ternary digits (“trits”) are in the set **{-1, 0, +1}**, written in docs and assembly as:

- `-` = -1
- `0` = 0
- `+` = +1

### 2.2 RTL encoding (SystemVerilog)

In RTL the trit type is encoded as a 2-bit enum in:

- `project/hdl/rtl/ternary_pkg.sv`

Encoding:

- `00` = 0 (`T_ZERO`)
- `01` = +1 (`T_POS_ONE`)
- `10` = -1 (`T_NEG_ONE`)
- `11` = invalid (`T_INVALID`)

The package also provides core operations used everywhere:

- `t_neg()` — ternary inversion/negation
- `t_min()`, `t_max()` — ternary MIN/MAX
- `t_add_trit()` — 1-trit add with carry (the basis for adders)
- `bin_to_ternary()`, `ternary_to_bin()` — debug/interop helpers

### 2.3 Circuit-level encoding (SPICE)

At the transistor/SPICE level (GT-LOGIC library), ternary is voltage-mode:

- -1 ↔ 0V (GND)
- 0 ↔ VDD/2 (≈0.9V for VDD=1.8V)
- +1 ↔ VDD (≈1.8V)

This is specified in:

- `project/docs/specs/gt_logic_cells.md`

---

## 3) What subsystems exist (and where)

### 3.1 SPICE: GT-LOGIC ternary CMOS cell library

**Where:**

- Cells: `project/spice/cells/`
- Testbenches: `project/spice/testbenches/`
- Results/logs: `project/spice/results/`

**What’s in it:**

- Inverters: `sti.spice`, `pti.spice`, `nti.spice` (+ an explicit 3-rail version `sti_3rail.spice`)
- Logic: `tmin.spice`, `tmax.spice`, `tnand.spice`, `tnor.spice`, `tmux3.spice`
- Arithmetic: `btha.spice`, `btfa.spice`

The `project/spice/results/` folder already contains CSV/log outputs for many of these benches (DC sweeps, transient, characterization, Monte Carlo).

### 3.2 RTL: balanced ternary arithmetic + ALU

**Where:** `project/hdl/rtl/`

Key modules:

- `btfa.sv` — balanced ternary full adder (wraps `t_add_trit`)
- `ternary_adder.sv` — multi-trit adder built from BTFA
- `ternary_alu.sv` — ternary ALU (add/sub/neg/min/max/shifts/compare)

### 3.3 RTL: BTISA CPU core (pipelined)

**Where:** `project/hdl/rtl/`

Key modules:

- `ternary_cpu.sv` — **4-stage pipeline** (IF → ID → EX → WB)
- `btisa_decoder.sv` — instruction decode and control signals
- `ternary_regfile.sv` — 9 GPRs of 27-trit width
- `ternary_memory.sv` — simple IMEM/DMEM model
- `ternary_hazard_unit.sv` — stall/hazard detection (RAW + load-use)
- `ternary_forward_unit.sv` — forwarding controls to reduce stalls
- `ternary_cpu_system.sv` — intended system top; notes future program-loading hooks

CPU characteristics (from docs/spec + RTL):

- Datapath: **27 trits**
- Instruction width: **9 trits**
- Register file: **9 registers (R0–R8)**
- IMEM depth: **243 instructions** (3^5)
- DMEM depth: **729 words** (3^6)
- Has hazard detection + forwarding; produces perf counters in the testbench

### 3.4 ISA: BTISA v0.1

**Where:** `project/docs/specs/btisa_v01.md`

BTISA defines (26 total) arithmetic, logic, memory, control-flow, and system operations. The repo’s current test suite achieves **80.8% coverage (21/26 instructions)** per `project/docs/PHASE5_READINESS_REPORT.md`.

### 3.5 Tooling: BTISA assembler + test programs

**Where:**

- Assembler: `project/tools/btisa_assembler.py`
- Example programs: `project/tools/programs/`

Important detail: the assembler emits **SystemVerilog `imem[...] = '{ ... }` assignment lines** suitable for pasting into a testbench/initial block.

### 3.6 FPGA prototyping support

**Where:** `project/fpga/`

- Multi-vendor notes and scripts: `project/fpga/MULTI_VENDOR_README.md`
- A pipelined ALU implementation aimed at higher Fmax: `project/fpga/src/` (see `PIPELINE_README.md`)

Note: full Phase 3 synthesis depends on external vendor tools (e.g., Vivado).

### 3.7 Presentation generator

**Where:** `presentation/`

- `presentation/generate_presentation.js` builds a PPTX from HTML slides in `presentation/slides/`.

Important: this script currently references `html2pptx` via a **machine-specific absolute path**; you’ll likely need to adjust that import on other systems.

---

## 4) “What does it do?” (behavioral description)

### 4.1 The CPU

The CPU executes BTISA v0.1 instructions in a 4-stage pipeline. It supports:

- Balanced-ternary arithmetic (ADD/SUB/NEG and immediate forms)
- Tritwise logic via MIN/MAX/XOR and inverter variants
- Loads/stores (word + trit operations)
- Branch instructions (some jump-family instructions are listed as missing from the 80.8% tested set)

The testbench emits per-cycle trace lines like:

```text
[Cycle 12] PC=3 Valid=1 Stall=0 Fwd=1
```

and prints overall metrics at halt (cycles, instruction count, stalls, forwarding events, CPI/IPC).

### 4.2 The SPICE library

The SPICE cells demonstrate ternary logic built with standard CMOS assumptions (multi-Vth + mid-rail encoding). The benches generate CSV outputs (DC transfer curves, etc.), which are already included under `project/spice/results/`.

---

## 5) How to use it (practical quickstart)

### 5.1 Prerequisites

Pick what you want to run:

**For RTL simulation (recommended first):**

- Icarus Verilog with SystemVerilog 2012 support (`iverilog` + `vvp`)

**For assembler and utilities:**

- Python 3

**For SPICE sims:**

- `ngspice` (and optionally Xyce)

**For slides → PPTX:**

- Node.js + npm (see `presentation/package.json`) and fix the `html2pptx` import path if needed

---

## 6) Run the RTL simulations (Windows)

All paths below assume you start at the repository root.

### 6.1 Run the basic unit testbenches (BTFA, adder, ALU)

```powershell
cd project\hdl\sim
run_sim.bat
```

Or a specific one:

```powershell
run_sim.bat btfa
run_sim.bat adder
run_sim.bat alu
```

Outputs are saved under:

- `project/hdl/sim/output/`

### 6.2 Run the CPU testbench

```powershell
cd project\hdl\sim
run_cpu_sim.bat
```

This builds and runs `tb_ternary_cpu.sv` against the CPU RTL.

---

## 7) Run the RTL simulations (Linux/macOS)

There’s also a shell script:

```bash
cd project/hdl/sim
./run_sim.sh
```

(CPU simulation on *nix can be run by invoking the same `iverilog` command used by the `.bat` script, or by writing a small shell wrapper analogous to `run_cpu_sim.bat`.)

---

## 8) Assemble and run your own BTISA program

### 8.1 Choose a program

Example programs are in:

- `project/tools/programs/`

Files ending in `.btasm` are BTISA assembly examples.

### 8.2 Assemble it

From repo root:

```powershell
python project\tools\btisa_assembler.py project\tools\programs\test_arithmetic.btasm -o out.mem
```

The output is **not** a binary image; it is a text file that includes:

- A human-readable list of encodings
- A **SystemVerilog initialization snippet** like:

```systemverilog
imem[0] = '{ T_ZERO, T_ZERO, /* ... */ };
imem[1] = '{ /* ... */ };
```

### 8.3 Load it into simulation

Current default CPU testbench (`project/hdl/tb/tb_ternary_cpu.sv`) loads a small demo program by directly assigning `imem[...]` in an `initial` block.

To run one of the assembled `.btasm` programs:

1. Generate the `.mem` output with the assembler.
2. Open `project/hdl/tb/tb_ternary_cpu.sv`.
3. Replace the existing `imem[...] = ...` assignments in the “Loading Test Program” section with the generated lines.
4. Run `project/hdl/sim/run_cpu_sim.bat` again.

This is intentionally simple and simulator-friendly; if you want true “loadmem from file”, you can extend the bench to parse the assembler output or introduce a separate memory init format.

---

## 9) Performance analysis

The CPU testbench prints per-cycle trace lines and summary metrics.

To capture a log and compute CPI automatically:

1. Run simulation and capture output:

```powershell
cd project\hdl\sim
run_cpu_sim.bat > output\cpu_test.log
```

1. Analyze:

```powershell
powershell -ExecutionPolicy Bypass -File ..\..\tools\scripts\analyze_performance.ps1 -LogFile output\cpu_test.log
```

---

## 10) Run SPICE characterization

Example (ngspice):

```bash
cd project/spice/testbenches
ngspice tb_sti.spice
ngspice tb_inverters.spice
ngspice characterize_sti.spice
ngspice monte_carlo_sti.spice
```

Many expected outputs already exist in `project/spice/results/` (CSV + log).

---

## 11) Repository structure (what each top-level folder is for)

- `project/`
  - `hdl/` — RTL + testbenches + simulation scripts
  - `spice/` — ternary CMOS cells + benches + results
  - `tools/` — assembler, scripts, example programs
  - `docs/` — phase reports, ISA spec, roadmap, proposals
  - `fpga/` — FPGA wrappers + build scripts for multiple vendors
  - `asic/` — placeholders for ASIC deliverables (lef/gds/lib/scripts)

- `presentation/` — HTML slides + PPTX generator
- `agents/`, `teams/`, `expansion-packs/` — BMad workflow/agent scaffolding used to generate/manage docs and execution plans

---

## 12) Project status (as of 2025-12-18)

From `project/docs/PHASE5_READINESS_REPORT.md` and other phase summaries:

- **Phase 1 (SPICE cells):** complete at the design/bench level; results committed
- **Phase 2 (RTL flow/modules):** complete; BTFA exhaustive test exists
- **Phase 3 (FPGA synthesis):** **blocked externally** (needs vendor tools like Vivado)
- **Phase 4 (CPU core):** complete with hazards + forwarding integrated
- **Phase 5 readiness tasks:** complete for tests/profiling/stress tests; branch prediction is a documented proposal

Test coverage is reported as **80.8% (21/26 instructions)**, with some jump/system instructions not yet covered.

---

## 13) Known sharp edges / “gotchas”

1. **Assembler output is SV init code**, not a raw memory image. This is by design, but it means loading programs is currently “paste into testbench”.
2. **Presentation generator has a machine-specific path** to `html2pptx`. Plan to edit `presentation/generate_presentation.js` before running elsewhere.
3. **FPGA builds require external vendor tools**; the repo includes scripts/constraints but can’t run synthesis without them.

---

## 14) Suggested next improvements (optional)

If you want to make this feel “productized” without changing the architecture:

- Add a stable memory init format (e.g., a simple text list of 9-trit strings) and teach the testbench to load it.
- Add a top-level CPU simulation script that runs the assembler, loads IMEM/DMEM, then invokes `iverilog` + `vvp`.
- Implement + test remaining BTISA instructions to reach 100% coverage.

---

## 15) Key files to start with

- ISA spec: `project/docs/specs/btisa_v01.md`
- CPU core: `project/hdl/rtl/ternary_cpu.sv`
- CPU testbench: `project/hdl/tb/tb_ternary_cpu.sv`
- CPU sim script (Windows): `project/hdl/sim/run_cpu_sim.bat`
- Assembler: `project/tools/btisa_assembler.py`
- GT-LOGIC cell spec: `project/docs/specs/gt_logic_cells.md`

---

If you want, tell me whether your primary goal is **(1) CPU program execution** or **(2) SPICE cell validation**, and I can tighten the instructions in this doc to match your exact workflow (and optionally add a single “one-command run” script).

