// Ternary ALU Testbench - Icarus Verilog Compatible
// Tests all ALU operations
//
// Icarus Compatibility Notes:
//   - Avoids '{default: X} array assignments
//   - Uses integer instead of int in for loops
//   - Avoids string type in tasks
//   - Uses explicit array initialization

`timescale 1ns/1ps

// Package is passed first on command line for Icarus
// (Do not use `include - it causes double-compilation issues)

module tb_ternary_alu_icarus;
  import ternary_pkg::*;

  localparam WIDTH = 8;

  // Operation codes (must match ternary_alu.sv)
  localparam [2:0] OP_ADD = 3'b000;
  localparam [2:0] OP_SUB = 3'b001;
  localparam [2:0] OP_NEG = 3'b010;
  localparam [2:0] OP_MIN = 3'b011;
  localparam [2:0] OP_MAX = 3'b100;
  localparam [2:0] OP_SHL = 3'b101;
  localparam [2:0] OP_SHR = 3'b110;
  localparam [2:0] OP_CMP = 3'b111;

  // Signals
  trit_t [WIDTH-1:0] a, b;
  logic [2:0]        op;
  trit_t [WIDTH-1:0] result;
  trit_t             carry;
  logic              zero_flag;
  logic              neg_flag;

  // Test tracking
  integer pass_count, fail_count;
  integer i;  // Loop variable

  // DUT
  ternary_alu #(.WIDTH(WIDTH)) dut (
    .a         (a),
    .b         (b),
    .op        (op),
    .result    (result),
    .carry     (carry),
    .zero_flag (zero_flag),
    .neg_flag  (neg_flag)
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
    integer res;
    integer power3;
    integer idx;
    begin
      res = 0;
      power3 = 1;
      for (idx = 0; idx < WIDTH; idx = idx + 1) begin
        res = res + trit_to_int_local(arr[idx]) * power3;
        power3 = power3 * 3;
      end
      ternary_array_to_int = res;
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

  // Check numeric result
  task check_numeric_result;
    input integer expected;
    input [255:0] test_name;  // Fixed-width string for Icarus
    integer actual;
    begin
      actual = ternary_array_to_int(result);

      if (actual == expected) begin
        $display("%s = %0d (expected %0d) - PASS", test_name, actual, expected);
        pass_count = pass_count + 1;
      end else begin
        $display("%s = %0d (expected %0d) - FAIL ***", test_name, actual, expected);
        fail_count = fail_count + 1;
      end
    end
  endtask

  // Check boolean result
  task check_bool_result;
    input logic actual;
    input logic expected;
    input [255:0] test_name;
    begin
      if (actual == expected) begin
        $display("%s - PASS", test_name);
        pass_count = pass_count + 1;
      end else begin
        $display("%s - FAIL", test_name);
        fail_count = fail_count + 1;
      end
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("=== Ternary ALU Test (Icarus Compatible) ===");
    $display("WIDTH = %0d trits", WIDTH);
    $display("");

    // ========== ADD Tests ==========
    $display("--- ADD Operation Tests ---");

    // ADD: 10 + 5 = 15
    set_ternary_from_int(10, a);
    set_ternary_from_int(5, b);
    op = OP_ADD;
    #20;
    check_numeric_result(15, "ADD: 10 + 5");

    // ADD: -10 + 20 = 10
    set_ternary_from_int(-10, a);
    set_ternary_from_int(20, b);
    op = OP_ADD;
    #20;
    check_numeric_result(10, "ADD: -10 + 20");

    // ========== SUB Tests ==========
    $display("");
    $display("--- SUB Operation Tests ---");

    // SUB: 20 - 5 = 15
    set_ternary_from_int(20, a);
    set_ternary_from_int(5, b);
    op = OP_SUB;
    #20;
    check_numeric_result(15, "SUB: 20 - 5");

    // SUB: 10 - 15 = -5
    set_ternary_from_int(10, a);
    set_ternary_from_int(15, b);
    op = OP_SUB;
    #20;
    check_numeric_result(-5, "SUB: 10 - 15");

    // ========== NEG Tests ==========
    $display("");
    $display("--- NEG Operation Tests ---");

    // NEG: -(10) = -10
    set_ternary_from_int(10, a);
    set_all_zero(b);
    op = OP_NEG;
    #20;
    check_numeric_result(-10, "NEG: -(10)");

    // NEG: -(-5) = 5
    set_ternary_from_int(-5, a);
    op = OP_NEG;
    #20;
    check_numeric_result(5, "NEG: -(-5)");

    // ========== MIN Tests ==========
    $display("");
    $display("--- MIN Operation Tests ---");

    // All zeros
    set_all_zero(a);
    set_all_zero(b);
    op = OP_MIN;
    #20;
    check_numeric_result(0, "MIN: 0, 0");

    // MIN with mixed values
    set_all_zero(a);
    set_all_zero(b);
    a[0] = T_POS_ONE; a[1] = T_NEG_ONE; a[2] = T_ZERO;
    b[0] = T_ZERO;    b[1] = T_ZERO;    b[2] = T_POS_ONE;
    op = OP_MIN;
    #20;
    // Expected: MIN(+1,0)=0, MIN(-1,0)=-1, MIN(0,+1)=0
    if (result[0] == T_ZERO && result[1] == T_NEG_ONE && result[2] == T_ZERO) begin
      $display("MIN: trit-wise mixed - PASS");
      pass_count = pass_count + 1;
    end else begin
      $display("MIN: trit-wise mixed - FAIL");
      fail_count = fail_count + 1;
    end

    // ========== MAX Tests ==========
    $display("");
    $display("--- MAX Operation Tests ---");

    // MAX with mixed values
    set_all_zero(a);
    set_all_zero(b);
    a[0] = T_POS_ONE; a[1] = T_NEG_ONE; a[2] = T_ZERO;
    b[0] = T_ZERO;    b[1] = T_ZERO;    b[2] = T_POS_ONE;
    op = OP_MAX;
    #20;
    // Expected: MAX(+1,0)=+1, MAX(-1,0)=0, MAX(0,+1)=+1
    if (result[0] == T_POS_ONE && result[1] == T_ZERO && result[2] == T_POS_ONE) begin
      $display("MAX: trit-wise mixed - PASS");
      pass_count = pass_count + 1;
    end else begin
      $display("MAX: trit-wise mixed - FAIL");
      fail_count = fail_count + 1;
    end

    // ========== Shift Tests ==========
    $display("");
    $display("--- SHIFT Operation Tests ---");

    // SHL
    set_all_zero(a);
    a[0] = T_POS_ONE;  // Value = 1
    op = OP_SHL;
    #20;
    if (result[0] == T_ZERO && result[1] == T_POS_ONE) begin
      $display("SHL: shift 1 left - PASS");
      pass_count = pass_count + 1;
    end else begin
      $display("SHL: shift 1 left - FAIL");
      fail_count = fail_count + 1;
    end

    // SHR
    set_all_zero(a);
    a[2] = T_POS_ONE;  // Value at position 2
    op = OP_SHR;
    #20;
    if (result[1] == T_POS_ONE && result[2] == T_ZERO) begin
      $display("SHR: shift right - PASS");
      pass_count = pass_count + 1;
    end else begin
      $display("SHR: shift right - FAIL");
      fail_count = fail_count + 1;
    end

    // ========== Flag Tests ==========
    $display("");
    $display("--- Flag Tests ---");

    // Zero flag
    set_all_zero(a);
    set_all_zero(b);
    op = OP_ADD;
    #20;
    check_bool_result(zero_flag, 1'b1, "Zero flag (0+0)");

    // Negative flag - need a value where MSB (trit 7) is -1
    // In 8-trit balanced ternary, this requires a value around -2187 or more negative
    // -3000 has MSB = -1 in balanced ternary
    set_ternary_from_int(-3000, a);
    set_all_zero(b);
    op = OP_ADD;
    #20;
    check_bool_result(neg_flag, 1'b1, "Neg flag (-3000)");

    // ========== Summary ==========
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
