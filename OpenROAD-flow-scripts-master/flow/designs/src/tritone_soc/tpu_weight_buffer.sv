// TPU Weight Buffer with Double-Buffering
// =========================================
// Stores ternary weights for systolic array computation.
// Supports double-buffering: load next layer while computing current.
//
// Features:
//   - Two banks for ping-pong buffering
//   - 2-bit weight encoding per entry
//   - Row-major storage for systolic feeding
//
// Author: Tritone Project

module tpu_weight_buffer #(
  parameter int ARRAY_SIZE = 8,           // Systolic array dimension
  parameter int MAX_K = 256,              // Maximum K dimension
  parameter int ADDR_WIDTH = 16           // Address width for external interface
)(
  input  logic                            clk,
  input  logic                            rst_n,

  // Control
  input  logic                            bank_select,    // Which bank is active for compute
  input  logic                            swap_banks,     // Swap active bank (pulse)

  // Write interface (for loading weights)
  input  logic                            wr_en,
  input  logic [ADDR_WIDTH-1:0]           wr_addr,
  input  logic [ARRAY_SIZE-1:0][1:0]      wr_data,        // One row of weights

  // Read interface (for systolic array)
  input  logic                            rd_en,
  input  logic [$clog2(MAX_K)-1:0]        rd_row,         // K index
  output logic [ARRAY_SIZE-1:0][1:0]      rd_data,        // One row of weights
  output logic                            rd_valid
);

  // ============================================================
  // Memory Arrays (Two Banks)
  // ============================================================
  // Each bank stores MAX_K rows, each row has ARRAY_SIZE weights (2-bit each)
  localparam int DEPTH = MAX_K;

  logic [ARRAY_SIZE-1:0][1:0] bank0 [DEPTH];
  logic [ARRAY_SIZE-1:0][1:0] bank1 [DEPTH];

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
  // Write Logic (to inactive bank for double-buffering)
  // ============================================================
  // Writes go to the opposite bank of what's being read
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
  // Read Logic (from active bank)
  // ============================================================
  logic [ARRAY_SIZE-1:0][1:0] rd_data_bank0;
  logic [ARRAY_SIZE-1:0][1:0] rd_data_bank1;

  always_ff @(posedge clk) begin
    if (rd_en) begin
      rd_data_bank0 <= bank0[rd_row];
      rd_data_bank1 <= bank1[rd_row];
    end
  end

  // Select active bank for output
  assign rd_data = active_bank ? rd_data_bank1 : rd_data_bank0;

  // Read valid delay
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_valid <= 1'b0;
    end else begin
      rd_valid <= rd_en;
    end
  end

endmodule
