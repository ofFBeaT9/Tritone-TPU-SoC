`timescale 1ns / 1ps
//==============================================================================
// Ternary Hazard Detection Unit
//
// Detects pipeline hazards and generates stall/flush signals
// - RAW (Read-After-Write) hazards
// - Load-use hazards
// - Branch hazards
//==============================================================================

module ternary_hazard_unit
  import ternary_pkg::*;
(
  // ID stage inputs (instruction being decoded)
  input  trit_t [2:0] id_rs1,        // Source register 1 address
  input  trit_t [2:0] id_rs2,        // Source register 2 address
  input  logic        id_uses_rs1,   // ID stage uses rs1
  input  logic        id_uses_rs2,   // ID stage uses rs2
  
  // EX stage inputs (instruction currently executing)
  input  trit_t [2:0] ex_rd,         // Destination register address
  input  logic        ex_reg_write,  // EX stage will write register
  input  logic        ex_mem_read,   // EX stage is a load instruction
  
  // MEM stage inputs (instruction in memory stage)
  input  trit_t [2:0] mem_rd,        // Destination register address
  input  logic        mem_reg_write, // MEM stage will write register
  
  // Hazard outputs
  output logic        pc_stall,      // Stall PC (freeze fetch)
  output logic        if_id_stall,   // Stall IF/ID pipeline register
  output logic        id_ex_flush    // Flush ID/EX pipeline register (insert bubble)
);

  // Helper function to compare ternary addresses
  function automatic logic addr_match(trit_t [2:0] a, trit_t [2:0] b);
    return (a[0] == b[0]) && (a[1] == b[1]) && (a[2] == b[2]);
  endfunction
  
  // Helper function to check if address is R0 (hardwired zero, never a hazard)
  function automatic logic is_r0(trit_t [2:0] addr);
    return (addr[0] == T_ZERO) && (addr[1] == T_ZERO) && (addr[2] == T_ZERO);
  endfunction

  // RAW hazard detection
  logic raw_hazard_ex_rs1, raw_hazard_ex_rs2;
  logic raw_hazard_mem_rs1, raw_hazard_mem_rs2;
  logic load_use_hazard;
  
  // Detect RAW hazards with EX stage
  assign raw_hazard_ex_rs1 = id_uses_rs1 && ex_reg_write && 
                             addr_match(id_rs1, ex_rd) && !is_r0(ex_rd);
  assign raw_hazard_ex_rs2 = id_uses_rs2 && ex_reg_write && 
                             addr_match(id_rs2, ex_rd) && !is_r0(ex_rd);
  
  // Detect RAW hazards with MEM stage
  assign raw_hazard_mem_rs1 = id_uses_rs1 && mem_reg_write && 
                              addr_match(id_rs1, mem_rd) && !is_r0(mem_rd);
  assign raw_hazard_mem_rs2 = id_uses_rs2 && mem_reg_write && 
                              addr_match(id_rs2, mem_rd) && !is_r0(mem_rd);
  
  // Load-use hazard: EX stage is loading data, ID stage needs it
  // Cannot forward load data until MEM stage, so must stall
  assign load_use_hazard = ex_mem_read && 
                           ((raw_hazard_ex_rs1) || (raw_hazard_ex_rs2));
  
  // Stall pipeline if load-use hazard detected
  assign pc_stall = load_use_hazard;
  assign if_id_stall = load_use_hazard;
  assign id_ex_flush = load_use_hazard;
  
  // Note: Non-load RAW hazards will be handled by forwarding unit
  // If forwarding is not available, additional stalls may be needed

endmodule
