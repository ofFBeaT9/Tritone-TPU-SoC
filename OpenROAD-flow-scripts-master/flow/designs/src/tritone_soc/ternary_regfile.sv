// Ternary Register File - Dual-Issue Version
// 9 registers × 27 trits each
// R0 is hardwired to zero (writes ignored)
// 4 read ports (2 per slot), 2 write ports with priority
//
// Register addressing uses 2 trits:
//   00 -> R0 (zero)
//   0+ -> R1, 0- -> R2
//   +0 -> R3, ++ -> R4, +- -> R5
//   -0 -> R6, -+ -> R7, -- -> R8

`include "ternary_defs.vh"

module ternary_regfile #(
  parameter NUM_REGS = 9,
  parameter TRIT_WIDTH = 27
)(
  input  wire                       clk,
  input  wire                       rst_n,

  // ============================================================
  // Slot A Read Ports
  // ============================================================
  input  wire [3:0]                 rs1_a_addr,  // 2 trits = 4 bits
  output wire [TRIT_WIDTH*2-1:0]    rs1_a_data,  // 27 trits = 54 bits

  input  wire [3:0]                 rs2_a_addr,
  output wire [TRIT_WIDTH*2-1:0]    rs2_a_data,

  // ============================================================
  // Slot B Read Ports
  // ============================================================
  input  wire [3:0]                 rs1_b_addr,
  output wire [TRIT_WIDTH*2-1:0]    rs1_b_data,

  input  wire [3:0]                 rs2_b_addr,
  output wire [TRIT_WIDTH*2-1:0]    rs2_b_data,

  // ============================================================
  // Slot A Write Port
  // ============================================================
  input  wire [3:0]                 rd_a_addr,
  input  wire [TRIT_WIDTH*2-1:0]    rd_a_data,
  input  wire                       we_a,

  // ============================================================
  // Slot B Write Port (has priority over Slot A on conflict)
  // ============================================================
  input  wire [3:0]                 rd_b_addr,
  input  wire [TRIT_WIDTH*2-1:0]    rd_b_data,
  input  wire                       we_b,

  // Debug ports (direct register access by integer index)
  input  wire [3:0]                 dbg_reg_idx,
  output wire [TRIT_WIDTH*2-1:0]    dbg_reg_data
);

  // Register storage array - 9 registers, each 54 bits (27 trits)
  reg [TRIT_WIDTH*2-1:0] regs [0:NUM_REGS-1];

  // Zero constant
  wire [TRIT_WIDTH*2-1:0] zero_val;
  assign zero_val = {TRIT_WIDTH*2{1'b0}};

  // ============================================================
  // Address conversion: 2-trit balanced ternary to integer index
  // ============================================================
  function [3:0] trit2_to_index;
    input [3:0] addr;  // 2 trits = 4 bits
    reg [3:0] val0, val1;
    begin
      // Convert trit 0 (bits [1:0])
      case (addr[1:0])
        `T_ZERO:    val0 = 4'd0;
        `T_POS_ONE: val0 = 4'd1;
        `T_NEG_ONE: val0 = 4'd2;
        default:    val0 = 4'd0;
      endcase

      // Convert trit 1 (bits [3:2])
      case (addr[3:2])
        `T_ZERO:    val1 = 4'd0;
        `T_POS_ONE: val1 = 4'd3;
        `T_NEG_ONE: val1 = 4'd6;
        default:    val1 = 4'd0;
      endcase

      trit2_to_index = val0 + val1;
      if (trit2_to_index >= NUM_REGS) trit2_to_index = 4'd0;
    end
  endfunction

  // ============================================================
  // Read ports (combinational) - 4 ports for dual-issue
  // ============================================================
  // R0 always reads as zero

  // Slot A read ports
  assign rs1_a_data = (trit2_to_index(rs1_a_addr) == 0) ?
                      zero_val :
                      regs[trit2_to_index(rs1_a_addr)];

  assign rs2_a_data = (trit2_to_index(rs2_a_addr) == 0) ?
                      zero_val :
                      regs[trit2_to_index(rs2_a_addr)];

  // Slot B read ports
  assign rs1_b_data = (trit2_to_index(rs1_b_addr) == 0) ?
                      zero_val :
                      regs[trit2_to_index(rs1_b_addr)];

  assign rs2_b_data = (trit2_to_index(rs2_b_addr) == 0) ?
                      zero_val :
                      regs[trit2_to_index(rs2_b_addr)];

  // Debug read port (direct integer index access)
  assign dbg_reg_data = (dbg_reg_idx == 0 || dbg_reg_idx >= NUM_REGS) ?
                        zero_val :
                        regs[dbg_reg_idx];

  // ============================================================
  // Write ports (sequential) - Dual-issue with priority
  // ============================================================
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset all registers to zero
      for (i = 0; i < NUM_REGS; i = i + 1) begin
        regs[i] <= {TRIT_WIDTH*2{1'b0}};
      end
    end else begin
      // Slot A write (only if Slot B isn't writing to same register)
      if (we_a && trit2_to_index(rd_a_addr) != 0) begin
        // Check if Slot B is also writing to this register
        if (!(we_b && trit2_to_index(rd_a_addr) == trit2_to_index(rd_b_addr))) begin
          regs[trit2_to_index(rd_a_addr)] <= rd_a_data;
        end
      end

      // Slot B write (always takes priority over Slot A)
      if (we_b && trit2_to_index(rd_b_addr) != 0) begin
        regs[trit2_to_index(rd_b_addr)] <= rd_b_data;
      end
    end
  end

endmodule
