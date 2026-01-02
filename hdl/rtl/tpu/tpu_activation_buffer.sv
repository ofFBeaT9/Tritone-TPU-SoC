// TPU Activation Buffer with Streaming Support
// ==============================================
// Stores activation vectors for systolic array input.
// Supports ping-pong buffering for continuous streaming.
//
// Features:
//   - Two banks for continuous operation
//   - Streaming read for systolic array feeding
//   - Configurable activation width
//
// Author: Tritone Project

module tpu_activation_buffer #(
  parameter int ARRAY_SIZE = 8,           // Systolic array dimension
  parameter int ACT_BITS = 16,            // Bits per activation
  parameter int MAX_K = 256,              // Maximum K dimension
  parameter int ADDR_WIDTH = 16           // Address width for external interface
)(
  input  logic                                     clk,
  input  logic                                     rst_n,

  // Control
  input  logic                                     bank_select,    // Which bank is active
  input  logic                                     swap_banks,     // Swap active bank (pulse)

  // Write interface (for loading activations)
  input  logic                                     wr_en,
  input  logic [ADDR_WIDTH-1:0]                    wr_addr,
  input  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      wr_data,

  // Streaming read interface (for systolic array)
  input  logic                                     stream_start,   // Start streaming
  input  logic [$clog2(MAX_K)-1:0]                 stream_count,   // Number of vectors to stream
  output logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      stream_data,
  output logic                                     stream_valid,
  output logic                                     stream_done
);

  // ============================================================
  // Memory Arrays (Two Banks)
  // ============================================================
  localparam int DEPTH = MAX_K;

  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] bank0 [DEPTH];
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] bank1 [DEPTH];

  // Active bank tracking
  logic active_bank;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      active_bank <= 1'b0;
    end else if (swap_banks) begin
      active_bank <= ~active_bank;
    end
  end

  // ============================================================
  // Write Logic (to inactive bank)
  // ============================================================
  logic write_to_bank0;
  assign write_to_bank0 = ~active_bank;

  always_ff @(posedge clk) begin
    if (wr_en) begin
      if (write_to_bank0) begin
        bank0[wr_addr[$clog2(MAX_K)-1:0]] <= wr_data;
      end else begin
        bank1[wr_addr[$clog2(MAX_K)-1:0]] <= wr_data;
      end
    end
  end

  // ============================================================
  // Streaming Read FSM
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

  // Read from active bank
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] rd_data_bank0;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] rd_data_bank1;

  always_ff @(posedge clk) begin
    rd_data_bank0 <= bank0[stream_idx];
    rd_data_bank1 <= bank1[stream_idx];
  end

  assign stream_data = active_bank ? rd_data_bank1 : rd_data_bank0;

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

endmodule
