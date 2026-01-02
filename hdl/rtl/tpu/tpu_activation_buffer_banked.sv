// TPU Activation Buffer with 8-Bank Architecture
// ================================================
// High-bandwidth activation storage with 8 independent banks for parallel access.
// Column-major banking optimized for systolic array activation flow.
//
// Features:
//   - 8 independent banks for conflict-free parallel access
//   - 16 total banks (8 active + 8 shadow) for compute/load overlap
//   - Column-major banking: feeds systolic array columns in parallel
//   - Streaming interface for continuous systolic array feeding
//   - Bank conflict detection output
//
// Memory Organization:
//   - Each bank: DEPTH/8 rows, each row = ARRAY_SIZE activations
//   - Column-major: bank[i] feeds column i of systolic array
//
// Author: Tritone Project (Phase 1.3 Upgrade)

module tpu_activation_buffer_banked #(
  parameter int ARRAY_SIZE = 8,           // Systolic array dimension
  parameter int ACT_BITS = 16,            // Bits per activation
  parameter int MAX_K = 256,              // Maximum K dimension
  parameter int NUM_BANKS = 8,            // Number of parallel banks
  parameter int ADDR_WIDTH = 16           // Address width for external interface
)(
  input  logic                                     clk,
  input  logic                                     rst_n,

  // Control
  input  logic                                     swap_banks,     // Swap active/shadow banks (pulse)

  // Multi-port Write Interface (for DMA/CPU loading)
  input  logic [NUM_BANKS-1:0]                     wr_en,          // Per-bank write enable
  input  logic [NUM_BANKS-1:0][ADDR_WIDTH-1:0]     wr_addr,        // Per-bank write address
  input  logic [NUM_BANKS-1:0][ACT_BITS-1:0]       wr_data,        // Per-bank write data (single activation)

  // Unified Write Interface (for sequential row writes)
  input  logic                                     unified_wr_en,
  input  logic [ADDR_WIDTH-1:0]                    unified_wr_addr,
  input  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      unified_wr_data, // Full row of activations

  // Streaming Read Interface (for systolic array)
  input  logic                                     stream_start,   // Start streaming
  input  logic [$clog2(MAX_K)-1:0]                 stream_count,   // Number of vectors to stream
  output logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      stream_data,    // Full row output
  output logic                                     stream_valid,
  output logic                                     stream_done,

  // Multi-port Read Interface (for parallel column access)
  input  logic [NUM_BANKS-1:0]                     rd_en,          // Per-bank read enable
  input  logic [NUM_BANKS-1:0][$clog2(MAX_K)-1:0]  rd_addr,        // Per-bank read address
  output logic [NUM_BANKS-1:0][ACT_BITS-1:0]       rd_data,        // Per-bank read data
  output logic [NUM_BANKS-1:0]                     rd_valid,       // Per-bank read valid

  // Bank Conflict Detection
  output logic                                     conflict_detected,
  output logic [$clog2(NUM_BANKS)-1:0]             conflict_bank,
  output logic [31:0]                              conflict_count
);

  // ============================================================
  // Parameters and Types
  // ============================================================
  localparam int BANK_DEPTH = MAX_K;  // Each bank stores full K dimension
  localparam int BANK_ADDR_BITS = $clog2(BANK_DEPTH);
  localparam int BANK_SEL_BITS = $clog2(NUM_BANKS);

  // ============================================================
  // Memory Arrays (16 Banks: 8 Active + 8 Shadow)
  // ============================================================
  // Column-major: bank[i] stores column i of each activation row
  logic signed [ACT_BITS-1:0] bank_set0 [NUM_BANKS][BANK_DEPTH];
  logic signed [ACT_BITS-1:0] bank_set1 [NUM_BANKS][BANK_DEPTH];

  // Active set tracking
  logic active_set;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      active_set <= 1'b0;
    end else if (swap_banks) begin
      active_set <= ~active_set;
    end
  end

  // ============================================================
  // Unified Write Logic (writes full row to shadow banks)
  // ============================================================
  // Writes go to shadow set (opposite of active)
  // ============================================================
  // Combined Write Logic (unified + per-bank, merged to avoid multiple drivers)
  // ============================================================
  genvar b;
  generate
    for (b = 0; b < NUM_BANKS; b++) begin : gen_bank_write
      always_ff @(posedge clk) begin
        // Unified write has priority over per-bank write
        if (unified_wr_en) begin
          // Write column b of the row to bank b (shadow bank)
          if (active_set == 1'b0) begin
            bank_set1[b][unified_wr_addr[$clog2(MAX_K)-1:0]] <= unified_wr_data[b];
          end else begin
            bank_set0[b][unified_wr_addr[$clog2(MAX_K)-1:0]] <= unified_wr_data[b];
          end
        end else if (wr_en[b]) begin
          // Per-bank write (lower priority)
          if (active_set == 1'b0) begin
            bank_set1[b][wr_addr[b][$clog2(MAX_K)-1:0]] <= wr_data[b];
          end else begin
            bank_set0[b][wr_addr[b][$clog2(MAX_K)-1:0]] <= wr_data[b];
          end
        end
      end
    end
  endgenerate

  // ============================================================
  // Streaming Read FSM (primary interface for systolic array)
  // ============================================================
  typedef enum logic [1:0] {
    S_IDLE,
    S_STREAMING,
    S_DONE
  } stream_state_t;

  stream_state_t state, next_state;
  logic [$clog2(MAX_K)-1:0] stream_idx;
  logic [$clog2(MAX_K)-1:0] stream_end;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= S_IDLE;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      S_IDLE: begin
        if (stream_start) begin
          next_state = S_STREAMING;
        end
      end
      S_STREAMING: begin
        if (stream_idx >= stream_end) begin
          next_state = S_DONE;
        end
      end
      S_DONE: begin
        next_state = S_IDLE;
      end
      default: next_state = S_IDLE;
    endcase
  end

  // Stream index counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      stream_idx <= '0;
      stream_end <= '0;
    end else if (stream_start && state == S_IDLE) begin
      stream_idx <= '0;
      stream_end <= stream_count - 1;
    end else if (state == S_STREAMING) begin
      stream_idx <= stream_idx + 1;
    end
  end

  // ============================================================
  // Parallel Bank Read for Streaming (from active set)
  // ============================================================
  logic signed [ACT_BITS-1:0] stream_data_set0 [NUM_BANKS];
  logic signed [ACT_BITS-1:0] stream_data_set1 [NUM_BANKS];

  generate
    for (b = 0; b < NUM_BANKS; b++) begin : gen_stream_read
      always_ff @(posedge clk) begin
        stream_data_set0[b] <= bank_set0[b][stream_idx];
        stream_data_set1[b] <= bank_set1[b][stream_idx];
      end

      // Assemble output row from all banks
      assign stream_data[b] = active_set ? stream_data_set1[b] : stream_data_set0[b];
    end
  endgenerate

  // Output valid (one cycle delayed due to SRAM read)
  logic streaming_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      streaming_d <= 1'b0;
    end else begin
      streaming_d <= (state == S_STREAMING);
    end
  end

  assign stream_valid = streaming_d;
  assign stream_done = (state == S_DONE);

  // ============================================================
  // Multi-port Read Interface (for parallel column access)
  // ============================================================
  generate
    for (b = 0; b < NUM_BANKS; b++) begin : gen_bank_read
      logic signed [ACT_BITS-1:0] rd_data_set0;
      logic signed [ACT_BITS-1:0] rd_data_set1;
      logic rd_valid_reg;

      always_ff @(posedge clk) begin
        if (rd_en[b]) begin
          rd_data_set0 <= bank_set0[b][rd_addr[b]];
          rd_data_set1 <= bank_set1[b][rd_addr[b]];
        end
      end

      assign rd_data[b] = active_set ? rd_data_set1 : rd_data_set0;

      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          rd_valid_reg <= 1'b0;
        end else begin
          rd_valid_reg <= rd_en[b];
        end
      end

      assign rd_valid[b] = rd_valid_reg;
    end
  endgenerate

  // ============================================================
  // Bank Conflict Detection
  // ============================================================
  logic [NUM_BANKS-1:0] bank_rd_active;
  logic [NUM_BANKS-1:0] bank_wr_active;
  logic [NUM_BANKS-1:0] bank_conflict;
  logic [31:0] conflict_count_reg;

  // Track read activity
  always_comb begin
    bank_rd_active = rd_en;
    // Streaming reads all banks simultaneously
    if (state == S_STREAMING) begin
      bank_rd_active = {NUM_BANKS{1'b1}};
    end
  end

  // Track write activity
  always_comb begin
    bank_wr_active = wr_en;
    if (unified_wr_en) begin
      bank_wr_active = {NUM_BANKS{1'b1}};  // Unified write touches all banks
    end
  end

  // With shadow banking, conflicts shouldn't occur normally
  assign bank_conflict = bank_rd_active & bank_wr_active;
  assign conflict_detected = |bank_conflict;

  // Find first conflicting bank
  // Use found flag instead of break for Icarus compatibility
  always_comb begin
    logic found;
    conflict_bank = '0;
    found = 1'b0;
    for (int i = 0; i < NUM_BANKS; i++) begin
      if (!found && bank_conflict[i]) begin
        conflict_bank = i[BANK_SEL_BITS-1:0];
        found = 1'b1;
      end
    end
  end

  // Conflict counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      conflict_count_reg <= '0;
    end else if (conflict_detected) begin
      conflict_count_reg <= conflict_count_reg + 1;
    end
  end

  assign conflict_count = conflict_count_reg;

  // ============================================================
  // Assertions (for simulation)
  // ============================================================
  `ifdef SIMULATION
  initial begin
    assert (NUM_BANKS == ARRAY_SIZE)
      else $warning("NUM_BANKS should equal ARRAY_SIZE for column-major banking");
  end
  `endif

endmodule
