// TPU Memory Controller for 64×64 Array
// ======================================
// Integrates weight and activation buffers scaled for 64×64 systolic array.
//
// Memory Configuration:
//   - Weight buffer: 32 banks, 4096 depth, 64-wide rows
//   - Activation buffer: 64 banks (column-major), 4096 depth
//   - Total weight capacity: 32 banks × 128 rows × 64 weights = 262,144 weights
//   - Total activation capacity: 64 banks × 4096 rows = 262,144 activations
//
// Features:
//   - Double-buffering for compute/load overlap
//   - DMA interface for bulk transfers
//   - Bank conflict detection and counters
//   - CPU write interface for programming
//
// Author: Tritone Project (Phase 4.3 - 64×64 Scaling)

module tpu_memory_controller_64x64 #(
  parameter int ARRAY_SIZE = 64,          // 64×64 systolic array
  parameter int ACT_BITS = 16,            // Bits per activation
  parameter int ACC_BITS = 32,            // Bits per accumulator
  parameter int MAX_K = 4096,             // Maximum K dimension
  parameter int WGT_NUM_BANKS = 32,       // Weight buffer banks
  parameter int ACT_NUM_BANKS = 64,       // Activation buffer banks (one per column)
  parameter int ADDR_WIDTH = 16           // Address width
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Control
  input  logic                                      swap_weight_banks,
  input  logic                                      swap_act_banks,

  // ============================================================
  // CPU/DMA Write Interface (to shadow buffers)
  // ============================================================

  // Weight writes
  input  logic                                      wgt_wr_en,
  input  logic [ADDR_WIDTH-1:0]                     wgt_wr_addr,
  input  logic [ARRAY_SIZE-1:0][1:0]                wgt_wr_data,     // Full row (64 weights)

  // Activation writes
  input  logic                                      act_wr_en,
  input  logic [ADDR_WIDTH-1:0]                     act_wr_addr,
  input  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]       act_wr_data,     // Full row (64 activations)

  // ============================================================
  // Systolic Array Interface (from active buffers)
  // ============================================================

  // Weight read (one row per cycle during weight load)
  input  logic                                      wgt_rd_en,
  input  logic [$clog2(MAX_K)-1:0]                  wgt_rd_row,
  output logic [ARRAY_SIZE-1:0][1:0]                wgt_rd_data,
  output logic                                      wgt_rd_valid,

  // Activation streaming (continuous feed to systolic array)
  input  logic                                      act_stream_start,
  input  logic [$clog2(MAX_K)-1:0]                  act_stream_count,
  output logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]       act_stream_data,
  output logic                                      act_stream_valid,
  output logic                                      act_stream_done,

  // ============================================================
  // Output Buffer Interface
  // ============================================================
  input  logic                                      out_wr_en,
  input  logic [$clog2(ARRAY_SIZE*MAX_K)-1:0]       out_wr_addr,
  input  logic [ACC_BITS-1:0]                       out_wr_data,

  input  logic                                      out_rd_en,
  input  logic [$clog2(ARRAY_SIZE*MAX_K)-1:0]       out_rd_addr,
  output logic [ACC_BITS-1:0]                       out_rd_data,
  output logic                                      out_rd_valid,

  // ============================================================
  // Performance Counters
  // ============================================================
  output logic [31:0]                               wgt_conflict_count,
  output logic [31:0]                               act_conflict_count,
  output logic                                      wgt_conflict_detected,
  output logic                                      act_conflict_detected
);

  // ============================================================
  // Weight Buffer (32-Bank for 64×64)
  // ============================================================
  // Note: Using 32 banks allows 2 weights per bank per row
  // Bank selection: addr[4:0] for 32 banks
  // Each bank stores: MAX_K/32 rows of 64 weights

  localparam int WGT_BANK_DEPTH = MAX_K / WGT_NUM_BANKS;  // 128 rows per bank

  // Weight buffer memory (double-buffered)
  logic [ARRAY_SIZE-1:0][1:0] wgt_bank_set0 [WGT_NUM_BANKS][WGT_BANK_DEPTH];
  logic [ARRAY_SIZE-1:0][1:0] wgt_bank_set1 [WGT_NUM_BANKS][WGT_BANK_DEPTH];
  logic wgt_active_set;

  // Bank swap control
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wgt_active_set <= 1'b0;
    end else if (swap_weight_banks) begin
      wgt_active_set <= ~wgt_active_set;
    end
  end

  // Weight write logic (to shadow buffer)
  logic [$clog2(WGT_NUM_BANKS)-1:0] wgt_wr_bank;
  logic [$clog2(WGT_BANK_DEPTH)-1:0] wgt_wr_bank_addr;

  assign wgt_wr_bank = wgt_wr_addr[$clog2(WGT_NUM_BANKS)-1:0];
  assign wgt_wr_bank_addr = wgt_wr_addr[$clog2(WGT_BANK_DEPTH)+$clog2(WGT_NUM_BANKS)-1:$clog2(WGT_NUM_BANKS)];

  always_ff @(posedge clk) begin
    if (wgt_wr_en) begin
      if (wgt_active_set == 1'b0) begin
        wgt_bank_set1[wgt_wr_bank][wgt_wr_bank_addr] <= wgt_wr_data;
      end else begin
        wgt_bank_set0[wgt_wr_bank][wgt_wr_bank_addr] <= wgt_wr_data;
      end
    end
  end

  // Weight read logic (from active buffer)
  logic [$clog2(WGT_NUM_BANKS)-1:0] wgt_rd_bank;
  logic [$clog2(WGT_BANK_DEPTH)-1:0] wgt_rd_bank_addr;
  logic [ARRAY_SIZE-1:0][1:0] wgt_rd_data_set0;
  logic [ARRAY_SIZE-1:0][1:0] wgt_rd_data_set1;
  logic wgt_rd_valid_reg;

  assign wgt_rd_bank = wgt_rd_row[$clog2(WGT_NUM_BANKS)-1:0];
  assign wgt_rd_bank_addr = wgt_rd_row[$clog2(WGT_BANK_DEPTH)+$clog2(WGT_NUM_BANKS)-1:$clog2(WGT_NUM_BANKS)];

  always_ff @(posedge clk) begin
    if (wgt_rd_en) begin
      wgt_rd_data_set0 <= wgt_bank_set0[wgt_rd_bank][wgt_rd_bank_addr];
      wgt_rd_data_set1 <= wgt_bank_set1[wgt_rd_bank][wgt_rd_bank_addr];
    end
  end

  assign wgt_rd_data = wgt_active_set ? wgt_rd_data_set1 : wgt_rd_data_set0;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wgt_rd_valid_reg <= 1'b0;
    end else begin
      wgt_rd_valid_reg <= wgt_rd_en;
    end
  end

  assign wgt_rd_valid = wgt_rd_valid_reg;

  // ============================================================
  // Activation Buffer (64-Bank Column-Major for 64×64)
  // ============================================================
  // Each bank stores one column of activations
  // Bank i stores column i of all activation rows

  logic signed [ACT_BITS-1:0] act_bank_set0 [ACT_NUM_BANKS][MAX_K];
  logic signed [ACT_BITS-1:0] act_bank_set1 [ACT_NUM_BANKS][MAX_K];
  logic act_active_set;

  // Bank swap control
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_active_set <= 1'b0;
    end else if (swap_act_banks) begin
      act_active_set <= ~act_active_set;
    end
  end

  // Activation write logic (to shadow buffer, all columns at once)
  genvar ab;
  generate
    for (ab = 0; ab < ACT_NUM_BANKS; ab++) begin : gen_act_write
      always_ff @(posedge clk) begin
        if (act_wr_en) begin
          if (act_active_set == 1'b0) begin
            act_bank_set1[ab][act_wr_addr[$clog2(MAX_K)-1:0]] <= act_wr_data[ab];
          end else begin
            act_bank_set0[ab][act_wr_addr[$clog2(MAX_K)-1:0]] <= act_wr_data[ab];
          end
        end
      end
    end
  endgenerate

  // Activation streaming FSM
  typedef enum logic [1:0] {
    ACT_IDLE,
    ACT_STREAMING,
    ACT_DONE
  } act_stream_state_t;

  act_stream_state_t act_state, act_next_state;
  logic [$clog2(MAX_K)-1:0] act_stream_idx;
  logic [$clog2(MAX_K)-1:0] act_stream_end;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_state <= ACT_IDLE;
    end else begin
      act_state <= act_next_state;
    end
  end

  always_comb begin
    act_next_state = act_state;
    case (act_state)
      ACT_IDLE: begin
        if (act_stream_start) begin
          act_next_state = ACT_STREAMING;
        end
      end
      ACT_STREAMING: begin
        if (act_stream_idx >= act_stream_end) begin
          act_next_state = ACT_DONE;
        end
      end
      ACT_DONE: begin
        act_next_state = ACT_IDLE;
      end
      default: act_next_state = ACT_IDLE;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_stream_idx <= '0;
      act_stream_end <= '0;
    end else if (act_stream_start && act_state == ACT_IDLE) begin
      act_stream_idx <= '0;
      act_stream_end <= act_stream_count - 1;
    end else if (act_state == ACT_STREAMING) begin
      act_stream_idx <= act_stream_idx + 1;
    end
  end

  // Parallel read from all activation banks (streaming)
  logic signed [ACT_BITS-1:0] act_stream_set0 [ACT_NUM_BANKS];
  logic signed [ACT_BITS-1:0] act_stream_set1 [ACT_NUM_BANKS];

  generate
    for (ab = 0; ab < ACT_NUM_BANKS; ab++) begin : gen_act_stream
      always_ff @(posedge clk) begin
        act_stream_set0[ab] <= act_bank_set0[ab][act_stream_idx];
        act_stream_set1[ab] <= act_bank_set1[ab][act_stream_idx];
      end

      assign act_stream_data[ab] = act_active_set ? act_stream_set1[ab] : act_stream_set0[ab];
    end
  endgenerate

  // Streaming valid (one cycle delayed)
  logic act_streaming_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_streaming_d <= 1'b0;
    end else begin
      act_streaming_d <= (act_state == ACT_STREAMING);
    end
  end

  assign act_stream_valid = act_streaming_d;
  assign act_stream_done = (act_state == ACT_DONE);

  // ============================================================
  // Output Buffer (for accumulator results)
  // ============================================================
  localparam int OUT_DEPTH = ARRAY_SIZE * 64;  // 64 rows × 64 columns = 4096 outputs

  logic signed [ACC_BITS-1:0] output_buffer [OUT_DEPTH];
  logic out_rd_valid_reg;

  always_ff @(posedge clk) begin
    if (out_wr_en) begin
      output_buffer[out_wr_addr] <= out_wr_data;
    end
  end

  logic signed [ACC_BITS-1:0] out_rd_data_reg;
  always_ff @(posedge clk) begin
    if (out_rd_en) begin
      out_rd_data_reg <= output_buffer[out_rd_addr];
    end
  end

  assign out_rd_data = out_rd_data_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_rd_valid_reg <= 1'b0;
    end else begin
      out_rd_valid_reg <= out_rd_en;
    end
  end

  assign out_rd_valid = out_rd_valid_reg;

  // ============================================================
  // Performance Counters (Conflict Detection)
  // ============================================================
  // With proper double-buffering, conflicts shouldn't occur
  // These counters detect architectural violations

  logic [31:0] wgt_conflict_count_reg;
  logic [31:0] act_conflict_count_reg;

  // Weight conflict: read and write to same bank in same cycle
  logic wgt_conflict;
  assign wgt_conflict = wgt_rd_en && wgt_wr_en && (wgt_rd_bank == wgt_wr_bank);
  assign wgt_conflict_detected = wgt_conflict;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wgt_conflict_count_reg <= '0;
    end else if (wgt_conflict) begin
      wgt_conflict_count_reg <= wgt_conflict_count_reg + 1;
    end
  end

  assign wgt_conflict_count = wgt_conflict_count_reg;

  // Activation conflict: streaming read and write active simultaneously
  logic act_conflict;
  assign act_conflict = (act_state == ACT_STREAMING) && act_wr_en;
  assign act_conflict_detected = act_conflict;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      act_conflict_count_reg <= '0;
    end else if (act_conflict) begin
      act_conflict_count_reg <= act_conflict_count_reg + 1;
    end
  end

  assign act_conflict_count = act_conflict_count_reg;

endmodule
