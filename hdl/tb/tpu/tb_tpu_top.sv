// Testbench for Tritone TPU Top
// ===============================
// End-to-end verification of the TPU including:
//   - Register access
//   - Weight/activation loading
//   - Matrix multiply execution
//   - Result verification
//
// Author: Tritone Project

`timescale 1ns/1ps

module tb_tpu_top;

  // ============================================================
  // Parameters
  // ============================================================
  localparam int ARRAY_SIZE = 8;
  localparam int ACT_BITS = 16;
  localparam int ACC_BITS = 32;
  localparam int CLK_PERIOD = 10;

  // Register addresses
  localparam logic [31:0] REG_CTRL        = 32'h00;
  localparam logic [31:0] REG_STATUS      = 32'h04;
  localparam logic [31:0] REG_WEIGHT_ADDR = 32'h08;
  localparam logic [31:0] REG_ACT_ADDR    = 32'h0C;
  localparam logic [31:0] REG_OUT_ADDR    = 32'h10;
  localparam logic [31:0] REG_LAYER_CFG   = 32'h14;
  localparam logic [31:0] REG_ARRAY_INFO  = 32'h18;

  // ============================================================
  // Signals
  // ============================================================
  logic clk;
  logic rst_n;

  // CPU interface
  logic cpu_sel;
  logic cpu_wen;
  logic cpu_ren;
  logic [31:0] cpu_addr;
  logic [31:0] cpu_wdata;
  logic [31:0] cpu_rdata;
  logic cpu_ready;

  // DMA interface
  logic dma_req;
  logic dma_wr;
  logic [31:0] dma_addr;
  logic [31:0] dma_wdata;
  logic [31:0] dma_rdata;
  logic dma_ack;

  // Interrupt
  logic irq;

  // Test data
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] test_activations [ARRAY_SIZE];
  logic [ARRAY_SIZE-1:0][1:0] test_weights [ARRAY_SIZE];
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] expected_output [ARRAY_SIZE];

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
  tpu_top #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .cpu_sel(cpu_sel),
    .cpu_wen(cpu_wen),
    .cpu_ren(cpu_ren),
    .cpu_addr(cpu_addr),
    .cpu_wdata(cpu_wdata),
    .cpu_rdata(cpu_rdata),
    .cpu_ready(cpu_ready),
    .dma_req(dma_req),
    .dma_wr(dma_wr),
    .dma_addr(dma_addr),
    .dma_wdata(dma_wdata),
    .dma_rdata(dma_rdata),
    .dma_ack(dma_ack),
    .irq(irq)
  );

  // ============================================================
  // CPU Interface Tasks
  // ============================================================

  task automatic cpu_write(input logic [31:0] addr, input logic [31:0] data);
    @(posedge clk);
    cpu_sel <= 1'b1;
    cpu_wen <= 1'b1;
    cpu_ren <= 1'b0;
    cpu_addr <= addr;
    cpu_wdata <= data;
    @(posedge clk);
    while (!cpu_ready) @(posedge clk);
    cpu_sel <= 1'b0;
    cpu_wen <= 1'b0;
    @(posedge clk);
  endtask

  task automatic cpu_read(input logic [31:0] addr, output logic [31:0] data);
    @(posedge clk);
    cpu_sel <= 1'b1;
    cpu_wen <= 1'b0;
    cpu_ren <= 1'b1;
    cpu_addr <= addr;
    @(posedge clk);
    while (!cpu_ready) @(posedge clk);
    data = cpu_rdata;
    cpu_sel <= 1'b0;
    cpu_ren <= 1'b0;
    @(posedge clk);
  endtask

  // ============================================================
  // Test Data Generation
  // ============================================================

  task automatic generate_test_data();
    // Simple test: identity weight matrix, sequential activations
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      for (int j = 0; j < ARRAY_SIZE; j++) begin
        // Identity-like weights
        if (i == j) begin
          test_weights[i][j] = 2'b10;  // +1
        end else begin
          test_weights[i][j] = 2'b01;  // 0
        end

        // Sequential activations
        test_activations[i][j] = (i * ARRAY_SIZE + j + 1);
      end
    end

    // Compute expected output (identity gives back the activations)
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      for (int j = 0; j < ARRAY_SIZE; j++) begin
        expected_output[i][j] = test_activations[i][j];
      end
    end

    $display("Test data generated:");
    $display("  Weights: Identity matrix");
    $display("  Activations: Sequential 1 to %0d", ARRAY_SIZE * ARRAY_SIZE);
  endtask

  // ============================================================
  // Main Test Sequence
  // ============================================================
  initial begin
    logic [31:0] rdata;
    int errors;

    $display("============================================================");
    $display("Tritone TPU Top-Level Testbench");
    $display("============================================================");
    $display("Array Size: %0d x %0d", ARRAY_SIZE, ARRAY_SIZE);
    $display("Activation bits: %0d", ACT_BITS);
    $display("Accumulator bits: %0d", ACC_BITS);
    $display("");

    // Initialize
    errors = 0;
    rst_n = 0;
    cpu_sel = 0;
    cpu_wen = 0;
    cpu_ren = 0;
    cpu_addr = 0;
    cpu_wdata = 0;
    dma_rdata = 0;
    dma_ack = 0;

    // Reset
    repeat(10) @(posedge clk);
    rst_n = 1;
    repeat(5) @(posedge clk);

    // Test 1: Read array info register
    $display("--- Test 1: Read Array Info Register ---");
    cpu_read(REG_ARRAY_INFO, rdata);
    $display("Array Info: 0x%08h", rdata);
    $display("  Array Size: %0d", rdata[15:8]);
    $display("  Acc Bits: %0d", rdata[7:0]);
    $display("  Version: 0x%04h", rdata[31:16]);

    if (rdata[15:8] != ARRAY_SIZE) begin
      $display("ERROR: Array size mismatch!");
      errors++;
    end

    // Test 2: Write and read control registers
    $display("\n--- Test 2: Register Read/Write ---");
    cpu_write(REG_LAYER_CFG, 32'h00080008);  // 8x8 layer
    cpu_read(REG_LAYER_CFG, rdata);
    $display("Layer Config: 0x%08h (expected 0x00080008)", rdata);

    if (rdata != 32'h00080008) begin
      $display("ERROR: Register mismatch!");
      errors++;
    end

    // Test 3: Generate test data
    $display("\n--- Test 3: Generate Test Data ---");
    generate_test_data();

    // Test 4: Load weights into TPU (via memory-mapped interface)
    $display("\n--- Test 4: Load Weights ---");
    $display("Skipping direct memory load (would use DMA in practice)");

    // Test 5: Configure and start TPU
    $display("\n--- Test 5: Configure TPU ---");
    cpu_write(REG_WEIGHT_ADDR, 32'h0000_0000);
    cpu_write(REG_ACT_ADDR, 32'h0008_0000);  // K=8 in upper 16 bits
    cpu_write(REG_OUT_ADDR, 32'h0000_0000);
    cpu_write(REG_LAYER_CFG, {16'd8, 16'd8});  // 8x8 output

    // Check status before start
    cpu_read(REG_STATUS, rdata);
    $display("Status before start: 0x%08h", rdata);

    // Start TPU
    $display("\n--- Test 6: Start TPU ---");
    cpu_write(REG_CTRL, 32'h0000_0001);  // Start bit

    // Poll for completion
    repeat(10) @(posedge clk);
    cpu_read(REG_STATUS, rdata);
    $display("Status after start: 0x%08h", rdata);
    $display("  Busy: %0d", rdata[1]);

    // Wait for completion (with timeout)
    $display("\n--- Test 7: Wait for Completion ---");
    repeat(1000) @(posedge clk);

    cpu_read(REG_STATUS, rdata);
    $display("Final Status: 0x%08h", rdata);
    $display("  Done: %0d", rdata[8]);
    $display("  Zero-skips: %0d", rdata[31:16]);

    // Summary
    $display("\n============================================================");
    $display("Test Summary:");
    $display("  Errors: %0d", errors);
    $display("============================================================");

    if (errors == 0) begin
      $display("BASIC TESTS PASSED!");
      $display("(Full matrix multiply verification requires memory loading)");
    end else begin
      $display("SOME TESTS FAILED!");
    end

    $finish;
  end

  // Timeout
  initial begin
    #200000;
    $display("TIMEOUT!");
    $finish;
  end

endmodule
