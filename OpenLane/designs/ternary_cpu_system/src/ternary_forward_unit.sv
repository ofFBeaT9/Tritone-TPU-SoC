`timescale 1ns / 1ps
//==============================================================================
// Ternary Data Forwarding Unit
//
// Manages data forwarding from EX and MEM stages to resolve RAW hazards
// without stalling the pipeline.
//
// Forwarding Priority:
//   1. EX stage (most recent)
//   2. MEM stage
//   3. No forwarding (use register file value)
//==============================================================================

module ternary_forward_unit
  import ternary_pkg::*;
(
  // EX stage inputs (operands being used)
  input  trit_t [2:0] ex_rs1,        // Source register 1 address in EX
  input  trit_t [2:0] ex_rs2,        // Source register 2 address in EX
  
  // MEM stage inputs (potential forwarding source)
  input  trit_t [2:0] mem_rd,        // Destination register in MEM
  input  logic        mem_reg_write, // MEM stage will write register
  
  // WB stage inputs (potential forwarding source)
  input  trit_t [2:0] wb_rd,         // Destination register in WB
  input  logic        wb_reg_write,  // WB stage will write register
  
  // Forwarding control outputs
  output logic [1:0]  forward_a,     // Forward control for operand A (rs1)
  output logic [1:0]  forward_b      // Forward control for operand B (rs2)
);

  // Forward control encoding:
  // 2'b00 = No forwarding (use value from register file)
  // 2'b01 = Forward from WB stage
  // 2'b10 = Forward from MEM stage
  // 2'b11 = Reserved (not used)

  // Helper function to compare ternary addresses
  function automatic logic addr_match(trit_t [2:0] a, trit_t [2:0] b);
    return (a[0] == b[0]) && (a[1] == b[1]) && (a[2] == b[2]);
  endfunction
  
  // Helper function to check if address is R0 (never needs forwarding)
  function automatic logic is_r0(trit_t [2:0] addr);
    return (addr[0] == T_ZERO) && (addr[1] == T_ZERO) && (addr[2] == T_ZERO);
  endfunction

  // Forwarding logic using continuous assignment
  logic mem_fwd_a, mem_fwd_b, wb_fwd_a, wb_fwd_b;
  
  // MEM stage forwarding conditions
  assign mem_fwd_a = mem_reg_write && addr_match(ex_rs1, mem_rd) && !is_r0(mem_rd);
  assign mem_fwd_b = mem_reg_write && addr_match(ex_rs2, mem_rd) && !is_r0(mem_rd);
  
  // WB stage forwarding conditions
  assign wb_fwd_a = wb_reg_write && addr_match(ex_rs1, wb_rd) && !is_r0(wb_rd);
  assign wb_fwd_b = wb_reg_write && addr_match(ex_rs2, wb_rd) && !is_r0(wb_rd);
  
  // Forwarding control for operand A (MEM has priority over WB)
  assign forward_a = mem_fwd_a ? 2'b10 : (wb_fwd_a ? 2'b01 : 2'b00);
  
  // Forwarding control for operand B (MEM has priority over WB)
  assign forward_b = mem_fwd_b ? 2'b10 : (wb_fwd_b ? 2'b01 : 2'b00);

endmodule
