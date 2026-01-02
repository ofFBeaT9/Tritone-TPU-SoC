// Ternary MAC Unit - 2 GHz Pipelined Version
// ============================================
// Two-stage pipeline for 2 GHz operation on ASAP7 7nm
//
// Pipeline Stages:
//   Stage 1: Weight decode + Sign selection + Sign extension
//   Stage 2: CLA addition + Output registration
//
// Latency: 2 cycles
// Throughput: 1 MAC/cycle (fully pipelined)
//
// Critical Path Analysis @ 2 GHz (500ps):
//   - Stage 1: ~200ps (decode + mux + extend)
//   - Stage 2: ~250ps (27-trit CLA)
//   - Margin: ~50ps for clock skew + setup
//
// Author: Tritone Project (2 GHz Enhancement)

module ternary_mac_2ghz #(
  parameter int ACT_BITS = 16,    // Activation bits (signed integer)
  parameter int ACC_BITS = 32     // Accumulator bits (signed integer)
)(
  input  logic                      clk,
  input  logic                      rst_n,
  input  logic                      enable,
  input  logic                      clear,       // Clear accumulator

  // Inputs (Stage 0)
  input  logic signed [ACT_BITS-1:0] activation,
  input  logic [1:0]                  weight,     // 00=-1, 01=0, 10=+1
  input  logic signed [ACC_BITS-1:0]  psum_in,    // Partial sum from north

  // Outputs (Stage 2)
  output logic signed [ACC_BITS-1:0]  psum_out,
  output logic                        zero_skip,
  output logic                        valid_out   // Output valid indicator
);

  // ============================================================
  // Stage 1 Registers (Weight Decode + Sign Selection)
  // ============================================================
  logic signed [ACC_BITS-1:0] s1_product;
  logic signed [ACC_BITS-1:0] s1_psum_in;
  logic                       s1_zero_skip;
  logic                       s1_valid;

  // Sign extension
  wire signed [ACC_BITS-1:0] act_extended = {{(ACC_BITS-ACT_BITS){activation[ACT_BITS-1]}}, activation};

  // Combinational: Weight decode and product selection
  logic signed [ACC_BITS-1:0] product_comb;
  logic                       zero_skip_comb;

  always_comb begin
    case (weight)
      2'b00: begin   // -1
        product_comb = -act_extended;
        zero_skip_comb = 1'b0;
      end
      2'b01: begin   // 0
        product_comb = '0;
        zero_skip_comb = 1'b1;
      end
      2'b10: begin   // +1
        product_comb = act_extended;
        zero_skip_comb = 1'b0;
      end
      default: begin
        product_comb = '0;
        zero_skip_comb = 1'b1;
      end
    endcase
  end

  // Stage 1 Pipeline Register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      s1_product   <= '0;
      s1_psum_in   <= '0;
      s1_zero_skip <= 1'b0;
      s1_valid     <= 1'b0;
    end else if (clear) begin
      s1_product   <= '0;
      s1_psum_in   <= '0;
      s1_zero_skip <= 1'b0;
      s1_valid     <= 1'b0;
    end else if (enable) begin
      s1_product   <= product_comb;
      s1_psum_in   <= psum_in;
      s1_zero_skip <= zero_skip_comb;
      s1_valid     <= 1'b1;
    end else begin
      s1_valid     <= 1'b0;
    end
  end

  // ============================================================
  // Stage 2: Addition + Output Registration
  // ============================================================
  // The adder is the critical path - use simple addition for synthesis
  // Synthesis tools will map this optimally for the target frequency

  logic signed [ACC_BITS-1:0] sum_result;
  assign sum_result = s1_psum_in + s1_product;

  // Stage 2 Output Registers
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      psum_out  <= '0;
      zero_skip <= 1'b0;
      valid_out <= 1'b0;
    end else if (clear) begin
      psum_out  <= '0;
      zero_skip <= 1'b0;
      valid_out <= 1'b0;
    end else begin
      psum_out  <= sum_result;
      zero_skip <= s1_zero_skip;
      valid_out <= s1_valid;
    end
  end

endmodule


// ============================================================
// 2 GHz Processing Element with Pipelined MAC
// ============================================================
module ternary_pe_2ghz #(
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32
)(
  input  logic                      clk,
  input  logic                      rst_n,

  // Control
  input  logic                      enable,
  input  logic                      weight_load,
  input  logic                      clear,

  // Weight input
  input  logic [1:0]                weight_in,

  // Activation flow (west → east)
  input  logic signed [ACT_BITS-1:0] act_in,
  output logic signed [ACT_BITS-1:0] act_out,

  // Partial sum flow (north → south)
  input  logic signed [ACC_BITS-1:0] psum_in,
  output logic signed [ACC_BITS-1:0] psum_out,

  // Status
  output logic                      zero_skip,
  output logic                      valid_out
);

  // Weight register (stationary)
  logic [1:0] weight_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weight_reg <= 2'b01;  // Zero
    end else if (weight_load) begin
      weight_reg <= weight_in;
    end
  end

  // Activation passthrough (1 cycle delay to match pipeline)
  logic signed [ACT_BITS-1:0] act_d1;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_d1  <= '0;
      act_out <= '0;
    end else if (enable) begin
      act_d1  <= act_in;
      act_out <= act_d1;  // 2 cycle delay to match MAC pipeline
    end
  end

  // Pipelined MAC
  ternary_mac_2ghz #(
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS)
  ) u_mac (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .clear(clear),
    .activation(act_in),
    .weight(weight_reg),
    .psum_in(psum_in),
    .psum_out(psum_out),
    .zero_skip(zero_skip),
    .valid_out(valid_out)
  );

endmodule


// ============================================================
// Systolic Array Configuration for 2 GHz
// ============================================================
// Note: The 2-stage pipeline adds 1 cycle latency per PE.
// For 64x64 array, total latency increases from 64+63=127 to 64+63+64=191 cycles.
// However, throughput remains 1 result/cycle in steady state.
//
// Controller modifications needed:
// - Increase drain cycles by ARRAY_SIZE
// - Adjust fill timing for activation skewing
// - Update performance counter expectations

module ternary_systolic_array_2ghz
  import ternary_pkg::*;
#(
  parameter int ARRAY_SIZE = 64,
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32
)(
  input  logic                              clk,
  input  logic                              rst_n,

  // Control
  input  logic                              enable,
  input  logic                              weight_load,
  input  logic                              clear,

  // Weight inputs (one per column)
  input  logic [ARRAY_SIZE-1:0][1:0]        weight_in,

  // Activation inputs (one per row, from west edge)
  input  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_in,

  // Partial sum inputs (one per column, from north edge)
  input  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] psum_in,

  // Outputs
  output logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] psum_out,
  output logic [ARRAY_SIZE-1:0]                      valid_out,

  // Statistics
  output logic [$clog2(ARRAY_SIZE*ARRAY_SIZE+1)-1:0] zero_skip_count
);

  // PE array signals
  logic signed [ARRAY_SIZE:0][ARRAY_SIZE-1:0][ACT_BITS-1:0] pe_act;
  logic signed [ARRAY_SIZE-1:0][ARRAY_SIZE:0][ACC_BITS-1:0] pe_psum;
  logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] pe_zero_skip;
  logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] pe_valid;

  // Connect edge inputs
  genvar row, col;
  generate
    for (row = 0; row < ARRAY_SIZE; row++) begin : gen_act_in
      assign pe_act[0][row] = act_in[row];
    end
    for (col = 0; col < ARRAY_SIZE; col++) begin : gen_psum_in
      assign pe_psum[col][0] = psum_in[col];
    end
  endgenerate

  // Instantiate PE array
  generate
    for (row = 0; row < ARRAY_SIZE; row++) begin : gen_row
      for (col = 0; col < ARRAY_SIZE; col++) begin : gen_col
        ternary_pe_2ghz #(
          .ACT_BITS(ACT_BITS),
          .ACC_BITS(ACC_BITS)
        ) u_pe (
          .clk(clk),
          .rst_n(rst_n),
          .enable(enable),
          .weight_load(weight_load),
          .clear(clear),
          .weight_in(weight_in[col]),
          .act_in(pe_act[col][row]),
          .act_out(pe_act[col+1][row]),
          .psum_in(pe_psum[col][row]),
          .psum_out(pe_psum[col][row+1]),
          .zero_skip(pe_zero_skip[row][col]),
          .valid_out(pe_valid[row][col])
        );
      end
    end
  endgenerate

  // Connect south edge outputs
  generate
    for (col = 0; col < ARRAY_SIZE; col++) begin : gen_psum_out
      assign psum_out[col] = pe_psum[col][ARRAY_SIZE];
      assign valid_out[col] = pe_valid[ARRAY_SIZE-1][col];
    end
  endgenerate

  // Zero-skip counter (sum all PE zero_skips)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      zero_skip_count <= '0;
    end else if (clear) begin
      zero_skip_count <= '0;
    end else if (enable) begin
      // Count zero skips this cycle
      automatic int skip_sum = 0;
      for (int r = 0; r < ARRAY_SIZE; r++) begin
        for (int c = 0; c < ARRAY_SIZE; c++) begin
          skip_sum += pe_zero_skip[r][c];
        end
      end
      zero_skip_count <= zero_skip_count + skip_sum[$bits(zero_skip_count)-1:0];
    end
  end

endmodule
