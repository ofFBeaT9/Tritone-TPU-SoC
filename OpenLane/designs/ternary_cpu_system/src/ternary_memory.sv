// Ternary Memory Module
// Unified instruction and data memory for CPU
//
// Features:
// - Separate instruction port (read-only)
// - Data port (read/write)
// - Ternary addressing using 9-trit addresses

`include "ternary_defs.vh"

module ternary_memory #(
  parameter TRIT_WIDTH = 27,
  parameter IMEM_DEPTH = 243,   // 3^5 = 243 instructions
  parameter DMEM_DEPTH = 729,   // 3^6 = 729 data words
  parameter ADDR_WIDTH = 9      // 9 trits for addressing
)(
  input  wire        clk,
  input  wire        rst_n,

  // Instruction port (read-only) - Dual-issue: fetches 2 instructions
  input  wire [15:0] imem_addr,   // 8 trits = 16 bits
  output reg  [35:0] imem_data,   // 18 trits = 36 bits (2 × 9-trit instructions)

  // Data port (read/write)
  input  wire [ADDR_WIDTH*2-1:0]  dmem_addr,   // 9 trits = 18 bits
  input  wire [TRIT_WIDTH*2-1:0]  dmem_wdata,  // 27 trits = 54 bits
  output reg  [TRIT_WIDTH*2-1:0]  dmem_rdata,  // 27 trits = 54 bits
  input  wire                     dmem_we,
  input  wire                     dmem_re      // Read enable (unused - combinational read)
);

  // ============================================================
  // Memory Arrays
  // ============================================================

  // Instruction memory (9 trits = 18 bits per instruction)
  reg [17:0] imem [0:IMEM_DEPTH-1];

  // Data memory (27 trits = 54 bits per word)
  reg [TRIT_WIDTH*2-1:0] dmem [0:DMEM_DEPTH-1];

  // ============================================================
  // Address Conversion Functions
  // ============================================================

  // Convert 8-trit ternary address to integer index
  function integer trit8_to_int;
    input [15:0] addr;  // 8 trits = 16 bits
    integer result, power3, i;
    reg [1:0] trit_val;
    begin
      result = 0;
      power3 = 1;
      for (i = 0; i < 8; i = i + 1) begin
        trit_val = addr[i*2 +: 2];
        case (trit_val)
          `T_NEG_ONE: result = result - power3;
          `T_POS_ONE: result = result + power3;
          default: ;
        endcase
        power3 = power3 * 3;
      end
      // Handle negative addresses by wrapping
      if (result < 0) result = 0;
      trit8_to_int = result;
    end
  endfunction

  // Convert 9-trit ternary address to integer index
  function integer trit9_to_int;
    input [17:0] addr;  // 9 trits = 18 bits
    integer result, power3, i;
    reg [1:0] trit_val;
    begin
      result = 0;
      power3 = 1;
      for (i = 0; i < 9; i = i + 1) begin
        trit_val = addr[i*2 +: 2];
        case (trit_val)
          `T_NEG_ONE: result = result - power3;
          `T_POS_ONE: result = result + power3;
          default: ;
        endcase
        power3 = power3 * 3;
      end
      // Handle negative addresses by wrapping
      if (result < 0) result = 0;
      trit9_to_int = result;
    end
  endfunction

  // ============================================================
  // Instruction Memory (Combinational Read) - Dual-Issue Fetch
  // ============================================================
  integer imem_idx;
  always @(*) begin
    imem_idx = trit8_to_int(imem_addr);

    // Slot A: instruction at PC
    if (imem_idx >= 0 && imem_idx < IMEM_DEPTH)
      imem_data[17:0] = imem[imem_idx];
    else
      imem_data[17:0] = 18'b0;  // NOP for out-of-bounds

    // Slot B: instruction at PC+1
    if (imem_idx + 1 >= 0 && imem_idx + 1 < IMEM_DEPTH)
      imem_data[35:18] = imem[imem_idx + 1];
    else
      imem_data[35:18] = 18'b0;  // NOP for out-of-bounds or boundary
  end

  // ============================================================
  // Data Memory (Synchronous Write, Combinational Read)
  // ============================================================

  // Read port (combinational)
  integer dmem_read_idx;
  always @(*) begin
    dmem_read_idx = trit9_to_int(dmem_addr);
    if (dmem_read_idx >= 0 && dmem_read_idx < DMEM_DEPTH)
      dmem_rdata = dmem[dmem_read_idx];
    else
      dmem_rdata = {TRIT_WIDTH*2{1'b0}};
  end

  // Write port (synchronous)
  integer dmem_write_idx;
  always @(posedge clk) begin
    if (dmem_we) begin
      dmem_write_idx = trit9_to_int(dmem_addr);
      if (dmem_write_idx >= 0 && dmem_write_idx < DMEM_DEPTH) begin
        dmem[dmem_write_idx] <= dmem_wdata;
      end
    end
  end

endmodule
