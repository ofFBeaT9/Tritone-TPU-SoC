// Parametric Balanced Ternary Adder
// N-trit ripple carry implementation
//
// Uses generate loop to instantiate BTFA cells in a chain
// Carry propagates from LSB to MSB

module ternary_adder
  import ternary_pkg::*;
#(
  parameter int WIDTH = 8  // Number of trits
)(
  input  trit_t [WIDTH-1:0] a,
  input  trit_t [WIDTH-1:0] b,
  input  trit_t             cin,
  output trit_t [WIDTH-1:0] sum,
  output trit_t             cout
);

  trit_t [WIDTH:0] carry;

  assign carry[0] = cin;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_adders
      btfa u_btfa (
        .a    (a[i]),
        .b    (b[i]),
        .cin  (carry[i]),
        .sum  (sum[i]),
        .cout (carry[i+1])
      );
    end
  endgenerate

  assign cout = trit_t'(carry[WIDTH]);

endmodule
