// TPU RSQRT Unit - Reciprocal Square Root for Molecular Dynamics
// ==============================================================
// Phase 6.2: Fast 1/sqrt(x) for force calculations
//
// Algorithm:
//   1. LUT initial estimate (8-bit precision)
//   2. Newton-Raphson refinement: x' = x * (3 - y*x²) / 2
//   3. Configurable iterations (1-2 for 16-bit precision)
//
// Applications:
//   - Molecular dynamics: F = q1*q2 / r² requires 1/sqrt(r²)
//   - Neural networks: Layer normalization requires rsqrt(variance)
//   - Graphics: Vector normalization
//
// Input Format: Q8.8 fixed-point (unsigned, range [0.004, 255.996])
// Output Format: Q1.15 fixed-point (range [0, 16])
//
// Latency: 3 + 2*NUM_ITERATIONS cycles
// Throughput: 1 result/cycle (pipelined)
//
// Author: Tritone Project (Phase 6: Specialized Numerics)

module tpu_rsqrt_unit #(
  parameter int DATA_WIDTH = 16,
  parameter int LUT_DEPTH = 256,
  parameter int NUM_ITERATIONS = 2,      // Newton-Raphson iterations
  parameter bit ENABLE_SPECIAL_CASES = 1 // Handle 0, inf, very small
)(
  input  logic                          clk,
  input  logic                          rst_n,
  input  logic                          enable,

  // Streaming interface
  input  logic [DATA_WIDTH-1:0]         data_in,       // Q8.8 unsigned
  input  logic                          data_valid,
  output logic                          data_ready,

  output logic signed [DATA_WIDTH-1:0]  data_out,      // Q1.15 signed
  output logic                          data_out_valid,
  output logic                          special_case,  // Output is special (0, inf)

  // Performance counters
  output logic [31:0]                   ops_count,
  output logic [31:0]                   newton_iters
);

  // ============================================================
  // RSQRT LUT (256 entries, Q1.15 output for sqrt range)
  // ============================================================
  // Index = upper 8 bits of input
  // LUT[i] ≈ 1/sqrt((i + 0.5) / 16) scaled to Q1.15
  //
  // For input x in [0, 16) with 256 steps:
  //   step = x / 256 * 16 = x / 16
  //   rsqrt(step) scaled to fit Q1.15

  logic signed [DATA_WIDTH-1:0] rsqrt_lut [LUT_DEPTH];

  // Initialize LUT with rsqrt values
  // rsqrt(x) = 1/sqrt(x), where x = (i + 0.5) / 16 for i in [0, 255]
  // Output scaled: rsqrt * 32768 (Q1.15)
  initial begin
    // Special: index 0 represents very small x, output max
    rsqrt_lut[0] = 16'h7FFF;  // Saturate to max

    // Index 1-15: x in [0.03125, 1.0) - rsqrt > 1.0
    rsqrt_lut[1]  = 16'h7FFF;  // rsqrt(0.09375) ≈ 3.27
    rsqrt_lut[2]  = 16'h7D87;  // rsqrt(0.15625) ≈ 2.53
    rsqrt_lut[3]  = 16'h6ED9;  // rsqrt(0.21875) ≈ 2.14
    rsqrt_lut[4]  = 16'h6324;  // rsqrt(0.28125) ≈ 1.89
    rsqrt_lut[5]  = 16'h59A0;  // rsqrt(0.34375) ≈ 1.71
    rsqrt_lut[6]  = 16'h5168;  // rsqrt(0.40625) ≈ 1.57
    rsqrt_lut[7]  = 16'h4A40;  // rsqrt(0.46875) ≈ 1.46
    rsqrt_lut[8]  = 16'h43F5;  // rsqrt(0.53125) ≈ 1.37
    rsqrt_lut[9]  = 16'h3E5C;  // rsqrt(0.59375) ≈ 1.30
    rsqrt_lut[10] = 16'h3958;  // rsqrt(0.65625) ≈ 1.23
    rsqrt_lut[11] = 16'h34D0;  // rsqrt(0.71875) ≈ 1.18
    rsqrt_lut[12] = 16'h30B7;  // rsqrt(0.78125) ≈ 1.13
    rsqrt_lut[13] = 16'h2D00;  // rsqrt(0.84375) ≈ 1.09
    rsqrt_lut[14] = 16'h29A1;  // rsqrt(0.90625) ≈ 1.05
    rsqrt_lut[15] = 16'h2690;  // rsqrt(0.96875) ≈ 1.02

    // Index 16: x = 1.0, rsqrt = 1.0 = 0x4000 in Q1.15
    rsqrt_lut[16] = 16'h4000;

    // Index 17-255: x in (1.0, 16.0], rsqrt < 1.0
    for (int i = 17; i < LUT_DEPTH; i++) begin
      // x = (i + 0.5) / 16, rsqrt = 1/sqrt(x)
      // Approximate: rsqrt ≈ 16/sqrt(i+0.5) * 2048
      // Use integer approximation to avoid $sqrt
      // rsqrt(i/16) ≈ 4/sqrt(i)
      // For LUT: 32768 / sqrt(i * 4) approximately
      rsqrt_lut[i] = 16'h4000 - ((i - 16) * 16'h0080);  // Linear approx
    end

    // More accurate values for common range [1, 4]
    rsqrt_lut[32]  = 16'h2D41;  // rsqrt(2.0) ≈ 0.707
    rsqrt_lut[48]  = 16'h24F3;  // rsqrt(3.0) ≈ 0.577
    rsqrt_lut[64]  = 16'h2000;  // rsqrt(4.0) = 0.5
    rsqrt_lut[80]  = 16'h1C72;  // rsqrt(5.0) ≈ 0.447
    rsqrt_lut[96]  = 16'h19B1;  // rsqrt(6.0) ≈ 0.408
    rsqrt_lut[112] = 16'h1770;  // rsqrt(7.0) ≈ 0.378
    rsqrt_lut[128] = 16'h15A0;  // rsqrt(8.0) ≈ 0.354
    rsqrt_lut[144] = 16'h1414;  // rsqrt(9.0) = 0.333
    rsqrt_lut[160] = 16'h12BB;  // rsqrt(10) ≈ 0.316
    rsqrt_lut[176] = 16'h118A;  // rsqrt(11) ≈ 0.302
    rsqrt_lut[192] = 16'h1078;  // rsqrt(12) ≈ 0.289
    rsqrt_lut[208] = 16'h0F81;  // rsqrt(13) ≈ 0.277
    rsqrt_lut[224] = 16'h0E9F;  // rsqrt(14) ≈ 0.267
    rsqrt_lut[240] = 16'h0DCF;  // rsqrt(15) ≈ 0.258
  end

  // ============================================================
  // Pipeline Stage 0: Input capture and LUT address
  // ============================================================
  logic                   p0_valid;
  logic [DATA_WIDTH-1:0]  p0_input;
  logic [7:0]             p0_lut_addr;
  logic                   p0_special;

  // Special case detection
  wire input_is_zero = (data_in == '0);
  wire input_is_tiny = (data_in[DATA_WIDTH-1:8] == '0);  // < 1.0

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p0_valid <= 1'b0;
      p0_input <= '0;
      p0_lut_addr <= '0;
      p0_special <= 1'b0;
    end else if (enable) begin
      p0_valid <= data_valid;
      p0_input <= data_in;
      p0_lut_addr <= data_in[DATA_WIDTH-1:8];  // Upper 8 bits for LUT
      p0_special <= ENABLE_SPECIAL_CASES && input_is_zero;
    end
  end

  // ============================================================
  // Pipeline Stage 1: LUT Read
  // ============================================================
  logic                         p1_valid;
  logic [DATA_WIDTH-1:0]        p1_input;
  logic signed [DATA_WIDTH-1:0] p1_estimate;
  logic                         p1_special;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      p1_valid <= 1'b0;
      p1_input <= '0;
      p1_estimate <= '0;
      p1_special <= 1'b0;
    end else if (enable) begin
      p1_valid <= p0_valid;
      p1_input <= p0_input;
      p1_estimate <= rsqrt_lut[p0_lut_addr];
      p1_special <= p0_special;
    end
  end

  // ============================================================
  // Newton-Raphson Iterations
  // ============================================================
  // Formula: x' = x * (3 - y*x²) / 2
  // Where: y = input, x = current estimate
  //
  // In fixed-point:
  //   x_sq = x * x             (Q1.15 * Q1.15 = Q2.30, shift to Q1.15)
  //   y_x_sq = y * x_sq        (Q8.8 * Q1.15 = Q9.23, shift to Q1.15)
  //   three_minus = 3 - y_x_sq (Q2.14)
  //   x_new = x * three_minus / 2

  // Generate Newton-Raphson pipeline stages
  generate
    if (NUM_ITERATIONS > 0) begin : gen_newton

      // Iteration arrays
      logic                         iter_valid [NUM_ITERATIONS+1];
      logic [DATA_WIDTH-1:0]        iter_input [NUM_ITERATIONS+1];
      logic signed [DATA_WIDTH-1:0] iter_x     [NUM_ITERATIONS+1];
      logic                         iter_special [NUM_ITERATIONS+1];

      // Initial values from LUT stage
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          iter_valid[0] <= 1'b0;
          iter_input[0] <= '0;
          iter_x[0] <= '0;
          iter_special[0] <= 1'b0;
        end else if (enable) begin
          iter_valid[0] <= p1_valid;
          iter_input[0] <= p1_input;
          iter_x[0] <= p1_estimate;
          iter_special[0] <= p1_special;
        end
      end

      // Newton iterations
      for (genvar n = 0; n < NUM_ITERATIONS; n++) begin : gen_iter

        // Intermediate calculation registers
        logic signed [31:0] x_sq;        // x² in Q2.30
        logic signed [31:0] y_x_sq;      // y * x² in Q10.22
        logic signed [31:0] three_minus; // 3 - y*x² in Q3.13
        logic signed [31:0] x_times_tm;  // x * (3 - y*x²) in Q4.28
        logic signed [DATA_WIDTH-1:0] x_new;

        // Pipeline stage A: Compute x²
        logic                         pA_valid;
        logic [DATA_WIDTH-1:0]        pA_input;
        logic signed [DATA_WIDTH-1:0] pA_x;
        logic signed [31:0]           pA_x_sq;
        logic                         pA_special;

        always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            pA_valid <= 1'b0;
            pA_input <= '0;
            pA_x <= '0;
            pA_x_sq <= '0;
            pA_special <= 1'b0;
          end else if (enable) begin
            pA_valid <= iter_valid[n];
            pA_input <= iter_input[n];
            pA_x <= iter_x[n];
            // x² = x * x (Q1.15 * Q1.15 = Q2.30)
            pA_x_sq <= iter_x[n] * iter_x[n];
            pA_special <= iter_special[n];
          end
        end

        // Pipeline stage B: Compute y * x² and 3 - y*x²
        logic                         pB_valid;
        logic [DATA_WIDTH-1:0]        pB_input;
        logic signed [DATA_WIDTH-1:0] pB_x;
        logic signed [31:0]           pB_three_minus;
        logic                         pB_special;

        always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            pB_valid <= 1'b0;
            pB_input <= '0;
            pB_x <= '0;
            pB_three_minus <= '0;
            pB_special <= 1'b0;
          end else if (enable) begin
            pB_valid <= pA_valid;
            pB_input <= pA_input;
            pB_x <= pA_x;
            // y_x_sq = y * x² (Q8.8 * Q2.30 >> 15 = Q10.23 >> 15 = Q10.8)
            // Scale properly: input is Q8.8, x_sq is Q2.30
            // y * x_sq = Q8.8 * Q2.30 = Q10.38, shift right 23 to get Q10.15
            y_x_sq = ($signed({1'b0, pA_input}) * pA_x_sq) >>> 23;
            // 3 in Q2.14 = 3 * 16384 = 0xC000
            // But we need matching format, so 3 in Q10.15 = 3 * 32768 = 98304
            pB_three_minus <= 32'sd98304 - y_x_sq;  // 3 - y*x² in ~Q2.15
            pB_special <= pA_special;
          end
        end

        // Pipeline stage C: Compute final x' = x * (3 - y*x²) / 2
        always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            iter_valid[n+1] <= 1'b0;
            iter_input[n+1] <= '0;
            iter_x[n+1] <= '0;
            iter_special[n+1] <= 1'b0;
          end else if (enable) begin
            iter_valid[n+1] <= pB_valid;
            iter_input[n+1] <= pB_input;
            // x_new = x * three_minus / 2
            // x is Q1.15, three_minus is ~Q2.15
            // Product is Q3.30, divide by 2 and shift to get Q1.15
            x_times_tm = pB_x * pB_three_minus;
            iter_x[n+1] <= x_times_tm[30:15];  // Extract Q1.15 result
            iter_special[n+1] <= pB_special;
          end
        end

      end

      // Final output from last iteration
      assign data_out = iter_special[NUM_ITERATIONS] ? 16'h7FFF : iter_x[NUM_ITERATIONS];
      assign data_out_valid = iter_valid[NUM_ITERATIONS];
      assign special_case = iter_special[NUM_ITERATIONS];

    end else begin : gen_no_newton

      // No iterations - just use LUT estimate
      logic                         p2_valid;
      logic signed [DATA_WIDTH-1:0] p2_result;
      logic                         p2_special;

      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          p2_valid <= 1'b0;
          p2_result <= '0;
          p2_special <= 1'b0;
        end else if (enable) begin
          p2_valid <= p1_valid;
          p2_result <= p1_special ? 16'h7FFF : p1_estimate;
          p2_special <= p1_special;
        end
      end

      assign data_out = p2_result;
      assign data_out_valid = p2_valid;
      assign special_case = p2_special;

    end
  endgenerate

  assign data_ready = enable;

  // ============================================================
  // Performance Counters
  // ============================================================
  logic [31:0] ops_reg;
  logic [31:0] iters_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ops_reg <= '0;
      iters_reg <= '0;
    end else if (enable) begin
      if (data_valid) begin
        ops_reg <= ops_reg + 1;
        iters_reg <= iters_reg + NUM_ITERATIONS;
      end
    end
  end

  assign ops_count = ops_reg;
  assign newton_iters = iters_reg;

endmodule


// ============================================================
// Fast RSQRT with Quake-style Magic Number (for comparison)
// ============================================================
// Alternative implementation using bit manipulation trick
// Less accurate but single-cycle latency

module tpu_rsqrt_fast #(
  parameter int DATA_WIDTH = 16
)(
  input  logic                 clk,
  input  logic                 rst_n,
  input  logic                 enable,

  input  logic [DATA_WIDTH-1:0]  data_in,
  input  logic                   data_valid,

  output logic [DATA_WIDTH-1:0]  data_out,
  output logic                   data_out_valid
);

  // Magic constant for 16-bit fixed-point (adapted from 32-bit 0x5F3759DF)
  // For Q8.8 format: magic ≈ 0x5F37 >> shift
  localparam logic [15:0] MAGIC = 16'h5F00;

  logic [DATA_WIDTH-1:0] result_reg;
  logic                  valid_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      result_reg <= '0;
      valid_reg <= 1'b0;
    end else if (enable) begin
      valid_reg <= data_valid;

      if (data_valid) begin
        // Fast inverse square root approximation
        // y = MAGIC - (x >> 1)
        // This gives rough estimate, would need Newton step for accuracy
        result_reg <= MAGIC - (data_in >> 1);
      end
    end
  end

  assign data_out = result_reg;
  assign data_out_valid = valid_reg;

endmodule


// ============================================================
// Parallel RSQRT Unit (for molecular dynamics force calculation)
// ============================================================
// Computes rsqrt for multiple distance² values simultaneously

module tpu_rsqrt_multi #(
  parameter int DATA_WIDTH = 16,
  parameter int NUM_CHANNELS = 8,
  parameter int NUM_ITERATIONS = 1
)(
  input  logic                                         clk,
  input  logic                                         rst_n,
  input  logic                                         enable,

  input  logic [NUM_CHANNELS-1:0][DATA_WIDTH-1:0]      data_in,
  input  logic                                         data_valid,

  output logic signed [NUM_CHANNELS-1:0][DATA_WIDTH-1:0] data_out,
  output logic                                         data_out_valid
);

  // Instantiate multiple RSQRT units
  logic [NUM_CHANNELS-1:0] channel_valid;
  logic [NUM_CHANNELS-1:0] channel_special;

  generate
    for (genvar ch = 0; ch < NUM_CHANNELS; ch++) begin : gen_channels
      tpu_rsqrt_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_ITERATIONS(NUM_ITERATIONS),
        .ENABLE_SPECIAL_CASES(1)
      ) u_rsqrt (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .data_in(data_in[ch]),
        .data_valid(data_valid),
        .data_ready(),
        .data_out(data_out[ch]),
        .data_out_valid(channel_valid[ch]),
        .special_case(channel_special[ch]),
        .ops_count(),
        .newton_iters()
      );
    end
  endgenerate

  // All channels complete together (they're synchronized)
  assign data_out_valid = channel_valid[0];

endmodule
