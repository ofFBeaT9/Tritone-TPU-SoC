// Ternary Adder Testbench
// Tests parametric N-trit ripple carry adder

`timescale 1ns/1ps

module tb_ternary_adder;
  import ternary_pkg::*;

  localparam int WIDTH = 8;

  // Signals
  trit_t [WIDTH-1:0] a, b;
  trit_t             cin;
  trit_t [WIDTH-1:0] sum;
  trit_t             cout;

  // Test tracking
  int pass_count, fail_count;

  // DUT
  ternary_adder #(.WIDTH(WIDTH)) dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  // Helper function to set trit value
  function automatic trit_t int_to_trit(int v);
    case (v)
      -1: return T_NEG_ONE;
       0: return T_ZERO;
       1: return T_POS_ONE;
      default: return T_INVALID;
    endcase
  endfunction

  // Helper to convert trit to int
  function automatic int trit_to_int_local(trit_t t);
    case (t)
      T_NEG_ONE: return -1;
      T_ZERO:    return 0;
      T_POS_ONE: return 1;
      default:   return 99;
    endcase
  endfunction

  // Convert ternary array to integer value
  function automatic int ternary_array_to_int(trit_t [WIDTH-1:0] arr);
    int result = 0;
    int power3 = 1;
    for (int i = 0; i < WIDTH; i++) begin
      result = result + trit_to_int_local(arr[i]) * power3;
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // Set ternary array from integer value
  task set_ternary_from_int(int val, output trit_t [WIDTH-1:0] arr);
    int temp = val;
    int remainder;
    for (int i = 0; i < WIDTH; i++) begin
      if (temp >= 0) begin
        remainder = temp % 3;
        if (remainder == 0) arr[i] = T_ZERO;
        else if (remainder == 1) arr[i] = T_POS_ONE;
        else begin
          arr[i] = T_NEG_ONE;
          temp = temp + 1;
        end
        temp = temp / 3;
      end else begin
        // Handle negative numbers
        temp = -temp;
        remainder = temp % 3;
        if (remainder == 0) arr[i] = T_ZERO;
        else if (remainder == 1) arr[i] = T_NEG_ONE;
        else begin
          arr[i] = T_POS_ONE;
          temp = temp + 1;
        end
        temp = -(temp / 3);
      end
    end
  endtask

  // Test vectors
  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("=== Ternary Adder Test ===");
    $display("WIDTH = %0d trits", WIDTH);
    $display("");

    cin = T_ZERO;

    // Test 1: 0 + 0 = 0
    $display("Test 1: 0 + 0");
    a = '{default: T_ZERO};
    b = '{default: T_ZERO};
    #20;
    check_result(0, 0, 0);

    // Test 2: 1 + 1 = 2 (in balanced ternary: -1 with carry +1)
    $display("Test 2: 1 + 1");
    a = '{default: T_ZERO};
    b = '{default: T_ZERO};
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

  // Check result task
  task check_result(int a_val, int b_val, int expected);
    int actual;
    actual = ternary_array_to_int(sum);

    // Account for carry extending the result
    if (cout == T_POS_ONE) actual = actual + (3**WIDTH);
    else if (cout == T_NEG_ONE) actual = actual - (3**WIDTH);

    if (actual == expected) begin
      $display("  %0d + %0d = %0d (expected %0d) - PASS", a_val, b_val, actual, expected);
      pass_count++;
    end else begin
      $display("  %0d + %0d = %0d (expected %0d) - FAIL ***", a_val, b_val, actual, expected);
      fail_count++;
    end
  endtask

endmodule
