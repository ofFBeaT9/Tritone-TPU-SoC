// Ternary Systolic Array Controller (v2.1 - 2 GHz Pipeline Support)
// ================================================================
// FSM controller for weight-stationary systolic array.
//
// Version 2.1 Changes:
//   - Added USE_2GHZ_PIPELINE parameter for 2-stage pipelined MACs
//   - Extended drain phase: N cycles (1 GHz) or 2N cycles (2 GHz)
//   - Pipeline adds ARRAY_SIZE extra cycles for results to propagate
//
// Version 2 Changes:
//   - Added swap_weight_banks and swap_act_banks output signals
//   - Swap signals pulse on tile completion (S_DRAIN -> next tile)
//   - Enables double-buffering with banked memory
//
// Orchestrates:
//   1. Weight loading phase (N cycles)
//   2. Computation phase with staggered activation input (2N-1 cycles)
//   3. Result drain phase (N cycles @ 1 GHz, 2N cycles @ 2 GHz)
//   4. Bank swap on tile completion
//
// Author: Tritone Project (v2.1 - Phase 9 2 GHz Enhancement)

module ternary_systolic_controller_v2 #(
  parameter int ARRAY_SIZE = 8,
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32,
  parameter int WEIGHT_ADDR_WIDTH = 12,
  parameter int ACT_ADDR_WIDTH = 12,
  parameter int OUT_ADDR_WIDTH = 12,
  parameter bit USE_2GHZ_PIPELINE = 1'b0   // Enable 2 GHz pipelined mode
)(
  input  logic                              clk,
  input  logic                              rst_n,

  // Control interface
  input  logic                              start,           // Start computation
  input  logic [15:0]                       layer_rows,      // M dimension
  input  logic [15:0]                       layer_cols,      // N dimension
  input  logic [15:0]                       layer_k,         // K dimension
  output logic                              done,            // Computation complete
  output logic                              busy,            // Controller busy

  // Bank swap signals (NEW in v2)
  output logic                              swap_weight_banks,  // Pulse to swap weight banks
  output logic                              swap_act_banks,     // Pulse to swap activation banks

  // Weight buffer interface
  output logic                              wgt_rd_en,
  output logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_rd_addr,
  input  logic [ARRAY_SIZE-1:0][1:0]        wgt_rd_data,

  // Activation buffer interface
  output logic                              act_rd_en,
  output logic [ACT_ADDR_WIDTH-1:0]         act_rd_addr,
  input  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_rd_data,

  // Output buffer interface
  output logic                              out_wr_en,
  output logic [OUT_ADDR_WIDTH-1:0]         out_wr_addr,
  output logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_wr_data,

  // Systolic array interface
  output logic                              array_enable,
  output logic                              array_weight_load,
  output logic [$clog2(ARRAY_SIZE)-1:0]     array_weight_row,
  output logic [ARRAY_SIZE-1:0][1:0]        array_weights,
  output logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] array_act_in,
  output logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_psum_in,
  input  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_psum_out
);

  // ============================================================
  // FSM States
  // ============================================================
  typedef enum logic [2:0] {
    S_IDLE,
    S_LOAD_WEIGHTS,
    S_COMPUTE,
    S_DRAIN,
    S_DONE
  } state_t;

  state_t state, next_state;

  // ============================================================
  // Counters and Registers
  // ============================================================

  // Tile counters (for matrices larger than array)
  logic [15:0] tile_m;    // Current M tile
  logic [15:0] tile_n;    // Current N tile
  logic [15:0] tile_k;    // Current K tile

  // Phase counters
  logic [$clog2(ARRAY_SIZE):0] weight_load_cnt;
  logic [15:0] compute_cycle;
  logic [$clog2(ARRAY_SIZE)+1:0] drain_cnt;  // Extra bit for 2 GHz extended drain

  // Drain cycle limit: N-1 for 1 GHz, 2N-1 for 2 GHz
  localparam int DRAIN_CYCLES_1GHZ = ARRAY_SIZE - 1;
  localparam int DRAIN_CYCLES_2GHZ = 2 * ARRAY_SIZE - 1;
  wire [$clog2(ARRAY_SIZE)+1:0] drain_limit = USE_2GHZ_PIPELINE ? DRAIN_CYCLES_2GHZ : DRAIN_CYCLES_1GHZ;

  // Saved configuration
  logic [15:0] cfg_rows, cfg_cols, cfg_k;

  // Bank swap registers (NEW in v2)
  logic swap_weight_banks_reg;
  logic swap_act_banks_reg;

  // ============================================================
  // FSM State Register
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= S_IDLE;
    end else begin
      state <= next_state;
    end
  end

  // ============================================================
  // FSM Next State Logic
  // ============================================================
  always_comb begin
    next_state = state;

    case (state)
      S_IDLE: begin
        if (start) begin
          next_state = S_LOAD_WEIGHTS;
        end
      end

      S_LOAD_WEIGHTS: begin
        if (weight_load_cnt == ARRAY_SIZE - 1) begin
          next_state = S_COMPUTE;
        end
      end

      S_COMPUTE: begin
        if (compute_cycle >= (2 * ARRAY_SIZE - 1)) begin
          next_state = S_DRAIN;
        end
      end

      S_DRAIN: begin
        // Use drain_limit for pipeline-aware transition
        if (drain_cnt >= drain_limit) begin
          if (tile_n + ARRAY_SIZE < cfg_cols) begin
            next_state = S_LOAD_WEIGHTS;
          end else if (tile_m + ARRAY_SIZE < cfg_rows) begin
            next_state = S_LOAD_WEIGHTS;
          end else begin
            next_state = S_DONE;
          end
        end
      end

      S_DONE: begin
        next_state = S_IDLE;
      end

      default: next_state = S_IDLE;
    endcase
  end

  // ============================================================
  // Control Signal Generation (including bank swap)
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weight_load_cnt <= '0;
      compute_cycle <= '0;
      drain_cnt <= '0;
      tile_m <= '0;
      tile_n <= '0;
      tile_k <= '0;
      cfg_rows <= '0;
      cfg_cols <= '0;
      cfg_k <= '0;
      done <= 1'b0;
      busy <= 1'b0;
      swap_weight_banks_reg <= 1'b0;
      swap_act_banks_reg <= 1'b0;
    end else begin
      // Default: clear swap signals (they are pulses)
      swap_weight_banks_reg <= 1'b0;
      swap_act_banks_reg <= 1'b0;

      case (state)
        S_IDLE: begin
          done <= 1'b0;
          if (start) begin
            cfg_rows <= layer_rows;
            cfg_cols <= layer_cols;
            cfg_k <= layer_k;
            tile_m <= '0;
            tile_n <= '0;
            tile_k <= '0;
            weight_load_cnt <= '0;
            busy <= 1'b1;
          end else begin
            busy <= 1'b0;
          end
        end

        S_LOAD_WEIGHTS: begin
          weight_load_cnt <= weight_load_cnt + 1;
          if (weight_load_cnt == ARRAY_SIZE - 1) begin
            compute_cycle <= '0;
          end
        end

        S_COMPUTE: begin
          compute_cycle <= compute_cycle + 1;
          if (compute_cycle >= (2 * ARRAY_SIZE - 1)) begin
            drain_cnt <= '0;
          end
        end

        S_DRAIN: begin
          drain_cnt <= drain_cnt + 1;
          // Use drain_limit for pipeline-aware completion
          if (drain_cnt >= drain_limit) begin
            // TILE COMPLETION - Generate bank swap pulses (v2)
            swap_weight_banks_reg <= 1'b1;
            swap_act_banks_reg <= 1'b1;

            // Advance to next tile
            if (tile_n + ARRAY_SIZE < cfg_cols) begin
              tile_n <= tile_n + ARRAY_SIZE;
              weight_load_cnt <= '0;
            end else if (tile_m + ARRAY_SIZE < cfg_rows) begin
              tile_m <= tile_m + ARRAY_SIZE;
              tile_n <= '0;
              weight_load_cnt <= '0;
            end
          end
        end

        S_DONE: begin
          done <= 1'b1;
          busy <= 1'b0;
        end

        default: ;
      endcase
    end
  end

  // Bank swap output signals (registered for clean timing)
  assign swap_weight_banks = swap_weight_banks_reg;
  assign swap_act_banks = swap_act_banks_reg;

  // ============================================================
  // Memory Address Generation
  // ============================================================
  always_comb begin
    wgt_rd_en = (state == S_LOAD_WEIGHTS);
    wgt_rd_addr = tile_n * cfg_k + weight_load_cnt * ARRAY_SIZE;
  end

  always_comb begin
    act_rd_en = (state == S_COMPUTE);
    act_rd_addr = tile_m * cfg_k + compute_cycle;
  end

  always_comb begin
    out_wr_en = (state == S_DRAIN);
    out_wr_addr = (tile_m + drain_cnt) * cfg_cols + tile_n;
  end

  // ============================================================
  // Array Interface Signals
  // ============================================================
  always_comb begin
    array_enable = (state == S_COMPUTE) || (state == S_DRAIN);
    array_weight_load = (state == S_LOAD_WEIGHTS);
    array_weight_row = weight_load_cnt[$clog2(ARRAY_SIZE)-1:0];
    array_weights = wgt_rd_data;

    // Stagger activation input for diagonal wavefront
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      if (state == S_COMPUTE && compute_cycle >= i && compute_cycle < cfg_k + i) begin
        array_act_in[i] = act_rd_data[i];
      end else begin
        array_act_in[i] = '0;
      end
    end

    // Initialize partial sums to zero
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      array_psum_in[i] = '0;
    end
  end

  // Output data from array
  assign out_wr_data = array_psum_out;

endmodule
