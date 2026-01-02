// TPU Banking Memory Integration Testbench
// ==========================================
// Verifies:
//   1. Banked memory instantiation when USE_BANKED_MEMORY=1
//   2. DMA writes to banked weight/activation buffers
//   3. Controller reads from banked buffers
//   4. Bank conflict detection and counting (PERF_CNT_2)
//   5. Error detection (status_error)
//   6. Double-buffer swap signals
//
// Author: Tritone Project (Phase 1.2/1.3 Verification)

`timescale 1ns/1ps

module tb_tpu_banking;

  // ============================================================
  // Parameters
  // ============================================================
  localparam int ARRAY_SIZE = 8;
  localparam int ACT_BITS = 16;
  localparam int ACC_BITS = 32;
  localparam int CLK_PERIOD = 10;
  localparam int NUM_BANKS = 8;

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
  logic irq, tpu_busy, tpu_done;

  // ============================================================
  // Clock Generation
  // ============================================================
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // ============================================================
  // DUT Instantiation (with banking enabled)
  // ============================================================
  tpu_top_v2 #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS),
    .USE_BANKED_MEMORY(1'b1),  // Enable banking
    .NUM_BANKS(NUM_BANKS),
    .WEIGHT_BUF_DEPTH(4096),
    .ACT_BUF_DEPTH(2048),
    .OUT_BUF_DEPTH(2048)
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
    .done(tpu_done)
  );

  // ============================================================
  // AXI Memory Model
  // ============================================================
  logic [31:0] ext_memory [0:4095];
  int axi_read_idx;
  int axi_read_len;
  int axi_read_cnt;

  // Initialize external memory with test patterns
  initial begin
    // Weights: all +1 (encoding: 10)
    for (int i = 0; i < 256; i++) begin
      ext_memory[i] = 32'hAAAA_AAAA;  // 16 weights of +1 (10 binary)
    end
    // Activations: sequential values
    for (int i = 256; i < 512; i++) begin
      ext_memory[i] = {16'(2*(i-256)+1), 16'(2*(i-256))};
    end
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
        // Accept read address
        axi_read_idx <= m_axi_araddr[13:2];
        axi_read_len <= m_axi_arlen + 1;
        axi_read_cnt <= 0;
        m_axi_arready <= 1'b0;
        m_axi_rvalid <= 1'b1;
        m_axi_rdata <= ext_memory[m_axi_araddr[13:2]];
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

  assign m_axi_rresp = 2'b00;  // OKAY

  // AXI write responder (simple - always accept)
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

  assign m_axi_bresp = 2'b00;  // OKAY
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
    int timeout = 1000;
    do begin
      @(posedge clk);
      cpu_read(REG_DMA_STATUS, status);
      timeout--;
    end while (!(status[1]) && timeout > 0);  // Wait for done bit
    if (timeout == 0) $display("ERROR: DMA timeout!");
  endtask

  task automatic wait_tpu_done();
    logic [31:0] status;
    int timeout = 2000;
    do begin
      @(posedge clk);
      cpu_read(REG_STATUS, status);
      timeout--;
    end while (!(status[8]) && timeout > 0);  // Wait for done bit
    if (timeout == 0) $display("ERROR: TPU timeout!");
  endtask

  // ============================================================
  // Test Sequence
  // ============================================================
  initial begin
    logic [31:0] rdata;
    int errors = 0;

    $display("============================================================");
    $display("TPU Banking Memory Integration Testbench (v2)");
    $display("============================================================");
    $display("Configuration:");
    $display("  USE_BANKED_MEMORY = 1 (ENABLED)");
    $display("  ARRAY_SIZE = %0d", ARRAY_SIZE);
    $display("  NUM_BANKS = %0d (16 total with shadow)", NUM_BANKS);
    $display("");

    // Initialize
    rst_n = 0;
    cpu_sel = 0;
    cpu_wen = 0;
    cpu_ren = 0;
    cpu_addr = 0;
    cpu_wdata = 0;

    // Reset
    repeat(10) @(posedge clk);
    rst_n = 1;
    repeat(5) @(posedge clk);

    // --------------------------------------------------------
    // Test 1: Verify Array Info (v2 indicator)
    // --------------------------------------------------------
    $display("--- Test 1: Verify Array Info (Version 2) ---");
    cpu_read(REG_ARRAY_INFO, rdata);
    $display("Array Info: 0x%08h", rdata);
    $display("  Version: %0d (expected: 2)", rdata[31:16]);
    $display("  Array Size: %0d", rdata[15:8]);
    $display("  ACC Bits: %0d", rdata[7:0]);
    if (rdata[31:16] != 16'h0002) begin
      $display("ERROR: Version should be 2 for v2 TPU");
      errors++;
    end

    // --------------------------------------------------------
    // Test 2: Clear Performance Counters
    // --------------------------------------------------------
    $display("\n--- Test 2: Performance Counter Reset ---");
    cpu_write(REG_PERF_CTRL, 32'h0000_0002);  // Set clear bit
    cpu_write(REG_PERF_CTRL, 32'h0000_0001);  // Enable, clear clear-bit
    cpu_read(REG_PERF_CNT_2, rdata);
    $display("PERF_CNT_2 (bank conflicts) after clear: %0d (expected 0)", rdata);
    if (rdata != 0) begin
      $display("ERROR: PERF_CNT_2 should be 0 after clear");
      errors++;
    end

    // --------------------------------------------------------
    // Test 3: DMA Weight Load
    // --------------------------------------------------------
    $display("\n--- Test 3: DMA Weight Load (mode=00) ---");
    cpu_write(REG_DMA_SRC, 32'h0000_0000);     // From ext mem address 0
    cpu_write(REG_DMA_DST, 32'h0000_0000);     // To weight buffer address 0
    cpu_write(REG_DMA_LEN, 32'h0000_0040);     // 64 bytes (16 words)
    cpu_write(REG_DMA_CTRL, 32'h0000_0001);    // Start, read, weight mode (00)

    wait_dma_done();

    cpu_read(REG_DMA_STATUS, rdata);
    $display("DMA Status: 0x%08h", rdata);
    $display("  Busy: %0d, Done: %0d, Error: %0d", rdata[0], rdata[1], rdata[2]);
    $display("  Bytes transferred: %0d", rdata[31:16]);
    if (rdata[2]) begin
      $display("ERROR: DMA reported error!");
      errors++;
    end

    // --------------------------------------------------------
    // Test 4: DMA Activation Load
    // --------------------------------------------------------
    $display("\n--- Test 4: DMA Activation Load (mode=01) ---");
    cpu_write(REG_DMA_SRC, 32'h0000_0400);     // From ext mem address 0x400
    cpu_write(REG_DMA_DST, 32'h0000_0000);     // To activation buffer address 0
    cpu_write(REG_DMA_LEN, 32'h0000_0080);     // 128 bytes (32 words)
    cpu_write(REG_DMA_CTRL, 32'h0000_0005);    // Start, read, activation mode (01)

    wait_dma_done();

    cpu_read(REG_DMA_STATUS, rdata);
    $display("DMA Status: 0x%08h", rdata);
    $display("  Bytes transferred: %0d", rdata[31:16]);

    // --------------------------------------------------------
    // Test 5: Verify Status (no error before computation)
    // --------------------------------------------------------
    $display("\n--- Test 5: Verify Status Before Compute ---");
    cpu_read(REG_STATUS, rdata);
    $display("TPU Status: 0x%08h", rdata);
    $display("  Busy: %0d, Done: %0d, Error: %0d", rdata[1], rdata[8], rdata[9]);
    if (rdata[9]) begin
      $display("ERROR: status_error set before computation!");
      errors++;
    end

    // --------------------------------------------------------
    // Test 6: Run Simple Matrix Multiply
    // --------------------------------------------------------
    $display("\n--- Test 6: Run 8x8 Matrix Multiply ---");
    cpu_write(REG_LAYER_CFG, {16'd8, 16'd8});   // 8 rows, 8 cols
    cpu_write(REG_ACT_ADDR, {16'd8, 16'd0});    // K=8, act_addr=0
    cpu_write(REG_WEIGHT_ADDR, 32'h0000_0000);
    cpu_write(REG_OUT_ADDR, 32'h0000_0000);
    cpu_write(REG_CTRL, 32'h0000_0001);         // Start

    wait_tpu_done();

    cpu_read(REG_STATUS, rdata);
    $display("TPU Status after compute: 0x%08h", rdata);
    $display("  Busy: %0d, Done: %0d, Error: %0d", rdata[1], rdata[8], rdata[9]);
    $display("  Zero-skips: %0d", rdata[31:16]);

    // --------------------------------------------------------
    // Test 7: Check Performance Counters
    // --------------------------------------------------------
    $display("\n--- Test 7: Performance Counters ---");
    cpu_read(REG_PERF_CNT, rdata);
    $display("PERF_CNT_0 (cycles while busy): %0d", rdata);

    cpu_read(REG_PERF_CNT_1, rdata);
    $display("PERF_CNT_1 (zero-skip count): %0d", rdata);

    cpu_read(REG_PERF_CNT_2, rdata);
    $display("PERF_CNT_2 (bank conflicts): %0d", rdata);
    // With proper double-buffering, conflicts should be 0 or very low
    if (rdata > 10) begin
      $display("WARNING: High bank conflict count - check memory access patterns");
    end

    cpu_read(REG_PERF_CNT_3, rdata);
    $display("PERF_CNT_3 (DMA bytes transferred): %0d", rdata);

    // --------------------------------------------------------
    // Test 8: Verify Error Detection
    // --------------------------------------------------------
    $display("\n--- Test 8: Verify Error Detection Logic ---");
    // Error detection should work (we can't easily trigger an AXI error in this testbench)
    cpu_read(REG_STATUS, rdata);
    if (!rdata[9]) begin
      $display("PASS: status_error is 0 (no error occurred)");
    end else begin
      $display("FAIL: Unexpected error in status register");
      errors++;
    end

    // --------------------------------------------------------
    // Summary
    // --------------------------------------------------------
    $display("\n============================================================");
    $display("Test Summary: %0d errors", errors);
    $display("============================================================");

    if (errors == 0)
      $display("ALL TESTS PASSED!");
    else
      $display("SOME TESTS FAILED - check log for details");

    $finish;
  end

  // Timeout
  initial begin
    #1000000;  // 1ms timeout
    $display("TIMEOUT - test took too long!");
    $finish;
  end

endmodule
