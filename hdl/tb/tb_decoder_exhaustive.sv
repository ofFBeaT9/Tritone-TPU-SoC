// Exhaustive BTISA Decoder Testbench
// Tests all 19,683 instruction combinations against golden model
//
// Usage:
//   1. Generate test vectors: python tools/scripts/generate_decoder_tests.py
//   2. Compile: iverilog -g2012 -I rtl -o build/tb_decoder rtl/ternary_pkg.sv rtl/btisa_decoder.sv tb/tb_decoder_exhaustive.sv
//   3. Run: vvp build/tb_decoder
//
// BTISA v0.2 - All 27 opcodes unique

`timescale 1ns/1ps

module tb_decoder_exhaustive;
  import ternary_pkg::*;

  // Test vector file
  parameter string TEST_VECTOR_FILE = "decoder_test_vectors.txt";

  // DUT signals
  trit_t [8:0] instruction;
  trit_t [2:0] opcode;
  trit_t [1:0] rd, rs1, rs2_imm;
  logic        reg_write, mem_read, mem_write;
  logic        branch, jump, alu_src, halt, lui;
  logic [1:0]  branch_type;
  logic [2:0]  alu_op;

  // Test counters
  int test_count = 0;
  int pass_count = 0;
  int fail_count = 0;

  // Instantiate DUT
  btisa_decoder dut (
    .instruction (instruction),
    .opcode      (opcode),
    .rd          (rd),
    .rs1         (rs1),
    .rs2_imm     (rs2_imm),
    .reg_write   (reg_write),
    .mem_read    (mem_read),
    .mem_write   (mem_write),
    .branch      (branch),
    .branch_type (branch_type),
    .jump        (jump),
    .alu_src     (alu_src),
    .alu_op      (alu_op),
    .halt        (halt),
    .lui         (lui)
  );

  // Convert 18-bit instruction word to 9-trit array
  // Instruction format: [17:12]=opcode, [11:8]=rd, [7:4]=rs1, [3:0]=rs2_imm
  // Each trit is 2 bits
  function automatic void set_instruction(input logic [17:0] instr_word);
    // Opcode [8:6]
    instruction[8] = trit_t'(instr_word[17:16]);
    instruction[7] = trit_t'(instr_word[15:14]);
    instruction[6] = trit_t'(instr_word[13:12]);
    // Rd [5:4]
    instruction[5] = trit_t'(instr_word[11:10]);
    instruction[4] = trit_t'(instr_word[9:8]);
    // Rs1 [3:2]
    instruction[3] = trit_t'(instr_word[7:6]);
    instruction[2] = trit_t'(instr_word[5:4]);
    // Rs2/Imm [1:0]
    instruction[1] = trit_t'(instr_word[3:2]);
    instruction[0] = trit_t'(instr_word[1:0]);
  endfunction

  // Trit to string for debug output
  function automatic string trit_to_str(trit_t t);
    case (t)
      T_ZERO:    return "0";
      T_POS_ONE: return "+";
      T_NEG_ONE: return "-";
      default:   return "X";
    endcase
  endfunction

  // Format instruction as trit string
  function automatic string instr_to_str(trit_t [8:0] instr);
    string s = "";
    for (int i = 8; i >= 0; i--) begin
      s = {s, trit_to_str(instr[i])};
      if (i == 6 || i == 4 || i == 2) s = {s, " "};
    end
    return s;
  endfunction

  // Main test logic
  initial begin
    // Variables for parsing test vectors
    int fd;
    int scan_ret;
    string line;
    logic [17:0] instr_word;
    logic exp_reg_write, exp_mem_read, exp_mem_write;
    logic exp_branch, exp_jump, exp_alu_src, exp_halt, exp_lui;
    logic [1:0] exp_branch_type;
    logic [2:0] exp_alu_op;

    $display("=== BTISA Decoder Exhaustive Test ===");
    $display("BTISA v0.2 - All 27 opcodes unique");
    $display("");

    // Try to open test vector file
    fd = $fopen(TEST_VECTOR_FILE, "r");
    if (fd == 0) begin
      $display("ERROR: Could not open test vector file: %s", TEST_VECTOR_FILE);
      $display("Generate it with: python tools/scripts/generate_decoder_tests.py");
      $finish;
    end

    $display("Reading test vectors from: %s", TEST_VECTOR_FILE);
    $display("");

    // Read and process each line
    while (!$feof(fd)) begin
      // Read line
      scan_ret = $fgets(line, fd);
      if (scan_ret == 0) continue;

      // Skip comment lines and empty lines
      if (line[0] == "#" || line.len() < 10) continue;

      // Parse test vector
      // Format: INSTR REG_WR MEM_RD MEM_WR BR BR_TYPE JMP ALU_SRC ALU_OP HALT LUI
      scan_ret = $sscanf(line, "%x %b %b %b %b %b %b %b %b %b %b",
                         instr_word,
                         exp_reg_write, exp_mem_read, exp_mem_write,
                         exp_branch, exp_branch_type,
                         exp_jump, exp_alu_src, exp_alu_op,
                         exp_halt, exp_lui);

      if (scan_ret != 11) continue;  // Skip malformed lines

      // Apply instruction to DUT
      set_instruction(instr_word);
      #1;  // Allow combinational logic to settle

      test_count++;

      // Compare outputs
      if (reg_write   !== exp_reg_write ||
          mem_read    !== exp_mem_read ||
          mem_write   !== exp_mem_write ||
          branch      !== exp_branch ||
          branch_type !== exp_branch_type ||
          jump        !== exp_jump ||
          alu_src     !== exp_alu_src ||
          alu_op      !== exp_alu_op ||
          halt        !== exp_halt ||
          lui         !== exp_lui) begin

        fail_count++;

        // Report first 10 failures in detail
        if (fail_count <= 10) begin
          $display("FAIL [%0d]: Instr=%05X (%s)", test_count, instr_word, instr_to_str(instruction));
          $display("  reg_write:   got=%b exp=%b %s", reg_write, exp_reg_write, reg_write !== exp_reg_write ? "MISMATCH" : "");
          $display("  mem_read:    got=%b exp=%b %s", mem_read, exp_mem_read, mem_read !== exp_mem_read ? "MISMATCH" : "");
          $display("  mem_write:   got=%b exp=%b %s", mem_write, exp_mem_write, mem_write !== exp_mem_write ? "MISMATCH" : "");
          $display("  branch:      got=%b exp=%b %s", branch, exp_branch, branch !== exp_branch ? "MISMATCH" : "");
          $display("  branch_type: got=%02b exp=%02b %s", branch_type, exp_branch_type, branch_type !== exp_branch_type ? "MISMATCH" : "");
          $display("  jump:        got=%b exp=%b %s", jump, exp_jump, jump !== exp_jump ? "MISMATCH" : "");
          $display("  alu_src:     got=%b exp=%b %s", alu_src, exp_alu_src, alu_src !== exp_alu_src ? "MISMATCH" : "");
          $display("  alu_op:      got=%03b exp=%03b %s", alu_op, exp_alu_op, alu_op !== exp_alu_op ? "MISMATCH" : "");
          $display("  halt:        got=%b exp=%b %s", halt, exp_halt, halt !== exp_halt ? "MISMATCH" : "");
          $display("  lui:         got=%b exp=%b %s", lui, exp_lui, lui !== exp_lui ? "MISMATCH" : "");
          $display("");
        end
      end else begin
        pass_count++;
      end

      // Progress indicator every 5000 tests
      if (test_count % 5000 == 0) begin
        $display("Progress: %0d tests completed, %0d passed, %0d failed",
                 test_count, pass_count, fail_count);
      end
    end

    $fclose(fd);

    // Summary
    $display("");
    $display("=== Test Summary ===");
    $display("Total tests:  %0d", test_count);
    $display("Passed:       %0d", pass_count);
    $display("Failed:       %0d", fail_count);
    $display("");

    if (fail_count == 0) begin
      $display("*** ALL TESTS PASSED ***");
      $display("Decoder correctly handles all 19,683 instruction combinations.");
    end else begin
      $display("*** TEST FAILED ***");
      $display("%0d mismatches detected between RTL and golden model.", fail_count);
    end

    $display("");
    $finish;
  end

endmodule
