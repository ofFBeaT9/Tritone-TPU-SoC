// Tritone TPU Top-Level Module
// =============================
// Complete Ternary Neural Network accelerator integrating:
//   - Systolic array (configurable N×N)
//   - Weight buffer (double-buffered)
//   - Activation buffer (ping-pong)
//   - Accumulator buffer
//   - Control/status registers
//   - Memory-mapped CPU interface
//
// Register Map:
//   0x000: TPU_CTRL     - Start/stop, mode select
//   0x004: TPU_STATUS   - Busy, done, error flags
//   0x008: WEIGHT_ADDR  - Base address for weights
//   0x00C: ACT_ADDR     - Base address for activations
//   0x010: OUT_ADDR     - Base address for outputs
//   0x014: LAYER_CFG    - Rows, cols, stride config
//   0x018: ARRAY_INFO   - Read-only: array size, features
//   0x01C: PERF_CNT     - Performance counters
//
// Author: Tritone Project

module tpu_top
  import ternary_pkg::*;
#(
  parameter int ARRAY_SIZE = 8,           // Systolic array dimension
  parameter int ACT_BITS = 16,            // Activation bit width
  parameter int ACC_BITS = 32,            // Accumulator bit width
  parameter int WEIGHT_BUF_DEPTH = 4096,  // Weight buffer entries
  parameter int ACT_BUF_DEPTH = 2048,     // Activation buffer entries
  parameter int OUT_BUF_DEPTH = 2048,     // Output buffer entries
  parameter int ADDR_WIDTH = 32,          // CPU address width
  parameter int DATA_WIDTH = 32           // CPU data width
)(
  input  logic                    clk,
  input  logic                    rst_n,

  // CPU Interface (Memory-mapped)
  input  logic                    cpu_sel,        // Select TPU
  input  logic                    cpu_wen,        // Write enable
  input  logic                    cpu_ren,        // Read enable
  input  logic [ADDR_WIDTH-1:0]   cpu_addr,       // Address
  input  logic [DATA_WIDTH-1:0]   cpu_wdata,      // Write data
  output logic [DATA_WIDTH-1:0]   cpu_rdata,      // Read data
  output logic                    cpu_ready,      // Ready/ack

  // DMA Interface (for bulk data transfer)
  output logic                    dma_req,        // DMA request
  output logic                    dma_wr,         // DMA write (vs read)
  output logic [ADDR_WIDTH-1:0]   dma_addr,       // DMA address
  output logic [DATA_WIDTH-1:0]   dma_wdata,      // DMA write data
  input  logic [DATA_WIDTH-1:0]   dma_rdata,      // DMA read data
  input  logic                    dma_ack,        // DMA acknowledge

  // Interrupt
  output logic                    irq             // Completion interrupt
);

  // ============================================================
  // Local Parameters
  // ============================================================
  localparam int WEIGHT_ADDR_WIDTH = $clog2(WEIGHT_BUF_DEPTH);
  localparam int ACT_ADDR_WIDTH = $clog2(ACT_BUF_DEPTH);
  localparam int OUT_ADDR_WIDTH = $clog2(OUT_BUF_DEPTH);

  // Register addresses
  localparam logic [7:0] REG_CTRL       = 8'h00;
  localparam logic [7:0] REG_STATUS     = 8'h04;
  localparam logic [7:0] REG_WEIGHT_ADDR = 8'h08;
  localparam logic [7:0] REG_ACT_ADDR   = 8'h0C;
  localparam logic [7:0] REG_OUT_ADDR   = 8'h10;
  localparam logic [7:0] REG_LAYER_CFG  = 8'h14;
  localparam logic [7:0] REG_ARRAY_INFO = 8'h18;
  localparam logic [7:0] REG_PERF_CNT   = 8'h1C;

  // ============================================================
  // Control/Status Registers
  // ============================================================
  logic [31:0] reg_ctrl;
  logic [31:0] reg_status;
  logic [31:0] reg_weight_addr;
  logic [31:0] reg_act_addr;
  logic [31:0] reg_out_addr;
  logic [31:0] reg_layer_cfg;
  logic [31:0] reg_array_info;
  logic [31:0] reg_perf_cnt;

  // Control bits
  logic ctrl_start;
  logic ctrl_clear;
  logic ctrl_irq_en;

  assign ctrl_start = reg_ctrl[0];
  assign ctrl_clear = reg_ctrl[1];
  assign ctrl_irq_en = reg_ctrl[8];

  // Status bits
  logic status_busy;
  logic status_done;
  logic status_error;
  logic [15:0] status_zero_skips;

  // Layer configuration
  logic [15:0] layer_rows;
  logic [15:0] layer_cols;
  logic [15:0] layer_k;

  assign layer_rows = reg_layer_cfg[15:0];
  assign layer_cols = reg_layer_cfg[31:16];
  assign layer_k = reg_act_addr[31:16];  // Reuse upper bits of act_addr for K

  // Array info (read-only)
  assign reg_array_info = {16'h0001,               // Version
                           8'(ARRAY_SIZE),          // Array size
                           8'(ACC_BITS)};          // Accumulator bits

  // ============================================================
  // Register Interface
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reg_ctrl <= '0;
      reg_weight_addr <= '0;
      reg_act_addr <= '0;
      reg_out_addr <= '0;
      reg_layer_cfg <= '0;
      reg_perf_cnt <= '0;
      cpu_ready <= 1'b0;
    end else begin
      // Auto-clear start bit
      if (ctrl_start && status_busy) begin
        reg_ctrl[0] <= 1'b0;
      end

      // Register writes
      if (cpu_sel && cpu_wen) begin
        case (cpu_addr[7:0])
          REG_CTRL:        reg_ctrl <= cpu_wdata;
          REG_WEIGHT_ADDR: reg_weight_addr <= cpu_wdata;
          REG_ACT_ADDR:    reg_act_addr <= cpu_wdata;
          REG_OUT_ADDR:    reg_out_addr <= cpu_wdata;
          REG_LAYER_CFG:   reg_layer_cfg <= cpu_wdata;
          default: ;
        endcase
        cpu_ready <= 1'b1;
      end else if (cpu_sel && cpu_ren) begin
        cpu_ready <= 1'b1;
      end else begin
        cpu_ready <= 1'b0;
      end
    end
  end

  // Register reads
  always_comb begin
    cpu_rdata = '0;
    if (cpu_sel && cpu_ren) begin
      case (cpu_addr[7:0])
        REG_CTRL:        cpu_rdata = reg_ctrl;
        REG_STATUS:      cpu_rdata = reg_status;
        REG_WEIGHT_ADDR: cpu_rdata = reg_weight_addr;
        REG_ACT_ADDR:    cpu_rdata = reg_act_addr;
        REG_OUT_ADDR:    cpu_rdata = reg_out_addr;
        REG_LAYER_CFG:   cpu_rdata = reg_layer_cfg;
        REG_ARRAY_INFO:  cpu_rdata = reg_array_info;
        REG_PERF_CNT:    cpu_rdata = reg_perf_cnt;
        default:         cpu_rdata = '0;
      endcase
    end
  end

  // Status register
  assign reg_status = {status_zero_skips,
                       6'b0,
                       status_error,
                       status_done,
                       6'b0,
                       status_busy,
                       1'b0};

  // ============================================================
  // Weight Buffer (Simple SRAM)
  // ============================================================
  logic                              wgt_wr_en;
  logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_wr_addr;
  logic [ARRAY_SIZE-1:0][1:0]        wgt_wr_data;
  logic                              wgt_rd_en;
  logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_rd_addr;
  logic [ARRAY_SIZE-1:0][1:0]        wgt_rd_data;

  // Weight SRAM (N×2 bits wide)
  logic [ARRAY_SIZE*2-1:0] weight_mem [WEIGHT_BUF_DEPTH-1:0];

  always_ff @(posedge clk) begin
    if (wgt_wr_en) begin
      weight_mem[wgt_wr_addr] <= wgt_wr_data;
    end
    if (wgt_rd_en) begin
      wgt_rd_data <= weight_mem[wgt_rd_addr];
    end
  end

  // ============================================================
  // Activation Buffer (Simple SRAM)
  // ============================================================
  logic                              act_wr_en;
  logic [ACT_ADDR_WIDTH-1:0]         act_wr_addr;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_wr_data;
  logic                              act_rd_en;
  logic [ACT_ADDR_WIDTH-1:0]         act_rd_addr;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_rd_data;

  // Activation SRAM
  logic [ARRAY_SIZE*ACT_BITS-1:0] act_mem [ACT_BUF_DEPTH-1:0];

  always_ff @(posedge clk) begin
    if (act_wr_en) begin
      act_mem[act_wr_addr] <= act_wr_data;
    end
    if (act_rd_en) begin
      act_rd_data <= act_mem[act_rd_addr];
    end
  end

  // ============================================================
  // Output Buffer (Simple SRAM)
  // ============================================================
  logic                              out_wr_en;
  logic [OUT_ADDR_WIDTH-1:0]         out_wr_addr;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_wr_data;
  logic                              out_rd_en;
  logic [OUT_ADDR_WIDTH-1:0]         out_rd_addr;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_rd_data;

  // Output SRAM
  logic [ARRAY_SIZE*ACC_BITS-1:0] out_mem [OUT_BUF_DEPTH-1:0];

  always_ff @(posedge clk) begin
    if (out_wr_en) begin
      out_mem[out_wr_addr] <= out_wr_data;
    end
    if (out_rd_en) begin
      out_rd_data <= out_mem[out_rd_addr];
    end
  end

  // ============================================================
  // Systolic Array
  // ============================================================
  logic                              array_enable;
  logic                              array_weight_load;
  logic [$clog2(ARRAY_SIZE)-1:0]     array_weight_row;
  logic [ARRAY_SIZE-1:0][1:0]        array_weights;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] array_act_in;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_psum_in;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_psum_out;
  logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] zero_skip_map;

  ternary_systolic_array_int #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS)
  ) u_systolic_array (
    .clk(clk),
    .rst_n(rst_n),
    .enable(array_enable),
    .weight_load(array_weight_load),
    .weight_row(array_weight_row),
    .weights_in(array_weights),
    .act_in(array_act_in),
    .psum_in(array_psum_in),
    .psum_out(array_psum_out),
    .zero_skip_map(zero_skip_map)
  );

  // ============================================================
  // Controller
  // ============================================================
  logic controller_start;
  logic controller_done;
  logic controller_busy;

  // Pulse start on rising edge of ctrl_start
  logic ctrl_start_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ctrl_start_d <= 1'b0;
    end else begin
      ctrl_start_d <= ctrl_start;
    end
  end
  assign controller_start = ctrl_start && !ctrl_start_d;

  ternary_systolic_controller #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS),
    .WEIGHT_ADDR_WIDTH(WEIGHT_ADDR_WIDTH),
    .ACT_ADDR_WIDTH(ACT_ADDR_WIDTH),
    .OUT_ADDR_WIDTH(OUT_ADDR_WIDTH)
  ) u_controller (
    .clk(clk),
    .rst_n(rst_n),
    .start(controller_start),
    .layer_rows(layer_rows),
    .layer_cols(layer_cols),
    .layer_k(layer_k),
    .done(controller_done),
    .busy(controller_busy),

    .wgt_rd_en(wgt_rd_en),
    .wgt_rd_addr(wgt_rd_addr),
    .wgt_rd_data(wgt_rd_data),

    .act_rd_en(act_rd_en),
    .act_rd_addr(act_rd_addr),
    .act_rd_data(act_rd_data),

    .out_wr_en(out_wr_en),
    .out_wr_addr(out_wr_addr),
    .out_wr_data(out_wr_data),

    .array_enable(array_enable),
    .array_weight_load(array_weight_load),
    .array_weight_row(array_weight_row),
    .array_weights(array_weights),
    .array_act_in(array_act_in),
    .array_psum_in(array_psum_in),
    .array_psum_out(array_psum_out)
  );

  // ============================================================
  // Status and Interrupt
  // ============================================================
  assign status_busy = controller_busy;
  assign status_done = controller_done;
  assign status_error = 1'b0;  // TODO: Add error detection

  // Count zero-skips from array (synthesis-friendly population count)
  // zero_skip_map is [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] = ARRAY_SIZE*ARRAY_SIZE bits
  wire [ARRAY_SIZE*ARRAY_SIZE-1:0] zero_skip_flat;
  genvar gi, gj;
  generate
    for (gi = 0; gi < ARRAY_SIZE; gi = gi + 1) begin : gen_flat_i
      for (gj = 0; gj < ARRAY_SIZE; gj = gj + 1) begin : gen_flat_j
        assign zero_skip_flat[gi*ARRAY_SIZE + gj] = zero_skip_map[gi][gj];
      end
    end
  endgenerate

  // Synthesis-friendly population count (adder tree for 64 bits)
  // Level 1: count pairs (64 -> 32 x 2-bit sums)
  wire [1:0] popcount_l1 [31:0];
  generate
    for (gi = 0; gi < 32; gi = gi + 1) begin : gen_pop_l1
      assign popcount_l1[gi] = {1'b0, zero_skip_flat[gi*2]} + {1'b0, zero_skip_flat[gi*2+1]};
    end
  endgenerate

  // Level 2: sum pairs of pairs (32 -> 16 x 3-bit sums)
  wire [2:0] popcount_l2 [15:0];
  generate
    for (gi = 0; gi < 16; gi = gi + 1) begin : gen_pop_l2
      assign popcount_l2[gi] = {1'b0, popcount_l1[gi*2]} + {1'b0, popcount_l1[gi*2+1]};
    end
  endgenerate

  // Level 3: (16 -> 8 x 4-bit sums)
  wire [3:0] popcount_l3 [7:0];
  generate
    for (gi = 0; gi < 8; gi = gi + 1) begin : gen_pop_l3
      assign popcount_l3[gi] = {1'b0, popcount_l2[gi*2]} + {1'b0, popcount_l2[gi*2+1]};
    end
  endgenerate

  // Level 4: (8 -> 4 x 5-bit sums)
  wire [4:0] popcount_l4 [3:0];
  generate
    for (gi = 0; gi < 4; gi = gi + 1) begin : gen_pop_l4
      assign popcount_l4[gi] = {1'b0, popcount_l3[gi*2]} + {1'b0, popcount_l3[gi*2+1]};
    end
  endgenerate

  // Level 5: (4 -> 2 x 6-bit sums)
  wire [5:0] popcount_l5 [1:0];
  assign popcount_l5[0] = {1'b0, popcount_l4[0]} + {1'b0, popcount_l4[1]};
  assign popcount_l5[1] = {1'b0, popcount_l4[2]} + {1'b0, popcount_l4[3]};

  // Level 6: final sum (2 -> 1 x 7-bit sum, max value 64)
  wire [15:0] zero_skip_count_comb;
  assign zero_skip_count_comb = {9'b0, popcount_l5[0]} + {9'b0, popcount_l5[1]};

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      status_zero_skips <= '0;
    end else if (ctrl_clear) begin
      status_zero_skips <= '0;
    end else if (array_enable) begin
      status_zero_skips <= status_zero_skips + zero_skip_count_comb;
    end
  end

  // Interrupt generation
  logic done_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done_d <= 1'b0;
      irq <= 1'b0;
    end else begin
      done_d <= controller_done;
      if (ctrl_irq_en && controller_done && !done_d) begin
        irq <= 1'b1;
      end else if (cpu_sel && cpu_wen && cpu_addr[7:0] == REG_STATUS) begin
        irq <= 1'b0;  // Clear on status read
      end
    end
  end

  // ============================================================
  // DMA Interface (Simplified - for future use)
  // ============================================================
  assign dma_req = 1'b0;
  assign dma_wr = 1'b0;
  assign dma_addr = '0;
  assign dma_wdata = '0;

endmodule
