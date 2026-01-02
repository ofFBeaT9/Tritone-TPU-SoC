# Getting Started: Ternary CMOS CPU Project

**Quick-start guide for setting up and running the project on a fresh machine.**

---

## Prerequisites

### Required Tools

| Tool | Version | Purpose | Download |
|------|---------|---------|----------|
| **Python 3** | 3.8+ | BTISA assembler, analysis scripts | [python.org](https://python.org) |
| **Icarus Verilog** | 12.0+ | RTL simulation | [iverilog.icarus.com](http://iverilog.icarus.com/) |
| **ngspice** | 42+ | SPICE simulation | [ngspice.sourceforge.io](http://ngspice.sourceforge.io/) |
| **Node.js** | 18+ | Presentation generator (optional) | [nodejs.org](https://nodejs.org) |

### Optional Tools (for FPGA/ASIC)

| Tool | Purpose | Notes |
|------|---------|-------|
| **Vivado** | Xilinx FPGA synthesis | Phase 3 synthesis |
| **Quartus** | Intel FPGA synthesis | Alternative to Vivado |
| **OpenLane** | ASIC flow | Phase 6 (future) |

---

## Installation Steps (Windows)

### 1. Clone/Download the Repository

```powershell
# The project should be in a folder like: E:\ternary cmos compile\
```

### 2. Verify Python

```powershell
python --version
# Should show Python 3.8 or higher
```

### 3. Install Icarus Verilog

Download from: http://bleyer.org/icarus/

Add to PATH after installation:
```powershell
# Verify installation
iverilog -v
```

### 4. Install ngspice (for SPICE simulations)

Download from: http://ngspice.sourceforge.io/download.html

The project includes a bundled version at `project/Spice64/` which can be used directly.

### 5. Install Node.js (for presentation generator - optional)

```powershell
# After installing Node.js
cd presentation
npm install
```

---

## Quick Start Commands

### Run CPU Simulation

```powershell
cd project\hdl\sim
.\run_cpu_sim.bat
```

Or manually:
```powershell
cd project\hdl
iverilog -g2012 -o tb_cpu.vvp `
    rtl\ternary_pkg.sv `
    rtl\btfa.sv `
    rtl\ternary_adder.sv `
    rtl\ternary_alu.sv `
    rtl\ternary_regfile.sv `
    rtl\btisa_decoder.sv `
    rtl\ternary_hazard_unit.sv `
    rtl\ternary_forward_unit.sv `
    rtl\ternary_memory.sv `
    rtl\ternary_cpu.sv `
    rtl\ternary_cpu_system.sv `
    tb\tb_ternary_cpu.sv

vvp tb_cpu.vvp
```

### Assemble a Program

```powershell
cd project\tools
python btisa_assembler.py programs\test_arithmetic.btasm -o output.mem
```

### Run SPICE Simulations

```powershell
cd project\spice
..\Spice64\bin\ngspice.exe testbenches\tb_tnand.sp
```

### Generate Presentation (optional)

```powershell
cd presentation
npm install
node generate_presentation.js
```

The presentation generator creates a PowerPoint from HTML slides. Dependencies:
- **pptxgenjs**: PowerPoint generation library
- **playwright**: Headless browser for HTML rendering
- **sharp**: Image processing

---

## SKY130 PDK Setup (for SPICE with Real Models)

The project includes simplified SPICE models in `project/spice/models/sky130_models.spice` that work standalone. For full PDK support:

### Option 1: Use Bundled Models (Recommended for Quick Start)

The bundled models are already configured and require no additional setup.

### Option 2: Use Bundled ngspice SKY130 Examples

The bundled ngspice at `project/Spice64/` includes SKY130 examples:

```
project/Spice64/examples/SkywaterOpenSourcePDK/
├── readme.txt                  # Setup instructions
├── skywater_inverter.net       # Simple inverter example
└── c7552_ann_skywater.net      # Large benchmark (15k transistors)
```

To run the example (after installing full PDK):

```powershell
cd project\Spice64\examples\SkywaterOpenSourcePDK
# Edit skywater_inverter.net to set your PDK path
..\..\..\bin\ngspice.exe skywater_inverter.net
```

**Recommended ngspice settings** (add to `.spiceinit` in your HOME directory):

```spice
set num_threads=8           ; number of CPU cores
set ngbehavior=hsa          ; compatibility for PDK libs
set skywaterpdk             ; faster lib loading
set ng_nomodcheck           ; skip model param checks
option KLU                  ; use KLU solver (faster)
```

### Option 3: Full SKY130 PDK Installation

If you need the complete PDK with all corners and process data:

1. **Install the PDK** (requires ~8GB disk space):

```powershell
# Clone the open_pdks repository
git clone https://github.com/RTimothyEdwards/open_pdks
cd open_pdks

# Or use volare for easier management:
pip install volare
volare enable --pdk sky130 sky130A
```

2. **Set Environment Variables**:

```powershell
$env:PDK_ROOT = "C:\path\to\pdk"
$env:PDK = "sky130A"
```

3. **Update SPICE Include Paths** in testbenches:

```spice
* Replace bundled model include:
.include ../models/sky130_models.spice

* With PDK path (use the combined libs.tech path):
.lib D:\path\to\open_pdks\sky130\sky130A\libs.tech\combined\sky130.lib.spice tt
```

### Corner Simulations

For multi-corner analysis (TT/SS/FF), modify the `.lib` statement:

```spice
.lib $PDK_ROOT/$PDK/libs.tech/ngspice/sky130.lib.spice ss  ; Slow-Slow
.lib $PDK_ROOT/$PDK/libs.tech/ngspice/sky130.lib.spice ff  ; Fast-Fast
```

---

## Project Structure

```
project/
├── hdl/                    # Hardware description (SystemVerilog)
│   ├── rtl/               # Synthesizable RTL modules
│   ├── tb/                # Testbenches
│   └── sim/               # Simulation scripts and outputs
├── spice/                  # SPICE cell library
│   ├── cells/             # Cell definitions
│   ├── testbenches/       # Cell test circuits
│   └── results/           # Simulation results
├── fpga/                   # FPGA-specific files
│   ├── src/               # FPGA wrappers and testbenches
│   ├── constraints/       # Timing constraints (XDC)
│   └── scripts/           # Build scripts (TCL)
├── tools/                  # Utilities
│   ├── btisa_assembler.py # Assembly language assembler
│   └── programs/          # Test programs (.btasm)
├── docs/                   # Documentation
│   ├── specs/             # ISA specification
│   └── qa/                # QA reports and gates
└── asic/                   # ASIC flow files (future)
```

---

## Running Test Programs

The project includes comprehensive test programs in `project/tools/programs/`:

| Test File | Coverage |
|-----------|----------|
| `test_arithmetic.btasm` | ADD, SUB, NEG, MUL |
| `test_logical.btasm` | MIN, MAX, XOR, INV |
| `test_shift.btasm` | SHL, SHR |
| `test_control_flow.btasm` | BEQ, BNE, BEQZ, BNEZ |
| `test_jumps.btasm` | JAL, JR, function calls |
| `test_data_movement.btasm` | LDI, MOV, LDT, STT |
| `test_hazards.btasm` | Pipeline hazard scenarios |
| `test_memory_edge_cases.btasm` | Memory corner cases |
| `test_system_ops.btasm` | NOP, HALT |
| `test_invalid_encodings.btasm` | Edge cases, boundary conditions |

### Quick Test (One Command)

Use the integrated test runner for end-to-end testing:

```powershell
cd project\tools\scripts

# List available programs
.\run_test.ps1 -ListPrograms

# Run a specific test with performance metrics
.\run_test.ps1 -Program test_arithmetic

# Run with detailed output
.\run_test.ps1 -Program test_hazards -ShowDetails
```

### Batch Operations

```powershell
# Assemble all programs to memory init files
.\batch_assemble.ps1

# Run CI smoke test (validates all programs + RTL compile)
.\ci_smoke_test.ps1
```

### Manual Test Process

1. Assemble the test program:

```powershell
python btisa_assembler.py programs\test_hazards.btasm
```

2. Copy the generated memory initialization into `tb_ternary_cpu.sv`

3. Run simulation:
```powershell
cd ..\hdl\sim
.\run_cpu_sim.bat
```

---

## Troubleshooting

### "iverilog not found"
- Ensure Icarus Verilog is in your PATH
- Try: `$env:PATH += ";C:\iverilog\bin"`

### "python not found"
- Ensure Python 3 is installed and in PATH
- On Windows, try `py` instead of `python`

### Simulation Hangs
- Check if HALT instruction is present in the test program
- Look for infinite loops in branch targets

### SPICE Model Errors
- Verify SKY130 PDK paths if using external models
- Use bundled `project/Spice64/` for built-in models

---

## Next Steps

1. **Explore the ISA**: Read `docs/specs/btisa_v01.md`
2. **Run CPU tests**: Use the simulation scripts
3. **Write your own programs**: Create `.btasm` files and assemble
4. **Synthesize for FPGA**: (When Vivado available) Use `fpga/scripts/build.tcl`

---

## Contact / Issues

For questions about the project structure or implementation, refer to:
- `docs/MASTER_REMAINING_WORK.md` - Current project status
- `docs/IMPLEMENTATION_ROADMAP.md` - Completed milestones
- `docs/qa/QA_STATUS_SUMMARY.md` - Quality assurance status

---

**Last Updated**: 2025-12-19
