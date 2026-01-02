// Ternary Memory Module
// Unified instruction and data memory for CPU
//
// Features:
// - Separate instruction port (read-only)
// - Data port (read/write)
// - Ternary addressing using 9-trit addresses

module ternary_memory
  import ternary_pkg::*;
#(
  parameter int TRIT_WIDTH = 27,
  parameter int IMEM_DEPTH = 243,   // 3^5 = 243 instructions
  parameter int DMEM_DEPTH = 729,   // 3^6 = 729 data words
  parameter int ADDR_WIDTH = 9      // 9 trits for addressing
)(
  input  logic clk,
  input  logic rst_n,

  // Instruction port (read-only) - Dual-issue: fetches 2 instructions
  input  trit_t [7:0]            imem_addr,
  output trit_t [17:0]           imem_data,  // 18 trits = 2 × 9-trit instructions

  // Data port (read/write)
  input  trit_t [ADDR_WIDTH-1:0] dmem_addr,
  input  trit_t [TRIT_WIDTH-1:0] dmem_wdata,
  output trit_t [TRIT_WIDTH-1:0] dmem_rdata,
  input  logic                   dmem_we,
  /* verilator lint_off UNUSED */
  input  logic                   dmem_re  // Read enable - unused (combinational read always active)
  /* verilator lint_on UNUSED */
);

  // ============================================================
  // Memory Arrays
  // ============================================================

  // Instruction memory (9 trits per instruction)
  trit_t [8:0] imem [IMEM_DEPTH];

  // Data memory (27 trits per word)
  trit_t [TRIT_WIDTH-1:0] dmem [DMEM_DEPTH];

  // ============================================================
  // Address Conversion Functions
  // ============================================================

  // Convert 8-trit ternary address to integer index
  function automatic int trit8_to_int(trit_t [7:0] addr);
    int result, power3, i;
    result = 0;
    power3 = 1;
    for (i = 0; i < 8; i++) begin
      case (addr[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    // Handle negative addresses by wrapping
    if (result < 0) result = 0;
    return result;
  endfunction

  // Convert 9-trit ternary address to integer index
  function automatic int trit9_to_int(trit_t [8:0] addr);
    int result, power3, i;
    result = 0;
    power3 = 1;
    for (i = 0; i < 9; i++) begin
      case (addr[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    // Handle negative addresses by wrapping
    if (result < 0) result = 0;
    return result;
  endfunction

  // ============================================================
  // Instruction Memory (Combinational Read) - Dual-Issue Fetch
  // ============================================================
  // Fetches two consecutive instructions per cycle:
  //   imem_data[8:0]   = Slot A instruction (at PC)
  //   imem_data[17:9]  = Slot B instruction (at PC+1)

  always_comb begin
    int idx;
    idx = trit8_to_int(imem_addr);

    // Slot A: instruction at PC
    if (idx >= 0 && idx < IMEM_DEPTH)
      imem_data[8:0] = imem[idx];
    else
      imem_data[8:0] = TRIT9_ZERO;  // NOP for out-of-bounds

    // Slot B: instruction at PC+1
    if (idx + 1 >= 0 && idx + 1 < IMEM_DEPTH)
      imem_data[17:9] = imem[idx + 1];
    else
      imem_data[17:9] = TRIT9_ZERO;  // NOP for out-of-bounds or boundary
  end

  // ============================================================
  // Data Memory (Synchronous Write, Combinational Read)
  // ============================================================

  // Read port
  always_comb begin
    int idx;
    idx = trit9_to_int(dmem_addr);
    if (idx >= 0 && idx < DMEM_DEPTH)
      dmem_rdata = dmem[idx];
    else
      dmem_rdata = TRIT27_ZERO;
  end

  // Write port
  always_ff @(posedge clk) begin
    if (dmem_we) begin
      int idx;
      idx = trit9_to_int(dmem_addr);
      if (idx >= 0 && idx < DMEM_DEPTH) begin
        dmem[idx] <= dmem_wdata;
      end
    end
  end

  // ============================================================
  // Memory Initialization (for simulation)
  // ============================================================

  `ifdef SIMULATION
  // Initialize memories to zero
  initial begin
    for (int i = 0; i < IMEM_DEPTH; i++)
      imem[i] = TRIT9_ZERO;
    for (int i = 0; i < DMEM_DEPTH; i++)
      dmem[i] = TRIT27_ZERO;
  end

  // Task to load instruction memory from an array
  // Note: Icarus Verilog has limited support for unpacked-array ports in tasks.
  // Most of our testbenches initialize imem[] directly instead.
  `ifdef __ICARUS__
  task load_program(input int size);
    $display("[MEM] load_program(array) unsupported under Icarus; initialize imem[] directly (size=%0d)", size);
  endtask
  `else
  task load_program(input trit_t [8:0] program [0:IMEM_DEPTH-1], input int size);
    for (int i = 0; i < size && i < IMEM_DEPTH; i++) begin
      imem[i] = program[i];
    end
    $display("[MEM] Loaded %0d instructions", size);
  endtask
  `endif

  // Task to write data memory
  task write_data(input int addr, input trit_t [TRIT_WIDTH-1:0] data);
    if (addr >= 0 && addr < DMEM_DEPTH) begin
      dmem[addr] = data;
    end
  endtask

  // Task to read and display data memory
  task display_dmem(input int start_addr, input int count);
    $display("=== Data Memory ===");
    for (int i = start_addr; i < start_addr + count && i < DMEM_DEPTH; i++) begin
      $display("DMEM[%0d] = %0d", i, ternary_to_bin(dmem[i]));
    end
  endtask
  `endif

endmodule
