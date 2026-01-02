// Ternary Processing Element (PE) for Systolic Array
// ====================================================
// Weight-stationary PE for systolic array TPU.
//
// Data Flow (Weight-Stationary):
//   - Weights: Loaded once per layer, stored in local register
//   - Activations: Flow horizontally (west → east)
//   - Partial Sums: Flow vertically (north → south)
//
// Operation per cycle (when enabled):
//   1. act_out = act_in (pass activation east)
//   2. psum_out = psum_in + (activation * weight) (accumulate and pass south)
//
// Weight Loading:
//   - Assert weight_load and provide weight on weight_in
//   - Weight stored in local register
//
// Author: Tritone Project

// The trit-based PE requires ternary_mac module.
// Use TPU_INT_ONLY define to exclude it when only integer version is needed.
`ifndef TPU_INT_ONLY

module ternary_pe
  import ternary_pkg::*;
#(
  parameter int ACT_WIDTH = 8,     // Activation width in trits
  parameter int ACC_WIDTH = 27     // Accumulator/partial sum width in trits
)(
  input  logic                      clk,
  input  logic                      rst_n,

  // Control
  input  logic                      enable,       // Enable data flow
  input  logic                      weight_load,  // Load new weight

  // Weight input (2-bit encoded: 00=-1, 01=0, 10=+1)
  input  logic [1:0]                weight_in,

  // Activation flow (west → east)
  input  trit_t [ACT_WIDTH-1:0]     act_in,       // From west neighbor
  output trit_t [ACT_WIDTH-1:0]     act_out,      // To east neighbor

  // Partial sum flow (north → south)
  input  trit_t [ACC_WIDTH-1:0]     psum_in,      // From north neighbor
  output trit_t [ACC_WIDTH-1:0]     psum_out,     // To south neighbor

  // Status
  output logic                      zero_skip     // Weight is zero (skipped)
);

  // ============================================================
  // Weight Register (Stationary)
  // ============================================================
  logic [1:0] weight_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weight_reg <= 2'b01;  // Initialize to zero weight
    end else if (weight_load) begin
      weight_reg <= weight_in;
    end
  end

  // ============================================================
  // MAC Unit
  // ============================================================
  trit_t [ACC_WIDTH-1:0] mac_result;
  logic mac_zero_skip;

  ternary_mac #(
    .ACT_WIDTH(ACT_WIDTH),
    .ACC_WIDTH(ACC_WIDTH),
    .REGISTERED(0)  // Combinational MAC, we register outputs here
  ) u_mac (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .activation(act_in),
    .weight(weight_reg),
    .acc_in(psum_in),
    .acc_out(mac_result),
    .zero_skip(mac_zero_skip)
  );

  assign zero_skip = mac_zero_skip;

  // ============================================================
  // Output Registers (Pipeline Stage)
  // ============================================================

  // Activation passthrough register (west → east)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < ACT_WIDTH; i++) begin
        act_out[i] <= T_ZERO;
      end
    end else if (enable) begin
      act_out <= act_in;
    end
  end

  // Partial sum register (north → south)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < ACC_WIDTH; i++) begin
        psum_out[i] <= T_ZERO;
      end
    end else if (enable) begin
      psum_out <= mac_result;
    end
  end

endmodule

`endif // TPU_INT_ONLY

// ============================================================
// PE with Integer Interface (for simpler integration)
// ============================================================
// Uses integer representation internally, converts at boundaries

module ternary_pe_int #(
  parameter int ACT_BITS = 16,     // Activation bits (signed integer)
  parameter int ACC_BITS = 32      // Accumulator bits (signed integer)
)(
  input  logic                      clk,
  input  logic                      rst_n,

  // Control
  input  logic                      enable,
  input  logic                      weight_load,

  // Weight input (2-bit encoded)
  input  logic [1:0]                weight_in,

  // Activation flow (west → east)
  input  logic signed [ACT_BITS-1:0] act_in,
  output logic signed [ACT_BITS-1:0] act_out,

  // Partial sum flow (north → south)
  input  logic signed [ACC_BITS-1:0] psum_in,
  output logic signed [ACC_BITS-1:0] psum_out,

  // Status
  output logic                      zero_skip
);

  // Weight register
  logic [1:0] weight_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weight_reg <= 2'b01;  // Zero
    end else if (weight_load) begin
      weight_reg <= weight_in;
    end
  end

  // Zero-skip detection
  assign zero_skip = (weight_reg == 2'b01);

  // MAC computation
  logic signed [ACC_BITS-1:0] mac_result;

  always_comb begin
    case (weight_reg)
      2'b00:   mac_result = psum_in - {{(ACC_BITS-ACT_BITS){act_in[ACT_BITS-1]}}, act_in};  // -1
      2'b01:   mac_result = psum_in;                                                          // 0
      2'b10:   mac_result = psum_in + {{(ACC_BITS-ACT_BITS){act_in[ACT_BITS-1]}}, act_in};  // +1
      default: mac_result = psum_in;
    endcase
  end

  // Output registers
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_out <= '0;
      psum_out <= '0;
    end else if (enable) begin
      act_out <= act_in;
      psum_out <= mac_result;
    end
  end

endmodule
