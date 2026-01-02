// Ternary PE Cluster for Hierarchical Systolic Array
// ====================================================
// 8×8 PE cluster with shared weight distribution for reduced routing
// complexity when scaling to 64×64.
//
// Architecture:
//   - 8×8 grid of PEs within cluster
//   - Shared weight bus with local register file
//   - Weight-stationary dataflow preserved
//   - Activations flow west→east across cluster boundary
//   - Partial sums flow north→south across cluster boundary
//
// Benefits:
//   - Reduced global routing (weights broadcast within cluster)
//   - Local weight storage reduces SRAM port pressure
//   - Enables hierarchical floor planning
//
// Usage:
//   - Instantiate 8×8 grid of clusters for 64×64 array
//   - Each cluster loads weights for its 8 rows (64 weights total)
//
// Author: Tritone Project
// Phase: 4.1 - 64×64 Array Scaling

module ternary_pe_cluster_int #(
  parameter int CLUSTER_SIZE = 8,    // 8×8 PEs per cluster
  parameter int ACT_BITS = 16,       // Activation bits (signed integer)
  parameter int ACC_BITS = 32        // Accumulator bits (signed integer)
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Control
  input  logic                                      enable,           // Enable computation
  input  logic                                      weight_load,      // Load weights
  input  logic [$clog2(CLUSTER_SIZE)-1:0]          weight_row,       // Row within cluster to load

  // Weight input (one row at a time: CLUSTER_SIZE weights × 2 bits)
  input  logic [CLUSTER_SIZE-1:0][1:0]             weights_in,

  // Activation input (CLUSTER_SIZE activations on west edge)
  input  logic signed [CLUSTER_SIZE-1:0][ACT_BITS-1:0] act_in,

  // Activation output (east edge, for cluster chaining)
  output logic signed [CLUSTER_SIZE-1:0][ACT_BITS-1:0] act_out,

  // Partial sum input (CLUSTER_SIZE values on north edge)
  input  logic signed [CLUSTER_SIZE-1:0][ACC_BITS-1:0] psum_in,

  // Partial sum output (south edge)
  output logic signed [CLUSTER_SIZE-1:0][ACC_BITS-1:0] psum_out,

  // Status - zero skip map for power monitoring
  output logic [CLUSTER_SIZE-1:0][CLUSTER_SIZE-1:0]    zero_skip_map,

  // Performance counters
  output logic [15:0]                               zero_skip_count
);

  // ============================================================
  // Local Weight Register File (Shared within cluster)
  // ============================================================
  // Store all weights for the cluster (8 rows × 8 cols = 64 weights)
  logic [CLUSTER_SIZE-1:0][CLUSTER_SIZE-1:0][1:0] weight_regs;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Initialize all weights to zero (2'b01)
      for (int r = 0; r < CLUSTER_SIZE; r++) begin
        for (int c = 0; c < CLUSTER_SIZE; c++) begin
          weight_regs[r][c] <= 2'b01;
        end
      end
    end else if (weight_load) begin
      // Load one row of weights
      weight_regs[weight_row] <= weights_in;
    end
  end

  // ============================================================
  // Internal Wire Grid
  // ============================================================
  // Horizontal activation wires (CLUSTER_SIZE+1 columns × CLUSTER_SIZE rows)
  logic signed [CLUSTER_SIZE:0][CLUSTER_SIZE-1:0][ACT_BITS-1:0] act_wires;

  // Vertical partial sum wires (CLUSTER_SIZE columns × CLUSTER_SIZE+1 rows)
  logic signed [CLUSTER_SIZE-1:0][CLUSTER_SIZE:0][ACC_BITS-1:0] psum_wires;

  // ============================================================
  // Connect External Inputs to Wire Grid
  // ============================================================

  // Activations enter from west (column 0)
  genvar row;
  generate
    for (row = 0; row < CLUSTER_SIZE; row++) begin : gen_act_input
      assign act_wires[0][row] = act_in[row];
    end
  endgenerate

  // Partial sums enter from north (row 0)
  genvar col;
  generate
    for (col = 0; col < CLUSTER_SIZE; col++) begin : gen_psum_input
      assign psum_wires[col][0] = psum_in[col];
    end
  endgenerate

  // ============================================================
  // PE Array Instantiation (8×8 within cluster)
  // ============================================================
  genvar r, c;
  generate
    for (r = 0; r < CLUSTER_SIZE; r++) begin : gen_row
      for (c = 0; c < CLUSTER_SIZE; c++) begin : gen_col

        // Local signals for this PE
        logic [1:0] pe_weight;
        logic pe_zero_skip;

        // Weight comes from local register file (no load signal needed per PE)
        assign pe_weight = weight_regs[r][c];

        // Simplified PE without weight_load (weight already in register file)
        ternary_pe_cluster_cell #(
          .ACT_BITS(ACT_BITS),
          .ACC_BITS(ACC_BITS)
        ) u_pe (
          .clk(clk),
          .rst_n(rst_n),
          .enable(enable),
          .weight(pe_weight),
          .act_in(act_wires[c][r]),
          .act_out(act_wires[c+1][r]),
          .psum_in(psum_wires[c][r]),
          .psum_out(psum_wires[c][r+1]),
          .zero_skip(zero_skip_map[r][c])
        );

      end
    end
  endgenerate

  // ============================================================
  // Connect East Edge to Output (for cluster chaining)
  // ============================================================
  generate
    for (row = 0; row < CLUSTER_SIZE; row++) begin : gen_act_output
      assign act_out[row] = act_wires[CLUSTER_SIZE][row];
    end
  endgenerate

  // ============================================================
  // Connect South Edge to Output
  // ============================================================
  generate
    for (col = 0; col < CLUSTER_SIZE; col++) begin : gen_psum_output
      assign psum_out[col] = psum_wires[col][CLUSTER_SIZE];
    end
  endgenerate

  // ============================================================
  // Zero-Skip Counter (Performance Monitoring)
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      zero_skip_count <= '0;
    end else if (enable) begin
      // Count zero-skips in this cycle
      automatic logic [6:0] skip_sum = '0;
      for (int i = 0; i < CLUSTER_SIZE; i++) begin
        for (int j = 0; j < CLUSTER_SIZE; j++) begin
          skip_sum = skip_sum + {6'b0, zero_skip_map[i][j]};
        end
      end
      zero_skip_count <= zero_skip_count + {9'b0, skip_sum};
    end
  end

endmodule


// ============================================================
// PE Cell for Cluster (No weight_load, uses external weight)
// ============================================================
// Simplified PE that reads weight from cluster's register file

module ternary_pe_cluster_cell #(
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32
)(
  input  logic                          clk,
  input  logic                          rst_n,
  input  logic                          enable,
  input  logic [1:0]                    weight,      // From cluster register file

  // Activation flow (west → east)
  input  logic signed [ACT_BITS-1:0]    act_in,
  output logic signed [ACT_BITS-1:0]    act_out,

  // Partial sum flow (north → south)
  input  logic signed [ACC_BITS-1:0]    psum_in,
  output logic signed [ACC_BITS-1:0]    psum_out,

  // Status
  output logic                          zero_skip
);

  // Zero-skip detection
  assign zero_skip = (weight == 2'b01);

  // MAC computation (ternary multiply is just sign select)
  logic signed [ACC_BITS-1:0] mac_result;

  always_comb begin
    case (weight)
      2'b00:   mac_result = psum_in - {{(ACC_BITS-ACT_BITS){act_in[ACT_BITS-1]}}, act_in};  // weight = -1
      2'b01:   mac_result = psum_in;                                                          // weight = 0
      2'b10:   mac_result = psum_in + {{(ACC_BITS-ACT_BITS){act_in[ACT_BITS-1]}}, act_in};  // weight = +1
      default: mac_result = psum_in;
    endcase
  end

  // Output registers (pipeline stage)
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


// ============================================================
// 64×64 Hierarchical Systolic Array (8×8 clusters)
// ============================================================
// Assembles 64 PE clusters into full 64×64 array

module ternary_systolic_array_64x64 #(
  parameter int CLUSTER_SIZE = 8,      // 8×8 PEs per cluster
  parameter int NUM_CLUSTERS = 8,      // 8×8 grid of clusters
  parameter int ARRAY_SIZE = 64,       // Total array dimension (8×8=64)
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Control
  input  logic                                      enable,
  input  logic                                      weight_load,
  input  logic [$clog2(ARRAY_SIZE)-1:0]            weight_row,    // Global row (0-63)

  // Weight input (64 weights × 2 bits for one row)
  input  logic [ARRAY_SIZE-1:0][1:0]               weights_in,

  // Activation input (64 activations on west edge)
  input  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_in,

  // Partial sum input (64 values on north edge, typically zero)
  input  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] psum_in,

  // Output (64 partial sums on south edge)
  output logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] psum_out,

  // Status
  output logic [31:0]                               total_zero_skip_count
);

  // ============================================================
  // Cluster Address Decoding
  // ============================================================
  // weight_row[5:3] = cluster row (0-7)
  // weight_row[2:0] = row within cluster (0-7)

  logic [$clog2(NUM_CLUSTERS)-1:0] cluster_row_sel;
  logic [$clog2(CLUSTER_SIZE)-1:0] local_row_sel;

  assign cluster_row_sel = weight_row[$clog2(ARRAY_SIZE)-1:$clog2(CLUSTER_SIZE)];
  assign local_row_sel = weight_row[$clog2(CLUSTER_SIZE)-1:0];

  // Weight load enable per cluster row
  logic [NUM_CLUSTERS-1:0] cluster_weight_load;

  always_comb begin
    cluster_weight_load = '0;
    if (weight_load) begin
      cluster_weight_load[cluster_row_sel] = 1'b1;
    end
  end

  // ============================================================
  // Inter-Cluster Wiring
  // ============================================================

  // Horizontal activation wires between cluster columns
  // [cluster_col][cluster_row][row_within_cluster]
  logic signed [NUM_CLUSTERS:0][NUM_CLUSTERS-1:0][CLUSTER_SIZE-1:0][ACT_BITS-1:0] cluster_act_wires;

  // Vertical partial sum wires between cluster rows
  // [cluster_col][cluster_row][col_within_cluster]
  logic signed [NUM_CLUSTERS-1:0][NUM_CLUSTERS:0][CLUSTER_SIZE-1:0][ACC_BITS-1:0] cluster_psum_wires;

  // Zero skip counts per cluster
  logic [NUM_CLUSTERS-1:0][NUM_CLUSTERS-1:0][15:0] cluster_zero_skip;

  // ============================================================
  // Connect External Inputs to West Edge Clusters
  // ============================================================
  genvar cr;
  generate
    for (cr = 0; cr < NUM_CLUSTERS; cr++) begin : gen_west_input
      // Map global activations to cluster inputs
      // Cluster row cr receives activations [cr*8 +: 8]
      assign cluster_act_wires[0][cr] = act_in[cr*CLUSTER_SIZE +: CLUSTER_SIZE];
    end
  endgenerate

  // Connect External Inputs to North Edge Clusters
  genvar cc;
  generate
    for (cc = 0; cc < NUM_CLUSTERS; cc++) begin : gen_north_input
      // Map global psum inputs to cluster inputs
      // Cluster col cc receives psum [cc*8 +: 8]
      assign cluster_psum_wires[cc][0] = psum_in[cc*CLUSTER_SIZE +: CLUSTER_SIZE];
    end
  endgenerate

  // ============================================================
  // Cluster Grid Instantiation (8×8 clusters = 64×64 PEs)
  // ============================================================
  genvar crow, ccol;
  generate
    for (crow = 0; crow < NUM_CLUSTERS; crow++) begin : gen_cluster_row
      for (ccol = 0; ccol < NUM_CLUSTERS; ccol++) begin : gen_cluster_col

        // Extract weights for this cluster column from global weight bus
        logic [CLUSTER_SIZE-1:0][1:0] cluster_weights;
        assign cluster_weights = weights_in[ccol*CLUSTER_SIZE +: CLUSTER_SIZE];

        // Zero skip map for this cluster (unused externally but available)
        logic [CLUSTER_SIZE-1:0][CLUSTER_SIZE-1:0] cluster_skip_map;

        ternary_pe_cluster_int #(
          .CLUSTER_SIZE(CLUSTER_SIZE),
          .ACT_BITS(ACT_BITS),
          .ACC_BITS(ACC_BITS)
        ) u_cluster (
          .clk(clk),
          .rst_n(rst_n),
          .enable(enable),
          .weight_load(cluster_weight_load[crow]),
          .weight_row(local_row_sel),
          .weights_in(cluster_weights),

          // Activation flow
          .act_in(cluster_act_wires[ccol][crow]),
          .act_out(cluster_act_wires[ccol+1][crow]),

          // Partial sum flow
          .psum_in(cluster_psum_wires[ccol][crow]),
          .psum_out(cluster_psum_wires[ccol][crow+1]),

          // Status
          .zero_skip_map(cluster_skip_map),
          .zero_skip_count(cluster_zero_skip[crow][ccol])
        );

      end
    end
  endgenerate

  // ============================================================
  // Connect South Edge Clusters to Output
  // ============================================================
  generate
    for (cc = 0; cc < NUM_CLUSTERS; cc++) begin : gen_south_output
      assign psum_out[cc*CLUSTER_SIZE +: CLUSTER_SIZE] = cluster_psum_wires[cc][NUM_CLUSTERS];
    end
  endgenerate

  // ============================================================
  // Aggregate Zero-Skip Count
  // ============================================================
  always_comb begin
    automatic logic [31:0] sum = '0;
    for (int i = 0; i < NUM_CLUSTERS; i++) begin
      for (int j = 0; j < NUM_CLUSTERS; j++) begin
        sum = sum + {16'b0, cluster_zero_skip[i][j]};
      end
    end
    total_zero_skip_count = sum;
  end

endmodule
