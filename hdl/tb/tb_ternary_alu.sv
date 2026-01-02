// Ternary ALU Testbench
// Tests all ALU operations

`timescale 1ns/1ps

module tb_ternary_alu;
  import ternary_pkg::*;

  localparam int WIDTH = 8;

  // Operation codes (must match ternary_alu.sv)
  localparam logic [2:0] OP_ADD = 3'b000;
  localparam logic [2:0] OP_SUB = 3'b001;
  localparam logic [2:0] OP_NEG = 3'b010;
  localparam logic [2:0] OP_MIN = 3'b011;
  localparam logic [2:0] OP_MAX = 3'b100;
  localparam logic [2:0] OP_SHL = 3'b101;
  localparam logic [2:0] OP_SHR = 3'b110;
  localparam logic [2:0] OP_CMP = 3'b111;

  // Signals
  trit_t [WIDTH-1:0] a, b;
  logic [2:0]        op;
  trit_t [WIDTH-1:0] result;
  trit_t             carry;
  logic              zero_flag;
  logic              neg_flag;

  // Test tracking
  int pass_count, fail_count;

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

  // Helper functions
  function automatic int trit_to_int_local(trit_t t);
    case (t)
      T_NEG_ONE: return -1;
      T_ZERO:    return 0;
      T_POS_ONE: return 1;
      default:   return 99;
    endcase
  endfunction

  function automatic int ternary_array_to_int(trit_t [WIDTH-1:0] arr);
    int res = 0;
    int power3 = 1;
    for (int i = 0; i < WIDTH; i++) begin
      res = res + trit_to_int_local(arr[i]) * power3;
      power3 = power3 * 3;
    end
    return res;
  endfunction

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

  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("=== Ternary ALU Test ===");
    $display("WIDTH = %0d trits", WIDTH);
    $display("");

    // ========== ADD Tests ==========
    $display("--- ADD Operation Tests ---");

    // ADD: 10 + 5 = 15
    set_ternary_from_int(10, a);
    set_ternary_from_int(5, b);
    op = OP_ADD;
    #20;
    test_result("ADD: 10 + 5", 15);

    // ADD: -10 + 20 = 10
    set_ternary_from_int(-10, a);
    set_ternary_from_int(20, b);
    op = OP_ADD;
    #20;
    test_result("ADD: -10 + 20", 10);

    // ========== SUB Tests ==========
    $display("");
    $display("--- SUB Operation Tests ---");

    // SUB: 20 - 5 = 15
    set_ternary_from_int(20, a);
    set_ternary_from_int(5, b);
    op = OP_SUB;
    #20;
    test_result("SUB: 20 - 5", 15);

    // SUB: 10 - 15 = -5
    set_ternary_from_int(10, a);
    set_ternary_from_int(15, b);
    op = OP_SUB;
    #20;
    test_result("SUB: 10 - 15", -5);

    // ========== NEG Tests ==========
    $display("");
    $display("--- NEG Operation Tests ---");

    // NEG: -10 => 10
    set_ternary_from_int(10, a);
    b = '{default: T_ZERO};
    op = OP_NEG;
    #20;
    test_result("NEG: -(10)", -10);

    // NEG: -(-5) => 5
    set_ternary_from_int(-5, a);
    op = OP_NEG;
    #20;
    test_result("NEG: -(-5)", 5);

    // ========== MIN Tests ==========
    $display("");
    $display("--- MIN Operation Tests ---");

    // All zeros
    a = '{default: T_ZERO};
    b = '{default: T_ZERO};
    op = OP_MIN;
    #20;
    if (result == '{default: T_ZERO}) begin
      $display("MIN: zeros - PASS");
      pass_count++;
    end else begin
      $display("MIN: zeros - FAIL");
      fail_count++;
    end

    // MIN with mixed values
    a[0] = T_POS_ONE; a[1] = T_NEG_ONE; a[2] = T_ZERO;
    b[0] = T_ZERO;    b[1] = T_ZERO;    b[2] = T_POS_ONE;
    op = OP_MIN;
    #20;
    // Expected: MIN(+1,0)=0, MIN(-1,0)=-1, MIN(0,+1)=0
    if (result[0] == T_ZERO && result[1] == T_NEG_ONE && result[2] == T_ZERO) begin
      $display("MIN: trit-wise - PASS");
      pass_count++;
    end else begin
      $display("MIN: trit-wise - FAIL");
      fail_count++;
    end

    // ========== MAX Tests ==========
    $display("");
    $display("--- MAX Operation Tests ---");

    // MAX with mixed values
    a[0] = T_POS_ONE; a[1] = T_NEG_ONE; a[2] = T_ZERO;
    b[0] = T_ZERO;    b[1] = T_ZERO;    b[2] = T_POS_ONE;
    op = OP_MAX;
    #20;
    // Expected: MAX(+1,0)=+1, MAX(-1,0)=0, MAX(0,+1)=+1
    if (result[0] == T_POS_ONE && result[1] == T_ZERO && result[2] == T_POS_ONE) begin
      $display("MAX: trit-wise - PASS");
      pass_count++;
    end else begin
      $display("MAX: trit-wise - FAIL");
      fail_count++;
    end

    // ========== Shift Tests ==========
    $display("");
    $display("--- SHIFT Operation Tests ---");

    // SHL
    a = '{default: T_ZERO};
    a[0] = T_POS_ONE;  // Value = 1
    op = OP_SHL;
    #20;
    // After shift left, value should be at position 1
    if (result[0] == T_ZERO && result[1] == T_POS_ONE) begin
      $display("SHL: shift 1 left - PASS");
      pass_count++;
    end else begin
      $display("SHL: shift 1 left - FAIL");
      fail_count++;
    end

    // SHR
    a = '{default: T_ZERO};
    a[2] = T_POS_ONE;  // Value at position 2
    op = OP_SHR;
    #20;
    // After shift right, value should be at position 1
    if (result[1] == T_POS_ONE && result[2] == T_ZERO) begin
      $display("SHR: shift right - PASS");
      pass_count++;
    end else begin
      $display("SHR: shift right - FAIL");
      fail_count++;
    end

    // ========== Flag Tests ==========
    $display("");
    $display("--- Flag Tests ---");

    // Zero flag
    a = '{default: T_ZERO};
    b = '{default: T_ZERO};
    op = OP_ADD;
    #20;
    if (zero_flag) begin
      $display("Zero flag (0+0) - PASS");
      pass_count++;
    end else begin
      $display("Zero flag (0+0) - FAIL");
      fail_count++;
    end

    // Negative flag
    set_ternary_from_int(-100, a);
    b = '{default: T_ZERO};
    op = OP_ADD;
    #20;
    if (neg_flag) begin
      $display("Neg flag (-100) - PASS");
      pass_count++;
    end else begin
      $display("Neg flag (-100) - FAIL");
      fail_count++;
    end

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

  task test_result(string test_name, int expected);
    int actual;
    actual = ternary_array_to_int(result);

    if (actual == expected) begin
      $display("%s = %0d (expected %0d) - PASS", test_name, actual, expected);
      pass_count++;
    end else begin
      $display("%s = %0d (expected %0d) - FAIL ***", test_name, actual, expected);
      fail_count++;
    end
  endtask

endmodule
