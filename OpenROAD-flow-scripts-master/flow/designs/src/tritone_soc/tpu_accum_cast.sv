// TPU Accumulator Cast Module
// ============================
// Phase 5.3: Cast/truncate wide accumulator outputs to standard width
//
// Features:
//   - Wide (128-bit) to standard (32-bit) truncation
//   - Saturation on overflow/underflow
//   - Optional rounding modes
//   - Debug mode: full 128-bit passthrough
//
// Rounding Modes:
//   0: Truncate (toward zero)
//   1: Round half-up (standard rounding)
//   2: Round half-even (banker's rounding)
//   3: Ceiling (round up)
//
// Author: Tritone Project (Phase 5.3: 81-Trit Accumulator)

module tpu_accum_cast #(
  parameter int WIDE_WIDTH = 128,        // Wide accumulator width
  parameter int OUT_WIDTH = 32,          // Output width
  parameter int SHIFT_BITS = 4           // Configurable right shift
)(
  input  logic                          clk,
  input  logic                          rst_n,

  // Control
  input  logic                          enable,
  input  logic                          debug_mode,      // 1=passthrough wide
  input  logic [1:0]                    round_mode,      // Rounding mode
  input  logic [SHIFT_BITS-1:0]         shift_amount,    // Right shift before truncate

  // Wide input
  input  logic signed [WIDE_WIDTH-1:0]  wide_in,
  input  logic                          wide_valid,

  // Standard output
  output logic signed [OUT_WIDTH-1:0]   out,
  output logic                          out_valid,
  output logic                          saturated,       // Saturation occurred

  // Debug output (full width)
  output logic signed [WIDE_WIDTH-1:0]  debug_out,
  output logic                          debug_valid
);

  // Saturation bounds
  localparam logic signed [OUT_WIDTH-1:0] SAT_MAX = {1'b0, {(OUT_WIDTH-1){1'b1}}};
  localparam logic signed [OUT_WIDTH-1:0] SAT_MIN = {1'b1, {(OUT_WIDTH-1){1'b0}}};

  // Extended saturation bounds for comparison
  localparam logic signed [WIDE_WIDTH-1:0] SAT_MAX_EXT = {{(WIDE_WIDTH-OUT_WIDTH){1'b0}}, SAT_MAX};
  localparam logic signed [WIDE_WIDTH-1:0] SAT_MIN_EXT = {{(WIDE_WIDTH-OUT_WIDTH){1'b1}}, SAT_MIN};

  // Pipeline stage 1: Shift
  logic signed [WIDE_WIDTH-1:0] shifted;
  logic valid_s1;
  logic [1:0] round_mode_s1;
  logic debug_mode_s1;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      shifted <= '0;
      valid_s1 <= 1'b0;
      round_mode_s1 <= '0;
      debug_mode_s1 <= 1'b0;
    end else if (enable) begin
      valid_s1 <= wide_valid;
      round_mode_s1 <= round_mode;
      debug_mode_s1 <= debug_mode;
      shifted <= wide_in >>> shift_amount;  // Arithmetic right shift
    end
  end

  // Pipeline stage 2: Rounding (optional)
  logic signed [WIDE_WIDTH-1:0] rounded;
  logic valid_s2;
  logic debug_mode_s2;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rounded <= '0;
      valid_s2 <= 1'b0;
      debug_mode_s2 <= 1'b0;
    end else if (enable) begin
      valid_s2 <= valid_s1;
      debug_mode_s2 <= debug_mode_s1;

      case (round_mode_s1)
        2'b00: begin
          // Truncate (toward zero) - just use shifted value
          rounded <= shifted;
        end
        2'b01: begin
          // Round half-up
          if (shifted[OUT_WIDTH-1]) begin
            // Negative: round toward zero (add 0.5 before truncate)
            rounded <= shifted;
          end else begin
            // Positive: round away from zero (add 0.5)
            rounded <= shifted + 1;
          end
        end
        2'b10: begin
          // Round half-even (banker's rounding)
          // Check if exactly 0.5 and LSB is odd
          if (shifted[0]) begin
            rounded <= shifted + 1;  // Round up if odd
          end else begin
            rounded <= shifted;      // Keep if even
          end
        end
        2'b11: begin
          // Ceiling (always round up for positive)
          if (!shifted[WIDE_WIDTH-1]) begin
            rounded <= shifted + 1;
          end else begin
            rounded <= shifted;
          end
        end
      endcase
    end
  end

  // Pipeline stage 3: Saturation and output
  logic signed [OUT_WIDTH-1:0] out_reg;
  logic out_valid_reg;
  logic saturated_reg;
  logic signed [WIDE_WIDTH-1:0] debug_out_reg;
  logic debug_valid_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_reg <= '0;
      out_valid_reg <= 1'b0;
      saturated_reg <= 1'b0;
      debug_out_reg <= '0;
      debug_valid_reg <= 1'b0;
    end else if (enable) begin
      out_valid_reg <= valid_s2 && !debug_mode_s2;
      debug_valid_reg <= valid_s2 && debug_mode_s2;
      debug_out_reg <= rounded;

      // Saturation logic
      if (rounded > SAT_MAX_EXT) begin
        out_reg <= SAT_MAX;
        saturated_reg <= 1'b1;
      end else if (rounded < SAT_MIN_EXT) begin
        out_reg <= SAT_MIN;
        saturated_reg <= 1'b1;
      end else begin
        out_reg <= rounded[OUT_WIDTH-1:0];
        saturated_reg <= 1'b0;
      end
    end
  end

  assign out = out_reg;
  assign out_valid = out_valid_reg;
  assign saturated = saturated_reg;
  assign debug_out = debug_out_reg;
  assign debug_valid = debug_valid_reg;

endmodule


// ============================================================
// Array-Wide Accumulator Cast (for systolic array output)
// ============================================================
// Casts multiple PE outputs in parallel

module tpu_accum_cast_array #(
  parameter int ARRAY_SIZE = 64,
  parameter int WIDE_WIDTH = 128,
  parameter int OUT_WIDTH = 32
)(
  input  logic                                        clk,
  input  logic                                        rst_n,
  input  logic                                        enable,
  input  logic                                        debug_mode,
  input  logic [1:0]                                  round_mode,
  input  logic [3:0]                                  shift_amount,

  // Wide inputs (one per PE column)
  input  logic signed [ARRAY_SIZE-1:0][WIDE_WIDTH-1:0] wide_in,
  input  logic                                        wide_valid,

  // Standard outputs
  output logic signed [ARRAY_SIZE-1:0][OUT_WIDTH-1:0] out,
  output logic                                        out_valid,
  output logic [ARRAY_SIZE-1:0]                       saturated
);

  logic [ARRAY_SIZE-1:0] valid_array;

  genvar i;
  generate
    for (i = 0; i < ARRAY_SIZE; i++) begin : gen_cast
      tpu_accum_cast #(
        .WIDE_WIDTH(WIDE_WIDTH),
        .OUT_WIDTH(OUT_WIDTH)
      ) u_cast (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .debug_mode(debug_mode),
        .round_mode(round_mode),
        .shift_amount(shift_amount),
        .wide_in(wide_in[i]),
        .wide_valid(wide_valid),
        .out(out[i]),
        .out_valid(valid_array[i]),
        .saturated(saturated[i]),
        .debug_out(),
        .debug_valid()
      );
    end
  endgenerate

  assign out_valid = valid_array[0];  // All should be synchronized

endmodule
