// Top-level Ternary ALU for FPGA Implementation
// Binary I/O interface with internal ternary processing
// Part of Phase 3: FPGA ALU Prototype

module ternary_alu_top (
  input  logic        clk,
  input  logic        rst_n,

  // Binary input interface (2 bits per trit)
  input  logic [15:0] a_bin,      // 8 trits = 16 bits
  input  logic [15:0] b_bin,      // 8 trits = 16 bits
  input  logic [2:0]  op,
  input  logic        valid_in,

  // Binary output interface
  output logic [15:0] result_bin,
  output logic [1:0]  carry_bin,
  output logic        zero_flag,
  output logic        neg_flag,
  output logic        valid_out
);

  import ternary_pkg::*;

  // Internal ternary signals
  trit_t [7:0] a_tern, b_tern;
  trit_t [7:0] result_tern;
  trit_t       carry_tern;

  // Convert binary inputs to ternary
  genvar i;
  generate
    for (i = 0; i < 8; i++) begin : gen_input_conv
      assign a_tern[i] = trit_t'(a_bin[2*i+1:2*i]);
      assign b_tern[i] = trit_t'(b_bin[2*i+1:2*i]);
    end
  endgenerate

  // Ternary ALU core
  ternary_alu #(.WIDTH(8)) u_alu (
    .a         (a_tern),
    .b         (b_tern),
    .op        (op),
    .result    (result_tern),
    .carry     (carry_tern),
    .zero_flag (zero_flag),
    .neg_flag  (neg_flag)
  );

  // Convert ternary outputs to binary
  generate
    for (i = 0; i < 8; i++) begin : gen_output_conv
      assign result_bin[2*i+1:2*i] = result_tern[i];
    end
  endgenerate

  assign carry_bin = carry_tern;

  // Pipeline register for valid signal
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      valid_out <= 1'b0;
    else
      valid_out <= valid_in;
  end

endmodule