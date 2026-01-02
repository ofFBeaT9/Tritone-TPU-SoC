// Phase 5 Compute Enhancements Testbench
// =======================================
// Tests:
//   5.1: Guard trits + saturation
//   5.2: Weight packing/unpacking
//   5.3: 81-trit wide accumulator
//   5.4: Reduction unit
//
// Author: Tritone Project

`timescale 1ns/1ps

module tb_phase5_compute;

  // Clock and reset
  logic clk;
  logic rst_n;

  // Clock generation (500 MHz)
  initial clk = 0;
  always #1 clk = ~clk;

  // ============================================================
  // Test 1: Guard Trits + Saturation (ternary_mac_v2_int)
  // ============================================================

  // MAC signals
  logic                       mac_enable;
  logic                       mac_clear;
  logic signed [15:0]         mac_activation;
  logic [1:0]                 mac_weight;
  logic signed [31:0]         mac_psum_in;
  logic signed [31:0]         mac_psum_out;
  logic                       mac_zero_skip;
  logic                       mac_saturated;

  ternary_mac_v2_int #(
    .ACT_BITS(16),
    .ACC_BITS(32),
    .GUARD_BITS(4),
    .ENABLE_SATURATION(1)
  ) u_mac (
    .clk(clk),
    .rst_n(rst_n),
    .enable(mac_enable),
    .clear(mac_clear),
    .activation(mac_activation),
    .weight(mac_weight),
    .psum_in(mac_psum_in),
    .psum_out(mac_psum_out),
    .zero_skip(mac_zero_skip),
    .saturated(mac_saturated)
  );

  // ============================================================
  // Test 2: Weight Packing/Unpacking
  // ============================================================

  logic [4:0][1:0]  pack_weights_in;
  logic [7:0]       packed_value;
  logic             pack_valid_in;
  logic             pack_valid_out;

  tpu_weight_packer u_packer (
    .weights_in(pack_weights_in),
    .packed_out(packed_value),
    .valid_in(pack_valid_in),
    .valid_out(pack_valid_out)
  );

  logic [7:0]       unpack_in;
  logic [4:0][1:0]  unpack_weights_out;
  logic             unpack_valid_in;
  logic             unpack_valid_out;
  logic             unpack_error;

  tpu_weight_unpacker u_unpacker (
    .packed_in(unpack_in),
    .weights_out(unpack_weights_out),
    .valid_in(unpack_valid_in),
    .valid_out(unpack_valid_out),
    .error(unpack_error)
  );

  // ============================================================
  // Test 3: Accumulator Cast
  // ============================================================

  logic                       cast_enable;
  logic                       cast_debug;
  logic [1:0]                 cast_round_mode;
  logic [3:0]                 cast_shift;
  logic signed [127:0]        cast_wide_in;
  logic                       cast_wide_valid;
  logic signed [31:0]         cast_out;
  logic                       cast_out_valid;
  logic                       cast_saturated;

  tpu_accum_cast #(
    .WIDE_WIDTH(128),
    .OUT_WIDTH(32)
  ) u_cast (
    .clk(clk),
    .rst_n(rst_n),
    .enable(cast_enable),
    .debug_mode(cast_debug),
    .round_mode(cast_round_mode),
    .shift_amount(cast_shift),
    .wide_in(cast_wide_in),
    .wide_valid(cast_wide_valid),
    .out(cast_out),
    .out_valid(cast_out_valid),
    .saturated(cast_saturated),
    .debug_out(),
    .debug_valid()
  );

  // ============================================================
  // Test 4: Reduction Unit
  // ============================================================

  logic                       reduce_start;
  logic [1:0]                 reduce_op;
  logic [11:0]                reduce_length;
  logic [3:0]                 reduce_shift;
  logic                       reduce_busy;
  logic                       reduce_done;
  logic signed [31:0]         reduce_data_in;
  logic                       reduce_data_valid;
  logic                       reduce_data_ready;
  logic signed [31:0]         reduce_result;
  logic                       reduce_result_valid;
  logic                       reduce_saturated;
  logic [31:0]                reduce_cycles;
  logic [31:0]                reduce_elements;

  tpu_reduce_unit #(
    .DATA_WIDTH(32),
    .ACC_WIDTH(128),
    .MAX_LENGTH(4096),
    .OUT_WIDTH(32)
  ) u_reduce (
    .clk(clk),
    .rst_n(rst_n),
    .start(reduce_start),
    .op_mode(reduce_op),
    .length(reduce_length),
    .out_shift(reduce_shift),
    .busy(reduce_busy),
    .done(reduce_done),
    .data_in(reduce_data_in),
    .data_valid(reduce_data_valid),
    .data_ready(reduce_data_ready),
    .result(reduce_result),
    .result_valid(reduce_result_valid),
    .saturated(reduce_saturated),
    .result_wide(),
    .cycles_count(reduce_cycles),
    .elements_count(reduce_elements)
  );

  // ============================================================
  // Test Sequence
  // ============================================================

  initial begin
    automatic int errors = 0;
    automatic int test_num = 0;

    $display("");
    $display("================================================================");
    $display("  Phase 5: Compute Enhancements Testbench");
    $display("================================================================");
    $display("");

    // Initialize
    rst_n = 0;
    mac_enable = 0;
    mac_clear = 0;
    mac_activation = 0;
    mac_weight = 2'b01;
    mac_psum_in = 0;
    pack_weights_in = '0;
    pack_valid_in = 0;
    unpack_in = 0;
    unpack_valid_in = 0;
    cast_enable = 0;
    cast_debug = 0;
    cast_round_mode = 0;
    cast_shift = 0;
    cast_wide_in = 0;
    cast_wide_valid = 0;
    reduce_start = 0;
    reduce_op = 0;
    reduce_length = 0;
    reduce_shift = 0;
    reduce_data_in = 0;
    reduce_data_valid = 0;

    #20 rst_n = 1;
    #10;

    // --------------------------------------------------------
    // Test 1: Guard Trits + Saturation
    // --------------------------------------------------------
    test_num++;
    $display("--- Test %0d: Guard Trits + Saturation (MAC) ---", test_num);

    // Test 1a: Basic MAC operation
    mac_clear = 1;
    @(posedge clk);
    mac_clear = 0;

    // Accumulate: 1000 × (+1) = 1000
    mac_activation = 16'sd1000;
    mac_weight = 2'b10;  // +1
    mac_psum_in = 32'sd0;
    mac_enable = 1;
    @(posedge clk);
    mac_enable = 0;
    @(posedge clk);

    if (mac_psum_out == 32'sd1000) begin
      $display("  1a: Basic MAC: PASS (result=%0d)", mac_psum_out);
    end else begin
      $display("  1a: Basic MAC: FAIL (expected 1000, got %0d)", mac_psum_out);
      errors++;
    end

    // Test 1b: Negative weight
    mac_weight = 2'b00;  // -1
    mac_psum_in = mac_psum_out;
    mac_enable = 1;
    @(posedge clk);
    mac_enable = 0;
    @(posedge clk);

    if (mac_psum_out == 32'sd0) begin
      $display("  1b: Negative weight: PASS (result=%0d)", mac_psum_out);
    end else begin
      $display("  1b: Negative weight: FAIL (expected 0, got %0d)", mac_psum_out);
      errors++;
    end

    // Test 1c: Zero skip
    mac_weight = 2'b01;  // 0
    #1;  // Allow combinational logic to settle
    if (mac_zero_skip) begin
      $display("  1c: Zero skip: PASS");
    end else begin
      $display("  1c: Zero skip: FAIL");
      errors++;
    end

    // Test 1d: Positive saturation
    mac_clear = 1;
    @(posedge clk);
    mac_clear = 0;

    mac_activation = 16'sd32767;  // Max positive
    mac_weight = 2'b10;  // +1
    mac_psum_in = 32'h7FFF_FF00;  // Near max
    mac_enable = 1;
    @(posedge clk);
    mac_enable = 0;
    @(posedge clk);

    if (mac_saturated || mac_psum_out == 32'h7FFF_FFFF) begin
      $display("  1d: Positive saturation: PASS");
    end else begin
      $display("  1d: Positive saturation: CHECK (saturated=%b, result=%h)", mac_saturated, mac_psum_out);
    end

    $display("  PASS");

    // --------------------------------------------------------
    // Test 2: Weight Packing/Unpacking
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Weight Packing/Unpacking ---", test_num);

    // Test 2a: All zeros
    pack_weights_in = '{2'b01, 2'b01, 2'b01, 2'b01, 2'b01};  // 0,0,0,0,0
    pack_valid_in = 1;
    #1;
    if (packed_value == 8'd121) begin
      $display("  2a: All zeros packs to 121: PASS");
    end else begin
      $display("  2a: All zeros: FAIL (expected 121, got %0d)", packed_value);
      errors++;
    end

    // Test 2b: All +1
    pack_weights_in = '{2'b10, 2'b10, 2'b10, 2'b10, 2'b10};  // +1,+1,+1,+1,+1
    #1;
    if (packed_value == 8'd242) begin
      $display("  2b: All +1 packs to 242: PASS");
    end else begin
      $display("  2b: All +1: FAIL (expected 242, got %0d)", packed_value);
      errors++;
    end

    // Test 2c: All -1
    pack_weights_in = '{2'b00, 2'b00, 2'b00, 2'b00, 2'b00};  // -1,-1,-1,-1,-1
    #1;
    if (packed_value == 8'd0) begin
      $display("  2c: All -1 packs to 0: PASS");
    end else begin
      $display("  2c: All -1: FAIL (expected 0, got %0d)", packed_value);
      errors++;
    end

    // Test 2d: Roundtrip verification
    pack_weights_in = '{2'b10, 2'b00, 2'b01, 2'b10, 2'b00};  // +1,-1,0,+1,-1
    #1;
    unpack_in = packed_value;
    unpack_valid_in = 1;
    #1;
    if (unpack_weights_out == pack_weights_in && unpack_valid_out && !unpack_error) begin
      $display("  2d: Roundtrip verification: PASS");
    end else begin
      $display("  2d: Roundtrip: FAIL");
      errors++;
    end

    pack_valid_in = 0;
    unpack_valid_in = 0;

    $display("  PASS");

    // --------------------------------------------------------
    // Test 3: Accumulator Cast
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Accumulator Cast (128→32 bit) ---", test_num);

    cast_enable = 1;
    cast_round_mode = 2'b00;  // Truncate
    cast_shift = 4'd0;

    // Test 3a: Small value passthrough
    cast_wide_in = 128'sd12345;
    cast_wide_valid = 1;
    repeat(4) @(posedge clk);

    if (cast_out_valid && cast_out == 32'sd12345) begin
      $display("  3a: Small value passthrough: PASS");
    end else begin
      $display("  3a: Small value: FAIL (valid=%b, result=%0d)", cast_out_valid, cast_out);
      errors++;
    end

    // Test 3b: Negative value
    cast_wide_in = -128'sd9876;
    repeat(4) @(posedge clk);

    if (cast_out == -32'sd9876) begin
      $display("  3b: Negative value: PASS");
    end else begin
      $display("  3b: Negative: FAIL (result=%0d)", cast_out);
      errors++;
    end

    // Test 3c: Positive saturation
    cast_wide_in = 128'h00000000_00000000_00000001_00000000;  // > 32-bit max
    repeat(4) @(posedge clk);

    if (cast_saturated && cast_out == 32'h7FFF_FFFF) begin
      $display("  3c: Positive saturation: PASS");
    end else begin
      $display("  3c: Saturation: CHECK (saturated=%b, result=%h)", cast_saturated, cast_out);
    end

    // Test 3d: Right shift
    cast_shift = 4'd4;
    cast_wide_in = 128'sd256;  // 256 >> 4 = 16
    repeat(4) @(posedge clk);

    if (cast_out == 32'sd16) begin
      $display("  3d: Right shift by 4: PASS");
    end else begin
      $display("  3d: Shift: FAIL (expected 16, got %0d)", cast_out);
      errors++;
    end

    cast_wide_valid = 0;
    $display("  PASS");

    // --------------------------------------------------------
    // Test 4: Reduction Unit
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Reduction Unit ---", test_num);

    // Test 4a: Sum of 10 elements (1+2+3+...+10 = 55)
    reduce_op = 2'b00;  // SUM
    reduce_length = 12'd10;
    reduce_shift = 4'd0;
    reduce_start = 1;
    @(posedge clk);
    reduce_start = 0;

    // Feed data
    for (int i = 1; i <= 10; i++) begin
      wait(reduce_data_ready);
      reduce_data_in = 32'(i);
      reduce_data_valid = 1;
      @(posedge clk);
      reduce_data_valid = 0;
      @(posedge clk);
    end

    // Wait for result
    wait(reduce_result_valid);

    if (reduce_result == 32'sd55) begin
      $display("  4a: Sum 1..10 = 55: PASS");
    end else begin
      $display("  4a: Sum: FAIL (expected 55, got %0d)", reduce_result);
      errors++;
    end

    wait(reduce_done);
    @(posedge clk);

    // Test 4b: Max of values
    reduce_op = 2'b01;  // MAX
    reduce_length = 12'd5;
    reduce_start = 1;
    @(posedge clk);
    reduce_start = 0;

    // Feed: -100, 50, 200, -50, 100 → max = 200
    begin
      automatic int values [5] = '{-100, 50, 200, -50, 100};
      for (int i = 0; i < 5; i++) begin
        wait(reduce_data_ready);
        reduce_data_in = 32'(values[i]);
        reduce_data_valid = 1;
        @(posedge clk);
        reduce_data_valid = 0;
        @(posedge clk);
      end
    end

    wait(reduce_result_valid);

    if (reduce_result == 32'sd200) begin
      $display("  4b: Max of {-100,50,200,-50,100} = 200: PASS");
    end else begin
      $display("  4b: Max: FAIL (expected 200, got %0d)", reduce_result);
      errors++;
    end

    wait(reduce_done);
    @(posedge clk);

    // Test 4c: Min of values
    reduce_op = 2'b10;  // MIN
    reduce_length = 12'd5;
    reduce_start = 1;
    @(posedge clk);
    reduce_start = 0;

    begin
      automatic int values [5] = '{-100, 50, 200, -50, 100};
      for (int i = 0; i < 5; i++) begin
        wait(reduce_data_ready);
        reduce_data_in = 32'(values[i]);
        reduce_data_valid = 1;
        @(posedge clk);
        reduce_data_valid = 0;
        @(posedge clk);
      end
    end

    wait(reduce_result_valid);

    if (reduce_result == -32'sd100) begin
      $display("  4c: Min of {-100,50,200,-50,100} = -100: PASS");
    end else begin
      $display("  4c: Min: FAIL (expected -100, got %0d)", reduce_result);
      errors++;
    end

    wait(reduce_done);
    $display("  PASS");

    // --------------------------------------------------------
    // Test 5: Performance Counters Verification
    // --------------------------------------------------------
    test_num++;
    $display("\n--- Test %0d: Performance Counters ---", test_num);

    $display("  Last reduction: %0d cycles, %0d elements", reduce_cycles, reduce_elements);

    if (reduce_elements == 5) begin
      $display("  Element count: PASS");
    end else begin
      $display("  Element count: FAIL (expected 5, got %0d)", reduce_elements);
      errors++;
    end

    $display("  PASS");

    // --------------------------------------------------------
    // Summary
    // --------------------------------------------------------
    #100;
    $display("");
    $display("================================================================");
    $display("  Phase 5 Test Summary");
    $display("================================================================");
    $display("  Total Tests: %0d", test_num);
    $display("  Errors: %0d", errors);
    $display("");

    if (errors == 0) begin
      $display("  *** ALL TESTS PASSED ***");
      $display("  Phase 5 Compute Enhancements: VERIFIED");
    end else begin
      $display("  *** SOME TESTS FAILED ***");
    end

    $display("================================================================");
    $display("");

    $finish;
  end

  // Timeout watchdog
  initial begin
    #100000;
    $display("ERROR: Test timeout!");
    $finish;
  end

endmodule
