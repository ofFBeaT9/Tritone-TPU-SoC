// 8-trit Carry-Lookahead Adder Wrapper
// Uses 9-trit CLA with padding for optimal timing
//
// Strategy:
//   - Pad 8-trit inputs to 9-trit (prepend T_ZERO)
//   - Use 9-trit CLA (supported hierarchical width = 3^2)
//   - Truncate output back to 8-trit
//
// Trade-off:
//   - ~11% area overhead (1 extra trit per adder)
//   - Critical path: O(log3(9)) = 2 lookahead levels vs 8 ripple stages
//
// Usage:
//   Drop-in replacement for ternary_adder #(.WIDTH(8)) in:
//   - ternary_cpu.sv (PC incrementers, branch adders)
//   - ternary_alu.sv (ALU adder)
//
// Simulation Note:
//   When SIMULATION is defined, uses ripple-carry for Icarus compatibility.
//   CLA has always_comb in generate blocks which Icarus doesn't support.

module ternary_adder_8trit_cla
  import ternary_pkg::*;
(
  input  trit_t [7:0] a,
  input  trit_t [7:0] b,
  input  trit_t       cin,
  output trit_t [7:0] sum,
  output trit_t       cout
);

`ifdef SIMULATION
  // Use ripple-carry for simulation (Icarus Verilog compatible)
  ternary_adder #(.WIDTH(8)) u_adder (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );
`else
  // Use 9-trit CLA for synthesis (optimal timing)
  trit_t [8:0] a_padded;
  trit_t [8:0] b_padded;
  trit_t [8:0] sum_padded;

  assign a_padded = {T_ZERO, a};
  assign b_padded = {T_ZERO, b};

  ternary_cla #(.WIDTH(9)) u_cla (
    .a    (a_padded),
    .b    (b_padded),
    .cin  (cin),
    .sum  (sum_padded),
    .cout (cout)
  );

  assign sum = sum_padded[7:0];
`endif

endmodule
