// Ternary CPU System - Dual-Issue Superscalar
// Complete system with CPU core and memory
//
// This is the top-level module for FPGA/ASIC implementation

module ternary_cpu_system
  import ternary_pkg::*;
#(
  parameter int TRIT_WIDTH = 27,
  parameter int IMEM_DEPTH = 243,
  parameter int DMEM_DEPTH = 729
)(
  input  logic clk,
  input  logic rst_n,

  // External interface for loading programs (active during reset)
  // TODO: Connect to memory module for runtime program loading
  /* verilator lint_off UNUSED */
  input  logic                   prog_mode,
  input  logic [7:0]             prog_addr,
  input  trit_t [8:0]            prog_data,
  input  logic                   prog_we,
  /* verilator lint_on UNUSED */

  // Status outputs
  output logic                   halted,
  output trit_t [7:0]            pc_out,
  output logic                   valid_out_a,   // Slot A valid
  output logic                   valid_out_b,   // Slot B valid
  output logic [1:0]             ipc_out,       // Instructions per cycle (0, 1, or 2)

  // Debug register read port
  input  trit_t [1:0]            debug_reg_addr,
  output trit_t [TRIT_WIDTH-1:0] debug_reg_data
);

  // ============================================================
  // Internal Signals
  // ============================================================

  // CPU <-> Instruction Memory (Dual-Issue: 18 trits = 2 instructions)
  trit_t [7:0]  imem_addr;
  trit_t [17:0] imem_data;  // 2 × 9-trit instructions

  // CPU <-> Data Memory
  trit_t [8:0]            dmem_addr;
  trit_t [TRIT_WIDTH-1:0] dmem_wdata;
  trit_t [TRIT_WIDTH-1:0] dmem_rdata;
  logic                   dmem_we;
  logic                   dmem_re;

  // CPU status signals (directly output or unused)
  /* verilator lint_off UNUSED */
  logic                   stall_status;    // Hazard status - for debug
  logic                   fwd_a_status;    // Forward A active - for debug
  logic                   fwd_b_status;    // Forward B active - for debug
  /* verilator lint_on UNUSED */

  // ============================================================
  // CPU Core - Dual-Issue Superscalar
  // ============================================================

  ternary_cpu #(
    .TRIT_WIDTH (TRIT_WIDTH)
  ) u_cpu (
    .clk          (clk),
    .rst_n        (rst_n),
    .imem_addr    (imem_addr),
    .imem_data    (imem_data),    // 18 trits for dual-issue
    .dmem_addr    (dmem_addr),
    .dmem_wdata   (dmem_wdata),
    .dmem_rdata   (dmem_rdata),
    .dmem_we      (dmem_we),
    .dmem_re      (dmem_re),
    .halted       (halted),
    .pc_out       (pc_out),
    .valid_out_a  (valid_out_a),  // Slot A valid
    .valid_out_b  (valid_out_b),  // Slot B valid
    .ipc_out      (ipc_out),      // Instructions per cycle
    // Debug interface - convert 2-trit to 4-bit index
    .dbg_reg_idx  ({2'b00, debug_reg_addr[1], debug_reg_addr[0] == T_POS_ONE}),
    .dbg_reg_data (debug_reg_data),
    // Status outputs (optional monitoring)
    .stall_out    (stall_status),
    .fwd_a_out    (fwd_a_status),
    .fwd_b_out    (fwd_b_status)
  );

  // ============================================================
  // Memory
  // ============================================================

  ternary_memory #(
    .TRIT_WIDTH (TRIT_WIDTH),
    .IMEM_DEPTH (IMEM_DEPTH),
    .DMEM_DEPTH (DMEM_DEPTH)
  ) u_memory (
    .clk        (clk),
    .rst_n      (rst_n),
    .imem_addr  (imem_addr),
    .imem_data  (imem_data),
    .dmem_addr  (dmem_addr),
    .dmem_wdata (dmem_wdata),
    .dmem_rdata (dmem_rdata),
    .dmem_we    (dmem_we),
    .dmem_re    (dmem_re)
  );

  // ============================================================
  // Program Loading Interface
  // ============================================================

  // TODO: During prog_mode, allow external writes to instruction memory
  // This requires modification to memory module to support this
  // For now, use $readmemh or initial blocks in simulation

  // ============================================================
  // Debug Interface
  // ============================================================

  // Debug register access is now connected through CPU core
  // debug_reg_data output comes from CPU's dbg_reg_data port

endmodule
