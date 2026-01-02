// Balanced Ternary ALU
// 8-trit datapath with multiple operations
//
// Operations:
// 000 - ADD: a + b
// 001 - SUB: a - b (a + (-b))
// 010 - NEG: -a (ternary negation)
// 011 - MIN: trit-wise MIN(a, b) - AND-like
// 100 - MAX: trit-wise MAX(a, b) - OR-like
// 101 - SHL: shift left (multiply by 3)
// 110 - SHR: shift right (divide by 3)
// 111 - CMP: compare a and b (result = a - b for flags)

module ternary_alu
  import ternary_pkg::*;
#(
  parameter int WIDTH = 8
)(
  input  trit_t [WIDTH-1:0] a,
  input  trit_t [WIDTH-1:0] b,
  input  logic [2:0]        op,
  output trit_t [WIDTH-1:0] result,
  output trit_t             carry,
  output logic              zero_flag,
  output logic              neg_flag
);

  // Operation codes
  localparam logic [2:0] OP_ADD = 3'b000;
  localparam logic [2:0] OP_SUB = 3'b001;
  localparam logic [2:0] OP_NEG = 3'b010;
  localparam logic [2:0] OP_MIN = 3'b011;
  localparam logic [2:0] OP_MAX = 3'b100;
  localparam logic [2:0] OP_SHL = 3'b101;  // Shift left (multiply by 3)
  localparam logic [2:0] OP_SHR = 3'b110;  // Shift right (divide by 3)
  localparam logic [2:0] OP_CMP = 3'b111;  // Compare

  // Internal signals
  trit_t [WIDTH-1:0] b_negated;
  trit_t [WIDTH-1:0] add_result;
  trit_t [WIDTH-1:0] min_result;
  trit_t [WIDTH-1:0] max_result;
  trit_t [WIDTH-1:0] neg_result;
  trit_t [WIDTH-1:0] shl_result;
  trit_t [WIDTH-1:0] shr_result;
  trit_t             add_carry;

  // Negate B for subtraction
  genvar i;
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_neg_b
      assign b_negated[i] = t_neg(b[i]);
    end
  endgenerate

  // Local constant zero for carry-in (workaround for Icarus Verilog)
  trit_t const_zero_trit;
  assign const_zero_trit = T_ZERO;

  // Adder (used for ADD and SUB) - using 9-trit CLA with padding for timing
  // Note: This assumes WIDTH=8 (default). For other widths, use ternary_adder.
  ternary_adder_8trit_cla u_adder (
    .a    (a),
    .b    (op == OP_SUB || op == OP_CMP ? b_negated : b),
    .cin  (const_zero_trit),
    .sum  (add_result),
    .cout (add_carry)
  );

  // Bitwise operations
  generate
    for (i = 0; i < WIDTH; i++) begin : gen_bitwise
      assign neg_result[i] = t_neg(a[i]);
      assign min_result[i] = t_min(a[i], b[i]);
      assign max_result[i] = t_max(a[i], b[i]);
    end
  endgenerate

  // Shift operations for single trit
  trit_t shift_insert;
  assign shift_insert = T_ZERO;
  assign shl_result = {a[WIDTH-2:0], shift_insert};  // Shift left, insert 0
  assign shr_result = {shift_insert, a[WIDTH-1:1]};  // Shift right, insert 0

  // Output multiplexer
  always_comb begin
    case (op)
      OP_ADD: result = add_result;
      OP_SUB: result = add_result;
      OP_NEG: result = neg_result;
      OP_MIN: result = min_result;
      OP_MAX: result = max_result;
      OP_SHL: result = shl_result;
      OP_SHR: result = shr_result;
      OP_CMP: result = add_result;  // Compare uses subtraction
      default: begin
        for (int k = 0; k < WIDTH; k++) result[k] = T_INVALID;
      end
    endcase
  end

  // Carry output
  assign carry = trit_t'((op == OP_ADD || op == OP_SUB || op == OP_CMP) ? add_carry : T_ZERO);

  // Zero flag: check if all trits are zero
  logic all_zero;
  always_comb begin
    all_zero = 1'b1;
    for (int j = 0; j < WIDTH; j++) begin
      if (result[j] != T_ZERO) all_zero = 1'b0;
    end
  end
  assign zero_flag = all_zero;

  // Negative flag: check MSB
  assign neg_flag = (result[WIDTH-1] == T_NEG_ONE);

endmodule
