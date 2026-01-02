// Ternary CPU Testbench
// Tests the complete BTISA CPU with instruction and data memory

`timescale 1ns/1ps

module tb_ternary_cpu;

  import ternary_pkg::*;

  // Parameters
  localparam int TRIT_WIDTH = 27;
  localparam int IMEM_DEPTH = 243;
  localparam int DMEM_DEPTH = 729;
  localparam int CLK_PERIOD = 10;

  // Signals
  logic clk;
  logic rst_n;

  // Instruction memory interface
  trit_t [7:0]            imem_addr;
  trit_t [8:0]            imem_data;

  // Data memory interface
  trit_t [8:0]            dmem_addr;
  trit_t [TRIT_WIDTH-1:0] dmem_wdata;
  trit_t [TRIT_WIDTH-1:0] dmem_rdata;
  logic                   dmem_we;
  logic                   dmem_re;

  // Status
  logic                   halted;
  trit_t [7:0]            pc_out;
  logic                   valid_out;

  // Debug ports
  logic [3:0]             dbg_reg_idx;
  trit_t [TRIT_WIDTH-1:0] dbg_reg_data;
  logic                   stall_out;
  logic                   fwd_a_out;
  logic                   fwd_b_out;

  // Memory arrays
  trit_t [8:0]            imem [IMEM_DEPTH];
  trit_t [TRIT_WIDTH-1:0] dmem [DMEM_DEPTH];

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // DUT instantiation
  ternary_cpu #(
    .TRIT_WIDTH (TRIT_WIDTH),
    .IMEM_DEPTH (IMEM_DEPTH),
    .DMEM_DEPTH (DMEM_DEPTH)
  ) dut (
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
    .valid_out    (valid_out),
    .dbg_reg_idx  (dbg_reg_idx),
    .dbg_reg_data (dbg_reg_data),
    .stall_out    (stall_out),
    .fwd_a_out    (fwd_a_out),
    .fwd_b_out    (fwd_b_out)
  );

  // Instruction memory read
  always_comb begin
    int idx;
    idx = trit8_to_int(imem_addr);
    if (idx >= 0 && idx < IMEM_DEPTH)
      imem_data = imem[idx];
    else
      imem_data = TRIT9_ZERO;  // NOP
  end

  // Data memory read/write
  always_ff @(posedge clk) begin
    int idx;
    idx = trit9_to_int(dmem_addr);
    if (dmem_we && idx >= 0 && idx < DMEM_DEPTH) begin
      dmem[idx] <= dmem_wdata;
      $display("[MEM] Write: Addr=%0d Data=%0d", idx, ternary_to_bin(dmem_wdata));
    end
  end

  always_comb begin
    int idx;
    idx = trit9_to_int(dmem_addr);
    if (idx >= 0 && idx < DMEM_DEPTH)
      dmem_rdata = dmem[idx];
    else
      dmem_rdata = TRIT27_ZERO;
  end

  // Helper functions
  function automatic int trit8_to_int(trit_t [7:0] val);
    int result, power3, i;
    result = 0;
    power3 = 1;
    for (i = 0; i < 8; i++) begin
      case (val[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  function automatic int trit9_to_int(trit_t [8:0] val);
    int result, power3, i;
    result = 0;
    power3 = 1;
    for (i = 0; i < 9; i++) begin
      case (val[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // Encode instruction helper
  // Format: opcode[8:6], rd[5:4], rs1[3:2], rs2/imm[1:0]
  function automatic trit_t [8:0] encode_instr(
    trit_t [2:0] opcode,
    trit_t [1:0] rd,
    trit_t [1:0] rs1,
    trit_t [1:0] rs2_imm
  );
    trit_t [8:0] instr;
    instr[8:6] = opcode;
    instr[5:4] = rd;
    instr[3:2] = rs1;
    instr[1:0] = rs2_imm;
    return instr;
  endfunction

  // Opcode constants
  localparam trit_t [2:0] OP_ADD  = {T_ZERO, T_ZERO, T_ZERO};       // 000
  localparam trit_t [2:0] OP_SUB  = {T_ZERO, T_ZERO, T_POS_ONE};    // 00+
  localparam trit_t [2:0] OP_NEG  = {T_ZERO, T_ZERO, T_NEG_ONE};    // 00-
  localparam trit_t [2:0] OP_SHL  = {T_ZERO, T_POS_ONE, T_POS_ONE}; // 0++
  localparam trit_t [2:0] OP_SHR  = {T_ZERO, T_POS_ONE, T_NEG_ONE}; // 0+-
  localparam trit_t [2:0] OP_MIN  = {T_POS_ONE, T_ZERO, T_ZERO};    // +00
  localparam trit_t [2:0] OP_MAX  = {T_POS_ONE, T_ZERO, T_POS_ONE}; // +0+
  localparam trit_t [2:0] OP_LD   = {T_NEG_ONE, T_ZERO, T_ZERO};    // -00
  localparam trit_t [2:0] OP_ST   = {T_NEG_ONE, T_ZERO, T_POS_ONE}; // -0+
  localparam trit_t [2:0] OP_NOP  = {T_NEG_ONE, T_NEG_ONE, T_ZERO}; // --0
  localparam trit_t [2:0] OP_HALT = {T_NEG_ONE, T_NEG_ONE, T_POS_ONE}; // --+

  // Register address constants
  localparam trit_t [1:0] R0 = {T_ZERO, T_ZERO};      // 00
  localparam trit_t [1:0] R1 = {T_ZERO, T_POS_ONE};   // 0+
  localparam trit_t [1:0] R2 = {T_ZERO, T_NEG_ONE};   // 0-
  localparam trit_t [1:0] R3 = {T_POS_ONE, T_ZERO};   // +0
  localparam trit_t [1:0] R4 = {T_POS_ONE, T_POS_ONE}; // ++

  // Immediate constants
  localparam trit_t [1:0] IMM_0  = {T_ZERO, T_ZERO};     // 0
  localparam trit_t [1:0] IMM_1  = {T_ZERO, T_POS_ONE};  // +1
  localparam trit_t [1:0] IMM_N1 = {T_ZERO, T_NEG_ONE};  // -1

  // Test sequence
  initial begin
    $display("===========================================");
    $display("=== Balanced Ternary CPU Testbench ===");
    $display("===========================================");

    // Initialize debug port
    dbg_reg_idx = 0;

    // Initialize memories
    for (int i = 0; i < IMEM_DEPTH; i++) imem[i] = TRIT9_ZERO;
    for (int i = 0; i < DMEM_DEPTH; i++) dmem[i] = TRIT27_ZERO;

    // Load test program
    // Program: Arithmetic test with immediate values
    // Note: With current decoder, ADD uses immediate mode (alu_src=1)
    // so rs2_imm is treated as a sign-extended 2-trit immediate (-4 to +4)
    //
    // R1 = R0 + 1  (R1 = 1)   - immediate = +1
    // R2 = R1 + 1  (R2 = 2)   - immediate = +1
    // R3 = R2 + 1  (R3 = 3)   - immediate = +1
    // R4 = R3 + 1  (R4 = 4)   - immediate = +1
    // HALT

    $display("\n--- Loading Test Program ---");

    // Instruction 0: ADD R1, R0, 1 (R1 = 0 + 1 = 1)
    imem[0] = encode_instr(OP_ADD, R1, R0, IMM_1);
    $display("IMEM[0]: ADD R1, R0, 1");

    // Instruction 1: ADD R2, R1, 1 (R2 = 1 + 1 = 2)
    imem[1] = encode_instr(OP_ADD, R2, R1, IMM_1);
    $display("IMEM[1]: ADD R2, R1, 1");

    // Instruction 2: ADD R3, R2, 1 (R3 = 2 + 1 = 3)
    imem[2] = encode_instr(OP_ADD, R3, R2, IMM_1);
    $display("IMEM[2]: ADD R3, R2, 1");

    // Instruction 3: ADD R4, R3, 1 (R4 = 3 + 1 = 4)
    imem[3] = encode_instr(OP_ADD, R4, R3, IMM_1);
    $display("IMEM[3]: ADD R4, R3, 1");

    // Instruction 4: NOP
    imem[4] = encode_instr(OP_NOP, R0, R0, IMM_0);
    $display("IMEM[4]: NOP");

    // Instruction 5: HALT
    imem[5] = encode_instr(OP_HALT, R0, R0, IMM_0);
    $display("IMEM[5]: HALT");

    $display("\n--- Starting Simulation ---\n");

    // Reset
    rst_n = 0;
    #(CLK_PERIOD * 5);
    rst_n = 1;
    $display("[TB] Reset released at time %0t", $time);

    // Run until halt or timeout
    fork
      begin
        wait(halted);
        $display("\n[TB] CPU halted at time %0t", $time);
      end
      begin
        #(CLK_PERIOD * 100);
        $display("\n[TB] TIMEOUT at time %0t", $time);
      end
    join_any
    disable fork;

    // Wait a few more cycles for pipeline to drain
    #(CLK_PERIOD * 5);

    // Display final state
    $display("\n===========================================");
    $display("=== Final CPU State ===");
    $display("===========================================");
    $display("PC = %0d", trit8_to_int(pc_out));
    $display("Halted = %0d", halted);

    // Verify register values using debug port
    $display("\n--- Register Verification ---");
    verify_register(1, 1, "R1 = 1");
    verify_register(2, 2, "R2 = 2");
    verify_register(3, 3, "R3 = 3");
    verify_register(4, 4, "R4 = 4");

    $display("\n===========================================");
    $display("=== Test Complete ===");
    $display("===========================================");

    $finish;
  end

  // Task to verify register value
  task automatic verify_register(
    input int reg_num,
    input int expected_val,
    input string msg
  );
    int actual_val;
    dbg_reg_idx = reg_num[3:0];
    #1;  // Allow combinational logic to settle
    actual_val = ternary_to_bin(dbg_reg_data);
    if (actual_val == expected_val) begin
      $display("[PASS] %s: Expected=%0d, Got=%0d", msg, expected_val, actual_val);
    end else begin
      $display("[FAIL] %s: Expected=%0d, Got=%0d", msg, expected_val, actual_val);
    end
  endtask

  // Performance counters
  int cycle_count;
  int instruction_count;
  int stall_count;
  int forward_count;
  real cpi;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cycle_count <= 0;
      instruction_count <= 0;
      stall_count <= 0;
      forward_count <= 0;
    end else begin
      cycle_count <= cycle_count + 1;
      
      // Count instructions (when valid and not stalled)
      if (valid_out && !stall_out)
        instruction_count <= instruction_count + 1;
      
      // Count stalls
      if (stall_out)
        stall_count <= stall_count + 1;
      
      // Count forwarding events
      if (fwd_a_out || fwd_b_out)
        forward_count <= forward_count + 1;
    end
  end

  // Calculate and display performance metrics when halted
  always @(posedge halted) begin
    #1;  // Wait for counters to settle
    if (instruction_count > 0)
      cpi = real'(cycle_count) / real'(instruction_count);
    else
      cpi = 0.0;
    
    $display("\n===========================================");
    $display("=== Performance Metrics ===");
    $display("===========================================");
    $display("Total Cycles:       %0d", cycle_count);
    $display("Instructions:       %0d", instruction_count);
    $display("Stall Cycles:       %0d (%.1f%%)", stall_count, 
             100.0 * real'(stall_count) / real'(cycle_count));
    $display("Forward Events:     %0d", forward_count);
    $display("CPI:                %.3f", cpi);
    $display("IPC:                %.3f", 1.0/cpi);
    $display("===========================================");
  end

  // Debug output each cycle
  always_ff @(posedge clk) begin
    if (rst_n && !halted) begin
      $display("[Cycle %0d] PC=%0d Valid=%0d Stall=%0d Fwd=%0d",
               cycle_count, trit8_to_int(pc_out), valid_out, stall_out, 
               fwd_a_out || fwd_b_out);
    end
  end

endmodule
