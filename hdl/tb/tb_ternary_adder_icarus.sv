// Ternary Adder Testbench - Icarus Verilog Compatible
// Tests parametric N-trit ripple carry adder
//
// Icarus Compatibility Notes:
//   - Avoids '{default: X} array assignments
//   - Uses integer instead of int in for loops
//   - Avoids string type in tasks
//   - Uses explicit array initialization

`timescale 1ns/1ps

// Package is passed first on command line for Icarus
// (Do not use `include - it causes double-compilation issues)

module tb_ternary_adder_icarus;
  import ternary_pkg::*;

  localparam WIDTH = 8;

  // Signals
  trit_t [WIDTH-1:0] a, b;
  trit_t             cin;
  trit_t [WIDTH-1:0] sum;
  trit_t             cout;

  // Test tracking
  integer pass_count, fail_count;
  integer i;  // Loop variable declared outside for Icarus

  // DUT
  ternary_adder #(.WIDTH(WIDTH)) dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  // Helper function to convert trit to int
  function automatic integer trit_to_int_local;
    input trit_t t;
    begin
      case (t)
        T_NEG_ONE: trit_to_int_local = -1;
        T_ZERO:    trit_to_int_local = 0;
        T_POS_ONE: trit_to_int_local = 1;
        default:   trit_to_int_local = 99;
      endcase
    end
  endfunction

  // Convert ternary array to integer value
  function automatic integer ternary_array_to_int;
    input trit_t [WIDTH-1:0] arr;
    integer result;
    integer power3;
    integer idx;
    begin
      result = 0;
      power3 = 1;
      for (idx = 0; idx < WIDTH; idx = idx + 1) begin
        result = result + trit_to_int_local(arr[idx]) * power3;
        power3 = power3 * 3;
      end
      ternary_array_to_int = result;
    end
  endfunction

  // Task to set all array elements to zero
  task set_all_zero;
    output trit_t [WIDTH-1:0] arr;
    integer idx;
    begin
      for (idx = 0; idx < WIDTH; idx = idx + 1) begin
        arr[idx] = T_ZERO;
      end
    end
  endtask

  // Set ternary array from integer value
  task set_ternary_from_int;
    input integer val;
    output trit_t [WIDTH-1:0] arr;
    integer temp;
    integer remainder;
    integer idx;
    begin
      temp = val;
      for (idx = 0; idx < WIDTH; idx = idx + 1) begin
        if (temp >= 0) begin
          remainder = temp % 3;
          if (remainder == 0) arr[idx] = T_ZERO;
          else if (remainder == 1) arr[idx] = T_POS_ONE;
          else begin
            arr[idx] = T_NEG_ONE;
            temp = temp + 1;
          end
          temp = temp / 3;
        end else begin
          temp = -temp;
          remainder = temp % 3;
          if (remainder == 0) arr[idx] = T_ZERO;
          else if (remainder == 1) arr[idx] = T_NEG_ONE;
          else begin
            arr[idx] = T_POS_ONE;
            temp = temp + 1;
          end
          temp = -(temp / 3);
        end
      end
    end
  endtask

  // Check result task (without string parameter)
  task check_result;
    input integer a_val;
    input integer b_val;
    input integer expected;
    integer actual;
    begin
      actual = ternary_array_to_int(sum);

      // Account for carry extending the result
      if (cout == T_POS_ONE) actual = actual + (3**WIDTH);
      else if (cout == T_NEG_ONE) actual = actual - (3**WIDTH);

      if (actual == expected) begin
        $display("  %0d + %0d = %0d (expected %0d) - PASS", a_val, b_val, actual, expected);
        pass_count = pass_count + 1;
      end else begin
        $display("  %0d + %0d = %0d (expected %0d) - FAIL ***", a_val, b_val, actual, expected);
        fail_count = fail_count + 1;
      end
    end
  endtask

  // Test vectors
  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("=== Ternary Adder Test (Icarus Compatible) ===");
    $display("WIDTH = %0d trits", WIDTH);
    $display("");

    cin = T_ZERO;

    // Test 1: 0 + 0 = 0
    $display("Test 1: 0 + 0");
    set_all_zero(a);
    set_all_zero(b);
    #20;
    check_result(0, 0, 0);

    // Test 2: 1 + 1 = 2
    $display("Test 2: 1 + 1");
    set_all_zero(a);
    set_all_zero(b);
    a[0] = T_POS_ONE;
    b[0] = T_POS_ONE;
    #20;
    check_result(1, 1, 2);

    // Test 3: 10 + 5 = 15
    $display("Test 3: 10 + 5");
    set_ternary_from_int(10, a);
    set_ternary_from_int(5, b);
    #20;
    check_result(10, 5, 15);

    // Test 4: -5 + 10 = 5
    $display("Test 4: -5 + 10");
    set_ternary_from_int(-5, a);
    set_ternary_from_int(10, b);
    #20;
    check_result(-5, 10, 5);

    // Test 5: 100 + 100 = 200
    $display("Test 5: 100 + 100");
    set_ternary_from_int(100, a);
    set_ternary_from_int(100, b);
    #20;
    check_result(100, 100, 200);

    // Test 6: -100 + -50 = -150
    $display("Test 6: -100 + -50");
    set_ternary_from_int(-100, a);
    set_ternary_from_int(-50, b);
    #20;
    check_result(-100, -50, -150);

    // Test 7: Max positive values
    $display("Test 7: Large positive addition");
    set_ternary_from_int(1000, a);
    set_ternary_from_int(500, b);
    #20;
    check_result(1000, 500, 1500);

    $display("");
    $display("------------------------------------------------------------");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);

    if (fail_count == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** SOME TESTS FAILED ***");

    $finish;
  end

endmodule
