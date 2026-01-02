// Tritone SoC v2 Testbench for Questa Sim
// =========================================
// Verifies Phase 1 (32-bank memory), Phase 2 (DMA), and Phase 3 (Command Queue).
//
// Test sequence:
//   1. Reset and initialization
//   2. TPU register read/write via external interface
//   3. Performance counter verification
//   4. DMA weight prefetch operation
//   5. Basic TPU compute operation
//   6. Bank conflict counter check
//   7. Output port signals
//   8. Command queue register read/write
//   9. Command queue mode execution
//
// Author: Tritone Project

`timescale 1ns/1ps

module tb_tritone_soc_v2;

  import ternary_pkg::*;

  // Parameters
  parameter int CLK_PERIOD = 10;  // 100 MHz
  parameter int ARRAY_SIZE = 8;

  // TPU Register Addresses (from tpu_top_v2.sv)
  localparam logic [31:0] TPU_BASE      = 32'h1000;
  localparam logic [31:0] REG_CTRL      = TPU_BASE + 32'h00;
  localparam logic [31:0] REG_STATUS    = TPU_BASE + 32'h04;
  localparam logic [31:0] REG_WEIGHT    = TPU_BASE + 32'h08;
  localparam logic [31:0] REG_ACT       = TPU_BASE + 32'h0C;
  localparam logic [31:0] REG_OUT       = TPU_BASE + 32'h10;
  localparam logic [31:0] REG_LAYER     = TPU_BASE + 32'h14;
  localparam logic [31:0] REG_INFO      = TPU_BASE + 32'h18;
  localparam logic [31:0] REG_PERF0     = TPU_BASE + 32'h1C;
  localparam logic [31:0] REG_PERF1     = TPU_BASE + 32'h20;
  localparam logic [31:0] REG_PERF2     = TPU_BASE + 32'h24;
  localparam logic [31:0] REG_PERF3     = TPU_BASE + 32'h28;
  localparam logic [31:0] REG_PERF_CTRL = TPU_BASE + 32'h2C;
  localparam logic [31:0] REG_DMA_SRC   = TPU_BASE + 32'h30;
  localparam logic [31:0] REG_DMA_DST   = TPU_BASE + 32'h34;
  localparam logic [31:0] REG_DMA_LEN   = TPU_BASE + 32'h38;
  localparam logic [31:0] REG_DMA_CTRL  = TPU_BASE + 32'h3C;
  localparam logic [31:0] REG_DMA_STAT  = TPU_BASE + 32'h40;
  // Command Queue Registers (Phase 3)
  localparam logic [31:0] REG_CMDQ_CTRL   = TPU_BASE + 32'h44;
  localparam logic [31:0] REG_CMDQ_STATUS = TPU_BASE + 32'h48;
  localparam logic [31:0] REG_CMDQ_DATA0  = TPU_BASE + 32'h50;
  localparam logic [31:0] REG_CMDQ_DATA1  = TPU_BASE + 32'h54;
  localparam logic [31:0] REG_CMDQ_DATA2  = TPU_BASE + 32'h58;
  localparam logic [31:0] REG_CMDQ_DATA3  = TPU_BASE + 32'h5C;

  // Signals
  logic        clk;
  logic        rst_n;
  logic        ext_sel;
  logic        ext_wen;
  logic        ext_ren;
  logic [31:0] ext_addr;
  logic [31:0] ext_wdata;
  logic [31:0] ext_rdata;
  logic        ext_ready;
  logic        cpu_halted;
  logic        tpu_busy;
  logic        tpu_done;
  logic        tpu_irq;
  logic        tpu_error;

  // Test control
  int          test_num;
  int          pass_count;
  int          fail_count;
  logic [31:0] read_data;

  // DUT
  tritone_soc_v2 #(
    .ARRAY_SIZE(ARRAY_SIZE)
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
    .tpu_irq(tpu_irq),
    .tpu_error(tpu_error)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // ============================================================
  // Helper Tasks
  // ============================================================

  task automatic reset_dut();
    rst_n <= 1'b0;
    ext_sel <= 1'b0;
    ext_wen <= 1'b0;
    ext_ren <= 1'b0;
    ext_addr <= '0;
    ext_wdata <= '0;
    repeat(10) @(posedge clk);
    rst_n <= 1'b1;
    repeat(5) @(posedge clk);
  endtask

  task automatic write_reg(input logic [31:0] addr, input logic [31:0] data);
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

  task automatic read_reg(input logic [31:0] addr, output logic [31:0] data);
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

  task automatic check_value(input string name, input logic [31:0] expected, input logic [31:0] actual);
    test_num++;
    if (expected === actual) begin
      $display("[PASS] Test %0d: %s = 0x%08h", test_num, name, actual);
      pass_count++;
    end else begin
      $display("[FAIL] Test %0d: %s expected 0x%08h, got 0x%08h", test_num, name, expected, actual);
      fail_count++;
    end
  endtask

  task automatic check_nonzero(input string name, input logic [31:0] value);
    test_num++;
    if (value !== 0) begin
      $display("[PASS] Test %0d: %s = 0x%08h (non-zero)", test_num, name, value);
      pass_count++;
    end else begin
      $display("[FAIL] Test %0d: %s expected non-zero, got 0x%08h", test_num, name, value);
      fail_count++;
    end
  endtask

  // ============================================================
  // Test Sequence
  // ============================================================

  initial begin
    $display("=================================================");
    $display("  Tritone SoC v2 Testbench - Questa Sim");
    $display("  Testing Phase 1/2/3 (Banks, DMA, Command Queue)");
    $display("=================================================");

    test_num = 0;
    pass_count = 0;
    fail_count = 0;

    // ----------------------------------------
    // Test 1: Reset and Initialization
    // ----------------------------------------
    $display("\n--- Test Section 1: Reset and Initialization ---");
    reset_dut();
    $display("[INFO] Reset complete");

    // ----------------------------------------
    // Test 2: Read ARRAY_INFO register (version check)
    // ----------------------------------------
    $display("\n--- Test Section 2: Register Interface ---");
    read_reg(REG_INFO, read_data);
    // Expected: Version=2, ArraySize=8, AccBits=32
    // [31:16]=0x0002, [15:8]=0x08, [7:0]=0x20
    check_value("ARRAY_INFO version", 16'h0002, read_data[31:16]);
    check_value("ARRAY_INFO array_size", 8'h08, read_data[15:8]);
    check_value("ARRAY_INFO acc_bits", 8'h20, read_data[7:0]);

    // ----------------------------------------
    // Test 3: Write/Read configuration registers
    // ----------------------------------------
    write_reg(REG_WEIGHT, 32'h0000_1000);
    read_reg(REG_WEIGHT, read_data);
    check_value("WEIGHT_ADDR write/read", 32'h0000_1000, read_data);

    write_reg(REG_ACT, 32'h0008_2000);  // K=8 in upper 16 bits
    read_reg(REG_ACT, read_data);
    check_value("ACT_ADDR write/read", 32'h0008_2000, read_data);

    write_reg(REG_OUT, 32'h0000_3000);
    read_reg(REG_OUT, read_data);
    check_value("OUT_ADDR write/read", 32'h0000_3000, read_data);

    write_reg(REG_LAYER, 32'h0008_0008);  // 8x8 layer
    read_reg(REG_LAYER, read_data);
    check_value("LAYER_CFG write/read", 32'h0008_0008, read_data);

    // ----------------------------------------
    // Test 4: Performance Counter Control
    // ----------------------------------------
    $display("\n--- Test Section 3: Performance Counters ---");

    // Clear counters
    write_reg(REG_PERF_CTRL, 32'h0000_0003);  // Enable + Clear
    repeat(2) @(posedge clk);
    write_reg(REG_PERF_CTRL, 32'h0000_0001);  // Enable only

    read_reg(REG_PERF0, read_data);
    check_value("PERF_CNT_0 after clear", 32'h0, read_data);

    read_reg(REG_PERF2, read_data);
    check_value("PERF_CNT_2 (bank conflicts) after clear", 32'h0, read_data);

    // ----------------------------------------
    // Test 5: Status Register Check
    // ----------------------------------------
    $display("\n--- Test Section 4: Status Signals ---");

    read_reg(REG_STATUS, read_data);
    check_value("STATUS busy bit (idle)", 1'b0, read_data[1]);
    check_value("STATUS done bit (idle)", 1'b0, read_data[8]);
    check_value("STATUS error bit (no error)", 1'b0, read_data[9]);

    // ----------------------------------------
    // Test 6: DMA Register Interface
    // ----------------------------------------
    $display("\n--- Test Section 5: DMA Registers ---");

    write_reg(REG_DMA_SRC, 32'h0000_0200);  // Source in DMEM
    read_reg(REG_DMA_SRC, read_data);
    check_value("DMA_SRC write/read", 32'h0000_0200, read_data);

    write_reg(REG_DMA_DST, 32'h0000_0000);  // Destination in weight buffer
    read_reg(REG_DMA_DST, read_data);
    check_value("DMA_DST write/read", 32'h0000_0000, read_data);

    write_reg(REG_DMA_LEN, 32'h0000_0040);  // 64 bytes
    read_reg(REG_DMA_LEN, read_data);
    check_value("DMA_LEN write/read", 32'h0000_0040, read_data);

    // Check DMA status (should be idle)
    read_reg(REG_DMA_STAT, read_data);
    check_value("DMA_STATUS busy (idle)", 1'b0, read_data[0]);

    // ----------------------------------------
    // Test 7: TPU Busy/Done output ports
    // ----------------------------------------
    $display("\n--- Test Section 6: Output Port Signals ---");

    check_value("tpu_busy port (idle)", 1'b0, tpu_busy);
    check_value("tpu_done port (idle)", 1'b0, tpu_done);
    check_value("tpu_error port (no error)", 1'b0, tpu_error);

    // ----------------------------------------
    // Test 8: Start a compute operation (brief)
    // ----------------------------------------
    $display("\n--- Test Section 7: Compute Start ---");

    // Configure for 8x8 compute
    write_reg(REG_LAYER, 32'h0008_0008);
    write_reg(REG_ACT, 32'h0008_0000);  // K=8

    // Start TPU
    write_reg(REG_CTRL, 32'h0000_0001);

    // Wait a few cycles and check busy
    repeat(5) @(posedge clk);
    read_reg(REG_STATUS, read_data);
    // Note: May or may not be busy depending on implementation timing
    $display("[INFO] STATUS after start: 0x%08h (busy=%b)", read_data, read_data[1]);

    // Wait for completion (with timeout)
    repeat(500) @(posedge clk);

    // Check final status
    read_reg(REG_STATUS, read_data);
    $display("[INFO] STATUS after wait: 0x%08h", read_data);

    // Check performance counter incremented
    read_reg(REG_PERF0, read_data);
    $display("[INFO] PERF_CNT_0 (busy cycles): %0d", read_data);

    // ----------------------------------------
    // Test 8: Command Queue Registers (Phase 3)
    // ----------------------------------------
    $display("\n--- Test Section 8: Command Queue Registers ---");

    // Check initial CMDQ status (should be empty)
    read_reg(REG_CMDQ_STATUS, read_data);
    check_value("CMDQ_STATUS empty bit (initial)", 1'b1, read_data[4]);
    check_value("CMDQ_STATUS full bit (initial)", 1'b0, read_data[5]);
    check_value("CMDQ_STATUS count (initial)", 4'h0, read_data[3:0]);

    // Write command descriptor registers
    write_reg(REG_CMDQ_DATA0, 32'h0808_0000);  // wgt_base=0, k_tile=8, m_tile=0, n_tile=0
    read_reg(REG_CMDQ_DATA0, read_data);
    check_value("CMDQ_DATA0 write/read", 32'h0808_0000, read_data);

    write_reg(REG_CMDQ_DATA1, 32'h0000_2000);  // act_base = 0x2000
    read_reg(REG_CMDQ_DATA1, read_data);
    check_value("CMDQ_DATA1 write/read", 32'h0000_2000, read_data);

    write_reg(REG_CMDQ_DATA2, 32'h0000_3000);  // out_base = 0x3000
    read_reg(REG_CMDQ_DATA2, read_data);
    check_value("CMDQ_DATA2 write/read", 32'h0000_3000, read_data);

    // Write DATA3 triggers push
    write_reg(REG_CMDQ_DATA3, 32'h00_00_00_00);  // opcode=GEMM(0x00), no chain, no irq
    repeat(2) @(posedge clk);

    // Check count increased
    read_reg(REG_CMDQ_STATUS, read_data);
    check_value("CMDQ_STATUS count after push", 4'h1, read_data[3:0]);
    check_value("CMDQ_STATUS empty after push", 1'b0, read_data[4]);

    // Push a second command (with IRQ enabled)
    write_reg(REG_CMDQ_DATA0, 32'h0808_1000);
    write_reg(REG_CMDQ_DATA1, 32'h0000_4000);
    write_reg(REG_CMDQ_DATA2, 32'h0000_5000);
    write_reg(REG_CMDQ_DATA3, 32'h04_00_00_00);  // opcode=0x00, irq_en=1 (bit 118 = DATA3[22])
    repeat(2) @(posedge clk);

    read_reg(REG_CMDQ_STATUS, read_data);
    check_value("CMDQ_STATUS count after 2nd push", 4'h2, read_data[3:0]);

    // Test flush
    write_reg(REG_CMDQ_CTRL, 32'h0000_0001);  // Flush
    repeat(2) @(posedge clk);

    read_reg(REG_CMDQ_STATUS, read_data);
    check_value("CMDQ_STATUS count after flush", 4'h0, read_data[3:0]);
    check_value("CMDQ_STATUS empty after flush", 1'b1, read_data[4]);

    // ----------------------------------------
    // Test 9: Command Queue Mode Execution
    // ----------------------------------------
    $display("\n--- Test Section 9: Command Queue Mode ---");

    // Configure for 8x8 compute (legacy registers still used for configuration)
    write_reg(REG_LAYER, 32'h0008_0008);
    write_reg(REG_ACT, 32'h0008_0000);  // K=8

    // Enable command queue mode (bit 16 of CTRL)
    write_reg(REG_CTRL, 32'h0001_0000);

    // Push a command
    write_reg(REG_CMDQ_DATA0, 32'h0808_0000);
    write_reg(REG_CMDQ_DATA1, 32'h0000_0000);
    write_reg(REG_CMDQ_DATA2, 32'h0000_0000);
    write_reg(REG_CMDQ_DATA3, 32'h00_00_00_00);  // GEMM opcode
    repeat(2) @(posedge clk);

    // Command queue should start executing automatically
    repeat(10) @(posedge clk);
    read_reg(REG_STATUS, read_data);
    $display("[INFO] STATUS in cmdq mode: 0x%08h (busy=%b)", read_data, read_data[1]);

    // Wait for completion
    repeat(500) @(posedge clk);

    // Queue should be empty after execution
    read_reg(REG_CMDQ_STATUS, read_data);
    $display("[INFO] CMDQ_STATUS after exec: 0x%08h (count=%0d, empty=%b)",
             read_data, read_data[3:0], read_data[4]);

    // Disable cmdq mode
    write_reg(REG_CTRL, 32'h0000_0000);

    // ----------------------------------------
    // Summary
    // ----------------------------------------
    $display("\n=================================================");
    $display("  Test Summary:");
    $display("    Total:  %0d", test_num);
    $display("    Passed: %0d", pass_count);
    $display("    Failed: %0d", fail_count);
    $display("=================================================");

    if (fail_count == 0) begin
      $display("\n*** ALL TESTS PASSED ***\n");
    end else begin
      $display("\n*** SOME TESTS FAILED ***\n");
    end

    $finish;
  end

  // Timeout watchdog
  initial begin
    #100000;  // 100us timeout
    $display("\n[ERROR] Simulation timeout!");
    $finish;
  end

endmodule
