// Ternary CPU System - Dual-Issue Superscalar
// Complete system with CPU core and memory
//
// This is the top-level module for FPGA/ASIC implementation

`include "ternary_defs.vh"

module ternary_cpu_system #(
  parameter TRIT_WIDTH = 27,
  parameter IMEM_DEPTH = 243,
  parameter DMEM_DEPTH = 729
)(
  input  wire        clk,
  input  wire        rst_n,

  // External interface for loading programs (active during reset)
  input  wire        prog_mode,
  input  wire [7:0]  prog_addr,
  input  wire [17:0] prog_data,      // 9 trits = 18 bits
  input  wire        prog_we,

  // Status outputs
  output wire        halted,
  output wire [15:0] pc_out,          // 8 trits = 16 bits
  output wire        valid_out_a,     // Slot A valid
  output wire        valid_out_b,     // Slot B valid
  output wire [1:0]  ipc_out,         // Instructions per cycle (0, 1, or 2)

  // Debug register read port
  input  wire [3:0]  debug_reg_addr,  // 2 trits = 4 bits
  output wire [TRIT_WIDTH*2-1:0] debug_reg_data  // 27 trits = 54 bits
);

  // ============================================================
  // Internal Signals
  // ============================================================

  // CPU <-> Instruction Memory (Dual-Issue: 36 bits = 18 trits = 2 instructions)
  wire [15:0] imem_addr;  // 8 trits = 16 bits
  wire [35:0] imem_data;  // 18 trits = 36 bits (2 × 9-trit instructions)

  // CPU <-> Data Memory
  wire [17:0]               dmem_addr;   // 9 trits = 18 bits
  wire [TRIT_WIDTH*2-1:0]   dmem_wdata;  // 27 trits = 54 bits
  wire [TRIT_WIDTH*2-1:0]   dmem_rdata;  // 27 trits = 54 bits
  wire                      dmem_we;
  wire                      dmem_re;

  // CPU status signals (for debug)
  wire                      stall_status;
  wire                      fwd_a_status;
  wire                      fwd_b_status;

  // ============================================================
  // CPU Core - Dual-Issue Superscalar
  // ============================================================

  ternary_cpu #(
    .TRIT_WIDTH (TRIT_WIDTH)
  ) u_cpu (
    .clk          (clk),
    .rst_n        (rst_n),
    .imem_addr    (imem_addr),
    .imem_data    (imem_data),
    .dmem_addr    (dmem_addr),
    .dmem_wdata   (dmem_wdata),
    .dmem_rdata   (dmem_rdata),
    .dmem_we      (dmem_we),
    .dmem_re      (dmem_re),
    .halted       (halted),
    .pc_out       (pc_out),
    .valid_out_a  (valid_out_a),
    .valid_out_b  (valid_out_b),
    .ipc_out      (ipc_out),
    // Debug interface
    .dbg_reg_idx  (debug_reg_addr),
    .dbg_reg_data (debug_reg_data),
    // Status outputs
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

endmodule
