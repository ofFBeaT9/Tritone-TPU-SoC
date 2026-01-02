// TPU Weight Packer/Unpacker Module
// ==================================
// Phase 5.2: Pack 5 ternary weights into 8 bits
//
// Ternary values: {-1, 0, +1} = 3 states
// 5 values: 3^5 = 243 states < 256 = 2^8
//
// Bandwidth reduction: 5 weights × 2 bits = 10 bits → 8 bits = 20% savings
//
// Encoding:
//   packed_value = sum(weight[i] * 3^i) + 121  (offset to make positive)
//   where weight[i] ∈ {-1, 0, +1}
//
// Examples:
//   {0,0,0,0,0}     → 121 (0x79)
//   {1,1,1,1,1}     → 242 (0xF2)
//   {-1,-1,-1,-1,-1}→ 0   (0x00)
//
// Author: Tritone Project (Phase 5.2: Weight Packing)

module tpu_weight_packer #(
  parameter int NUM_WEIGHTS = 5     // Weights per packed byte
)(
  // Input: 5 ternary weights (2-bit each: 00=-1, 01=0, 10=+1)
  input  logic [NUM_WEIGHTS-1:0][1:0]   weights_in,

  // Output: packed 8-bit value
  output logic [7:0]                     packed_out,

  // Validity
  input  logic                           valid_in,
  output logic                           valid_out
);

  // Powers of 3 lookup: 3^0=1, 3^1=3, 3^2=9, 3^3=27, 3^4=81
  localparam int POW3 [5] = '{1, 3, 9, 27, 81};

  // Offset to make all values positive: sum of max negative = -1*(1+3+9+27+81) = -121
  localparam int OFFSET = 121;

  // Convert 2-bit weight encoding to signed value
  function automatic int weight_to_signed(logic [1:0] w);
    case (w)
      2'b00:   return -1;
      2'b01:   return 0;
      2'b10:   return 1;
      default: return 0;
    endcase
  endfunction

  // Packing logic
  logic [7:0] pack_sum;
  always_comb begin
    pack_sum = OFFSET[7:0];
    for (int i = 0; i < NUM_WEIGHTS; i++) begin
      pack_sum = pack_sum + 8'(weight_to_signed(weights_in[i]) * POW3[i]);
    end
  end
  assign packed_out = pack_sum;

  assign valid_out = valid_in;

endmodule


// ============================================================
// Weight Unpacker: 8-bit packed → 5 ternary weights
// ============================================================

module tpu_weight_unpacker #(
  parameter int NUM_WEIGHTS = 5
)(
  // Input: packed 8-bit value
  input  logic [7:0]                     packed_in,

  // Output: 5 ternary weights (2-bit each)
  output logic [NUM_WEIGHTS-1:0][1:0]    weights_out,

  // Validity
  input  logic                           valid_in,
  output logic                           valid_out,
  output logic                           error        // Invalid packed value (>242)
);

  // Offset used in packing
  localparam int OFFSET = 121;

  // Convert signed value to 2-bit weight encoding
  function automatic logic [1:0] signed_to_weight(int s);
    case (s)
      -1:      return 2'b00;
      0:       return 2'b01;
      1:       return 2'b10;
      default: return 2'b01;  // Default to 0
    endcase
  endfunction

  // Unpacking logic - use LUT-based approach for synthesis efficiency
  // Pre-computed decode table (generated at elaboration)

  // Simple decode using modular arithmetic
  logic signed [9:0] remaining [NUM_WEIGHTS+1];  // Intermediate values
  logic signed [2:0] digit [NUM_WEIGHTS];        // Extracted digits

  // Check for invalid packed value
  assign error = (packed_in > 8'd242);

  // Initial value
  assign remaining[0] = $signed({2'b00, packed_in}) - 10'sd121;

  // Decode each weight position
  genvar gi;
  generate
    for (gi = 0; gi < NUM_WEIGHTS; gi++) begin : gen_decode
      // Compute digit and remaining for next iteration
      always_comb begin
        automatic int r = remaining[gi];
        automatic int d = r - 3 * (r / 3);  // r mod 3

        if (d == 2) begin
          digit[gi] = -3'sd1;
          remaining[gi+1] = (r + 1) / 3;
        end else if (d == -2) begin
          digit[gi] = 3'sd1;
          remaining[gi+1] = (r - 1) / 3;
        end else begin
          digit[gi] = 3'(d);
          remaining[gi+1] = r / 3;
        end
      end

      // Convert digit to weight encoding
      always_comb begin
        case (digit[gi])
          -3'sd1:  weights_out[gi] = 2'b00;
          3'sd0:   weights_out[gi] = 2'b01;
          3'sd1:   weights_out[gi] = 2'b10;
          default: weights_out[gi] = 2'b01;
        endcase
      end
    end
  endgenerate

  assign valid_out = valid_in && !error;

endmodule


// ============================================================
// Weight Unpacker Pipeline (for high throughput)
// ============================================================
// Registered version with LUT-based unpacking for timing

module tpu_weight_unpacker_lut #(
  parameter int NUM_WEIGHTS = 5
)(
  input  logic                           clk,
  input  logic                           rst_n,

  input  logic [7:0]                     packed_in,
  input  logic                           valid_in,

  output logic [NUM_WEIGHTS-1:0][1:0]    weights_out,
  output logic                           valid_out,
  output logic                           error
);

  // LUT for unpacking - precomputed at synthesis time
  // Each entry: 10 bits = 5 weights × 2 bits each
  logic [9:0] unpack_lut [243];

  // Helper function to compute LUT entry
  function automatic logic [9:0] compute_lut_entry(int p);
    automatic int remaining = p - 121;
    automatic logic [9:0] entry = '0;
    automatic int digit;

    for (int i = 0; i < 5; i++) begin
      digit = remaining - 3 * (remaining / 3);
      if (digit == 2) begin
        digit = -1;
        remaining = remaining + 1;
      end else if (digit == -2) begin
        digit = 1;
        remaining = remaining - 1;
      end

      case (digit)
        -1: entry[i*2 +: 2] = 2'b00;
        0:  entry[i*2 +: 2] = 2'b01;
        1:  entry[i*2 +: 2] = 2'b10;
        default: entry[i*2 +: 2] = 2'b01;
      endcase

      remaining = remaining / 3;
    end

    return entry;
  endfunction

  // Generate LUT values at synthesis
  initial begin
    for (int p = 0; p < 243; p++) begin
      unpack_lut[p] = compute_lut_entry(p);
    end
  end

  // Registered lookup
  logic [9:0] lut_result;
  logic valid_d, error_d;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      lut_result <= '0;
      valid_d <= 1'b0;
      error_d <= 1'b0;
    end else begin
      valid_d <= valid_in;
      error_d <= (packed_in > 8'd242);

      if (packed_in <= 8'd242) begin
        lut_result <= unpack_lut[packed_in];
      end else begin
        lut_result <= 10'b01_01_01_01_01;  // All zeros on error
      end
    end
  end

  // Output assignment
  genvar i;
  generate
    for (i = 0; i < NUM_WEIGHTS; i++) begin : gen_out
      assign weights_out[i] = lut_result[i*2 +: 2];
    end
  endgenerate

  assign valid_out = valid_d && !error_d;
  assign error = error_d;

endmodule


// ============================================================
// Weight Buffer Interface with Packing Support
// ============================================================
// Wraps the weight buffer to support both packed and unpacked formats

module tpu_weight_buffer_packed #(
  parameter int ARRAY_SIZE = 64,
  parameter int DEPTH = 4096,
  parameter int ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic                              clk,
  input  logic                              rst_n,

  // Configuration
  input  logic                              packed_mode,     // 1=packed, 0=unpacked

  // Write interface (from DMA)
  input  logic                              wr_en,
  input  logic [ADDR_WIDTH-1:0]             wr_addr,
  input  logic [127:0]                      wr_data,         // 128 bits per write

  // Read interface (to systolic array)
  input  logic                              rd_en,
  input  logic [ADDR_WIDTH-1:0]             rd_addr,
  output logic [ARRAY_SIZE-1:0][1:0]        rd_weights,      // Unpacked weights
  output logic                              rd_valid
);

  // Internal storage
  // Unpacked: 64 weights × 2 bits = 128 bits per row
  // Packed: 64 weights / 5 × 8 bits = 13 bytes = 104 bits per row (+ padding)

  logic [127:0] weight_mem [DEPTH];

  // Write logic
  always_ff @(posedge clk) begin
    if (wr_en) begin
      weight_mem[wr_addr] <= wr_data;
    end
  end

  // Read with optional unpacking
  logic [127:0] raw_data;
  logic rd_valid_d1;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      raw_data <= '0;
      rd_valid_d1 <= 1'b0;
    end else begin
      rd_valid_d1 <= rd_en;
      if (rd_en) begin
        raw_data <= weight_mem[rd_addr];
      end
    end
  end

  // Unpacking logic
  // 13 packed bytes contain 65 weights, we use 64
  // Byte 0: weights 0-4, Byte 1: weights 5-9, etc.

  logic [4:0][1:0] unpacked_groups [13];  // 13 groups of 5 weights each

  genvar g;
  generate
    for (g = 0; g < 13; g++) begin : gen_unpack_groups
      tpu_weight_unpacker u_unpack (
        .packed_in(raw_data[g*8 +: 8]),
        .weights_out(unpacked_groups[g]),
        .valid_in(1'b1),
        .valid_out(),
        .error()
      );
    end
  endgenerate

  // Output selection with pre-computed indices
  genvar w;
  generate
    for (w = 0; w < ARRAY_SIZE; w++) begin : gen_output
      localparam int GROUP_IDX = w / 5;
      localparam int WITHIN_GROUP = w % 5;

      always_comb begin
        if (packed_mode) begin
          if (GROUP_IDX < 13) begin
            rd_weights[w] = unpacked_groups[GROUP_IDX][WITHIN_GROUP];
          end else begin
            rd_weights[w] = 2'b01;  // Zero for overflow
          end
        end else begin
          rd_weights[w] = raw_data[w*2 +: 2];
        end
      end
    end
  endgenerate

  assign rd_valid = rd_valid_d1;

endmodule
