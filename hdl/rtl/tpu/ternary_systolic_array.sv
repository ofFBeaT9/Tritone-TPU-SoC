// Ternary Systolic Array for TPU
// ================================
// Parameterized NxN weight-stationary systolic array for ternary
// neural network inference.
//
// Architecture:
//   - N×N grid of Processing Elements (PEs)
//   - Weight-stationary dataflow
//   - Activations flow west→east
//   - Partial sums flow north→south
//
// Matrix Operation:
//   Output = Weights × Activations^T
//   Where Weights are ternary {-1, 0, +1}
//
// Timing:
//   - Weight loading: N cycles (one row per cycle)
//   - Computation: 2N-1 cycles (diagonal wavefront)
//   - Results drain: N cycles
//
// Author: Tritone Project

// The trit-based systolic array requires ternary_pe module.
// Use TPU_INT_ONLY define to exclude it when only integer version is needed.
`ifndef TPU_INT_ONLY

module ternary_systolic_array
  import ternary_pkg::*;
#(
  parameter int ARRAY_SIZE = 8,    // N×N array dimension
  parameter int ACT_WIDTH = 8,     // Activation width in trits
  parameter int ACC_WIDTH = 27     // Accumulator width in trits
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Control
  input  logic                                      enable,       // Enable computation
  input  logic                                      weight_load,  // Load weights (all rows)
  input  logic [$clog2(ARRAY_SIZE)-1:0]            weight_row,   // Row to load weights

  // Weight input (one row at a time, N weights × 2 bits)
  input  logic [ARRAY_SIZE-1:0][1:0]               weights_in,

  // Activation input (N activations on west edge)
  input  trit_t [ARRAY_SIZE-1:0][ACT_WIDTH-1:0]    act_in,

  // Partial sum input (N values on north edge, typically zero)
  input  trit_t [ARRAY_SIZE-1:0][ACC_WIDTH-1:0]    psum_in,

  // Output (N partial sums on south edge)
  output trit_t [ARRAY_SIZE-1:0][ACC_WIDTH-1:0]    psum_out,

  // Status
  output logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0]    zero_skip_map
);

  // ============================================================
  // Internal Signals
  // ============================================================

  // Horizontal activation wires (N+1 columns × N rows)
  trit_t [ARRAY_SIZE:0][ARRAY_SIZE-1:0][ACT_WIDTH-1:0] act_wires;

  // Vertical partial sum wires (N columns × N+1 rows)
  trit_t [ARRAY_SIZE-1:0][ARRAY_SIZE:0][ACC_WIDTH-1:0] psum_wires;

  // Weight load enables per row
  logic [ARRAY_SIZE-1:0] weight_load_row;

  // ============================================================
  // Weight Load Decoder
  // ============================================================
  always_comb begin
    weight_load_row = '0;
    if (weight_load) begin
      weight_load_row[weight_row] = 1'b1;
    end
  end

  // ============================================================
  // Connect External Inputs to Wire Grid
  // ============================================================

  // Activations enter from west (column 0)
  genvar row;
  generate
    for (row = 0; row < ARRAY_SIZE; row++) begin : gen_act_input
      assign act_wires[0][row] = act_in[row];
    end
  endgenerate

  // Partial sums enter from north (row 0)
  genvar col;
  generate
    for (col = 0; col < ARRAY_SIZE; col++) begin : gen_psum_input
      assign psum_wires[col][0] = psum_in[col];
    end
  endgenerate

  // ============================================================
  // PE Array Instantiation
  // ============================================================
  genvar r, c;
  generate
    for (r = 0; r < ARRAY_SIZE; r++) begin : gen_row
      for (c = 0; c < ARRAY_SIZE; c++) begin : gen_col

        ternary_pe #(
          .ACT_WIDTH(ACT_WIDTH),
          .ACC_WIDTH(ACC_WIDTH)
        ) u_pe (
          .clk(clk),
          .rst_n(rst_n),
          .enable(enable),
          .weight_load(weight_load_row[r]),
          .weight_in(weights_in[c]),

          // Activation flow (west → east)
          .act_in(act_wires[c][r]),
          .act_out(act_wires[c+1][r]),

          // Partial sum flow (north → south)
          .psum_in(psum_wires[c][r]),
          .psum_out(psum_wires[c][r+1]),

          // Status
          .zero_skip(zero_skip_map[r][c])
        );

      end
    end
  endgenerate

  // ============================================================
  // Connect South Edge to Output
  // ============================================================
  generate
    for (col = 0; col < ARRAY_SIZE; col++) begin : gen_psum_output
      assign psum_out[col] = psum_wires[col][ARRAY_SIZE];
    end
  endgenerate

endmodule

`endif // TPU_INT_ONLY

// ============================================================
// Integer-Based Systolic Array (for simpler synthesis)
// ============================================================

module ternary_systolic_array_int #(
  parameter int ARRAY_SIZE = 8,
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Control
  input  logic                                      enable,
  input  logic                                      weight_load,
  input  logic [$clog2(ARRAY_SIZE)-1:0]            weight_row,

  // Weight input (N weights × 2 bits)
  input  logic [ARRAY_SIZE-1:0][1:0]               weights_in,

  // Activation input (N activations)
  input  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_in,

  // Partial sum input (N values, typically zero)
  input  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] psum_in,

  // Output (N partial sums)
  output logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] psum_out,

  // Status
  output logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0]    zero_skip_map
);

  // Internal wires
  logic signed [ARRAY_SIZE:0][ARRAY_SIZE-1:0][ACT_BITS-1:0] act_wires;
  logic signed [ARRAY_SIZE-1:0][ARRAY_SIZE:0][ACC_BITS-1:0] psum_wires;
  logic [ARRAY_SIZE-1:0] weight_load_row;

  // Weight load decoder
  always_comb begin
    weight_load_row = '0;
    if (weight_load) begin
      weight_load_row[weight_row] = 1'b1;
    end
  end

  // Connect inputs
  genvar row, col;
  generate
    for (row = 0; row < ARRAY_SIZE; row++) begin : gen_act_in
      assign act_wires[0][row] = act_in[row];
    end
    for (col = 0; col < ARRAY_SIZE; col++) begin : gen_psum_in
      assign psum_wires[col][0] = psum_in[col];
    end
  endgenerate

  // PE array
  generate
    for (row = 0; row < ARRAY_SIZE; row++) begin : gen_rows
      for (col = 0; col < ARRAY_SIZE; col++) begin : gen_cols

        ternary_pe_int #(
          .ACT_BITS(ACT_BITS),
          .ACC_BITS(ACC_BITS)
        ) u_pe (
          .clk(clk),
          .rst_n(rst_n),
          .enable(enable),
          .weight_load(weight_load_row[row]),
          .weight_in(weights_in[col]),
          .act_in(act_wires[col][row]),
          .act_out(act_wires[col+1][row]),
          .psum_in(psum_wires[col][row]),
          .psum_out(psum_wires[col][row+1]),
          .zero_skip(zero_skip_map[row][col])
        );

      end
    end
  endgenerate

  // Connect outputs
  generate
    for (col = 0; col < ARRAY_SIZE; col++) begin : gen_psum_out
      assign psum_out[col] = psum_wires[col][ARRAY_SIZE];
    end
  endgenerate

endmodule
