// Balanced Ternary Full Adder - RTL Model
// Maps to 42-transistor T-CMOS implementation from Phase 1
//
// Truth Table (a + b + cin):
// -1 + -1 + -1 = -3 = 0 (sum) with -1 (carry)
// -1 + -1 +  0 = -2 = +1 (sum) with -1 (carry)
// -1 + -1 + +1 = -1 = -1 (sum) with  0 (carry)
// ...etc for all 27 combinations

module btfa
  import ternary_pkg::*;
(
  input  trit_t a,
  input  trit_t b,
  input  trit_t cin,
  output trit_t sum,
  output trit_t cout
);

  logic [3:0] result;

  assign result = t_add_trit(a, b, cin);
  assign cout = trit_t'(result[3:2]);
  assign sum  = trit_t'(result[1:0]);

endmodule
