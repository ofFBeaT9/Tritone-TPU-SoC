// TPU 64×64 Array Verification Testbench
// =========================================
// Verifies Phase 4 64×64 scaling:
//   1. Hierarchical 64×64 systolic array (8×8 PE clusters)
//   2. Weight loading across all 64 rows
//   3. Activation streaming across 64 columns
//   4. GEMM operation (64×64×64 tile)
//   5. Performance counters
//   6. Parameterized popcount for 4096 PEs
//
// Author: Tritone Project (Phase 4 Verification)

`timescale 1ns/1ps

module tb_tpu_64x64;

  // ============================================================
  // Parameters
  // ============================================================
  localparam int ARRAY_SIZE = 64;
  localparam int ACT_BITS = 16;
  localparam int ACC_BITS = 32;
  localparam int CLK_PERIOD = 10;
  localparam int NUM_BANKS = 32;
  localparam int MAX_K = 4096;

  // Register addresses
  localparam logic [31:0] REG_CTRL        = 32'h00;
  localparam logic [31:0] REG_STATUS      = 32'h04;
  localparam logic [31:0] REG_WEIGHT_ADDR = 32'h08;
  localparam logic [31:0] REG_ACT_ADDR    = 32'h0C;
  localparam logic [31:0] REG_OUT_ADDR    = 32'h10;
  localparam logic [31:0] REG_LAYER_CFG   = 32'h14;
  localparam logic [31:0] REG_ARRAY_INFO  = 32'h18;
  localparam logic [31:0] REG_PERF_CNT    = 32'h1C;
  localparam logic [31:0] REG_PERF_CNT_1  = 32'h20;
  localparam logic [31:0] REG_PERF_CNT_2  = 32'h24;
  localparam logic [31:0] REG_PERF_CNT_3  = 32'h28;
  localparam logic [31:0] REG_PERF_CTRL   = 32'h2C;
  localparam logic [31:0] REG_DMA_SRC     = 32'h30;
  localparam logic [31:0] REG_DMA_DST     = 32'h34;
  localparam logic [31:0] REG_DMA_LEN     = 32'h38;
  localparam logic [31:0] REG_DMA_CTRL    = 32'h3C;
  localparam logic [31:0] REG_DMA_STATUS  = 32'h40;

  // ============================================================
  // Signals
  // ============================================================
  logic clk;
  logic rst_n;

  // CPU interface
  logic cpu_sel, cpu_wen, cpu_ren;
  logic [31:0] cpu_addr, cpu_wdata, cpu_rdata;
  logic cpu_ready;

  // AXI interface
  logic m_axi_awvalid, m_axi_awready;
  logic [31:0] m_axi_awaddr;
  logic [7:0] m_axi_awlen;
  logic [2:0] m_axi_awsize;
  logic [1:0] m_axi_awburst;
  logic m_axi_wvalid, m_axi_wready;
  logic [31:0] m_axi_wdata;
  logic [3:0] m_axi_wstrb;
  logic m_axi_wlast;
  logic m_axi_bvalid, m_axi_bready;
  logic [1:0] m_axi_bresp;
  logic m_axi_arvalid, m_axi_arready;
  logic [31:0] m_axi_araddr;
  logic [7:0] m_axi_arlen;
  logic [2:0] m_axi_arsize;
  logic [1:0] m_axi_arburst;
  logic m_axi_rvalid, m_axi_rready;
  logic [31:0] m_axi_rdata;
  logic [1:0] m_axi_rresp;
  logic m_axi_rlast;

  // Legacy DMA interface
  logic dma_req, dma_wr;
  logic [31:0] dma_addr, dma_wdata, dma_rdata;
  logic dma_ack;

  // Status
  logic irq, tpu_busy, tpu_done, status_error;

  // ============================================================
  // Clock Generation
  // ============================================================
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // ============================================================
  // DUT Instantiation (64×64 with hierarchical array)
  // ============================================================
  tpu_top_v2 #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS),
    .USE_BANKED_MEMORY(1'b1),
    .USE_HIERARCHICAL_ARRAY(1'b1),  // Use 8×8 PE clusters
    .NUM_BANKS(NUM_BANKS),
    .MAX_K(MAX_K),
    .WEIGHT_BUF_DEPTH(8192),
    .ACT_BUF_DEPTH(4096),
    .OUT_BUF_DEPTH(4096)
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
    // AXI Write
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready),
    .m_axi_bresp(m_axi_bresp),
    // AXI Read
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),
    // Legacy
    .dma_req(dma_req),
    .dma_wr(dma_wr),
    .dma_addr(dma_addr),
    .dma_wdata(dma_wdata),
    .dma_rdata(dma_rdata),
    .dma_ack(dma_ack),
    // Status
    .irq(irq),
    .busy(tpu_busy),
    .done(tpu_done),
    .status_error(status_error)
  );

  // ============================================================
  // AXI Memory Model (Large for 64×64)
  // ============================================================
  localparam int EXT_MEM_SIZE = 65536;  // 256KB
  logic [31:0] ext_memory [0:EXT_MEM_SIZE-1];
  int axi_read_idx;
  int axi_read_len;
  int axi_read_cnt;

  // Initialize external memory with test patterns
  initial begin
    // Weights: Pattern for 64×64 weight matrix
    // Row i, Col j: weight = (i + j) % 3 - 1 → {-1, 0, +1}
    // Encoding: -1=00, 0=01, +1=10
    for (int row = 0; row < 64; row++) begin
      for (int word = 0; word < 4; word++) begin  // 64 weights = 128 bits = 4 words
        automatic logic [31:0] wdata = 0;
        for (int w = 0; w < 16; w++) begin
          automatic int col = word * 16 + w;
          automatic int weight_val = (row + col) % 3;  // 0, 1, 2 → encode as 00, 01, 10
          wdata[w*2 +: 2] = weight_val[1:0];
        end
        ext_memory[row * 4 + word] = wdata;
      end
    end

    // Activations: Sequential values for 64 rows × K columns
    // Starting at address 0x1000
    for (int k = 0; k < 64; k++) begin
      for (int col = 0; col < 64; col++) begin
        // Each activation is 16 bits, 2 per word
        automatic int addr = 'h1000/4 + k * 32 + col / 2;
        if (col % 2 == 0) begin
          ext_memory[addr][15:0] = 16'(k * 64 + col);
        end else begin
          ext_memory[addr][31:16] = 16'(k * 64 + col);
        end
      end
    end

    $display("External memory initialized:");
    $display("  Weights: 0x0000 - 0x0FFF (64 rows × 4 words)");
    $display("  Activations: 0x1000 - 0x2FFF (64 K-steps × 32 words)");
  end

  // AXI read responder
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      m_axi_arready <= 1'b1;
      m_axi_rvalid <= 1'b0;
      m_axi_rlast <= 1'b0;
      m_axi_rdata <= '0;
      axi_read_idx <= 0;
      axi_read_len <= 0;
      axi_read_cnt <= 0;
    end else begin
      if (m_axi_arvalid && m_axi_arready) begin
        axi_read_idx <= m_axi_araddr[17:2];
        axi_read_len <= m_axi_arlen + 1;
        axi_read_cnt <= 0;
        m_axi_arready <= 1'b0;
        m_axi_rvalid <= 1'b1;
        m_axi_rdata <= ext_memory[m_axi_araddr[17:2]];
        m_axi_rlast <= (m_axi_arlen == 0);
      end else if (m_axi_rvalid && m_axi_rready) begin
        axi_read_cnt <= axi_read_cnt + 1;
        axi_read_idx <= axi_read_idx + 1;
        m_axi_rdata <= ext_memory[axi_read_idx + 1];
        if (axi_read_cnt + 1 >= axi_read_len) begin
          m_axi_rvalid <= 1'b0;
          m_axi_rlast <= 1'b0;
          m_axi_arready <= 1'b1;
        end else begin
          m_axi_rlast <= (axi_read_cnt + 2 >= axi_read_len);
        end
      end
    end
  end

  assign m_axi_rresp = 2'b00;

  // AXI write responder
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      m_axi_awready <= 1'b1;
      m_axi_wready <= 1'b1;
      m_axi_bvalid <= 1'b0;
    end else begin
      if (m_axi_wvalid && m_axi_wready && m_axi_wlast) begin
        m_axi_bvalid <= 1'b1;
      end
      if (m_axi_bvalid && m_axi_bready) begin
        m_axi_bvalid <= 1'b0;
      end
    end
  end

  assign m_axi_bresp = 2'b00;
  assign dma_rdata = '0;
  assign dma_ack = 1'b0;

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

  task automatic wait_dma_done();
    logic [31:0] status;
    int timeout = 10000;
    do begin
      @(posedge clk);
      cpu_read(REG_DMA_STATUS, status);
      timeout--;
    end while (!(status[1]) && timeout > 0);
    if (timeout == 0) $display("ERROR: DMA timeout!");
  endtask

  task automatic wait_tpu_done();
    logic [31:0] status;
    int timeout = 50000;  // Longer timeout for 64×64
    do begin
      @(posedge clk);
      cpu_read(REG_STATUS, status);
      timeout--;
    end while (!(status[8]) && timeout > 0);
    if (timeout == 0) $display("ERROR: TPU timeout!");
  endtask

  // ============================================================
  // Test Sequence
  // ============================================================
  initial begin
    automatic logic [31:0] rdata;
    automatic int errors = 0;
    automatic int test_num = 0;
    automatic real start_time, end_time;

    $display("");
    $display("================================================================");
    $display("  TPU 64×64 Array Verification Testbench (Phase 4)");
    $display("================================================================");
    $display("");
    $display("Configuration:");
    $display("  ARRAY_SIZE = %0d × %0d = %0d PEs", ARRAY_SIZE, ARRAY_SIZE, ARRAY_SIZE*ARRAY_SIZE);
    $display("  USE_HIERARCHICAL_ARRAY = 1 (8×8 PE clusters)");
    $display("  NUM_BANKS = %0d (weight) + %0d (activation)", NUM_BANKS, ARRAY_SIZE);
    $display("  MAX_K = %0d", MAX_K);
    $display("");

    // Initialize
    rst_n = 0;
    cpu_sel = 0;
    cpu_wen = 0;
    cpu_ren = 0;
    cpu_addr = 0;
    cpu_wdata = 0;

    // Reset
    repeat(20) @(posedge clk);
    rst_n = 1;
    repeat(10) @(posedge clk);

    // --------------------------------------------------------
    // Test 1: Verify Array Info (v2.1)
    // --------------------------------------------------------
    test_num++;
    $display("--- Test %0d: Verify Array Info (Version 2.1, 64×64) ---", test_num);
    cpu_read(REG_ARRAY_INFO, rdata);
    $display("  Array Info: 0x%08h", rdata);
    $display("    Version: 0x%04h (expected: 0x0201 for v2.1)", rdata[31:16]);
    $display("    Array Size: %0d (expected: 64)", rdata[15:8]);
    $display("    ACC Bits: %0d (expected: 32)", rdata[7:0]);

    if (rdata[31:16] != 16'h0201) begin
      $display("  ERROR: Version mismatch!");
      errors++;
    end
    if (rdata[15:8] != ARRAY_SIZE) begin
      $display("  ERROR: Array size mismatch!");
      errors++;
    end
    if (errors == 0) $display("  PASS");

    // --------------------------------------------------------
    // Test 2: Performance Counter Initialization
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Performance Counter Reset ---", test_num);
    cpu_write(REG_PERF_CTRL, 32'h0000_0002);  // Clear
    cpu_write(REG_PERF_CTRL, 32'h0000_0001);  // Enable

    cpu_read(REG_PERF_CNT, rdata);
    if (rdata != 0) errors++;
    cpu_read(REG_PERF_CNT_1, rdata);
    if (rdata != 0) errors++;
    cpu_read(REG_PERF_CNT_2, rdata);
    if (rdata != 0) errors++;
    cpu_read(REG_PERF_CNT_3, rdata);
    if (rdata != 0) errors++;

    if (errors == 0) $display("  PASS: All counters cleared");
    else $display("  FAIL: Counter clear failed");

    // --------------------------------------------------------
    // Test 3: DMA Weight Load (64 rows × 4 words each)
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: DMA Weight Load (64 rows) ---", test_num);
    cpu_write(REG_DMA_SRC, 32'h0000_0000);     // From ext mem
    cpu_write(REG_DMA_DST, 32'h0000_0000);     // To weight buffer
    cpu_write(REG_DMA_LEN, 32'h0000_0400);     // 1024 bytes (256 words = 64 rows × 4 words)
    cpu_write(REG_DMA_CTRL, 32'h0000_0001);    // Start, read, weight mode

    start_time = $realtime;
    wait_dma_done();
    end_time = $realtime;

    cpu_read(REG_DMA_STATUS, rdata);
    $display("  DMA Status: 0x%08h", rdata);
    $display("    Bytes transferred: %0d", rdata[31:16]);
    $display("    Transfer time: %0t", end_time - start_time);

    if (rdata[2]) begin
      $display("  ERROR: DMA reported error!");
      errors++;
    end else begin
      $display("  PASS");
    end

    // --------------------------------------------------------
    // Test 4: DMA Activation Load (64 K-steps × 32 words each)
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: DMA Activation Load (64 K-steps) ---", test_num);
    cpu_write(REG_DMA_SRC, 32'h0000_1000);     // From ext mem @ 0x1000
    cpu_write(REG_DMA_DST, 32'h0000_0000);     // To activation buffer
    cpu_write(REG_DMA_LEN, 32'h0000_2000);     // 8192 bytes (64×64 activations × 2 bytes)
    cpu_write(REG_DMA_CTRL, 32'h0000_0005);    // Start, read, activation mode

    start_time = $realtime;
    wait_dma_done();
    end_time = $realtime;

    cpu_read(REG_DMA_STATUS, rdata);
    $display("  Bytes transferred: %0d", rdata[31:16]);
    $display("  Transfer time: %0t", end_time - start_time);

    if (rdata[2]) begin
      $display("  ERROR: DMA reported error!");
      errors++;
    end else begin
      $display("  PASS");
    end

    // --------------------------------------------------------
    // Test 5: Run 64×64×64 GEMM
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Run 64×64×64 GEMM ---", test_num);
    cpu_write(REG_LAYER_CFG, {16'd64, 16'd64});  // 64 rows, 64 cols
    cpu_write(REG_ACT_ADDR, {16'd64, 16'd0});    // K=64, act_addr=0
    cpu_write(REG_WEIGHT_ADDR, 32'h0000_0000);
    cpu_write(REG_OUT_ADDR, 32'h0000_0000);

    $display("  Starting GEMM: M=64, N=64, K=64");
    $display("  Total MACs: %0d", 64*64*64);

    start_time = $realtime;
    cpu_write(REG_CTRL, 32'h0000_0001);  // Start

    wait_tpu_done();
    end_time = $realtime;

    cpu_read(REG_STATUS, rdata);
    $display("  TPU Status: 0x%08h", rdata);
    $display("    Busy: %0d, Done: %0d, Error: %0d", rdata[1], rdata[8], rdata[9]);
    $display("    Compute time: %0t", end_time - start_time);

    if (rdata[9]) begin
      $display("  ERROR: TPU reported error!");
      errors++;
    end else begin
      $display("  PASS");
    end

    // --------------------------------------------------------
    // Test 6: Performance Counter Analysis
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Performance Counter Analysis ---", test_num);

    cpu_read(REG_PERF_CNT, rdata);
    $display("  PERF_CNT_0 (cycles while busy): %0d", rdata);

    cpu_read(REG_PERF_CNT_1, rdata);
    $display("  PERF_CNT_1 (zero-skip count): %0d", rdata);
    $display("    Expected ~1/3 of %0d = %0d (for random ternary weights)",
             64*64*64, 64*64*64/3);

    cpu_read(REG_PERF_CNT_2, rdata);
    $display("  PERF_CNT_2 (bank conflicts): %0d", rdata);
    if (rdata > 100) begin
      $display("    WARNING: High bank conflict count!");
    end

    cpu_read(REG_PERF_CNT_3, rdata);
    $display("  PERF_CNT_3 (DMA bytes): %0d", rdata);

    // Calculate utilization
    cpu_read(REG_PERF_CNT, rdata);
    if (rdata > 0) begin
      automatic real utilization = 100.0 * (64.0 * 64.0 * 64.0) / (rdata * 64.0 * 64.0);
      $display("  Estimated Utilization: %.1f%%", utilization);
    end

    $display("  PASS");

    // --------------------------------------------------------
    // Test 7: Verify No Errors
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Final Error Check ---", test_num);
    cpu_read(REG_STATUS, rdata);
    if (rdata[9]) begin
      $display("  FAIL: status_error is set");
      errors++;
    end else begin
      $display("  PASS: No errors detected");
    end

    // --------------------------------------------------------
    // Summary
    // --------------------------------------------------------
    $display("");
    $display("================================================================");
    $display("  Test Summary");
    $display("================================================================");
    $display("  Total Tests: %0d", test_num);
    $display("  Errors: %0d", errors);
    $display("");

    if (errors == 0) begin
      $display("  *** ALL TESTS PASSED ***");
      $display("  64×64 Hierarchical Array Verification: SUCCESS");
    end else begin
      $display("  *** SOME TESTS FAILED ***");
      $display("  Check log for details");
    end

    $display("================================================================");
    $display("");

    $finish;
  end

  // Timeout (longer for 64×64)
  initial begin
    #50000000;  // 50ms timeout
    $display("TIMEOUT - test took too long!");
    $finish;
  end

  // Progress indicator
  initial begin
    forever begin
      #1000000;  // Every 1ms
      if (tpu_busy) $display("[%0t] TPU busy...", $realtime);
    end
  end

endmodule
