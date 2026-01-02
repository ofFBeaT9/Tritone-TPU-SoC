// Parametric Balanced Ternary Adder
// N-trit ripple carry implementation
//
// Uses generate loop to instantiate BTFA cells in a chain
// Carry propagates from LSB to MSB

`include "ternary_defs.vh"

module ternary_adder #(
  parameter WIDTH = 8  // Number of trits
)(
  input  wire [WIDTH*2-1:0] a,     // WIDTH trits, 2 bits each
  input  wire [WIDTH*2-1:0] b,     // WIDTH trits, 2 bits each
  input  wire [1:0]         cin,   // 1 trit carry in
  output wire [WIDTH*2-1:0] sum,   // WIDTH trits, 2 bits each
  output wire [1:0]         cout   // 1 trit carry out
);

  wire [1:0] carry [WIDTH:0];

  assign carry[0] = cin;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : gen_adders
      btfa u_btfa (
        .a    (a[i*2+1:i*2]),
        .b    (b[i*2+1:i*2]),
        .cin  (carry[i]),
        .sum  (sum[i*2+1:i*2]),
        .cout (carry[i+1])
      );
    end
  endgenerate

  assign cout = carry[WIDTH];

endmodule
