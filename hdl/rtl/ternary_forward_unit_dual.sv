// Dual-Issue Data Forwarding Unit
// Handles forwarding for both Slot A and Slot B with same-cycle EX_A→Slot_B support
//
// Forwarding Priority (highest to lowest):
// 1. EX_A (same cycle, Slot B only) - forward from Slot A's ALU result
// 2. MEM_A (previous cycle Slot A)
// 3. MEM_B (previous cycle Slot B)
// 4. WB_A (two cycles ago Slot A)
// 5. WB_B (two cycles ago Slot B)
// 6. No forwarding (use register file value)

module ternary_forward_unit_dual
  import ternary_pkg::*;
(
  // EX stage operand addresses - Slot A
  input  trit_t [2:0] ex_rs1_a,
  input  trit_t [2:0] ex_rs2_a,

  // EX stage operand addresses - Slot B
  input  trit_t [2:0] ex_rs1_b,
  input  trit_t [2:0] ex_rs2_b,

  // Same-cycle forwarding source (Slot A in EX stage)
  input  trit_t [2:0] ex_rd_a,
  input  logic        ex_reg_write_a,

  // MEM stage (previous cycle) - Slot A
  input  trit_t [2:0] mem_rd_a,
  input  logic        mem_reg_write_a,

  // MEM stage (previous cycle) - Slot B
  input  trit_t [2:0] mem_rd_b,
  input  logic        mem_reg_write_b,

  // WB stage (two cycles ago) - Slot A
  input  trit_t [2:0] wb_rd_a,
  input  logic        wb_reg_write_a,

  // WB stage (two cycles ago) - Slot B
  input  trit_t [2:0] wb_rd_b,
  input  logic        wb_reg_write_b,

  // Forwarding controls - Slot A
  // Encoding: 3'b000=no fwd, 3'b001=WB_A, 3'b010=WB_B, 3'b011=MEM_A, 3'b100=MEM_B
  output logic [2:0]  forward_a_rs1,
  output logic [2:0]  forward_a_rs2,

  // Forwarding controls - Slot B
  // Encoding: 3'b000=no fwd, 3'b001=WB_A, 3'b010=WB_B, 3'b011=MEM_A, 3'b100=MEM_B, 3'b101=EX_A
  output logic [2:0]  forward_b_rs1,
  output logic [2:0]  forward_b_rs2
);

  // ============================================================
  // Address Comparison Functions
  // ============================================================

  // Compare two 3-trit addresses
  function automatic logic addr_match(trit_t [2:0] a, trit_t [2:0] b);
    return (a[0] == b[0]) && (a[1] == b[1]) && (a[2] == b[2]);
  endfunction

  // Check if address is R0 (hardwired zero - no forwarding needed)
  function automatic logic is_r0(trit_t [2:0] addr);
    return (addr[0] == T_ZERO) && (addr[1] == T_ZERO) && (addr[2] == T_ZERO);
  endfunction

  // ============================================================
  // Slot A Forwarding Logic
  // ============================================================
  // Slot A cannot forward from EX_A (same slot, same cycle)

  always_comb begin
    // Default: no forwarding
    forward_a_rs1 = 3'b000;

    // Priority: MEM_A > MEM_B > WB_A > WB_B
    if (mem_reg_write_a && addr_match(ex_rs1_a, mem_rd_a) && !is_r0(mem_rd_a))
      forward_a_rs1 = 3'b011;  // MEM_A
    else if (mem_reg_write_b && addr_match(ex_rs1_a, mem_rd_b) && !is_r0(mem_rd_b))
      forward_a_rs1 = 3'b100;  // MEM_B
    else if (wb_reg_write_a && addr_match(ex_rs1_a, wb_rd_a) && !is_r0(wb_rd_a))
      forward_a_rs1 = 3'b001;  // WB_A
    else if (wb_reg_write_b && addr_match(ex_rs1_a, wb_rd_b) && !is_r0(wb_rd_b))
      forward_a_rs1 = 3'b010;  // WB_B
  end

  always_comb begin
    forward_a_rs2 = 3'b000;

    if (mem_reg_write_a && addr_match(ex_rs2_a, mem_rd_a) && !is_r0(mem_rd_a))
      forward_a_rs2 = 3'b011;
    else if (mem_reg_write_b && addr_match(ex_rs2_a, mem_rd_b) && !is_r0(mem_rd_b))
      forward_a_rs2 = 3'b100;
    else if (wb_reg_write_a && addr_match(ex_rs2_a, wb_rd_a) && !is_r0(wb_rd_a))
      forward_a_rs2 = 3'b001;
    else if (wb_reg_write_b && addr_match(ex_rs2_a, wb_rd_b) && !is_r0(wb_rd_b))
      forward_a_rs2 = 3'b010;
  end

  // ============================================================
  // Slot B Forwarding Logic
  // ============================================================
  // Slot B CAN forward from EX_A (same cycle, different slot)
  // This is the key dual-issue optimization!

  always_comb begin
    forward_b_rs1 = 3'b000;

    // Priority: EX_A > MEM_A > MEM_B > WB_A > WB_B
    if (ex_reg_write_a && addr_match(ex_rs1_b, ex_rd_a) && !is_r0(ex_rd_a))
      forward_b_rs1 = 3'b101;  // EX_A (same cycle - highest priority for Slot B)
    else if (mem_reg_write_a && addr_match(ex_rs1_b, mem_rd_a) && !is_r0(mem_rd_a))
      forward_b_rs1 = 3'b011;  // MEM_A
    else if (mem_reg_write_b && addr_match(ex_rs1_b, mem_rd_b) && !is_r0(mem_rd_b))
      forward_b_rs1 = 3'b100;  // MEM_B
    else if (wb_reg_write_a && addr_match(ex_rs1_b, wb_rd_a) && !is_r0(wb_rd_a))
      forward_b_rs1 = 3'b001;  // WB_A
    else if (wb_reg_write_b && addr_match(ex_rs1_b, wb_rd_b) && !is_r0(wb_rd_b))
      forward_b_rs1 = 3'b010;  // WB_B
  end

  always_comb begin
    forward_b_rs2 = 3'b000;

    if (ex_reg_write_a && addr_match(ex_rs2_b, ex_rd_a) && !is_r0(ex_rd_a))
      forward_b_rs2 = 3'b101;  // EX_A
    else if (mem_reg_write_a && addr_match(ex_rs2_b, mem_rd_a) && !is_r0(mem_rd_a))
      forward_b_rs2 = 3'b011;
    else if (mem_reg_write_b && addr_match(ex_rs2_b, mem_rd_b) && !is_r0(mem_rd_b))
      forward_b_rs2 = 3'b100;
    else if (wb_reg_write_a && addr_match(ex_rs2_b, wb_rd_a) && !is_r0(wb_rd_a))
      forward_b_rs2 = 3'b001;
    else if (wb_reg_write_b && addr_match(ex_rs2_b, wb_rd_b) && !is_r0(wb_rd_b))
      forward_b_rs2 = 3'b010;
  end

endmodule
