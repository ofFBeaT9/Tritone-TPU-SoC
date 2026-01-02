// Ternary MAC Unit for TPU Systolic Array - Icarus Compatible Version
// =====================================================================
// Simplified version for Icarus Verilog compatibility.
//
// Key Innovation: Ternary weights {-1, 0, +1} eliminate multiplication!
//
// Standard MAC:  output = input × weight + accumulator  (needs multiplier)
// Ternary MAC:   output = mux(weight, {-input, 0, +input}) + accumulator
//
// Weight Encoding (2-bit):
//   00 = -1 (negative one)
//   01 =  0 (zero)
//   10 = +1 (positive one)
//   11 = invalid
//
// This version uses integer arithmetic internally for easier verification.
//
// Author: Tritone Project

module ternary_mac_icarus
  import ternary_pkg::*;
#(
  parameter int ACT_WIDTH = 8,     // Activation width in trits
  parameter int ACC_WIDTH = 27     // Accumulator width in trits
)(
  input  logic                      clk,
  input  logic                      rst_n,
  input  logic                      enable,      // Enable MAC operation

  // Activation input (8-trit balanced ternary, 2-bit per trit)
  input  trit_t [ACT_WIDTH-1:0]     activation,

  // Ternary weight (2-bit encoded: 00=-1, 01=0, 10=+1)
  input  logic [1:0]                weight,

  // Accumulator input/output (27-trit balanced ternary)
  input  trit_t [ACC_WIDTH-1:0]     acc_in,
  output trit_t [ACC_WIDTH-1:0]     acc_out,

  // Zero-skip indicator (high when weight=0)
  output logic                      zero_skip
);

  // ============================================================
  // Weight Decoding
  // ============================================================
  localparam logic [1:0] WEIGHT_NEG = 2'b00;
  localparam logic [1:0] WEIGHT_ZERO = 2'b01;
  localparam logic [1:0] WEIGHT_POS = 2'b10;

  assign zero_skip = (weight == WEIGHT_ZERO);

  // ============================================================
  // Integer arithmetic version (simpler for verification)
  // ============================================================

  // Convert activation trits to signed integer
  function automatic int trit_array_to_int_act(input trit_t [ACT_WIDTH-1:0] trits);
    int result;
    int power3;
    int i;

    result = 0;
    power3 = 1;
    for (i = 0; i < ACT_WIDTH; i++) begin
      case (trits[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ; // T_ZERO
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // Convert accumulator trits to signed integer
  function automatic int trit_array_to_int_acc(input trit_t [ACC_WIDTH-1:0] trits);
    int result;
    int power3;
    int i;

    result = 0;
    power3 = 1;
    for (i = 0; i < ACC_WIDTH; i++) begin
      case (trits[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // ============================================================
  // MAC Computation
  // ============================================================

  trit_t [ACC_WIDTH-1:0] result_trits;
  trit_t [ACC_WIDTH-1:0] acc_out_reg;

  // Combinational MAC computation
  always_comb begin
    int act_int;
    int acc_int;
    int result_int;
    int temp;
    int rem;
    int i;

    // Convert inputs to integers
    act_int = trit_array_to_int_act(activation);
    acc_int = trit_array_to_int_acc(acc_in);

    // Compute MAC based on weight
    case (weight)
      WEIGHT_NEG:  result_int = acc_int - act_int;  // -1 * activation
      WEIGHT_ZERO: result_int = acc_int;             // 0 * activation
      WEIGHT_POS:  result_int = acc_int + act_int;  // +1 * activation
      default:     result_int = acc_int;
    endcase

    // Convert result back to trits (inline)
    // Uses Euclidean division for correct negative number handling
    temp = result_int;
    for (i = 0; i < ACC_WIDTH; i++) begin
      // Compute Euclidean modulo (always non-negative)
      rem = temp % 3;
      if (rem < 0) rem = rem + 3;

      case (rem)
        0: result_trits[i] = T_ZERO;
        1: result_trits[i] = T_POS_ONE;
        2: begin
          result_trits[i] = T_NEG_ONE;
          temp = temp + 1;  // Adjust for balanced representation
        end
        default: result_trits[i] = T_ZERO;
      endcase

      // Euclidean division (floor toward -infinity for negative)
      if (temp >= 0) begin
        temp = temp / 3;
      end else begin
        temp = (temp - 2) / 3;  // Floor division for negative
      end
    end
  end

  // ============================================================
  // Output Registration
  // ============================================================

  always_ff @(posedge clk or negedge rst_n) begin
    int j;
    if (!rst_n) begin
      for (j = 0; j < ACC_WIDTH; j++) begin
        acc_out_reg[j] <= T_ZERO;
      end
    end else if (enable) begin
      acc_out_reg <= result_trits;
    end
  end

  assign acc_out = acc_out_reg;

endmodule
