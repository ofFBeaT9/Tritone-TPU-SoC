// Pipelined Top-level Ternary ALU for FPGA Implementation
// REC-3.6: Performance Optimization with configurable pipeline stages
// Achieves higher clock frequencies through pipelining
// Part of Phase 3: FPGA ALU Prototype

module ternary_alu_top_pipelined #(
  parameter int PIPELINE_STAGES = 2  // 0=combinational, 1=1-stage, 2=2-stage (default)
)(
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

  // ========================================
  // Stage 0: Input Conversion
  // ========================================
  
  // Internal ternary signals
  trit_t [7:0] a_tern, b_tern;
  
  // Convert binary inputs to ternary
  genvar i;
  generate
    for (i = 0; i < 8; i++) begin : gen_input_conv
      assign a_tern[i] = trit_t'(a_bin[2*i+1:2*i]);
      assign b_tern[i] = trit_t'(b_bin[2*i+1:2*i]);
    end
  endgenerate

  // ========================================
  // Stage 1: ALU Operation (Pipelined)
  // ========================================
  
  trit_t [7:0] a_stage1, b_stage1;
  logic [2:0]  op_stage1;
  logic        valid_stage1;
  
  generate
    if (PIPELINE_STAGES >= 1) begin : gen_stage1_pipe
      // Pipeline registers for stage 1
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          a_stage1 <= '{default: T_ZERO};
          b_stage1 <= '{default: T_ZERO};
          op_stage1 <= 3'b000;
          valid_stage1 <= 1'b0;
        end else begin
          a_stage1 <= a_tern;
          b_stage1 <= b_tern;
          op_stage1 <= op;
          valid_stage1 <= valid_in;
        end
      end
    end else begin : gen_stage1_comb
      // No pipeline, direct connection
      assign a_stage1 = a_tern;
      assign b_stage1 = b_tern;
      assign op_stage1 = op;
      assign valid_stage1 = valid_in;
    end
  endgenerate

  // Ternary ALU core
  trit_t [7:0] result_tern;
  trit_t       carry_tern;
  logic        zero_flag_alu;
  logic        neg_flag_alu;
  
  ternary_alu #(.WIDTH(8)) u_alu (
    .a         (a_stage1),
    .b         (b_stage1),
    .op        (op_stage1),
    .result    (result_tern),
    .carry     (carry_tern),
    .zero_flag (zero_flag_alu),
    .neg_flag  (neg_flag_alu)
  );

  // ========================================
  // Stage 2: Output Conversion (Pipelined)
  // ========================================
  
  logic [15:0] result_bin_stage2;
  logic [1:0]  carry_bin_stage2;
  logic        zero_flag_stage2;
  logic        neg_flag_stage2;
  logic        valid_stage2;
  
  // Convert ternary outputs to binary
  generate
    for (i = 0; i < 8; i++) begin : gen_output_conv
      assign result_bin_stage2[2*i+1:2*i] = result_tern[i];
    end
  endgenerate
  
  assign carry_bin_stage2 = carry_tern;
  assign zero_flag_stage2 = zero_flag_alu;
  assign neg_flag_stage2 = neg_flag_alu;
  
  generate
    if (PIPELINE_STAGES >= 2) begin : gen_stage2_pipe
      // Pipeline registers for stage 2
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          result_bin <= 16'h0000;
          carry_bin <= 2'b00;
          zero_flag <= 1'b0;
          neg_flag <= 1'b0;
          valid_out <= 1'b0;
        end else begin
          result_bin <= result_bin_stage2;
          carry_bin <= carry_bin_stage2;
          zero_flag <= zero_flag_stage2;
          neg_flag <= neg_flag_stage2;
          valid_out <= valid_stage1;
        end
      end
    end else if (PIPELINE_STAGES == 1) begin : gen_stage2_single
      // Single pipeline stage - register only valid
      assign result_bin = result_bin_stage2;
      assign carry_bin = carry_bin_stage2;
      assign zero_flag = zero_flag_stage2;
      assign neg_flag = neg_flag_stage2;
      
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
          valid_out <= 1'b0;
        else
          valid_out <= valid_stage1;
      end
    end else begin : gen_stage2_comb
      // No pipeline, direct connection
      assign result_bin = result_bin_stage2;
      assign carry_bin = carry_bin_stage2;
      assign zero_flag = zero_flag_stage2;
      assign neg_flag = neg_flag_stage2;
      assign valid_out = valid_in;
    end
  endgenerate

endmodule
