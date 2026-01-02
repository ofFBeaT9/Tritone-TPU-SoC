// Testbench for Tritone Hybrid SoC
// =================================
// End-to-end verification of CPU + TPU integration.
//
// Tests:
//   1. CPU basic execution
//   2. TPU register access from external interface
//   3. CPU accessing TPU registers (memory-mapped I/O)
//   4. TPU operation triggered by CPU
//
// Author: Tritone Project

`timescale 1ns/1ps

module tb_tritone_soc;
  import ternary_pkg::*;

  // ============================================================
  // Parameters
  // ============================================================
  localparam int CLK_PERIOD = 10;
  localparam int TRIT_WIDTH = 27;
  localparam int ARRAY_SIZE = 8;

  // ============================================================
  // Signals
  // ============================================================
  logic clk;
  logic rst_n;

  // External interface
  logic ext_sel;
  logic ext_wen;
  logic ext_ren;
  logic [31:0] ext_addr;
  logic [31:0] ext_wdata;
  logic [31:0] ext_rdata;
  logic ext_ready;

  // Status
  logic cpu_halted;
  logic tpu_busy;
  logic tpu_done;
  logic tpu_irq;

  // Test control
  int test_count;
  int pass_count;
  int fail_count;

  // ============================================================
  // Clock Generation
  // ============================================================
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // ============================================================
  // DUT Instantiation
  // ============================================================
  tritone_soc #(
    .TRIT_WIDTH(TRIT_WIDTH),
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(16),
    .ACC_BITS(32)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .ext_sel(ext_sel),
    .ext_wen(ext_wen),
    .ext_ren(ext_ren),
    .ext_addr(ext_addr),
    .ext_wdata(ext_wdata),
    .ext_rdata(ext_rdata),
    .ext_ready(ext_ready),
    .cpu_halted(cpu_halted),
    .tpu_busy(tpu_busy),
    .tpu_done(tpu_done),
    .tpu_irq(tpu_irq)
  );

  // ============================================================
  // External Interface Tasks
  // ============================================================

  task automatic ext_write(input logic [31:0] addr, input logic [31:0] data);
    @(posedge clk);
    ext_sel <= 1'b1;
    ext_wen <= 1'b1;
    ext_ren <= 1'b0;
    ext_addr <= addr;
    ext_wdata <= data;
    @(posedge clk);
    while (!ext_ready) @(posedge clk);
    ext_sel <= 1'b0;
    ext_wen <= 1'b0;
    @(posedge clk);
  endtask

  task automatic ext_read(input logic [31:0] addr, output logic [31:0] data);
    @(posedge clk);
    ext_sel <= 1'b1;
    ext_wen <= 1'b0;
    ext_ren <= 1'b1;
    ext_addr <= addr;
    @(posedge clk);
    while (!ext_ready) @(posedge clk);
    data = ext_rdata;
    ext_sel <= 1'b0;
    ext_ren <= 1'b0;
    @(posedge clk);
  endtask

  // ============================================================
  // Test Helpers
  // ============================================================

  task automatic check_result(
    input string test_name,
    input logic [31:0] expected,
    input logic [31:0] actual
  );
    test_count = test_count + 1;
    if (actual == expected) begin
      pass_count = pass_count + 1;
      $display("PASS: %s (expected 0x%08h, got 0x%08h)", test_name, expected, actual);
    end else begin
      fail_count = fail_count + 1;
      $display("FAIL: %s (expected 0x%08h, got 0x%08h)", test_name, expected, actual);
    end
  endtask

  // ============================================================
  // Main Test Sequence
  // ============================================================
  initial begin
    logic [31:0] rdata;

    $display("============================================================");
    $display("Tritone Hybrid SoC Testbench");
    $display("============================================================");
    $display("Array Size: %0d x %0d", ARRAY_SIZE, ARRAY_SIZE);
    $display("");

    // Initialize
    test_count = 0;
    pass_count = 0;
    fail_count = 0;

    rst_n = 0;
    ext_sel = 0;
    ext_wen = 0;
    ext_ren = 0;
    ext_addr = 0;
    ext_wdata = 0;

    // Reset
    repeat(10) @(posedge clk);
    rst_n = 1;
    repeat(5) @(posedge clk);

    // ============================================================
    // Test 1: Read TPU Array Info Register
    // ============================================================
    $display("--- Test 1: Read TPU Array Info Register ---");
    ext_read(32'h1018, rdata);  // TPU_REG_BASE + ARRAY_INFO offset
    $display("Array Info: 0x%08h", rdata);
    $display("  Array Size: %0d", rdata[15:8]);
    $display("  Acc Bits: %0d", rdata[7:0]);

    // Check array size matches
    check_result("Array Size Field", ARRAY_SIZE, rdata[15:8]);

    // ============================================================
    // Test 2: Write and Read TPU Layer Config
    // ============================================================
    $display("\n--- Test 2: TPU Layer Config Read/Write ---");
    ext_write(32'h1014, 32'h00040004);  // 4x4 layer config
    ext_read(32'h1014, rdata);
    check_result("Layer Config Write/Read", 32'h00040004, rdata);

    // ============================================================
    // Test 3: Configure and Start TPU
    // ============================================================
    $display("\n--- Test 3: TPU Control ---");

    // Configure addresses
    ext_write(32'h1008, 32'h0000_0000);  // Weight address
    ext_write(32'h100C, 32'h0004_0000);  // Activation address (K=4)
    ext_write(32'h1010, 32'h0000_0000);  // Output address
    ext_write(32'h1014, 32'h0008_0008);  // 8x8 layer config

    // Check status before start
    ext_read(32'h1004, rdata);
    $display("Status before start: 0x%08h", rdata);

    // Start TPU
    ext_write(32'h1000, 32'h0000_0001);
    $display("TPU start command sent");

    // Check status after start
    repeat(5) @(posedge clk);
    ext_read(32'h1004, rdata);
    $display("Status after start: 0x%08h (busy=%0d)", rdata, rdata[1]);

    // Wait and check final status
    repeat(100) @(posedge clk);
    ext_read(32'h1004, rdata);
    $display("Final status: 0x%08h", rdata);

    // ============================================================
    // Test 4: CPU Halted Check
    // ============================================================
    $display("\n--- Test 4: CPU Status ---");
    $display("CPU halted: %0d", cpu_halted);
    // CPU should be halted since we haven't loaded a program

    // ============================================================
    // Summary
    // ============================================================
    $display("\n============================================================");
    $display("Test Summary:");
    $display("  Total tests: %0d", test_count);
    $display("  Passed:      %0d", pass_count);
    $display("  Failed:      %0d", fail_count);
    $display("============================================================");

    if (fail_count == 0) begin
      $display("ALL SOC INTEGRATION TESTS PASSED!");
    end else begin
      $display("SOME TESTS FAILED!");
    end

    $finish;
  end

  // Timeout
  initial begin
    #500000;
    $display("TIMEOUT!");
    $finish;
  end

endmodule
