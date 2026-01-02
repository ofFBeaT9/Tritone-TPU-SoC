// Dual-Issue Hazard Detection Unit
// Detects load-use hazards for both Slot A and Slot B
//
// Hazard Types:
// 1. Load-Use: A load instruction's result is needed by the next instruction
//    - Cannot forward load data until MEM stage completes
//    - Must stall the dependent instruction(s)
//
// 2. Cross-Slot Load-Use: EX_A is load, ID_B needs the result
//    - Handled by inter-slot hazard detection (slot_b_stall)
//
// Note: Inter-slot RAW hazards and memory conflicts are detected
// in ternary_cpu.sv directly for simplicity

module ternary_hazard_unit_dual
  import ternary_pkg::*;
(
  // ID stage - Slot A
  input  trit_t [2:0] id_rs1_a,
  input  trit_t [2:0] id_rs2_a,
  input  logic        id_uses_rs1_a,
  input  logic        id_uses_rs2_a,

  // ID stage - Slot B
  input  trit_t [2:0] id_rs1_b,
  input  trit_t [2:0] id_rs2_b,
  input  logic        id_uses_rs1_b,
  input  logic        id_uses_rs2_b,

  // EX stage - Slot A
  input  trit_t [2:0] ex_rd_a,
  input  logic        ex_reg_write_a,
  input  logic        ex_mem_read_a,

  // EX stage - Slot B
  input  trit_t [2:0] ex_rd_b,
  input  logic        ex_reg_write_b,
  input  logic        ex_mem_read_b,

  // MEM stage (previous cycle) - Slot A
  input  trit_t [2:0] mem_rd_a,
  input  logic        mem_reg_write_a,
  input  logic        mem_mem_read_a,

  // MEM stage (previous cycle) - Slot B
  input  trit_t [2:0] mem_rd_b,
  input  logic        mem_reg_write_b,
  input  logic        mem_mem_read_b,

  // Outputs
  output logic        pc_stall,       // Freeze PC and IF/ID
  output logic        if_id_stall_a,  // Freeze IF/ID for Slot A
  output logic        if_id_stall_b,  // Freeze IF/ID for Slot B
  output logic        id_ex_flush_a,  // Insert bubble in Slot A
  output logic        id_ex_flush_b   // Insert bubble in Slot B
);

  // ============================================================
  // Address Comparison Functions
  // ============================================================

  function automatic logic addr_match(trit_t [2:0] a, trit_t [2:0] b);
    return (a[0] == b[0]) && (a[1] == b[1]) && (a[2] == b[2]);
  endfunction

  function automatic logic is_r0(trit_t [2:0] addr);
    return (addr[0] == T_ZERO) && (addr[1] == T_ZERO) && (addr[2] == T_ZERO);
  endfunction

  // ============================================================
  // Load-Use Hazard Detection
  // ============================================================

  // EX stage load hazards (load in EX, use in ID)
  logic ex_a_load_use_a;  // EX_A load -> ID_A use
  logic ex_a_load_use_b;  // EX_A load -> ID_B use
  logic ex_b_load_use_a;  // EX_B load -> ID_A use
  logic ex_b_load_use_b;  // EX_B load -> ID_B use

  // Slot A in EX loading, Slot A in ID needs it
  assign ex_a_load_use_a = ex_mem_read_a && ex_reg_write_a && (
    (id_uses_rs1_a && addr_match(id_rs1_a, ex_rd_a) && !is_r0(ex_rd_a)) ||
    (id_uses_rs2_a && addr_match(id_rs2_a, ex_rd_a) && !is_r0(ex_rd_a))
  );

  // Slot A in EX loading, Slot B in ID needs it
  assign ex_a_load_use_b = ex_mem_read_a && ex_reg_write_a && (
    (id_uses_rs1_b && addr_match(id_rs1_b, ex_rd_a) && !is_r0(ex_rd_a)) ||
    (id_uses_rs2_b && addr_match(id_rs2_b, ex_rd_a) && !is_r0(ex_rd_a))
  );

  // Slot B in EX loading, Slot A in ID needs it
  assign ex_b_load_use_a = ex_mem_read_b && ex_reg_write_b && (
    (id_uses_rs1_a && addr_match(id_rs1_a, ex_rd_b) && !is_r0(ex_rd_b)) ||
    (id_uses_rs2_a && addr_match(id_rs2_a, ex_rd_b) && !is_r0(ex_rd_b))
  );

  // Slot B in EX loading, Slot B in ID needs it
  assign ex_b_load_use_b = ex_mem_read_b && ex_reg_write_b && (
    (id_uses_rs1_b && addr_match(id_rs1_b, ex_rd_b) && !is_r0(ex_rd_b)) ||
    (id_uses_rs2_b && addr_match(id_rs2_b, ex_rd_b) && !is_r0(ex_rd_b))
  );

  // MEM stage load hazards (rare - double stall scenario)
  logic mem_a_load_use_a, mem_a_load_use_b;
  logic mem_b_load_use_a, mem_b_load_use_b;

  assign mem_a_load_use_a = mem_mem_read_a && mem_reg_write_a && (
    (id_uses_rs1_a && addr_match(id_rs1_a, mem_rd_a) && !is_r0(mem_rd_a)) ||
    (id_uses_rs2_a && addr_match(id_rs2_a, mem_rd_a) && !is_r0(mem_rd_a))
  );

  assign mem_a_load_use_b = mem_mem_read_a && mem_reg_write_a && (
    (id_uses_rs1_b && addr_match(id_rs1_b, mem_rd_a) && !is_r0(mem_rd_a)) ||
    (id_uses_rs2_b && addr_match(id_rs2_b, mem_rd_a) && !is_r0(mem_rd_a))
  );

  assign mem_b_load_use_a = mem_mem_read_b && mem_reg_write_b && (
    (id_uses_rs1_a && addr_match(id_rs1_a, mem_rd_b) && !is_r0(mem_rd_b)) ||
    (id_uses_rs2_a && addr_match(id_rs2_a, mem_rd_b) && !is_r0(mem_rd_b))
  );

  assign mem_b_load_use_b = mem_mem_read_b && mem_reg_write_b && (
    (id_uses_rs1_b && addr_match(id_rs1_b, mem_rd_b) && !is_r0(mem_rd_b)) ||
    (id_uses_rs2_b && addr_match(id_rs2_b, mem_rd_b) && !is_r0(mem_rd_b))
  );

  // ============================================================
  // Stall and Flush Control
  // ============================================================

  // Any load-use hazard affecting Slot A
  logic load_use_hazard_a;
  assign load_use_hazard_a = ex_a_load_use_a || ex_b_load_use_a ||
                             mem_a_load_use_a || mem_b_load_use_a;

  // Any load-use hazard affecting Slot B
  logic load_use_hazard_b;
  assign load_use_hazard_b = ex_a_load_use_b || ex_b_load_use_b ||
                             mem_a_load_use_b || mem_b_load_use_b;

  // Global stall if any load-use hazard
  assign pc_stall = load_use_hazard_a || load_use_hazard_b;

  // Stall individual slots
  assign if_id_stall_a = load_use_hazard_a;
  assign if_id_stall_b = load_use_hazard_b;

  // Flush (insert bubble) for hazarded slots
  assign id_ex_flush_a = load_use_hazard_a;
  assign id_ex_flush_b = load_use_hazard_b;

endmodule
