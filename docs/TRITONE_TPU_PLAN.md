# Tritone Hybrid SoC: Ternary CPU + TPU Accelerator

## Project Overview

**Goal:** Design a complete balanced-ternary System-on-Chip combining:
1. **Tritone CPU** - Existing 4-stage dual-issue processor (proven)
2. **Tritone TPU** - Novel ternary neural network accelerator (new)
3. **Unified Memory System** - Shared SRAM hierarchy
4. **On-chip Interconnect** - CPU↔TPU communication

**Target:** ASAP7 7nm FinFET ASIC (same flow as current Tritone CPU)
**Application:** Ternary Neural Network (TNN) inference at the edge

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    TRITONE HYBRID SoC                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐     ┌──────────────────────────────────────┐  │
│  │ TRITONE CPU │     │         TRITONE TPU                   │  │
│  │ (4-stage    │     │  ┌────────────────────────────────┐  │  │
│  │  dual-issue)│     │  │    64×64 Ternary Systolic     │  │  │
│  │             │◄───►│  │         Array                   │  │  │
│  │ 9 regs×27t  │ AXI │  │    (4,096 Ternary MACs)        │  │  │
│  │ BTISA v0.2  │     │  └────────────────────────────────┘  │  │
│  └──────┬──────┘     │  ┌─────────┐ ┌─────────┐ ┌────────┐  │  │
│         │            │  │ Weight  │ │Activation│ │ Accum  │  │  │
│         │            │  │ Buffer  │ │ Buffer   │ │ Buffer │  │  │
│         │            │  │ 16KB    │ │ 8KB      │ │ 4KB    │  │  │
│         │            │  └─────────┘ └─────────┘ └────────┘  │  │
│         │            └──────────────────┬───────────────────┘  │
│         │                               │                       │
│  ┌──────┴───────────────────────────────┴────────────────────┐ │
│  │              UNIFIED MEMORY CONTROLLER                     │ │
│  │         (Arbitration + Address Mapping)                    │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │                                   │
│  ┌──────────────────────────┴────────────────────────────────┐ │
│  │                    SHARED SRAM                             │ │
│  │    IMEM: 2KB (512×27t)  │  DMEM: 8KB (2048×27t)           │ │
│  │    Weight SRAM: 64KB    │  Activation SRAM: 32KB          │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Ternary MAC Unit Design (Foundation)

### 1.1 Ternary MAC Architecture

**Key Insight:** Ternary weights {-1, 0, +1} eliminate multiplication!

```
Standard MAC:  output = input × weight + accumulator  (needs multiplier)
Ternary MAC:   output = mux(weight, {-input, 0, +input}) + accumulator
```

**Design:**
```systemverilog
// Ternary MAC Unit - replaces multiplier with 3-to-1 mux
module ternary_mac #(
    parameter ACT_WIDTH = 8,    // 8-trit activations
    parameter ACC_WIDTH = 27    // 27-trit accumulator
)(
    input  logic clk, rst_n, enable,
    input  logic [2*ACT_WIDTH-1:0] activation,  // 8-trit (16-bit encoded)
    input  logic [1:0] weight,                   // {-1,0,+1} as 2-bit
    input  logic [2*ACC_WIDTH-1:0] acc_in,
    output logic [2*ACC_WIDTH-1:0] acc_out,
    output logic zero_skip                       // High if weight=0
);
```

**Zero-Skipping:** When weight=0, skip entire MAC operation (power savings)

### 1.2 Files to Create

| File | Description | Est. Lines |
|------|-------------|-----------|
| `hdl/rtl/tpu/ternary_mac.sv` | Single MAC unit | 80-120 |
| `hdl/rtl/tpu/ternary_mac_array.sv` | 1D array of MACs | 100-150 |
| `hdl/tb/tb_ternary_mac.sv` | MAC unit testbench | 150-200 |

---

## Phase 2: Systolic Array Design

### 2.1 Architecture: Weight-Stationary Systolic Array

**Data Flow:**
- **Weights:** Loaded once per layer, stay in place (stationary)
- **Activations:** Flow horizontally (west→east)
- **Partial Sums:** Flow vertically (north→south)

```
        Activations →
        ┌────┬────┬────┬────┐
      ↓ │PE  │PE  │PE  │PE  │ ↓
Weights │00  │01  │02  │03  │ Partial
      ↓ ├────┼────┼────┼────┤ Sums
        │PE  │PE  │PE  │PE  │ ↓
        │10  │11  │12  │13  │
        ├────┼────┼────┼────┤
        │PE  │PE  │PE  │PE  │
        │20  │21  │22  │23  │
        └────┴────┴────┴────┘
```

### 2.2 Processing Element (PE)

```systemverilog
module ternary_pe #(
    parameter ACT_WIDTH = 8,
    parameter ACC_WIDTH = 27
)(
    input  logic clk, rst_n,
    // Data inputs
    input  logic [2*ACT_WIDTH-1:0] act_in,      // From west
    input  logic [2*ACC_WIDTH-1:0] psum_in,     // From north
    // Weight (stationary)
    input  logic [1:0] weight,
    input  logic weight_load,
    // Data outputs
    output logic [2*ACT_WIDTH-1:0] act_out,     // To east
    output logic [2*ACC_WIDTH-1:0] psum_out     // To south
);
```

### 2.3 Array Configurations

| Config | Array Size | MACs/cycle | Est. Area | Use Case |
|--------|------------|------------|-----------|----------|
| Small | 8×8 | 64 | ~500 µm² | Proof of concept |
| Medium | 32×32 | 1,024 | ~8,000 µm² | Small CNNs |
| **Full** | **64×64** | **4,096** | **~32,000 µm²** | Production TNN |

### 2.4 Files to Create

| File | Description | Est. Lines |
|------|-------------|-----------|
| `hdl/rtl/tpu/ternary_pe.sv` | Processing Element | 100-150 |
| `hdl/rtl/tpu/ternary_systolic_array.sv` | NxN array wrapper | 200-300 |
| `hdl/rtl/tpu/ternary_systolic_controller.sv` | Array control FSM | 250-350 |
| `hdl/tb/tb_ternary_systolic.sv` | Systolic array testbench | 300-400 |

---

## Phase 3: Memory Hierarchy

### 3.1 Buffer Architecture

**Weight Buffer (16KB):**
- Stores ternary weights for current layer
- 2-bit encoding: 64K weights capacity
- Double-buffered: Load next layer while computing

**Activation Buffer (8KB):**
- Input activations (8-trit = 16-bit each)
- 4K activation vectors
- Ping-pong buffering for streaming

**Accumulator Buffer (4KB):**
- 32-bit accumulators for partial sums
- 1K accumulator entries
- Supports saturation arithmetic

### 3.2 Memory Controller

```systemverilog
module tpu_memory_controller (
    // CPU interface (AXI-Lite style)
    input  logic [31:0] cpu_addr,
    input  logic [53:0] cpu_wdata,  // 27-trit
    output logic [53:0] cpu_rdata,
    input  logic cpu_wen, cpu_ren,
    output logic cpu_ready,

    // Systolic array interface
    output logic [127:0] weight_row,      // 64 weights (2-bit each)
    output logic [1023:0] activation_col, // 64 activations (16-bit each)
    input  logic [2047:0] psum_col,       // 64 partial sums (32-bit each)

    // SRAM interfaces
    // ... weight SRAM, activation SRAM, accumulator SRAM
);
```

### 3.3 Files to Create

| File | Description | Est. Lines |
|------|-------------|-----------|
| `hdl/rtl/tpu/tpu_weight_buffer.sv` | Weight SRAM + control | 150-200 |
| `hdl/rtl/tpu/tpu_activation_buffer.sv` | Activation SRAM + control | 150-200 |
| `hdl/rtl/tpu/tpu_accumulator.sv` | Accumulator array | 100-150 |
| `hdl/rtl/tpu/tpu_memory_controller.sv` | Unified memory control | 300-400 |

---

## Phase 4: CPU-TPU Integration

### 4.1 Interface Design

**Communication Model:** Memory-mapped I/O
- CPU writes commands to TPU control registers
- CPU loads weights/activations to shared SRAM
- TPU signals completion via interrupt or polling

**Register Map:**
| Address | Register | Description |
|---------|----------|-------------|
| 0x000 | TPU_CTRL | Start/stop, mode select |
| 0x004 | TPU_STATUS | Busy, done, error flags |
| 0x008 | WEIGHT_ADDR | Base address for weights |
| 0x00C | ACT_ADDR | Base address for activations |
| 0x010 | OUT_ADDR | Base address for outputs |
| 0x014 | LAYER_CFG | Rows, cols, stride config |

### 4.2 Execution Flow

```
1. CPU: Load weights to WEIGHT_SRAM via memory-mapped writes
2. CPU: Load activations to ACT_SRAM
3. CPU: Configure LAYER_CFG (dimensions)
4. CPU: Write 1 to TPU_CTRL[0] (start)
5. TPU: Execute matrix multiply on systolic array
6. TPU: Write results to OUT_SRAM
7. TPU: Set TPU_STATUS[0] (done)
8. CPU: Read results from OUT_SRAM
```

### 4.3 Files to Create/Modify

| File | Description | Est. Lines |
|------|-------------|-----------|
| `hdl/rtl/tpu/tpu_top.sv` | TPU top-level wrapper | 300-400 |
| `hdl/rtl/tpu/tpu_register_file.sv` | Control/status registers | 150-200 |
| `hdl/rtl/soc/tritone_soc.sv` | **NEW** SoC top integrating CPU+TPU | 400-500 |
| `hdl/rtl/soc/memory_arbiter.sv` | **NEW** Shared memory arbitration | 200-300 |
| `hdl/rtl/ternary_cpu.sv` | **MODIFY** Add TPU interface | +50-100 |

---

## Phase 4.5: BTISA TPU Instructions

### Custom Instructions for Tight CPU-TPU Integration

In addition to memory-mapped I/O, custom BTISA instructions enable low-latency TPU control:

| Opcode | Mnemonic | Format | Description |
|--------|----------|--------|-------------|
| TBD | `TPULD` | R-type | Load from CPU register to TPU buffer |
| TBD | `TPUST` | R-type | Store from TPU buffer to CPU register |
| TBD | `TPUEXEC` | I-type | Execute TPU operation (imm=layer config) |
| TBD | `TPUWAIT` | - | Poll/wait for TPU completion |

### Files to Modify

| File | Change |
|------|--------|
| `hdl/rtl/btisa_decoder.sv` | Add TPU opcode decoding |
| `hdl/rtl/ternary_cpu.sv` | Add TPU interface signals |
| `docs/specs/btisa_v01.md` | Document new instructions |

### Usage Example (BTISA Assembly)
```asm
; Load weights and execute TPU layer
TPULD  r1, r2      ; Load weights from r1 to TPU weight buffer
TPULD  r3, r4      ; Load activations from r3 to TPU activation buffer
TPUEXEC 0x0808     ; Execute 8x8 matrix multiply
TPUWAIT            ; Wait for completion
TPUST  r5, r6      ; Store results to r5
```

---

## Phase 5: Verification

### 5.1 Unit Tests

| Test | Coverage |
|------|----------|
| `tb_ternary_mac.sv` | MAC unit: all weight values, overflow |
| `tb_ternary_pe.sv` | PE: data flow, weight loading |
| `tb_ternary_systolic.sv` | Array: 4×4 matrix multiply |
| `tb_tpu_memory.sv` | Memory: read/write, buffering |

### 5.2 Integration Tests

| Test | Coverage |
|------|----------|
| `tb_tpu_top.sv` | Full TPU: layer execution |
| `tb_tritone_soc.sv` | SoC: CPU controlling TPU |
| `tb_tnn_inference.sv` | End-to-end: small CNN inference |

### 5.3 Reference Model

Create Python/C++ golden model for:
- Matrix multiply with ternary weights
- Layer-by-layer CNN execution
- Generate test vectors for RTL verification

---

## Phase 6: Physical Implementation (ASAP7)

### 6.1 Synthesis Configuration

```makefile
# OpenROAD config for Tritone SoC
DESIGN_NAME = tritone_soc
PLATFORM = asap7
CLOCK_PERIOD = 1.0  # 1 GHz target (conservative for larger design)

# Floorplan
DIE_AREA = 0 0 200 200  # ~40,000 µm² target
CORE_AREA = 10 10 190 190
```

### 6.2 Area Budget

| Block | Est. Area (µm²) | % of Total |
|-------|-----------------|------------|
| Tritone CPU | 41 | 0.1% |
| Systolic Array (64×64) | 25,000-30,000 | 75% |
| Weight Buffer (16KB) | 3,000 | 8% |
| Activation Buffer (8KB) | 1,500 | 4% |
| Accumulator Buffer (4KB) | 750 | 2% |
| Memory Controller | 500 | 1% |
| Interconnect | 1,000 | 3% |
| **Total** | **~35,000-40,000** | 100% |

### 6.3 Files to Create

| File | Description |
|------|-------------|
| `OpenLane/designs/tritone_soc/config.mk` | OpenROAD config |
| `OpenLane/designs/tritone_soc/constraint.sdc` | Timing constraints |
| `OpenLane/designs/tritone_soc/src/*.sv` | RTL sources |

---

## Implementation Milestones

### Milestone 0: Python Golden Model [COMPLETED] ✅
- [x] Create `tools/tpu/ternary_matmul.py` - Reference ternary matrix multiply
- [x] Create `tools/tpu/generate_test_vectors.py` - Generate RTL test inputs/outputs
- [x] Create `tools/tpu/tnn_layer_model.py` - Full layer computation reference
- [x] Validate against manual calculations (verified against NumPy)
- [x] Generate test vectors for all MAC weight cases {-1, 0, +1}

**Status:** All Python golden models complete and verified. TNN layer model shows ~35% zero-skip ratio.

**QA Verified:** 2024-12-29 - All 3 Python files exist and are functional with proper validation against NumPy.

### Milestone 1: Ternary MAC [COMPLETED] ✅
- [x] Design `ternary_mac.sv` (production) and `ternary_mac_icarus.sv` (Icarus-compatible)
- [x] Create testbench `tb_ternary_mac.sv`
- [x] Verify all weight combinations {-1, 0, +1} - **73/73 tests passing**
- [x] Synthesize standalone MAC, measure area/timing (via ASAP7 flow)

**Status:** MAC unit fully verified with all test cases passing. Uses balanced ternary representation with Euclidean division for correct negative number handling.

**QA Verified:** 2024-12-29 - Both ternary_mac.sv (212 lines) and ternary_mac_icarus.sv variants implemented. Testbench comprehensive with random + boundary tests.

### Milestone 2: Processing Element [COMPLETED] ✅
- [x] Design `ternary_pe.sv` with weight register (both trit and integer versions)
- [x] Add data flow (act east, psum south)
- [x] Testbench for single PE (verified via TPU top tests)
- [x] Integration with systolic array

**Status:** PE implemented with weight-stationary dataflow. `ternary_pe_int` version uses integer arithmetic for simpler synthesis.

**QA Verified:** 2024-12-29 - ternary_pe.sv (187 lines) implements both trit-based and integer versions with proper weight-stationary dataflow.

### Milestone 3: Systolic Array [COMPLETED] ✅
- [x] Design `ternary_systolic_array.sv` (parameterized N×N)
- [x] Implement `ternary_systolic_controller.sv` (FSM with IDLE, LOAD_WEIGHTS, COMPUTE, DRAIN, DONE)
- [x] 8×8 array verification with matrix multiply
- [ ] Scale to 32×32 and 64×64 (parameterized, untested at larger sizes)

**Status:** 8x8 systolic array compiles and runs. Integer version (`ternary_systolic_array_int`) used for Icarus simulation.

**QA Verified:** 2024-12-29 - Systolic array (238 lines) and controller (279 lines) fully implemented with proper diagonal wavefront and tile-based processing.

### Milestone 4: Memory System [COMPLETED] ✅
- [x] Design weight/activation/accumulator buffers
  - `tpu_weight_buffer.sv` - Double-buffered weight storage (100 lines)
  - `tpu_activation_buffer.sv` - Streaming activation buffer with ping-pong (153 lines)
  - `tpu_memory_controller.sv` - Unified memory control with accumulator (313 lines)
- [x] Implement memory controller
- [x] Double-buffering for weight loading
- [x] Integration with systolic array

**Status:** Complete memory subsystem with double-buffering support for continuous layer execution.

**QA Note:** The planned `tpu_accumulator.sv` was merged into `tpu_memory_controller.sv` for simpler design. Output buffer embedded in memory controller.

**QA Verified:** 2024-12-29 - All memory components functional with proper CPU interface and systolic array integration.

### Milestone 5: TPU Top [COMPLETED] ✅
- [x] Create `tpu_top.sv` wrapper (389 lines)
- [x] Add control registers and FSM
- [x] Full TPU verification - **Basic tests passing**
- [x] Testbench `tb_tpu_top.sv` created

**Status:** TPU top module complete with register interface (CTRL, STATUS, WEIGHT_ADDR, ACT_ADDR, OUT_ADDR, LAYER_CFG, ARRAY_INFO). Basic testbench passes.

**QA Note:** The planned `tpu_register_file.sv` was integrated directly into `tpu_top.sv` for simpler design.

**QA Verified:** 2024-12-29 - TPU top properly integrates systolic array, memory buffers, and controller with complete CPU interface.

### Milestone 6: SoC Integration [COMPLETED] ✅
- [x] Design `tritone_soc.sv` - Complete hybrid SoC (275 lines)
- [x] CPU-TPU interface via memory-mapped I/O
- [x] Unified memory system with address decode
- [x] End-to-end verification - **All integration tests passing**
- [x] Testbench `tb_tritone_soc.sv` created (246 lines)

**Status:** Complete SoC combining Tritone CPU + TPU with shared memory. External interface for testing. All basic integration tests passing.

**QA Note:** The planned `memory_arbiter.sv` and `soc_interconnect.sv` were simplified and embedded into `tritone_soc.sv` for cleaner design.

**QA Verified:** 2024-12-29 - Full SoC integration verified with external interface for TPU register access and CPU-TPU memory-mapped I/O.

### Milestone 7: Physical Implementation [IN PROGRESS]
- [x] OpenROAD configuration created
- [x] SDC constraints defined (1.0 GHz baseline, 1.5 GHz aggressive)
- [x] Source files prepared (28 .sv files + 1 .vh)
- [ ] ASAP7 synthesis
- [ ] Floor planning
- [ ] Place and route
- [ ] Timing closure
- [ ] DRC/LVS clean

**Configuration Files Created:**
```
OpenROAD-flow-scripts-master/
├── flow/designs/asap7/tritone_soc/
│   ├── config.mk              # OpenROAD configuration
│   ├── constraint_1ghz.sdc    # 1.0 GHz timing constraints
│   └── constraint_1500mhz.sdc # 1.5 GHz timing constraints
├── flow/designs/src/tritone_soc/
│   ├── ternary_pkg.sv         # Balanced ternary types
│   ├── ternary_cpu.sv         # CPU core (34KB)
│   ├── tritone_soc.sv         # Top-level SoC
│   ├── tpu_top.sv             # TPU accelerator
│   ├── ternary_systolic_*.sv  # Systolic array + controller
│   ├── tpu_*_buffer.sv        # Memory buffers
│   └── ... (28 files total)
├── run_tritone_soc_asap7.sh   # Linux run script
└── run_tritone_soc_asap7.bat  # Windows run script
```

**To Run Synthesis:**
```bash
# From OpenROAD-flow-scripts-master directory:
./run_tritone_soc_asap7.sh           # baseline 1.0 GHz
./run_tritone_soc_asap7.sh aggressive # aggressive 1.5 GHz

# Or manually via Docker:
cd flow
make DESIGN_CONFIG=designs/asap7/tritone_soc/config.mk
```

**Expected Results (Based on CPU-only Metrics):**
- Tritone CPU alone: ~41 µm² @ 2.0 GHz ASAP7
- TPU Systolic Array (8×8): ~500-1000 µm² estimated
- Full SoC: ~2000-5000 µm² estimated @ 1.0 GHz

---

## Key Reusable Components from Tritone

| Component | Source File | Reuse |
|-----------|-------------|-------|
| BTFA (Full Adder) | `hdl/rtl/btfa.sv` | Direct - MAC accumulator |
| CLA Adder | `hdl/rtl/ternary_cla.sv` | Direct - accumulator chain |
| SRAM Wrapper | `hdl/rtl/ternary_sram_wrapper.sv` | Adapt - larger buffers |
| Register File | `hdl/rtl/ternary_regfile.sv` | Pattern - TPU registers |
| Memory System | `hdl/rtl/ternary_memory.sv` | Extend - shared SRAM |
| CPU Core | `hdl/rtl/ternary_cpu.sv` | Direct - SoC integration |
| Standard Cells | `asic/lib/gt_logic_ternary.lib` | Direct - ASIC flow |

---

## Expected Outcomes

### Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| Clock Frequency | 1 GHz | Conservative for larger design |
| Peak Throughput | 4.1 TOPS | 4,096 MACs × 1 GHz |
| Power (TPU) | ~50-100 mW | Ternary MACs are simpler |
| Power (SoC total) | ~100-150 mW | Including CPU + memory |
| Area | ~40,000 µm² | ASAP7 7nm |

### Comparison Targets

| Metric | Tritone TPU | Google TPU (scaled) | Advantage |
|--------|-------------|---------------------|-----------|
| MAC Efficiency | ~10 µm²/MAC | ~50 µm²/MAC | 5× denser |
| Power/MAC | ~25 µW | ~100 µW | 4× efficient |
| Zero-skip benefit | 33% ops saved | N/A | Sparsity |

### Publication Value

**Novel Contributions:**
1. First balanced-ternary systolic array accelerator
2. Hybrid SoC combining ternary CPU + TPU
3. Zero-skipping architecture exploiting TNN sparsity
4. ASAP7 7nm physical implementation

---

## File Structure (New)

```
tools/
├── tpu/                       # NEW: Python golden model
│   ├── ternary_matmul.py      # Reference ternary matrix multiply
│   ├── generate_test_vectors.py # RTL test vector generation
│   └── tnn_layer_model.py     # Full layer computation reference

hdl/
├── rtl/
│   ├── tpu/                    # NEW: TPU modules
│   │   ├── ternary_mac.sv
│   │   ├── ternary_pe.sv
│   │   ├── ternary_systolic_array.sv
│   │   ├── ternary_systolic_controller.sv
│   │   ├── tpu_weight_buffer.sv
│   │   ├── tpu_activation_buffer.sv
│   │   ├── tpu_accumulator.sv
│   │   ├── tpu_memory_controller.sv
│   │   ├── tpu_register_file.sv
│   │   └── tpu_top.sv
│   ├── soc/                    # NEW: SoC integration
│   │   ├── tritone_soc.sv
│   │   ├── memory_arbiter.sv
│   │   └── soc_interconnect.sv
│   └── (existing CPU modules)
├── tb/
│   ├── tpu/                    # NEW: TPU testbenches
│   │   ├── tb_ternary_mac.sv
│   │   ├── tb_ternary_pe.sv
│   │   ├── tb_ternary_systolic.sv
│   │   ├── tb_tpu_memory.sv
│   │   └── tb_tpu_top.sv
│   └── soc/                    # NEW: SoC testbenches
│       ├── tb_tritone_soc.sv
│       └── tb_tnn_inference.sv
└── (existing)

OpenROAD-flow-scripts-master/flow/designs/
├── asap7/
│   ├── tritone/               # Existing CPU-only design
│   │   ├── config.mk
│   │   └── constraint_*.sdc
│   └── tritone_soc/           # NEW: CPU + TPU SoC
│       ├── config.mk
│       ├── constraint_1ghz.sdc
│       └── constraint_1500mhz.sdc
└── src/
    ├── tritone/               # CPU source files
    └── tritone_soc/           # Combined CPU + TPU sources (28 files)
```

---

## Research References

- [Google TPU Architecture Deep Dive](https://www.introl.io/blog/google-tpu-architecture-complete-guide-7-generations) - 7 generations of TPU design
- [TCN-CUTIE: 1036 TOp/s/W Ternary Accelerator](https://arxiv.org/abs/2212.00688) - State-of-art TNN accelerator
- [xTern: RISC-V TNN Extension](https://arxiv.org/abs/2405.19065) - ISA extensions for ternary inference
- [Weight-Stationary Systolic Arrays](https://telesens.co/2018/07/30/systolic-architectures/) - Dataflow tutorial
- [Systolic Array Dataflow Analysis](https://arxiv.org/html/2410.22595v1) - WS vs OS vs IS comparison
- [Systolic Array RTL Implementation](https://github.com/abdelazeem201/Systolic-array-implementation-in-RTL-for-TPU) - Reference RTL

---

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Initial Array Size | **8x8 (64 MACs)** | Good balance of complexity and iteration speed |
| CPU-TPU Interface | **Both MMIO + Custom Instructions** | MMIO for config, custom opcodes for tight loops |
| Golden Model | **Python first** | Generate test vectors before RTL |
| Priority | **Both SoC demo + ASAP7 metrics** | Need functional proof + publication data |

---

## Ready for Implementation

Implementation begins with **Milestone 0: Python Golden Model**, followed by **Milestone 1: Ternary MAC Unit** - the fundamental building block.
