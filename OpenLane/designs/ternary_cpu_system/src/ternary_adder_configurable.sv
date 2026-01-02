// Configurable Ternary Adder
// Selectable implementation: Ripple-Carry or Carry-Lookahead
//
// Parameters:
//   WIDTH: Number of trits (default 27)
//   USE_CLA: 0 = ripple-carry, 1 = carry-lookahead (default 0)
//
// Trade-offs:
//   Ripple-carry: Smaller area, longer critical path O(N)
//   CLA: Larger area, shorter critical path O(log3 N)
//
// Recommended usage:
//   - USE_CLA=0 for area-constrained designs or low clock frequency
//   - USE_CLA=1 for performance-critical paths (e.g., ALU in pipelined CPU)

module ternary_adder_configurable
  import ternary_pkg::*;
#(
  parameter int WIDTH = 27,
  parameter bit USE_CLA = 0  // 0 = ripple, 1 = CLA
)(
  input  trit_t [WIDTH-1:0] a,
  input  trit_t [WIDTH-1:0] b,
  input  trit_t             cin,
  output trit_t [WIDTH-1:0] sum,
  output trit_t             cout
);

  generate
    if (USE_CLA && (WIDTH == 27 || WIDTH == 9 || WIDTH == 3)) begin : gen_cla
      // Use CLA for widths that are powers of 3
      ternary_cla #(.WIDTH(WIDTH)) u_adder (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
      );
    end else begin : gen_ripple
      // Fall back to ripple-carry for other widths or when CLA disabled
      ternary_adder #(.WIDTH(WIDTH)) u_adder (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
      );
    end
  endgenerate

endmodule
