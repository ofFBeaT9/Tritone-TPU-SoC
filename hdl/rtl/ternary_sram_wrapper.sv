// ============================================================================
// Ternary SRAM Wrapper - Binary-Encoded Storage
// ============================================================================
//
// Provides synthesizable SRAM interface for ternary data using 2-bit binary
// encoding per trit. Compatible with foundry memory compilers and OpenRAM.
//
// Encoding:
//   T_ZERO    = 2'b00 (Logic 0)
//   T_POS_ONE = 2'b01 (Logic +1)
//   T_NEG_ONE = 2'b10 (Logic -1)
//   T_INVALID = 2'b11 (Error state)
//
// Memory Organization:
//   - 27-trit word = 54 binary bits
//   - 9-trit instruction = 18 binary bits
//   - Address space uses ternary addressing converted to binary indices
//
// Usage:
//   1. For synthesis: Instantiate with SRAM macro or let tool infer
//   2. For simulation: Uses behavioral model with initialization tasks
//   3. For OpenRAM: Generate 54-bit wide SRAM, connect to binary interface
//
// Author: Tritone Project
// Date: December 2025
// ============================================================================

module ternary_sram_wrapper
  import ternary_pkg::*;
#(
  parameter int TRIT_WIDTH  = 27,       // Trits per word
  parameter int BIT_WIDTH   = 54,       // Bits per word (2 × TRIT_WIDTH)
  parameter int DEPTH       = 256,      // Number of words
  parameter int ADDR_BITS   = 8,        // Binary address width
  parameter bit USE_MACRO   = 0         // 1 = Use SRAM macro, 0 = Infer
)(
  input  logic                    clk,
  input  logic                    rst_n,

  // Ternary Interface (for CPU connection)
  input  trit_t [TRIT_WIDTH-1:0]  wdata_trit,   // Write data (ternary)
  output trit_t [TRIT_WIDTH-1:0]  rdata_trit,   // Read data (ternary)
  input  logic  [ADDR_BITS-1:0]   addr,         // Binary address
  input  logic                    we,           // Write enable
  input  logic                    re,           // Read enable (for power gating)
  input  logic                    ce,           // Chip enable

  // Binary Interface (for SRAM macro connection)
  output logic  [BIT_WIDTH-1:0]   wdata_bin,    // Write data (binary)
  input  logic  [BIT_WIDTH-1:0]   rdata_bin,    // Read data (binary)
  output logic  [ADDR_BITS-1:0]   addr_bin,     // Address to macro
  output logic                    we_bin,       // Write enable to macro
  output logic                    ce_bin        // Chip enable to macro
);

  // ============================================================================
  // Ternary to Binary Conversion
  // ============================================================================

  // Convert ternary write data to binary
  always_comb begin
    for (int i = 0; i < TRIT_WIDTH; i++) begin
      wdata_bin[2*i +: 2] = wdata_trit[i];  // trit_t is already 2-bit
    end
  end

  // Convert binary read data to ternary
  always_comb begin
    for (int i = 0; i < TRIT_WIDTH; i++) begin
      rdata_trit[i] = trit_t'(rdata_bin[2*i +: 2]);
    end
  end

  // Pass through control signals
  assign addr_bin = addr;
  assign we_bin   = we & ce;
  assign ce_bin   = ce;

  // ============================================================================
  // Behavioral SRAM (when USE_MACRO = 0)
  // ============================================================================

  generate
    if (!USE_MACRO) begin : gen_behavioral

      // Memory array
      logic [BIT_WIDTH-1:0] mem [DEPTH];

      // Registered read data
      logic [BIT_WIDTH-1:0] rdata_reg;

      // Synchronous read/write
      always_ff @(posedge clk) begin
        if (ce) begin
          if (we) begin
            mem[addr] <= wdata_bin;
          end
          if (re) begin
            rdata_reg <= mem[addr];
          end
        end
      end

      // Connect to output
      assign rdata_bin = rdata_reg;

      // ========================================================================
      // Initialization (simulation only)
      // ========================================================================
      `ifdef SIMULATION
      initial begin
        for (int i = 0; i < DEPTH; i++) begin
          mem[i] = '0;
        end
      end

      // Task to load memory from ternary array
      task load_ternary_data(input trit_t [TRIT_WIDTH-1:0] data [], input int start_addr);
        logic [BIT_WIDTH-1:0] bin_word;
        for (int w = 0; w < data.size() && (start_addr + w) < DEPTH; w++) begin
          for (int t = 0; t < TRIT_WIDTH; t++) begin
            bin_word[2*t +: 2] = data[w][t];
          end
          mem[start_addr + w] = bin_word;
        end
      endtask

      // Task to dump memory contents
      task dump_memory(input int start_addr, input int count);
        trit_t [TRIT_WIDTH-1:0] trit_word;
        $display("=== SRAM Contents ===");
        for (int i = start_addr; i < start_addr + count && i < DEPTH; i++) begin
          for (int t = 0; t < TRIT_WIDTH; t++) begin
            trit_word[t] = trit_t'(mem[i][2*t +: 2]);
          end
          $display("[%03d] bin=%h trit_dec=%0d", i, mem[i], ternary_to_bin(trit_word));
        end
      endtask
      `endif

    end
  endgenerate

  // ============================================================================
  // SRAM Macro Integration (when USE_MACRO = 1)
  // ============================================================================

  generate
    if (USE_MACRO) begin : gen_macro

      // ========================================================================
      // SKY130 OpenRAM Integration Example
      // ========================================================================
      // Uncomment and modify for your specific SRAM macro:
      //
      // sky130_sram_1kbyte_1rw1r_32x256_8 u_sram (
      //   .clk0     (clk),
      //   .csb0     (~ce_bin),
      //   .web0     (~we_bin),
      //   .addr0    (addr_bin),
      //   .din0     (wdata_bin),
      //   .dout0    (rdata_bin),
      //   ...
      // );

      // Placeholder for macro - replace with actual instantiation
      // For now, fall back to behavioral
      logic [BIT_WIDTH-1:0] mem [DEPTH];
      logic [BIT_WIDTH-1:0] rdata_reg;

      always_ff @(posedge clk) begin
        if (ce) begin
          if (we) mem[addr] <= wdata_bin;
          rdata_reg <= mem[addr];
        end
      end

      assign rdata_bin = rdata_reg;

    end
  endgenerate

endmodule

// ============================================================================
// Ternary Register File SRAM Wrapper
// ============================================================================
// Specialized wrapper for register file (9 regs × 27 trits)
// Uses binary encoding internally but presents ternary interface

module ternary_regfile_sram
  import ternary_pkg::*;
#(
  parameter int NUM_REGS    = 9,
  parameter int TRIT_WIDTH  = 27,
  parameter int BIT_WIDTH   = 54
)(
  input  logic                     clk,
  input  logic                     rst_n,

  // Read port 1
  input  logic [$clog2(NUM_REGS)-1:0] raddr1,
  output trit_t [TRIT_WIDTH-1:0]      rdata1,

  // Read port 2
  input  logic [$clog2(NUM_REGS)-1:0] raddr2,
  output trit_t [TRIT_WIDTH-1:0]      rdata2,

  // Write port
  input  logic [$clog2(NUM_REGS)-1:0] waddr,
  input  trit_t [TRIT_WIDTH-1:0]      wdata,
  input  logic                        we
);

  // Binary-encoded register storage
  logic [BIT_WIDTH-1:0] regs [NUM_REGS];

  // Convert ternary write data to binary
  logic [BIT_WIDTH-1:0] wdata_bin;
  always_comb begin
    for (int i = 0; i < TRIT_WIDTH; i++) begin
      wdata_bin[2*i +: 2] = wdata[i];
    end
  end

  // Read ports (combinational)
  always_comb begin
    // Port 1
    if (raddr1 == 0) begin
      for (int i = 0; i < TRIT_WIDTH; i++) rdata1[i] = T_ZERO;
    end else begin
      for (int i = 0; i < TRIT_WIDTH; i++) begin
        rdata1[i] = trit_t'(regs[raddr1][2*i +: 2]);
      end
    end

    // Port 2
    if (raddr2 == 0) begin
      for (int i = 0; i < TRIT_WIDTH; i++) rdata2[i] = T_ZERO;
    end else begin
      for (int i = 0; i < TRIT_WIDTH; i++) begin
        rdata2[i] = trit_t'(regs[raddr2][2*i +: 2]);
      end
    end
  end

  // Write port (synchronous)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < NUM_REGS; i++) begin
        regs[i] <= '0;
      end
    end else if (we && waddr != 0) begin
      regs[waddr] <= wdata_bin;
    end
  end

endmodule

// ============================================================================
// Memory Interface Specification
// ============================================================================
//
// For integration with foundry SRAM compilers or OpenRAM:
//
// 1. DATA MEMORY (27-trit words):
//    Width:  54 bits
//    Depth:  As required (e.g., 256, 512, 1024 words)
//    Ports:  1RW (single port read/write)
//    Mux:    4:1 or 8:1 column mux
//
// 2. INSTRUCTION MEMORY (9-trit instructions):
//    Width:  18 bits (or 36 bits for dual-issue fetch)
//    Depth:  As required
//    Ports:  1R (read-only) or 1RW for programming
//
// 3. REGISTER FILE (9 regs × 27 trits):
//    Width:  54 bits
//    Depth:  9 words
//    Ports:  2R1W (two read, one write)
//    Note:   R0 hardwired to zero (software convention)
//
// 4. OpenRAM Command Example:
//    python openram.py -c config_sky130_54x256.py
//
//    Config file contents:
//      word_size = 54
//      num_words = 256
//      num_rw_ports = 1
//      tech_name = "sky130"
//
// ============================================================================
