// TPU DMA Engine Testbench
// =========================
// Comprehensive verification of Phase 2 DMA functionality:
//   - Weight prefetch (mode=00)
//   - Activation prefetch (mode=01)
//   - Result writeback (mode=10)
//   - Burst transfers
//   - Performance counter verification
//
// Author: Tritone Project (Phase 2 QA)

`timescale 1ns/1ps

module tb_tpu_dma;

  // ============================================================
  // Parameters
  // ============================================================
  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;
  parameter int ARRAY_SIZE = 8;
  parameter int ACT_BITS = 16;
  parameter int ACC_BITS = 32;
  parameter int CLK_PERIOD = 10;

  // ============================================================
  // DUT Signals
  // ============================================================
  logic clk;
  logic rst_n;

  // CPU Interface
  logic                    cpu_sel;
  logic                    cpu_wen;
  logic                    cpu_ren;
  logic [ADDR_WIDTH-1:0]   cpu_addr;
  logic [DATA_WIDTH-1:0]   cpu_wdata;
  logic [DATA_WIDTH-1:0]   cpu_rdata;
  logic                    cpu_ready;

  // AXI Master Interface
  logic                    m_axi_awvalid, m_axi_awready;
  logic [ADDR_WIDTH-1:0]   m_axi_awaddr;
  logic [7:0]              m_axi_awlen;
  logic [2:0]              m_axi_awsize;
  logic [1:0]              m_axi_awburst;

  logic                    m_axi_wvalid, m_axi_wready;
  logic [DATA_WIDTH-1:0]   m_axi_wdata;
  logic [DATA_WIDTH/8-1:0] m_axi_wstrb;
  logic                    m_axi_wlast;

  logic                    m_axi_bvalid, m_axi_bready;
  logic [1:0]              m_axi_bresp;

  logic                    m_axi_arvalid, m_axi_arready;
  logic [ADDR_WIDTH-1:0]   m_axi_araddr;
  logic [7:0]              m_axi_arlen;
  logic [2:0]              m_axi_arsize;
  logic [1:0]              m_axi_arburst;

  logic                    m_axi_rvalid, m_axi_rready;
  logic [DATA_WIDTH-1:0]   m_axi_rdata;
  logic [1:0]              m_axi_rresp;
  logic                    m_axi_rlast;

  // Legacy DMA
  logic                    dma_req, dma_wr;
  logic [ADDR_WIDTH-1:0]   dma_addr;
  logic [DATA_WIDTH-1:0]   dma_wdata, dma_rdata;
  logic                    dma_ack;

  // Status
  logic                    irq;
  logic                    busy;
  logic                    done;

  // ============================================================
  // Memory Model (Simple AXI Slave)
  // ============================================================
  logic [DATA_WIDTH-1:0] ext_mem [0:4095];
  logic [7:0] axi_burst_cnt;
  logic [7:0] axi_burst_len;
  logic [ADDR_WIDTH-1:0] axi_addr;

  typedef enum logic [2:0] {
    AXI_IDLE,
    AXI_READ,
    AXI_WRITE,
    AXI_WRESP
  } axi_state_t;

  axi_state_t axi_state;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      axi_state <= AXI_IDLE;
      m_axi_arready <= 1'b0;
      m_axi_rvalid <= 1'b0;
      m_axi_rdata <= '0;
      m_axi_rresp <= 2'b00;
      m_axi_rlast <= 1'b0;
      m_axi_awready <= 1'b0;
      m_axi_wready <= 1'b0;
      m_axi_bvalid <= 1'b0;
      m_axi_bresp <= 2'b00;
      axi_burst_cnt <= '0;
      axi_burst_len <= '0;
      axi_addr <= '0;
    end else begin
      m_axi_arready <= 1'b0;
      m_axi_awready <= 1'b0;

      case (axi_state)
        AXI_IDLE: begin
          m_axi_rvalid <= 1'b0;
          m_axi_rlast <= 1'b0;
          m_axi_bvalid <= 1'b0;

          if (m_axi_arvalid) begin
            m_axi_arready <= 1'b1;
            axi_addr <= m_axi_araddr;
            axi_burst_len <= m_axi_arlen;
            axi_burst_cnt <= '0;
            axi_state <= AXI_READ;
          end else if (m_axi_awvalid) begin
            m_axi_awready <= 1'b1;
            axi_addr <= m_axi_awaddr;
            axi_burst_len <= m_axi_awlen;
            axi_burst_cnt <= '0;
            m_axi_wready <= 1'b1;
            axi_state <= AXI_WRITE;
          end
        end

        AXI_READ: begin
          if (m_axi_rready || !m_axi_rvalid) begin
            m_axi_rdata <= ext_mem[axi_addr[13:2]];
            m_axi_rvalid <= 1'b1;
            m_axi_rresp <= 2'b00;

            if (axi_burst_cnt >= axi_burst_len) begin
              m_axi_rlast <= 1'b1;
              axi_state <= AXI_IDLE;
            end else begin
              m_axi_rlast <= 1'b0;
              axi_burst_cnt <= axi_burst_cnt + 1;
              axi_addr <= axi_addr + 4;
            end
          end
        end

        AXI_WRITE: begin
          if (m_axi_wvalid && m_axi_wready) begin
            ext_mem[axi_addr[13:2]] <= m_axi_wdata;

            if (m_axi_wlast) begin
              m_axi_wready <= 1'b0;
              m_axi_bvalid <= 1'b1;
              m_axi_bresp <= 2'b00;
              axi_state <= AXI_WRESP;
            end else begin
              axi_burst_cnt <= axi_burst_cnt + 1;
              axi_addr <= axi_addr + 4;
            end
          end
        end

        AXI_WRESP: begin
          if (m_axi_bready) begin
            m_axi_bvalid <= 1'b0;
            axi_state <= AXI_IDLE;
          end
        end
      endcase
    end
  end

  // ============================================================
  // DUT Instantiation
  // ============================================================
  tpu_top #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .cpu_sel(cpu_sel),
    .cpu_wen(cpu_wen),
    .cpu_ren(cpu_ren),
    .cpu_addr(cpu_addr),
    .cpu_wdata(cpu_wdata),
    .cpu_rdata(cpu_rdata),
    .cpu_ready(cpu_ready),

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

    .dma_req(dma_req),
    .dma_wr(dma_wr),
    .dma_addr(dma_addr),
    .dma_wdata(dma_wdata),
    .dma_rdata(dma_rdata),
    .dma_ack(dma_ack),

    .irq(irq),
    .busy(busy),
    .done(done)
  );

  // Tie off legacy DMA (not used in this test)
  assign dma_rdata = '0;
  assign dma_ack = 1'b0;

  // ============================================================
  // Clock Generation
  // ============================================================
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // ============================================================
  // Register Access Tasks
  // ============================================================
  task automatic write_reg(input logic [31:0] addr, input logic [31:0] data);
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
  endtask

  task automatic read_reg(input logic [31:0] addr, output logic [31:0] data);
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
  endtask

  // Register addresses
  localparam REG_DMA_SRC    = 32'h30;
  localparam REG_DMA_DST    = 32'h34;
  localparam REG_DMA_LEN    = 32'h38;
  localparam REG_DMA_CTRL   = 32'h3C;
  localparam REG_DMA_STATUS = 32'h40;
  localparam REG_PERF_CNT_3 = 32'h28;
  localparam REG_PERF_CTRL  = 32'h2C;

  // ============================================================
  // Test Sequences
  // ============================================================
  int test_pass_count = 0;
  int test_fail_count = 0;

  task automatic test_dma_read(
    input logic [31:0] src_addr,
    input logic [31:0] dst_addr,
    input logic [15:0] len,
    input logic [1:0]  mode,
    input string       test_name
  );
    logic [31:0] status;
    int timeout;

    $display("\n[TEST] %s", test_name);
    $display("  SRC=0x%08x DST=0x%08x LEN=%0d MODE=%0d", src_addr, dst_addr, len, mode);

    // Configure DMA
    write_reg(REG_DMA_SRC, src_addr);
    write_reg(REG_DMA_DST, dst_addr);
    write_reg(REG_DMA_LEN, {16'b0, len});
    write_reg(REG_DMA_CTRL, {28'b0, mode, 1'b0, 1'b1});  // direction=0 (read), start=1

    // Wait for completion
    timeout = 10000;
    do begin
      @(posedge clk);
      read_reg(REG_DMA_STATUS, status);
      timeout--;
    end while (!(status[1]) && timeout > 0);  // Wait for done bit

    if (timeout == 0) begin
      $display("  [FAIL] DMA timeout!");
      test_fail_count++;
    end else if (status[2]) begin
      $display("  [FAIL] DMA error!");
      test_fail_count++;
    end else begin
      $display("  [PASS] DMA completed, bytes=%0d", status[31:16]);
      test_pass_count++;
    end
  endtask

  task automatic test_dma_write(
    input logic [31:0] src_addr,
    input logic [31:0] dst_addr,
    input logic [15:0] len,
    input string       test_name
  );
    logic [31:0] status;
    int timeout;

    $display("\n[TEST] %s", test_name);
    $display("  SRC=0x%08x DST=0x%08x LEN=%0d (writeback)", src_addr, dst_addr, len);

    // Configure DMA for writeback (mode=10)
    write_reg(REG_DMA_SRC, src_addr);
    write_reg(REG_DMA_DST, dst_addr);
    write_reg(REG_DMA_LEN, {16'b0, len});
    write_reg(REG_DMA_CTRL, {28'b0, 2'b10, 1'b1, 1'b1});  // mode=10, direction=1 (write), start=1

    // Wait for completion
    timeout = 10000;
    do begin
      @(posedge clk);
      read_reg(REG_DMA_STATUS, status);
      timeout--;
    end while (!(status[1]) && timeout > 0);

    if (timeout == 0) begin
      $display("  [FAIL] DMA timeout!");
      test_fail_count++;
    end else if (status[2]) begin
      $display("  [FAIL] DMA error!");
      test_fail_count++;
    end else begin
      $display("  [PASS] DMA writeback completed, bytes=%0d", status[31:16]);
      test_pass_count++;
    end
  endtask

  task automatic test_perf_counters();
    logic [31:0] perf_cnt;

    $display("\n[TEST] Performance Counter Verification");

    // Clear counters
    write_reg(REG_PERF_CTRL, 32'h00000003);  // Enable + Clear
    write_reg(REG_PERF_CTRL, 32'h00000001);  // Enable only

    // Run a DMA transfer
    test_dma_read(32'h1000, 32'h0000, 64, 2'b00, "PERF_CNT DMA Transfer");

    // Check PERF_CNT_3 (DMA bytes)
    read_reg(REG_PERF_CNT_3, perf_cnt);
    $display("  PERF_CNT_3 (DMA bytes): %0d", perf_cnt);

    if (perf_cnt >= 64) begin
      $display("  [PASS] Performance counter recorded DMA bytes");
      test_pass_count++;
    end else begin
      $display("  [FAIL] Performance counter mismatch (expected >= 64, got %0d)", perf_cnt);
      test_fail_count++;
    end
  endtask

  // ============================================================
  // Main Test
  // ============================================================
  initial begin
    $display("\n");
    $display("========================================");
    $display("  TPU DMA Engine Testbench");
    $display("  Phase 2 Verification");
    $display("========================================");

    // Initialize signals
    rst_n = 0;
    cpu_sel = 0;
    cpu_wen = 0;
    cpu_ren = 0;
    cpu_addr = 0;
    cpu_wdata = 0;

    // Initialize external memory with test pattern
    for (int i = 0; i < 4096; i++) begin
      ext_mem[i] = 32'hDEAD0000 + i;
    end

    // Reset
    repeat(10) @(posedge clk);
    rst_n = 1;
    repeat(10) @(posedge clk);

    $display("\n--- DMA Read Tests ---");

    // Test 1: Single word weight prefetch
    test_dma_read(32'h1000, 32'h0000, 4, 2'b00, "Single Word Weight Prefetch");

    // Test 2: Burst weight prefetch (16 words = 64 bytes)
    test_dma_read(32'h1000, 32'h0000, 64, 2'b00, "Burst Weight Prefetch (64 bytes)");

    // Test 3: Activation prefetch
    test_dma_read(32'h2000, 32'h0000, 32, 2'b01, "Activation Prefetch (32 bytes)");

    // Test 4: Large burst (exceeds single burst)
    test_dma_read(32'h1000, 32'h0000, 128, 2'b00, "Large Burst Weight Prefetch (128 bytes)");

    $display("\n--- DMA Write Tests ---");

    // Test 5: Result writeback
    test_dma_write(32'h0000, 32'h3000, 64, "Result Writeback (64 bytes)");

    $display("\n--- Performance Counter Tests ---");
    test_perf_counters();

    // Summary
    $display("\n========================================");
    $display("  Test Summary");
    $display("========================================");
    $display("  Passed: %0d", test_pass_count);
    $display("  Failed: %0d", test_fail_count);
    $display("========================================\n");

    if (test_fail_count == 0) begin
      $display("*** ALL TESTS PASSED ***\n");
    end else begin
      $display("*** SOME TESTS FAILED ***\n");
    end

    $finish;
  end

  // Timeout watchdog
  initial begin
    #1000000;
    $display("\n[ERROR] Global timeout - simulation took too long!");
    $finish;
  end

endmodule
