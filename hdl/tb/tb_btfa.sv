// BTFA Testbench - Exhaustive verification
// Tests all 27 input combinations (3^3) for balanced ternary full adder

`timescale 1ns/1ps

module tb_btfa;
  import ternary_pkg::*;

  // Signals
  trit_t a, b, cin;
  trit_t sum, cout;

  // Expected values
  trit_t exp_sum, exp_cout;

  // Counters
  int pass_count, fail_count;

  // DUT
  btfa dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  // Test all 27 input combinations (3^3)
  initial begin
    pass_count = 0;
    fail_count = 0;

    $display("=== BTFA Exhaustive Test ===");
    $display("A\tB\tCin\t|\tSum\tCout\t|\tExp_S\tExp_C\t|\tResult");
    $display("------------------------------------------------------------");

    // Iterate through all combinations
    for (int ia = 0; ia < 3; ia++) begin
      for (int ib = 0; ib < 3; ib++) begin
        for (int ic = 0; ic < 3; ic++) begin
          // Set inputs
          case (ia)
            0: a = T_NEG_ONE;
            1: a = T_ZERO;
            2: a = T_POS_ONE;
          endcase

          case (ib)
            0: b = T_NEG_ONE;
            1: b = T_ZERO;
            2: b = T_POS_ONE;
          endcase

          case (ic)
            0: cin = T_NEG_ONE;
            1: cin = T_ZERO;
            2: cin = T_POS_ONE;
          endcase

          // Calculate expected
          calculate_expected(ia-1, ib-1, ic-1, exp_sum, exp_cout);

          #10;  // Wait for propagation

          // Check results
          if (sum === exp_sum && cout === exp_cout) begin
            $display("%d\t%d\t%d\t|\t%d\t%d\t|\t%d\t%d\t|\tPASS",
                     ia-1, ib-1, ic-1,
                     trit_to_int(sum), trit_to_int(cout),
                     trit_to_int(exp_sum), trit_to_int(exp_cout));
            pass_count++;
          end else begin
            $display("%d\t%d\t%d\t|\t%d\t%d\t|\t%d\t%d\t|\tFAIL ***",
                     ia-1, ib-1, ic-1,
                     trit_to_int(sum), trit_to_int(cout),
                     trit_to_int(exp_sum), trit_to_int(exp_cout));
            fail_count++;
          end
        end
      end
    end

    $display("------------------------------------------------------------");
    $display("Results: %0d PASS, %0d FAIL", pass_count, fail_count);

    if (fail_count == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** SOME TESTS FAILED ***");

    $finish;
  end

  // Helper function to calculate expected output
  task calculate_expected(
    input int a_val, b_val, c_val,
    output trit_t exp_s, exp_c
  );
    int total;
    total = a_val + b_val + c_val;

    // Balanced ternary: result in range -1 to +1
    if (total >= 2) begin
      exp_c = T_POS_ONE;
      total = total - 3;
    end else if (total <= -2) begin
      exp_c = T_NEG_ONE;
      total = total + 3;
    end else begin
      exp_c = T_ZERO;
    end

    case (total)
      -1: exp_s = T_NEG_ONE;
       0: exp_s = T_ZERO;
       1: exp_s = T_POS_ONE;
      default: exp_s = T_INVALID;
    endcase
  endtask

endmodule
