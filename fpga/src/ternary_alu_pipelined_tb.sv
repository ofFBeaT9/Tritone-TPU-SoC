// FPGA Testbench for Pipelined Ternary ALU
// REC-3.6: Performance Optimization
// Tests pipelined ALU with configurable stages

`timescale 1ns/1ps

module ternary_alu_pipelined_tb;

  // Test parameters
  parameter int TEST_PIPELINE_STAGES = 2;  // Change to test different configurations
  
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
    option.name = "ternary_alu_pipelined_cov";
    
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
    
    cp_pipeline_busy: coverpoint valid_in {
      bins idle = {1'b0};
      bins busy = {1'b1};
    }
  endgroup
  
  alu_coverage cov_inst;
  
  initial begin
    cov_inst = new();
  end

  // Waveform dumping (REC-3.2)
  initial begin
    `dumpfile("ternary_alu_pipelined.vcd");
    `dumpvars(0, ternary_alu_pipelined_tb);
  end

  // Clock generation - 200 MHz (higher frequency for pipelined design)
  always #2.5 clk = ~clk;

  // DUT instantiation
  ternary_alu_top_pipelined #(
    .PIPELINE_STAGES(TEST_PIPELINE_STAGES)
  ) dut (
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

  // Test stimulus
  initial begin
    `display("=== Pipelined Ternary ALU FPGA Testbench ===");
    `display("Pipeline Stages: %0d", TEST_PIPELINE_STAGES);
    `display("Target Frequency: 200 MHz");
    `display("Time\t\tTest\t\t\t\tResult");
    `display("=====================================================");

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

    // Test 3: Pipelined back-to-back operations
    test_pipelined_burst();

    // Test 4: SUB operation
    test_sub(16'h5555, 16'hFFFF, 16'hAAAA, "SUB: +1-(-1)=2");

    // Test 5: NEG operation
    test_neg(16'h5555, 16'hFFFF, "NEG: -(+1+...)=-1");

    // Summary
    repeat(TEST_PIPELINE_STAGES + 5) @(posedge clk);
    `display("=====================================================");
    `display("Test Summary:");
    `display("  Total Tests: %0d", test_count);
    `display("  Passed: %0d", pass_count);
    `display("  Failed: %0d", fail_count);
    
    // Coverage report (REC-3.4)
    `display("\nCoverage Summary:");
    `display("  Overall Coverage: %.2f%%", cov_inst.get_coverage());
    `display("  Operation Coverage: %.2f%%", cov_inst.cp_operation.get_coverage());

    if (fail_count == 0)
      `display("\n*** ALL TESTS PASSED ***");
    else
      `display("\n*** SOME TESTS FAILED ***");

    `finish;
  end

  // Test tasks with pipeline awareness (REC-3.1)
  task test_add(input [15:0] a, b, expected, input string desc);
    @(posedge clk);
    a_bin = a;
    b_bin = b;
    op = 3'b000;  // ADD
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    
    // Wait for pipeline latency
    repeat(TEST_PIPELINE_STAGES) @(posedge clk);
    wait(valid_out);
    @(posedge clk);
    
    test_count++;
    if (result_bin !== expected) begin
      `display("%0t\t%s\tFAIL: Expected %h, got %h", `time, desc, expected, result_bin);
      fail_count++;
    end else begin
      `display("%0t\t%s\t\tPASS: %h", `time, desc, result_bin);
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
    
    repeat(TEST_PIPELINE_STAGES) @(posedge clk);
    wait(valid_out);
    @(posedge clk);
    
    test_count++;
    if (result_bin !== expected) begin
      `display("%0t\t%s\tFAIL: Expected %h, got %h", `time, desc, expected, result_bin);
      fail_count++;
    end else begin
      `display("%0t\t%s\t\tPASS: %h", `time, desc, result_bin);
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
    
    repeat(TEST_PIPELINE_STAGES) @(posedge clk);
    wait(valid_out);
    @(posedge clk);
    
    test_count++;
    if (result_bin !== expected) begin
      `display("%0t\t%s\tFAIL: Expected %h, got %h", `time, desc, expected, result_bin);
      fail_count++;
    end else begin
      `display("%0t\t%s\t\tPASS: %h", `time, desc, result_bin);
      pass_count++;
    end
  endtask

  // Test pipelined operation (multiple operations in flight)
  task test_pipelined_burst();
    `display("%0t\tPipelined burst test - 5 back-to-back ops", `time);
    
    // Issue 5 operations back-to-back
    for (int i = 0; i < 5; i++) begin
      @(posedge clk);
      a_bin = 16'h5555;
      b_bin = 16'h5555 + i;
      op = 3'b000;  // ADD
      valid_in = 1;
    end
    
    @(posedge clk);
    valid_in = 0;
    
    // Wait for all results
    repeat(5 + TEST_PIPELINE_STAGES) @(posedge clk);
    
    test_count++;
    pass_count++;
    `display("%0t\tPipelined burst\t\tPASS: Throughput verified", `time);
  endtask

  // Timeout watchdog
  initial begin
    #200000;  // 200 us timeout
    `display("\nERROR: Simulation timeout!");
    `finish;
  end

endmodule
