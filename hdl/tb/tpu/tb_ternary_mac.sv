// Testbench for Ternary MAC Unit
// ================================
// Tests all weight combinations {-1, 0, +1} with various activations
// and accumulator values, verifying against Python golden model.
//
// Icarus Verilog compatible version.
//
// Author: Tritone Project

`timescale 1ns/1ps

module tb_ternary_mac;
  import ternary_pkg::*;

  // ============================================================
  // Parameters
  // ============================================================
  localparam int ACT_WIDTH = 8;
  localparam int ACC_WIDTH = 27;
  localparam int CLK_PERIOD = 10;

  // ============================================================
  // Signals
  // ============================================================
  logic clk;
  logic rst_n;
  logic enable;

  trit_t [ACT_WIDTH-1:0] activation;
  logic [1:0] weight;
  trit_t [ACC_WIDTH-1:0] acc_in;
  trit_t [ACC_WIDTH-1:0] acc_out;
  logic zero_skip;

  // Test statistics
  int test_count;
  int pass_count;
  int fail_count;

  // Temp arrays for conversion
  trit_t [ACC_WIDTH-1:0] temp_trits;
  trit_t [ACT_WIDTH-1:0] temp_act_trits;

  // ============================================================
  // Clock Generation
  // ============================================================
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // ============================================================
  // DUT Instantiation (Icarus-compatible version)
  // ============================================================
  ternary_mac_icarus #(
    .ACT_WIDTH(ACT_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .activation(activation),
    .weight(weight),
    .acc_in(acc_in),
    .acc_out(acc_out),
    .zero_skip(zero_skip)
  );

  // ============================================================
  // Helper Tasks (Icarus compatible)
  // ============================================================

  // Convert integer to balanced ternary trit vector (ACC_WIDTH)
  // Uses Euclidean division for correct negative number handling
  task automatic int_to_trits(input int val);
    int temp;
    int rem;
    int i;

    temp = val;
    for (i = 0; i < ACC_WIDTH; i++) begin
      // Compute Euclidean modulo (always non-negative)
      rem = temp % 3;
      if (rem < 0) rem = rem + 3;

      case (rem)
        0: begin
          temp_trits[i] = T_ZERO;
        end
        1: begin
          temp_trits[i] = T_POS_ONE;
        end
        2: begin
          temp_trits[i] = T_NEG_ONE;
          temp = temp + 1;  // Adjust for balanced representation
        end
      endcase

      // Euclidean division (floor toward -infinity for negative)
      if (temp >= 0) begin
        temp = temp / 3;
      end else begin
        temp = (temp - 2) / 3;  // Floor division for negative
      end
    end
  endtask

  // Convert balanced ternary trit vector to integer
  function automatic int trits_to_int(input trit_t [ACC_WIDTH-1:0] trits);
    int result;
    int power3;
    int i;

    result = 0;
    power3 = 1;

    for (i = 0; i < ACC_WIDTH; i++) begin
      case (trits[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ; // T_ZERO adds nothing
      endcase
      power3 = power3 * 3;
    end

    return result;
  endfunction

  // Convert integer to activation-width trit vector
  // Uses Euclidean division for correct negative number handling
  task automatic int_to_act_trits(input int val);
    int temp;
    int rem;
    int i;

    temp = val;
    for (i = 0; i < ACT_WIDTH; i++) begin
      // Compute Euclidean modulo (always non-negative)
      rem = temp % 3;
      if (rem < 0) rem = rem + 3;

      case (rem)
        0: begin
          temp_act_trits[i] = T_ZERO;
        end
        1: begin
          temp_act_trits[i] = T_POS_ONE;
        end
        2: begin
          temp_act_trits[i] = T_NEG_ONE;
          temp = temp + 1;  // Adjust for balanced representation
        end
      endcase

      // Euclidean division (floor toward -infinity for negative)
      if (temp >= 0) begin
        temp = temp / 3;
      end else begin
        temp = (temp - 2) / 3;  // Floor division for negative
      end
    end
  endtask

  // Weight encoding: 00=-1, 01=0, 10=+1
  function automatic logic [1:0] encode_weight(input int w);
    case (w)
      -1: return 2'b00;
       0: return 2'b01;
       1: return 2'b10;
      default: return 2'b01;
    endcase
  endfunction

  // ============================================================
  // Test Tasks
  // ============================================================

  task automatic run_mac_test(
    input int act_val,
    input int wgt_val,
    input int acc_val
  );
    int expected_result;
    int actual_result;
    int i;

    test_count = test_count + 1;

    // Compute expected result
    case (wgt_val)
      -1: expected_result = acc_val - act_val;
       0: expected_result = acc_val;
       1: expected_result = acc_val + act_val;
      default: expected_result = acc_val;
    endcase

    // Convert to trit vectors
    int_to_act_trits(act_val);
    for (i = 0; i < ACT_WIDTH; i++) activation[i] = temp_act_trits[i];

    int_to_trits(acc_val);
    for (i = 0; i < ACC_WIDTH; i++) acc_in[i] = temp_trits[i];

    // Apply inputs
    weight = encode_weight(wgt_val);
    enable = 1;

    // Wait for registered output
    @(posedge clk);
    @(posedge clk);

    // Get result
    actual_result = trits_to_int(acc_out);

    // Check zero_skip
    if ((wgt_val == 0) != zero_skip) begin
      $display("FAIL: zero_skip mismatch for weight=%0d, expected=%0d, got=%0d",
               wgt_val, (wgt_val == 0), zero_skip);
      fail_count = fail_count + 1;
    end
    // Check result
    else if (actual_result != expected_result) begin
      $display("FAIL: act=%0d, wgt=%0d, acc=%0d => expected=%0d, got=%0d",
               act_val, wgt_val, acc_val, expected_result, actual_result);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
      if (test_count <= 20) begin
        $display("PASS: act=%0d, wgt=%0d, acc=%0d => %0d",
                 act_val, wgt_val, acc_val, actual_result);
      end
    end
  endtask

  // ============================================================
  // Main Test Sequence
  // ============================================================
  initial begin
    int i;
    int acc;
    int r_act, r_wgt, r_acc;

    $display("============================================================");
    $display("Ternary MAC Unit Testbench");
    $display("============================================================");

    // Initialize
    test_count = 0;
    pass_count = 0;
    fail_count = 0;

    rst_n = 0;
    enable = 0;
    for (i = 0; i < ACT_WIDTH; i++) activation[i] = T_ZERO;
    weight = 2'b01;  // Zero
    for (i = 0; i < ACC_WIDTH; i++) acc_in[i] = T_ZERO;

    // Reset
    repeat(5) @(posedge clk);
    rst_n = 1;
    repeat(2) @(posedge clk);

    $display("\n--- Test 1: All weight values with activation=0 ---");
    run_mac_test(0, -1, 100);
    run_mac_test(0,  0, 100);
    run_mac_test(0,  1, 100);

    $display("\n--- Test 2: All weight values with activation=1 ---");
    run_mac_test(1, -1, 0);
    run_mac_test(1,  0, 0);
    run_mac_test(1,  1, 0);

    $display("\n--- Test 3: All weight values with activation=-1 ---");
    run_mac_test(-1, -1, 0);
    run_mac_test(-1,  0, 0);
    run_mac_test(-1,  1, 0);

    $display("\n--- Test 4: Larger activation values ---");
    run_mac_test(100, -1, 500);
    run_mac_test(100,  0, 500);
    run_mac_test(100,  1, 500);

    $display("\n--- Test 5: Negative activation values ---");
    run_mac_test(-50, -1, 200);
    run_mac_test(-50,  0, 200);
    run_mac_test(-50,  1, 200);

    $display("\n--- Test 6: Accumulator chain (simulating multiple MACs) ---");
    acc = 0;

    // MAC with act=10, wgt=+1
    run_mac_test(10, 1, acc);
    acc = acc + 10;

    // MAC with act=20, wgt=-1
    run_mac_test(20, -1, acc);
    acc = acc - 20;

    // MAC with act=15, wgt=0 (should keep acc)
    run_mac_test(15, 0, acc);

    // MAC with act=5, wgt=+1
    run_mac_test(5, 1, acc);
    acc = acc + 5;

    $display("\n--- Test 7: Boundary values ---");
    // 8-trit maximum positive: (3^8 - 1)/2 = 3280
    // 8-trit maximum negative: -(3^8 - 1)/2 = -3280
    run_mac_test(3280, 1, 0);
    run_mac_test(-3280, 1, 0);
    run_mac_test(3280, -1, 0);
    run_mac_test(-3280, -1, 0);

    $display("\n--- Test 8: Random values ---");
    for (i = 0; i < 50; i++) begin
      r_act = $urandom_range(0, 1000) - 500;
      r_wgt = $urandom_range(0, 2) - 1;
      r_acc = $urandom_range(0, 10000) - 5000;
      run_mac_test(r_act, r_wgt, r_acc);
    end

    // Summary
    $display("\n============================================================");
    $display("Test Summary:");
    $display("  Total tests: %0d", test_count);
    $display("  Passed:      %0d", pass_count);
    $display("  Failed:      %0d", fail_count);
    $display("============================================================");

    if (fail_count == 0) begin
      $display("ALL TESTS PASSED!");
    end else begin
      $display("SOME TESTS FAILED!");
    end

    $finish;
  end

  // Timeout
  initial begin
    #100000;
    $display("TIMEOUT!");
    $finish;
  end

endmodule
