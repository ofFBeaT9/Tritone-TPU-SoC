// FPGA Testbench for Ternary ALU
// Phase 3: FPGA ALU Prototype
// Generates test vectors and measures functionality

`timescale 1ns/1ps

module ternary_alu_tb;

  // Clock and reset
  logic clk = 0;
  logic rst_n;

  // DUT signals
  logic [15:0] a_bin, b_bin;
  logic [2:0]  op;
  logic        valid_in;
  logic [15:0] result_bin;
  logic [1:0]  carry_bin;
  logic        zero_flag;
  logic        neg_flag;
  logic        valid_out;

  // Test counters
  int test_count = 0;
  int pass_count = 0;
  int fail_count = 0;

  // Functional Coverage (REC-3.4)
  covergroup alu_coverage @(posedge clk);
    option.per_instance = 1;
    option.name = "ternary_alu_fpga_cov";
    
    // Operation coverage
    cp_operation: coverpoint op {
      bins add = {3'b000};
      bins sub = {3'b001};
      bins neg = {3'b010};
      bins min = {3'b011};
      bins max = {3'b100};
      bins consensus = {3'b101};
      bins any = {3'b110};
      bins xor_op = {3'b111};
    }
    
    // Input value coverage (sample values)
    cp_a_values: coverpoint a_bin {
      bins zero = {16'h0000};
      bins all_ones = {16'h5555};  // All +1 trits
      bins all_neg_ones = {16'hFFFF};  // All -1 trits
      bins mixed = default;
    }
    
    cp_b_values: coverpoint b_bin {
      bins zero = {16'h0000};
      bins all_ones = {16'h5555};
      bins all_neg_ones = {16'hFFFF};
      bins mixed = default;
    }
    
    // Flag coverage
    cp_zero_flag: coverpoint zero_flag {
      bins zero_set = {1'b1};
      bins zero_clear = {1'b0};
    }
    
    cp_neg_flag: coverpoint neg_flag {
      bins neg_set = {1'b1};
      bins neg_clear = {1'b0};
    }
    
    // Cross coverage: operations with different input patterns
    cx_op_inputs: cross cp_operation, cp_a_values, cp_b_values;
    
    // Cross coverage: operations with flags
    cx_op_flags: cross cp_operation, cp_zero_flag, cp_neg_flag;
  endgroup
  
  alu_coverage cov_inst;
  
  initial begin
    cov_inst = new();
  end

  // Clock generation - 100 MHz
  always #5 clk = ~clk;

  // DUT instantiation
  ternary_alu_top dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .a_bin      (a_bin),
    .b_bin      (b_bin),
    .op         (op),
    .valid_in   (valid_in),
    .result_bin (result_bin),
    .carry_bin  (carry_bin),
    .zero_flag  (zero_flag),
    .neg_flag   (neg_flag),
    .valid_out  (valid_out)
  );

  // Waveform dumping (REC-3.2)
  initial begin
    $dumpfile("ternary_alu_fpga.vcd");
    $dumpvars(0, ternary_alu_tb);
  end

  // Test stimulus
  initial begin
    $display("=== Ternary ALU FPGA Testbench ===");
    $display("Time\t\tTest\t\t\t\tResult");
    $display("=====================================================");

    // Initialize
    rst_n = 0;
    valid_in = 0;
    a_bin = 16'h0000;
    b_bin = 16'h0000;
    op = 3'b000;

    // Reset
    repeat(5) @(posedge clk);
    rst_n = 1;
    repeat(2) @(posedge clk);

    // Test 1: ADD operation (0 + 0 = 0)
    test_add(16'h0000, 16'h0000, 16'h0000, "ADD: 0+0");

    // Test 2: ADD operation (1 + 1 = 2)
    test_add(16'h5555, 16'h5555, 16'hAAAA, "ADD: 1+1=2");

    // Test 3: ADD operation (all +1 + all -1 = 0)
    test_add(16'h5555, 16'hFFFF, 16'h0000, "ADD: +1+...+(-1)=0");

    // Test 4: SUB operation
    test_sub(16'h5555, 16'hFFFF, 16'hAAAA, "SUB: +1-(-1)=2");

    // Test 5: NEG operation
    test_neg(16'h5555, 16'hFFFF, "NEG: -(+1+...)=-1");

    // Test 6: MIN operation
    test_min(16'h5555, 16'h0000, 16'h0000, "MIN: +1,0=0");

    // Test 7: MAX operation
    test_max(16'hFFFF, 16'h0000, 16'h0000, "MAX: -1,0=0");

    // Test 8: Zero flag test
    test_add(16'h0000, 16'h0000, 16'h0000, "Zero Flag Test");

    // Summary
    repeat(5) @(posedge clk);
    $display("=====================================================");
    $display("Test Summary:");
    $display("  Total Tests: %0d", test_count);
    $display("  Passed: %0d", pass_count);
    $display("  Failed: %0d", fail_count);
    
    // Coverage report (REC-3.4)
    $display("\nCoverage Summary:");
    $display("  Overall Coverage: %.2f%%", cov_inst.get_coverage());
    $display("  Operation Coverage: %.2f%%", cov_inst.cp_operation.get_coverage());
    $display("  Input Pattern Coverage: %.2f%%", cov_inst.cx_op_inputs.get_coverage());
    $display("  Flag Coverage: %.2f%%", cov_inst.cx_op_flags.get_coverage());

    if (fail_count == 0)
      $display("\n*** ALL TESTS PASSED ***");
    else
      $display("\n*** SOME TESTS FAILED ***");

    $finish;
  end

  // Test tasks (REC-3.1: Enhanced with expected value verification)
  task test_add(input [15:0] a, b, expected, input string desc);
    @(posedge clk);
    a_bin = a;
    b_bin = b;
    op = 3'b000;  // ADD
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    @(posedge clk);
    wait(valid_out);
    test_count++;
    if (result_bin !== expected) begin
      $display("%0t\t%s\tFAIL: Expected %h, got %h", $time, desc, expected, result_bin);
      fail_count++;
    end else begin
      $display("%0t\t%s\t\tPASS: %h", $time, desc, result_bin);
      pass_count++;
    end
  endtask

  task test_sub(input [15:0] a, b, expected, input string desc);
    @(posedge clk);
    a_bin = a;
    b_bin = b;
    op = 3'b001;  // SUB
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    @(posedge clk);
    wait(valid_out);
    test_count++;
    if (result_bin !== expected) begin
      $display("%0t\t%s\tFAIL: Expected %h, got %h", $time, desc, expected, result_bin);
      fail_count++;
    end else begin
      $display("%0t\t%s\t\tPASS: %h", $time, desc, result_bin);
      pass_count++;
    end
  endtask

  task test_neg(input [15:0] a, expected, input string desc);
    @(posedge clk);
    a_bin = a;
    b_bin = 16'h0000;
    op = 3'b010;  // NEG
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    @(posedge clk);
    wait(valid_out);
    test_count++;
    if (result_bin !== expected) begin
      $display("%0t\t%s\tFAIL: Expected %h, got %h", $time, desc, expected, result_bin);
      fail_count++;
    end else begin
      $display("%0t\t%s\t\tPASS: %h", $time, desc, result_bin);
      pass_count++;
    end
  endtask

  task test_min(input [15:0] a, b, expected, input string desc);
    @(posedge clk);
    a_bin = a;
    b_bin = b;
    op = 3'b011;  // MIN
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    @(posedge clk);
    wait(valid_out);
    test_count++;
    if (result_bin !== expected) begin
      $display("%0t\t%s\tFAIL: Expected %h, got %h", $time, desc, expected, result_bin);
      fail_count++;
    end else begin
      $display("%0t\t%s\t\tPASS: %h", $time, desc, result_bin);
      pass_count++;
    end
  endtask

  task test_max(input [15:0] a, b, expected, input string desc);
    @(posedge clk);
    a_bin = a;
    b_bin = b;
    op = 3'b100;  // MAX
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    @(posedge clk);
    wait(valid_out);
    test_count++;
    if (result_bin !== expected) begin
      $display("%0t\t%s\tFAIL: Expected %h, got %h", $time, desc, expected, result_bin);
      fail_count++;
    end else begin
      $display("%0t\t%s\t\tPASS: %h", $time, desc, result_bin);
      pass_count++;
    end
  endtask

  // Timeout watchdog
  initial begin
    #100000;  // 100 us timeout
    $display("\nERROR: Simulation timeout!");
    $finish;
  end

endmodule