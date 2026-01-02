// Ternary MAC Unit for TPU Systolic Array
// ========================================
// Key Innovation: Ternary weights {-1, 0, +1} eliminate multiplication!
//
// Standard MAC:  output = input × weight + accumulator  (needs multiplier)
// Ternary MAC:   output = mux(weight, {-input, 0, +input}) + accumulator
//
// Features:
// - Zero-skip: When weight=0, skip MAC operation entirely (power savings)
// - Pipelined option for high frequency
// - Uses balanced ternary encoding from ternary_pkg
//
// Weight Encoding (2-bit):
//   00 = -1 (negative one)
//   01 =  0 (zero)
//   10 = +1 (positive one)
//   11 = invalid
//
// Author: Tritone Project

module ternary_mac
  import ternary_pkg::*;
#(
  parameter int ACT_WIDTH = 8,     // Activation width in trits
  parameter int ACC_WIDTH = 27,    // Accumulator width in trits
  parameter bit REGISTERED = 1     // 1 = pipelined output, 0 = combinational
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

  logic weight_is_neg;
  logic weight_is_zero;
  logic weight_is_pos;

  assign weight_is_neg = (weight == WEIGHT_NEG);
  assign weight_is_zero = (weight == WEIGHT_ZERO);
  assign weight_is_pos = (weight == WEIGHT_POS);

  assign zero_skip = weight_is_zero;

  // ============================================================
  // Activation Selection (replaces multiplier)
  // ============================================================
  // Based on weight:
  //   -1: use -activation (negate)
  //    0: use 0 (zero-skip)
  //   +1: use +activation (pass through)

  trit_t [ACT_WIDTH-1:0] selected_act;

  // Negate activation for weight=-1
  genvar i;
  generate
    for (i = 0; i < ACT_WIDTH; i++) begin : gen_negate
      always_comb begin
        if (weight_is_neg) begin
          // Negate: swap +1 and -1, keep 0
          selected_act[i] = t_neg(activation[i]);
        end else if (weight_is_zero) begin
          // Zero-skip: output zero
          selected_act[i] = T_ZERO;
        end else begin
          // Pass through for weight=+1
          selected_act[i] = activation[i];
        end
      end
    end
  endgenerate

  // ============================================================
  // Sign Extension to Accumulator Width
  // ============================================================
  // Extend ACT_WIDTH trits to ACC_WIDTH trits
  // Sign extension in balanced ternary: replicate MST

  trit_t [ACC_WIDTH-1:0] extended_act;

  generate
    for (i = 0; i < ACC_WIDTH; i++) begin : gen_extend
      always_comb begin
        if (i < ACT_WIDTH) begin
          extended_act[i] = selected_act[i];
        end else begin
          // Sign extend: replicate the sign trit (MST of activation)
          // In balanced ternary, sign extension uses the most significant trit
          extended_act[i] = selected_act[ACT_WIDTH-1];
        end
      end
    end
  endgenerate

  // ============================================================
  // Ternary Addition (Accumulation)
  // ============================================================
  // Use the CLA adder for efficient accumulation

  trit_t [ACC_WIDTH-1:0] sum_result;
  trit_t cout_unused;

  ternary_cla #(
    .WIDTH(ACC_WIDTH)
  ) u_adder (
    .a(acc_in),
    .b(extended_act),
    .cin(T_ZERO),
    .sum(sum_result),
    .cout(cout_unused)
  );

  // ============================================================
  // Output Registration (Optional)
  // ============================================================

  generate
    if (REGISTERED) begin : gen_registered
      // Pipelined output
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          for (int j = 0; j < ACC_WIDTH; j++) begin
            acc_out[j] <= T_ZERO;
          end
        end else if (enable) begin
          acc_out <= sum_result;
        end
      end
    end else begin : gen_combinational
      // Combinational output
      assign acc_out = sum_result;
    end
  endgenerate

endmodule


// ============================================================
// Simplified MAC for Synthesis Analysis
// ============================================================
// This version uses integer math for comparison

module ternary_mac_simple #(
  parameter int ACT_BITS = 16,    // Activation bits (integer)
  parameter int ACC_BITS = 32     // Accumulator bits (integer)
)(
  input  logic                    clk,
  input  logic                    rst_n,
  input  logic                    enable,

  input  logic signed [ACT_BITS-1:0] activation,
  input  logic [1:0]                  weight,     // 00=-1, 01=0, 10=+1
  input  logic signed [ACC_BITS-1:0] acc_in,
  output logic signed [ACC_BITS-1:0] acc_out,
  output logic                       zero_skip
);

  // Weight decode
  logic signed [1:0] weight_val;
  always_comb begin
    case (weight)
      2'b00: weight_val = -2'sd1;  // -1
      2'b01: weight_val = 2'sd0;   // 0
      2'b10: weight_val = 2'sd1;   // +1
      default: weight_val = 2'sd0;
    endcase
  end

  assign zero_skip = (weight == 2'b01);

  // MAC operation (ternary multiply is just sign select!)
  logic signed [ACC_BITS-1:0] product;

  always_comb begin
    case (weight)
      2'b00: product = -{{(ACC_BITS-ACT_BITS){activation[ACT_BITS-1]}}, activation};
      2'b01: product = '0;
      2'b10: product = {{(ACC_BITS-ACT_BITS){activation[ACT_BITS-1]}}, activation};
      default: product = '0;
    endcase
  end

  // Registered accumulation
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      acc_out <= '0;
    end else if (enable) begin
      acc_out <= acc_in + product;
    end
  end

endmodule
