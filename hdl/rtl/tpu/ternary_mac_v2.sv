// Ternary MAC Unit v2 - Enhanced with Guard Trits and Wide Accumulator
// =====================================================================
// Phase 5 Enhancements:
//   - 5.1: Guard trits (4 extra trits) + saturation logic
//   - 5.3: 81-trit wide accumulator mode for numeric stability
//
// Key Innovation: Ternary weights {-1, 0, +1} eliminate multiplication!
//
// Accumulator Modes:
//   ACC_MODE=0: Standard 32-bit with 4 guard bits (36-bit internal)
//   ACC_MODE=1: Wide 81-bit for long dot products (256-bit internal for binary)
//
// Author: Tritone Project (Phase 5: Compute Enhancements)

module ternary_mac_v2 #(
  parameter int ACT_BITS = 16,           // Activation bits (signed integer)
  parameter int ACC_BITS = 32,           // Standard accumulator bits
  parameter int GUARD_BITS = 4,          // Guard bits for overflow protection
  parameter int ACC_BITS_WIDE = 128,     // Wide accumulator (81 trits ≈ 128 bits)
  parameter bit ENABLE_WIDE_MODE = 1,    // Enable 81-trit accumulator option
  parameter bit ENABLE_SATURATION = 1   // Enable saturation logic
)(
  input  logic                              clk,
  input  logic                              rst_n,
  input  logic                              enable,
  input  logic                              clear,        // Clear accumulator
  input  logic                              acc_mode,     // 0=standard, 1=wide

  // Activation input
  input  logic signed [ACT_BITS-1:0]        activation,

  // Ternary weight (2-bit encoded: 00=-1, 01=0, 10=+1)
  input  logic [1:0]                        weight,

  // Accumulator I/O
  input  logic signed [ACC_BITS-1:0]        acc_in,
  output logic signed [ACC_BITS-1:0]        acc_out,

  // Wide accumulator output (when ACC_MODE=1)
  output logic signed [ACC_BITS_WIDE-1:0]   acc_out_wide,

  // Status signals
  output logic                              zero_skip,
  output logic                              overflow,     // Saturation occurred
  output logic                              underflow     // Negative saturation
);

  // ============================================================
  // Internal accumulator with guard bits
  // ============================================================
  localparam int ACC_INTERNAL = ACC_BITS + GUARD_BITS;  // 36 bits for standard

  // Weight decode
  localparam logic [1:0] WEIGHT_NEG  = 2'b00;
  localparam logic [1:0] WEIGHT_ZERO = 2'b01;
  localparam logic [1:0] WEIGHT_POS  = 2'b10;

  assign zero_skip = (weight == WEIGHT_ZERO);

  // ============================================================
  // Standard Mode (32-bit + 4 guard bits)
  // ============================================================
  logic signed [ACC_INTERNAL-1:0] acc_internal;
  logic signed [ACC_INTERNAL-1:0] product_ext;
  logic signed [ACC_INTERNAL-1:0] sum_internal;

  // Sign-extend activation to internal width and apply weight
  always_comb begin
    case (weight)
      WEIGHT_NEG:  product_ext = -$signed({{(ACC_INTERNAL-ACT_BITS){activation[ACT_BITS-1]}}, activation});
      WEIGHT_ZERO: product_ext = '0;
      WEIGHT_POS:  product_ext = $signed({{(ACC_INTERNAL-ACT_BITS){activation[ACT_BITS-1]}}, activation});
      default:     product_ext = '0;
    endcase
  end

  // Accumulation with overflow detection
  assign sum_internal = acc_internal + product_ext;

  // Saturation bounds for standard mode
  localparam logic signed [ACC_INTERNAL-1:0] SAT_MAX = {1'b0, {(ACC_INTERNAL-1){1'b1}}};
  localparam logic signed [ACC_INTERNAL-1:0] SAT_MIN = {1'b1, {(ACC_INTERNAL-1){1'b0}}};

  // Overflow detection (check if result exceeds ACC_BITS range)
  logic overflow_detect, underflow_detect;
  logic signed [ACC_BITS-1:0] acc_bits_max;
  logic signed [ACC_BITS-1:0] acc_bits_min;

  assign acc_bits_max = {1'b0, {(ACC_BITS-1){1'b1}}};  // Max positive
  assign acc_bits_min = {1'b1, {(ACC_BITS-1){1'b0}}};  // Max negative

  assign overflow_detect = (sum_internal > $signed({{GUARD_BITS{1'b0}}, acc_bits_max}));
  assign underflow_detect = (sum_internal < $signed({{GUARD_BITS{1'b1}}, acc_bits_min}));

  // Standard accumulator register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      acc_internal <= '0;
      overflow <= 1'b0;
      underflow <= 1'b0;
    end else if (clear) begin
      acc_internal <= '0;
      overflow <= 1'b0;
      underflow <= 1'b0;
    end else if (enable && !acc_mode) begin
      if (ENABLE_SATURATION) begin
        // Saturating accumulation
        if (overflow_detect) begin
          acc_internal <= {{GUARD_BITS{1'b0}}, acc_bits_max};
          overflow <= 1'b1;
        end else if (underflow_detect) begin
          acc_internal <= {{GUARD_BITS{1'b1}}, acc_bits_min};
          underflow <= 1'b1;
        end else begin
          acc_internal <= sum_internal;
        end
      end else begin
        // Wrapping accumulation (no saturation)
        acc_internal <= sum_internal;
      end
    end
  end

  // Output truncation (drop guard bits)
  assign acc_out = acc_internal[ACC_BITS-1:0];

  // ============================================================
  // Wide Mode (81-trit / 128-bit accumulator)
  // ============================================================
  generate
    if (ENABLE_WIDE_MODE) begin : gen_wide_mode
      logic signed [ACC_BITS_WIDE-1:0] acc_wide;
      logic signed [ACC_BITS_WIDE-1:0] product_wide;
      logic signed [ACC_BITS_WIDE-1:0] sum_wide;

      // Sign-extend to wide width
      always_comb begin
        case (weight)
          WEIGHT_NEG:  product_wide = -$signed({{(ACC_BITS_WIDE-ACT_BITS){activation[ACT_BITS-1]}}, activation});
          WEIGHT_ZERO: product_wide = '0;
          WEIGHT_POS:  product_wide = $signed({{(ACC_BITS_WIDE-ACT_BITS){activation[ACT_BITS-1]}}, activation});
          default:     product_wide = '0;
        endcase
      end

      assign sum_wide = acc_wide + product_wide;

      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          acc_wide <= '0;
        end else if (clear) begin
          acc_wide <= '0;
        end else if (enable && acc_mode) begin
          acc_wide <= sum_wide;
        end
      end

      assign acc_out_wide = acc_wide;

    end else begin : gen_no_wide
      assign acc_out_wide = '0;
    end
  endgenerate

endmodule


// ============================================================
// Ternary MAC v2 Integer-Only (for 64×64 array - simplified)
// ============================================================
// Optimized version for systolic array PE usage
// Uses only integer arithmetic (no balanced ternary types)

module ternary_mac_v2_int #(
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32,
  parameter int GUARD_BITS = 4,
  parameter bit ENABLE_SATURATION = 1
)(
  input  logic                              clk,
  input  logic                              rst_n,
  input  logic                              enable,
  input  logic                              clear,

  input  logic signed [ACT_BITS-1:0]        activation,
  input  logic [1:0]                        weight,

  input  logic signed [ACC_BITS-1:0]        psum_in,
  output logic signed [ACC_BITS-1:0]        psum_out,

  output logic                              zero_skip,
  output logic                              saturated
);

  localparam int ACC_INTERNAL = ACC_BITS + GUARD_BITS;

  // Weight decode
  assign zero_skip = (weight == 2'b01);

  // Product computation (no multiply - just sign select)
  logic signed [ACC_INTERNAL-1:0] product;
  always_comb begin
    case (weight)
      2'b00:   product = -$signed({{(ACC_INTERNAL-ACT_BITS){activation[ACT_BITS-1]}}, activation});
      2'b01:   product = '0;
      2'b10:   product = $signed({{(ACC_INTERNAL-ACT_BITS){activation[ACT_BITS-1]}}, activation});
      default: product = '0;
    endcase
  end

  // Extended partial sum
  logic signed [ACC_INTERNAL-1:0] psum_ext;
  assign psum_ext = $signed({{GUARD_BITS{psum_in[ACC_BITS-1]}}, psum_in});

  // Accumulation
  logic signed [ACC_INTERNAL-1:0] sum_internal;
  assign sum_internal = psum_ext + product;

  // Saturation bounds
  localparam logic signed [ACC_BITS-1:0] SAT_MAX = {1'b0, {(ACC_BITS-1){1'b1}}};
  localparam logic signed [ACC_BITS-1:0] SAT_MIN = {1'b1, {(ACC_BITS-1){1'b0}}};

  // Registered output with saturation
  logic saturated_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      psum_out <= '0;
      saturated_reg <= 1'b0;
    end else if (clear) begin
      psum_out <= '0;
      saturated_reg <= 1'b0;
    end else if (enable) begin
      if (ENABLE_SATURATION) begin
        // Check overflow (positive)
        if (sum_internal > $signed({{GUARD_BITS{1'b0}}, SAT_MAX})) begin
          psum_out <= SAT_MAX;
          saturated_reg <= 1'b1;
        end
        // Check underflow (negative)
        else if (sum_internal < $signed({{GUARD_BITS{1'b1}}, SAT_MIN})) begin
          psum_out <= SAT_MIN;
          saturated_reg <= 1'b1;
        end
        else begin
          psum_out <= sum_internal[ACC_BITS-1:0];
        end
      end else begin
        psum_out <= sum_internal[ACC_BITS-1:0];
      end
    end
  end

  assign saturated = saturated_reg;

endmodule
