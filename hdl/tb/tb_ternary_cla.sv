// Testbench for Ternary Carry-Lookahead Adder
// Validates CLA against ripple-carry reference implementation

`timescale 1ns/1ps

module tb_ternary_cla;
  import ternary_pkg::*;

  localparam int WIDTH = 27;

  // Inputs
  trit_t [WIDTH-1:0] a, b;
  trit_t cin;

  // Outputs - CLA
  trit_t [WIDTH-1:0] sum_cla;
  trit_t cout_cla;

  // Outputs - Ripple (reference)
  trit_t [WIDTH-1:0] sum_ripple;
  trit_t cout_ripple;

  // Test control
  int test_count;
  int pass_count;
  int fail_count;

  // Instantiate CLA under test
  ternary_cla #(.WIDTH(WIDTH)) u_cla (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum_cla),
    .cout (cout_cla)
  );

  // Instantiate ripple-carry reference
  ternary_adder #(.WIDTH(WIDTH)) u_ripple (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum_ripple),
    .cout (cout_ripple)
  );

  // Helper: Convert trit array to signed integer
  function automatic logic signed [31:0] trit_to_int_arr(input trit_t [WIDTH-1:0] val);
    logic signed [31:0] result;
    logic signed [31:0] power3;
    int i;
    result = 0;
    power3 = 1;
    for (i = 0; i < WIDTH; i++) begin
      case (val[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // Helper: Compare two trit arrays
  function automatic logic compare_trits(
    input trit_t [WIDTH-1:0] actual,
    input trit_t [WIDTH-1:0] expected
  );
    int i;
    for (i = 0; i < WIDTH; i++) begin
      if (actual[i] != expected[i]) return 0;
    end
    return 1;
  endfunction

  // Test task
  task automatic run_test(
    input logic signed [31:0] a_val,
    input logic signed [31:0] b_val,
    input int cin_val
  );
    int i;
    logic signed [31:0] a_int, b_int, sum_cla_int, sum_ripple_int;
    logic match_sum, match_cout;

    // Convert inputs to balanced ternary
    a = bin_to_ternary(a_val);
    b = bin_to_ternary(b_val);
    cin = (cin_val == 1) ? T_POS_ONE : (cin_val == -1) ? T_NEG_ONE : T_ZERO;

    #10;  // Allow combinational logic to settle

    // Convert outputs for comparison
    a_int = trit_to_int_arr(a);
    b_int = trit_to_int_arr(b);
    sum_cla_int = trit_to_int_arr(sum_cla);
    sum_ripple_int = trit_to_int_arr(sum_ripple);

    // Compare results
    match_sum = compare_trits(sum_cla, sum_ripple);
    match_cout = (cout_cla == cout_ripple);

    test_count++;

    if (match_sum && match_cout) begin
      pass_count++;
      $display("[PASS] Test %0d: %0d + %0d + %0d = %0d (CLA matches ripple)",
               test_count, a_int, b_int, cin_val, sum_cla_int);
    end else begin
      fail_count++;
      $display("[FAIL] Test %0d: %0d + %0d + %0d", test_count, a_int, b_int, cin_val);
      $display("       CLA:    sum=%0d, cout=%0d", sum_cla_int,
               cout_cla == T_POS_ONE ? 1 : cout_cla == T_NEG_ONE ? -1 : 0);
      $display("       Ripple: sum=%0d, cout=%0d", sum_ripple_int,
               cout_ripple == T_POS_ONE ? 1 : cout_ripple == T_NEG_ONE ? -1 : 0);
    end
  endtask

  // Main test sequence
  initial begin
    $display("========================================");
    $display("Ternary CLA Testbench");
    $display("WIDTH = %0d trits", WIDTH);
    $display("========================================");

    test_count = 0;
    pass_count = 0;
    fail_count = 0;

    // Basic tests
    $display("\n--- Basic Tests ---");
    run_test(0, 0, 0);      // 0 + 0
    run_test(1, 0, 0);      // 1 + 0
    run_test(0, 1, 0);      // 0 + 1
    run_test(1, 1, 0);      // 1 + 1 = 2
    run_test(-1, 0, 0);     // -1 + 0
    run_test(0, -1, 0);     // 0 + -1
    run_test(-1, -1, 0);    // -1 + -1 = -2
    run_test(1, -1, 0);     // 1 + -1 = 0
    run_test(-1, 1, 0);     // -1 + 1 = 0

    // Carry-in tests
    $display("\n--- Carry-in Tests ---");
    run_test(0, 0, 1);      // 0 + 0 + 1
    run_test(0, 0, -1);     // 0 + 0 + -1
    run_test(1, 1, 1);      // 1 + 1 + 1 = 3
    run_test(-1, -1, -1);   // -1 + -1 + -1 = -3

    // Larger values
    $display("\n--- Larger Value Tests ---");
    run_test(10, 20, 0);
    run_test(-10, -20, 0);
    run_test(100, 50, 0);
    run_test(-100, 50, 0);
    run_test(1000, 2000, 0);
    run_test(-1000, 2000, 0);

    // Powers of 3 (important for ternary)
    $display("\n--- Powers of 3 Tests ---");
    run_test(3, 0, 0);
    run_test(9, 0, 0);
    run_test(27, 0, 0);
    run_test(81, 0, 0);
    run_test(243, 0, 0);
    run_test(3, 3, 0);      // 3 + 3 = 6
    run_test(9, 9, 0);      // 9 + 9 = 18
    run_test(27, 27, 0);    // 27 + 27 = 54

    // Carry propagation stress tests
    $display("\n--- Carry Propagation Tests ---");
    run_test(13, 14, 0);     // Multiple carries
    run_test(40, 41, 0);     // 81 = 3^4
    run_test(121, 122, 0);   // 243 = 3^5
    run_test(364, 365, 0);   // 729 = 3^6

    // Random tests
    $display("\n--- Random Value Tests ---");
    for (int i = 0; i < 20; i++) begin
      run_test($random % 10000, $random % 10000, $random % 3 - 1);
    end

    // Summary
    $display("\n========================================");
    $display("Test Summary");
    $display("========================================");
    $display("Total:  %0d", test_count);
    $display("Passed: %0d", pass_count);
    $display("Failed: %0d", fail_count);
    $display("========================================");

    if (fail_count == 0) begin
      $display("ALL TESTS PASSED!");
    end else begin
      $display("SOME TESTS FAILED!");
    end

    $finish;
  end

endmodule
