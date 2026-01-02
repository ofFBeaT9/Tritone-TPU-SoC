// TPU DMA Engine Simple Standalone Testbench
// Tests the DMA engine in isolation
`timescale 1ns/1ps

module tb_tpu_dma_simple;

  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;
  parameter int CLK_PERIOD = 10;

  // Signals
  logic clk, rst_n;

  // Control interface
  logic start;
  logic [ADDR_WIDTH-1:0] src_addr, dst_addr;
  logic [15:0] transfer_len;
  logic direction;
  logic [1:0] mode;
  logic busy, done, error;
  logic [31:0] bytes_transferred;

  // AXI interface
  logic m_axi_awvalid, m_axi_awready;
  logic [ADDR_WIDTH-1:0] m_axi_awaddr;
  logic [7:0] m_axi_awlen;
  logic [2:0] m_axi_awsize;
  logic [1:0] m_axi_awburst;

  logic m_axi_wvalid, m_axi_wready;
  logic [DATA_WIDTH-1:0] m_axi_wdata;
  logic [DATA_WIDTH/8-1:0] m_axi_wstrb;
  logic m_axi_wlast;

  logic m_axi_bvalid, m_axi_bready;
  logic [1:0] m_axi_bresp;

  logic m_axi_arvalid, m_axi_arready;
  logic [ADDR_WIDTH-1:0] m_axi_araddr;
  logic [7:0] m_axi_arlen;
  logic [2:0] m_axi_arsize;
  logic [1:0] m_axi_arburst;

  logic m_axi_rvalid, m_axi_rready;
  logic [DATA_WIDTH-1:0] m_axi_rdata;
  logic [1:0] m_axi_rresp;
  logic m_axi_rlast;

  // Buffer interface
  logic wgt_buf_wr_en;
  logic [15:0] wgt_buf_wr_addr;
  logic [DATA_WIDTH-1:0] wgt_buf_wr_data;
  logic act_buf_wr_en;
  logic [15:0] act_buf_wr_addr;
  logic [DATA_WIDTH-1:0] act_buf_wr_data;
  logic out_buf_rd_en;
  logic [15:0] out_buf_rd_addr;
  logic [DATA_WIDTH-1:0] out_buf_rd_data;
  logic out_buf_rd_valid;

  // DUT
  tpu_dma_engine #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .MAX_BURST_LEN(16),
    .BUFFER_DEPTH(64)
  ) u_dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .src_addr(src_addr),
    .dst_addr(dst_addr),
    .transfer_len(transfer_len),
    .direction(direction),
    .mode(mode),
    .busy(busy),
    .done(done),
    .error(error),
    .bytes_transferred(bytes_transferred),
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
    .wgt_buf_wr_en(wgt_buf_wr_en),
    .wgt_buf_wr_addr(wgt_buf_wr_addr),
    .wgt_buf_wr_data(wgt_buf_wr_data),
    .act_buf_wr_en(act_buf_wr_en),
    .act_buf_wr_addr(act_buf_wr_addr),
    .act_buf_wr_data(act_buf_wr_data),
    .out_buf_rd_en(out_buf_rd_en),
    .out_buf_rd_addr(out_buf_rd_addr),
    .out_buf_rd_data(out_buf_rd_data),
    .out_buf_rd_valid(out_buf_rd_valid)
  );

  // Clock
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // Memory model
  logic [DATA_WIDTH-1:0] ext_mem [0:4095];
  logic [DATA_WIDTH-1:0] wgt_buffer [0:4095];
  logic [7:0] axi_burst_cnt, axi_burst_len;
  logic [ADDR_WIDTH-1:0] axi_addr;

  typedef enum logic [1:0] {AXI_IDLE, AXI_READ, AXI_WRITE, AXI_WRESP} axi_state_t;
  axi_state_t axi_state;

  // AXI slave
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
            $display("[AXI] Read request: addr=0x%08x len=%0d", m_axi_araddr, m_axi_arlen+1);
            m_axi_arready <= 1'b1;
            axi_addr <= m_axi_araddr;
            axi_burst_len <= m_axi_arlen;
            axi_burst_cnt <= '0;
            axi_state <= AXI_READ;
          end else if (m_axi_awvalid) begin
            $display("[AXI] Write request: addr=0x%08x len=%0d", m_axi_awaddr, m_axi_awlen+1);
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
            $display("[AXI] Read data[%0d]: addr=0x%08x data=0x%08x", axi_burst_cnt, axi_addr, ext_mem[axi_addr[13:2]]);
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
            $display("[AXI] Write data[%0d]: addr=0x%08x data=0x%08x", axi_burst_cnt, axi_addr, m_axi_wdata);
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

  // Buffer write capture
  always_ff @(posedge clk) begin
    if (wgt_buf_wr_en) begin
      wgt_buffer[wgt_buf_wr_addr[11:0]] <= wgt_buf_wr_data;
      $display("[BUF] Weight write: addr=0x%04x data=0x%08x", wgt_buf_wr_addr, wgt_buf_wr_data);
    end
  end

  // Output buffer read
  assign out_buf_rd_data = 32'hCAFE0000 + out_buf_rd_addr;
  assign out_buf_rd_valid = 1'b1;

  // Test
  int test_pass = 0, test_fail = 0;

  initial begin
    $display("\n========================================");
    $display("  DMA Engine Simple Testbench");
    $display("========================================\n");

    // Init
    rst_n = 0;
    start = 0;
    src_addr = 0;
    dst_addr = 0;
    transfer_len = 0;
    direction = 0;
    mode = 0;

    // Init memory
    for (int i = 0; i < 4096; i++) ext_mem[i] = 32'hDEAD0000 + i;

    repeat(5) @(posedge clk);
    rst_n = 1;
    repeat(5) @(posedge clk);

    // Test 1: Single word read
    $display("\n[TEST 1] Single Word Read (4 bytes)");
    src_addr = 32'h1000;
    dst_addr = 32'h0000;
    transfer_len = 4;
    direction = 0;  // read
    mode = 2'b00;   // weight
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    // Wait for busy to assert first
    wait(busy);
    $display("  DMA started, waiting for completion...");
    // Then wait for done
    wait(done);
    @(posedge clk);

    if (done && !error) begin
      $display("[PASS] Single word read completed, bytes=%0d", bytes_transferred);
      test_pass++;
    end else begin
      $display("[FAIL] Single word read - done=%b error=%b busy=%b", done, error, busy);
      test_fail++;
    end

    repeat(5) @(posedge clk);

    // Test 2: Burst read (64 bytes = 16 words)
    $display("\n[TEST 2] Burst Read (64 bytes)");
    src_addr = 32'h2000;
    dst_addr = 32'h0100;
    transfer_len = 64;
    direction = 0;
    mode = 2'b00;
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    wait(busy);
    $display("  DMA started, waiting for completion...");
    wait(done);
    @(posedge clk);

    if (done && !error) begin
      $display("[PASS] Burst read completed, bytes=%0d", bytes_transferred);
      test_pass++;
    end else begin
      $display("[FAIL] Burst read - done=%b error=%b busy=%b", done, error, busy);
      test_fail++;
    end

    repeat(5) @(posedge clk);

    // Summary
    $display("\n========================================");
    $display("  Results: %0d passed, %0d failed", test_pass, test_fail);
    $display("========================================\n");

    $finish;
  end

  // Watchdog
  initial begin
    #50000;
    $display("\n[ERROR] Timeout!");
    $finish;
  end

endmodule
