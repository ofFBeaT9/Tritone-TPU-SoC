// Tritone TPU Phase 8 - Power Analysis Testbench
// ================================================
// Generates VCD/SAIF data for power estimation tools
//
// Usage:
//   1. Simulate with VCD dumping enabled
//   2. Convert VCD to SAIF: vcd2saif -i tpu_power.vcd -o tpu_power.saif
//   3. Run power analysis with SAIF in synthesis flow
//
// Benchmarks exercised:
//   - GEMM 64x64 (dense matmul, high PE activity)
//   - Burst DMA (memory system activity)
//   - Nonlinear operations (LUT/RSQRT activity)
//
// Author: Tritone Project (Phase 8)

`timescale 1ns/1ps

module tb_tpu_power;

  // ============================================================
  // Parameters
  // ============================================================
  parameter int ARRAY_SIZE = 64;
  parameter int ACT_BITS = 16;
  parameter int ACC_BITS = 32;
  parameter int ADDR_WIDTH = 32;
  parameter int DATA_WIDTH = 32;
  parameter real CLK_PERIOD_NS = 1.0;  // 1 GHz target

  // Power analysis periods (in cycles)
  parameter int WARMUP_CYCLES = 1000;
  parameter int MEASURE_CYCLES = 10000;
  parameter int COOLDOWN_CYCLES = 500;

  // ============================================================
  // Clock and Reset
  // ============================================================
  logic clk;
  logic rst_n;

  initial clk = 0;
  always #(CLK_PERIOD_NS/2) clk = ~clk;

  // ============================================================
  // TPU Interface Signals
  // ============================================================
  logic                    cpu_sel;
  logic                    cpu_wen;
  logic                    cpu_ren;
  logic [ADDR_WIDTH-1:0]   cpu_addr;
  logic [DATA_WIDTH-1:0]   cpu_wdata;
  logic [DATA_WIDTH-1:0]   cpu_rdata;
  logic                    cpu_ready;

  // AXI Master (simplified for power testing)
  logic                    m_axi_awvalid;
  logic                    m_axi_awready;
  logic [ADDR_WIDTH-1:0]   m_axi_awaddr;
  logic [7:0]              m_axi_awlen;
  logic [2:0]              m_axi_awsize;
  logic [1:0]              m_axi_awburst;
  logic                    m_axi_wvalid;
  logic                    m_axi_wready;
  logic [DATA_WIDTH-1:0]   m_axi_wdata;
  logic [DATA_WIDTH/8-1:0] m_axi_wstrb;
  logic                    m_axi_wlast;
  logic                    m_axi_bvalid;
  logic                    m_axi_bready;
  logic [1:0]              m_axi_bresp;
  logic                    m_axi_arvalid;
  logic                    m_axi_arready;
  logic [ADDR_WIDTH-1:0]   m_axi_araddr;
  logic [7:0]              m_axi_arlen;
  logic [2:0]              m_axi_arsize;
  logic [1:0]              m_axi_arburst;
  logic                    m_axi_rvalid;
  logic                    m_axi_rready;
  logic [DATA_WIDTH-1:0]   m_axi_rdata;
  logic [1:0]              m_axi_rresp;
  logic                    m_axi_rlast;

  logic                    dma_req;
  logic                    dma_wr;
  logic [ADDR_WIDTH-1:0]   dma_addr;
  logic [DATA_WIDTH-1:0]   dma_wdata;
  logic [DATA_WIDTH-1:0]   dma_rdata;
  logic                    dma_ack;
  logic                    irq;
  logic                    busy;
  logic                    done;
  logic                    status_error;

  // ============================================================
  // Register Addresses
  // ============================================================
  localparam logic [7:0] REG_CTRL       = 8'h00;
  localparam logic [7:0] REG_STATUS     = 8'h04;
  localparam logic [7:0] REG_WEIGHT_ADDR = 8'h08;
  localparam logic [7:0] REG_ACT_ADDR   = 8'h0C;
  localparam logic [7:0] REG_OUT_ADDR   = 8'h10;
  localparam logic [7:0] REG_LAYER_CFG  = 8'h14;
  localparam logic [7:0] REG_PERF_CNT_0 = 8'h1C;
  localparam logic [7:0] REG_PERF_CTRL  = 8'h2C;
  localparam logic [7:0] REG_NL_CTRL    = 8'h60;

  // ============================================================
  // Activity Tracking (for power analysis validation)
  // ============================================================
  int unsigned toggle_count_clk;
  int unsigned toggle_count_busy;
  int unsigned cycle_count;
  int unsigned active_cycles;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cycle_count <= 0;
      active_cycles <= 0;
    end else begin
      cycle_count <= cycle_count + 1;
      if (busy) active_cycles <= active_cycles + 1;
    end
  end

  // ============================================================
  // AXI Memory Model
  // ============================================================
  logic [31:0] axi_memory [0:16383];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      m_axi_awready <= 1'b1;
      m_axi_wready <= 1'b1;
      m_axi_bvalid <= 1'b0;
      m_axi_bresp <= 2'b00;
      m_axi_arready <= 1'b1;
      m_axi_rvalid <= 1'b0;
      m_axi_rdata <= '0;
      m_axi_rresp <= 2'b00;
      m_axi_rlast <= 1'b0;
    end else begin
      if (m_axi_wvalid && m_axi_wready && m_axi_wlast) m_axi_bvalid <= 1'b1;
      if (m_axi_bvalid && m_axi_bready) m_axi_bvalid <= 1'b0;
      if (m_axi_arvalid && m_axi_arready) begin
        m_axi_rvalid <= 1'b1;
        m_axi_rdata <= axi_memory[m_axi_araddr[15:2]];
        m_axi_rlast <= 1'b1;
      end
      if (m_axi_rvalid && m_axi_rready) begin
        m_axi_rvalid <= 1'b0;
        m_axi_rlast <= 1'b0;
      end
      if (m_axi_wvalid && m_axi_wready)
        axi_memory[m_axi_awaddr[15:2]] <= m_axi_wdata;
    end
  end

  assign dma_rdata = axi_memory[dma_addr[15:2]];
  assign dma_ack = dma_req;

  // ============================================================
  // DUT Instantiation
  // ============================================================
  tpu_top_v2 #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .USE_BANKED_MEMORY(1'b1),
    .USE_HIERARCHICAL_ARRAY(1'b1),
    .NUM_BANKS(32),
    .MAX_K(4096)
  ) u_tpu (
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
    .done(done),
    .status_error(status_error)
  );

  // ============================================================
  // Helper Tasks
  // ============================================================
  task automatic write_reg(input logic [7:0] addr, input logic [31:0] data);
    @(posedge clk);
    cpu_sel <= 1'b1;
    cpu_wen <= 1'b1;
    cpu_addr <= {24'b0, addr};
    cpu_wdata <= data;
    @(posedge clk);
    while (!cpu_ready) @(posedge clk);
    cpu_sel <= 1'b0;
    cpu_wen <= 1'b0;
    @(posedge clk);
  endtask

  task automatic wait_cycles(input int n);
    repeat(n) @(posedge clk);
  endtask

  task automatic wait_for_done(input int timeout);
    automatic int cnt = 0;
    while (!done && cnt < timeout) begin
      @(posedge clk);
      cnt++;
    end
  endtask

  // ============================================================
  // VCD Dump Control
  // ============================================================
  logic vcd_enabled;
  string vcd_filename;

  initial begin
    vcd_enabled = 1'b0;

    // Check for VCD filename from command line
    if ($value$plusargs("VCD_FILE=%s", vcd_filename)) begin
      $display("VCD output enabled: %s", vcd_filename);
      vcd_enabled = 1'b1;
    end else begin
      vcd_filename = "tpu_power.vcd";
    end

    // Initialize VCD dump
    $dumpfile(vcd_filename);

    // Dump hierarchy levels:
    // Level 0 = all signals (large file)
    // Level 1 = top-level + 1 level deep (recommended for power)
    // Level 2 = top-level + 2 levels deep
    $dumpvars(2, u_tpu);

    // Selective dumping for key modules (reduces file size):
    // Uncomment specific modules as needed
    // $dumpvars(1, u_tpu.u_systolic_array);
    // $dumpvars(1, u_tpu.u_memory_controller);
    // $dumpvars(1, u_tpu.u_dma_engine);
  end

  // ============================================================
  // Power Test Scenarios
  // ============================================================

  // Scenario 1: Idle Power (baseline leakage)
  task automatic run_idle_test();
    $display("\n=== Power Test 1: Idle (Leakage Baseline) ===");
    $display("  Measuring for %0d cycles...", MEASURE_CYCLES);

    $dumpoff;  // Pause during setup
    wait_cycles(WARMUP_CYCLES);

    $dumpon;   // Start capture
    wait_cycles(MEASURE_CYCLES);
    $dumpoff;  // Stop capture

    $display("  Idle test complete");
  endtask

  // Scenario 2: GEMM Compute (high PE activity)
  task automatic run_gemm_power_test();
    $display("\n=== Power Test 2: GEMM Compute (High Activity) ===");

    // Configure 64x64 GEMM
    write_reg(REG_WEIGHT_ADDR, 32'h00000000);
    write_reg(REG_ACT_ADDR, {16'd64, 16'h1000});  // K=64
    write_reg(REG_OUT_ADDR, 32'h00002000);
    write_reg(REG_LAYER_CFG, {16'd64, 16'd64});   // 64x64

    $display("  Running GEMM 64x64...");
    $dumpon;

    // Start computation
    write_reg(REG_CTRL, 32'h00000001);

    // Wait for completion (with VCD capture)
    wait_for_done(100000);

    $dumpoff;

    $display("  GEMM compute test complete");
    $display("  Active cycles: %0d", active_cycles);
  endtask

  // Scenario 3: Memory Burst (DMA activity)
  task automatic run_memory_burst_test();
    $display("\n=== Power Test 3: Memory Burst (DMA Activity) ===");

    // Simulate DMA burst patterns
    $dumpon;

    for (int burst = 0; burst < 10; burst++) begin
      // Configure DMA transfer
      write_reg(8'h30, 32'h00000000 + burst * 256);  // DMA_SRC
      write_reg(8'h34, 32'h00004000 + burst * 256);  // DMA_DST
      write_reg(8'h38, 32'd256);                      // DMA_LEN
      write_reg(8'h3C, 32'h00000001);                // DMA_CTRL start

      wait_cycles(100);  // Wait for burst
    end

    $dumpoff;
    $display("  Memory burst test complete");
  endtask

  // Scenario 4: Nonlinear Operations (LUT activity)
  task automatic run_nonlinear_power_test();
    $display("\n=== Power Test 4: Nonlinear (LUT Activity) ===");

    $dumpon;

    // Enable LUT with sigmoid function
    write_reg(REG_NL_CTRL, 32'h00000010);  // Enable

    // Process multiple values through LUT
    for (int i = 0; i < 256; i++) begin
      wait_cycles(3);  // ~3 cycles per LUT operation
    end

    write_reg(REG_NL_CTRL, 32'h00000000);  // Disable

    $dumpoff;
    $display("  Nonlinear test complete");
  endtask

  // Scenario 5: Mixed Workload (representative benchmark)
  task automatic run_mixed_workload();
    $display("\n=== Power Test 5: Mixed Workload (Representative) ===");

    $dumpon;

    // Run a sequence that represents typical FEP/MD workload
    // GEMM phase
    write_reg(REG_WEIGHT_ADDR, 32'h00000000);
    write_reg(REG_ACT_ADDR, {16'd32, 16'h1000});
    write_reg(REG_OUT_ADDR, 32'h00002000);
    write_reg(REG_LAYER_CFG, {16'd32, 16'd32});
    write_reg(REG_CTRL, 32'h00000001);
    wait_for_done(50000);

    // Nonlinear phase
    write_reg(REG_NL_CTRL, 32'h00000012);  // EXP function
    wait_cycles(1000);
    write_reg(REG_NL_CTRL, 32'h00000000);

    // Memory writeback phase
    wait_cycles(500);

    $dumpoff;
    $display("  Mixed workload test complete");
  endtask

  // ============================================================
  // Main Test Sequence
  // ============================================================
  initial begin
    $display("");
    $display("================================================================");
    $display("  Tritone TPU Phase 8 - Power Analysis Testbench");
    $display("================================================================");
    $display("  VCD Output: %s", vcd_filename);
    $display("  Warmup Cycles: %0d", WARMUP_CYCLES);
    $display("  Measure Cycles: %0d", MEASURE_CYCLES);
    $display("");

    // Initialize
    rst_n = 0;
    cpu_sel = 0;
    cpu_wen = 0;
    cpu_ren = 0;
    cpu_addr = 0;
    cpu_wdata = 0;

    // Initialize memory with pseudo-random data
    for (int i = 0; i < 16384; i++) begin
      axi_memory[i] = $random;
    end

    // Release reset
    #100 rst_n = 1;
    #50;

    $display("  TPU initialized, running power tests...\n");

    // Run power test scenarios
    run_idle_test();
    run_gemm_power_test();
    run_memory_burst_test();
    run_nonlinear_power_test();
    run_mixed_workload();

    // Final statistics
    $display("");
    $display("================================================================");
    $display("  Power Test Summary");
    $display("================================================================");
    $display("  Total cycles:  %0d", cycle_count);
    $display("  Active cycles: %0d", active_cycles);
    $display("  Activity:      %.1f%%", 100.0 * real'(active_cycles) / real'(cycle_count));
    $display("");
    $display("  VCD file generated: %s", vcd_filename);
    $display("  Convert to SAIF: vcd2saif -i %s -o tpu_power.saif", vcd_filename);
    $display("================================================================");
    $display("");

    #100 $finish;
  end

  // Timeout watchdog
  initial begin
    #5000000;
    $display("ERROR: Test timeout!");
    $finish;
  end

endmodule
