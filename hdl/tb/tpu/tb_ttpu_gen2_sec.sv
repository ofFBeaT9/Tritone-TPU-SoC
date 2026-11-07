// TTPU-Gen2 security register test (SEC at 0x70): the zero-skip counts (STATUS[31:16], PERF_CNT_1) are the weight
// sparsity, so they stay 0 unless SEC[0] opts in; SEC[31] LOCK is set-only, clears the opt-in and freezes SEC.
// The array's per-cycle zero-skip count and array_enable are forced, so the test does not depend on a full matmul run.
// Run: verilator --binary --timing ... --top-module tb_ttpu_gen2_sec (see scripts/run_gen2_tests.sh)
`timescale 1ns/1ps
module tb_ttpu_gen2_sec;
  logic clk = 0, rst_n = 0;
  always #5 clk = ~clk;
  logic        cpu_sel = 0, cpu_wen = 0, cpu_ren = 0, cpu_ready;
  logic [31:0] cpu_addr = 0, cpu_wdata = 0, cpu_rdata;
  int errors = 0, checks = 0;

  tpu_top_v2 #(.ARRAY_SIZE(8), .USE_BANKED_MEMORY(1'b0), .USE_HIERARCHICAL_ARRAY(1'b0)) dut (
    .clk(clk), .rst_n(rst_n),
    .cpu_sel(cpu_sel), .cpu_wen(cpu_wen), .cpu_ren(cpu_ren), .cpu_addr(cpu_addr), .cpu_wdata(cpu_wdata),
    .cpu_rdata(cpu_rdata), .cpu_ready(cpu_ready));

  task automatic wr(input logic [7:0] a, input logic [31:0] d);
    @(negedge clk); cpu_sel = 1; cpu_wen = 1; cpu_addr = {24'b0, a}; cpu_wdata = d;
    @(negedge clk); while (!cpu_ready) @(negedge clk);
    cpu_sel = 0; cpu_wen = 0;
  endtask
  task automatic rd(input logic [7:0] a, output logic [31:0] d);
    @(negedge clk); cpu_sel = 1; cpu_ren = 1; cpu_addr = {24'b0, a};
    #1 d = cpu_rdata;
    @(negedge clk); cpu_sel = 0; cpu_ren = 0;
  endtask
  task automatic chk(input string what, input logic ok);
    checks++; if (!ok) begin errors++; $display("[FAIL] %s", what); end else $display("[PASS] %s", what);
  endtask

  logic [31:0] st, pc1, sec;
  initial begin
    repeat (4) @(negedge clk); rst_n = 1; repeat (2) @(negedge clk);
    force dut.array_enable = 1'b1;
    force dut.zero_skip_count_comb = 16'd5;
    // 1. default: counts hidden and not counted
    repeat (20) @(negedge clk);
    rd(8'h04, st); rd(8'h20, pc1); rd(8'h70, sec);
    chk("default: SEC reads 0", sec == 0);
    chk("default: STATUS[31:16] reads 0", st[31:16] == 0);
    chk("default: PERF_CNT_1 reads 0", pc1 == 0);
    // 2. opt-in: counting works as before Gen2
    wr(8'h70, 32'h1);
    repeat (20) @(negedge clk);
    rd(8'h04, st); rd(8'h20, pc1); rd(8'h70, sec);
    chk("opt-in: SEC reads 1", sec == 32'h1);
    chk("opt-in: STATUS[31:16] counts", st[31:16] >= 16'd100);
    chk("opt-in: PERF_CNT_1 counts", pc1 >= 32'd100);
    // 3. LOCK: clears the opt-in, counts hidden again, SEC frozen
    wr(8'h70, 32'h8000_0001);
    repeat (5) @(negedge clk);
    rd(8'h04, st); rd(8'h20, pc1); rd(8'h70, sec);
    chk("LOCK: SEC reads 0x80000000 (opt-in cleared)", sec == 32'h8000_0000);
    chk("LOCK: STATUS[31:16] reads 0", st[31:16] == 0);
    chk("LOCK: PERF_CNT_1 reads 0", pc1 == 0);
    wr(8'h70, 32'h0000_0001); wr(8'h70, 32'h0);
    rd(8'h70, sec);
    chk("LOCK: writes cannot clear LOCK or set the opt-in", sec == 32'h8000_0000);
    // 4. reset clears LOCK
    rst_n = 0; repeat (3) @(negedge clk); rst_n = 1; repeat (2) @(negedge clk);
    rd(8'h70, sec);
    chk("reset clears SEC", sec == 0);
    release dut.array_enable; release dut.zero_skip_count_comb;
    $display("TTPU-Gen2 SEC test: %0d checks, %0d failures", checks, errors);
    $display(errors == 0 ? "*** ALL TESTS PASSED ***" : "*** SOME TESTS FAILED ***");
    $finish;
  end
endmodule
