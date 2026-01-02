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
//   0x004: TPU_STATUS   - Busy, done, error flags, zero-skip count
//   0x008: WEIGHT_ADDR  - Base address for weights
//   0x00C: ACT_ADDR     - Base address for activations (K dim in [31:16])
//   0x010: OUT_ADDR     - Base address for outputs
//   0x014: LAYER_CFG    - Rows[15:0], cols[31:16]
//   0x018: ARRAY_INFO   - Read-only: version, array size, acc bits
//   0x01C: PERF_CNT_0   - Cycles while busy
//   0x020: PERF_CNT_1   - Total zero-skip count
//   0x024: PERF_CNT_2   - Bank conflicts (future)
//   0x028: PERF_CNT_3   - DMA bytes transferred (future)
//   0x02C: PERF_CTRL    - [0]=enable, [1]=clear
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
  parameter int DATA_WIDTH = 32,          // CPU data width
  parameter bit USE_BANKED_MEMORY = 1'b0, // Enable 8-bank memory architecture
  parameter int NUM_BANKS = 8             // Number of memory banks (when banked)
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

  // AXI-Lite Master Interface (DMA to external memory)
  // Write Address Channel
  output logic                    m_axi_awvalid,
  input  logic                    m_axi_awready,
  output logic [ADDR_WIDTH-1:0]   m_axi_awaddr,
  output logic [7:0]              m_axi_awlen,
  output logic [2:0]              m_axi_awsize,
  output logic [1:0]              m_axi_awburst,

  // Write Data Channel
  output logic                    m_axi_wvalid,
  input  logic                    m_axi_wready,
  output logic [DATA_WIDTH-1:0]   m_axi_wdata,
  output logic [DATA_WIDTH/8-1:0] m_axi_wstrb,
  output logic                    m_axi_wlast,

  // Write Response Channel
  input  logic                    m_axi_bvalid,
  output logic                    m_axi_bready,
  input  logic [1:0]              m_axi_bresp,

  // Read Address Channel
  output logic                    m_axi_arvalid,
  input  logic                    m_axi_arready,
  output logic [ADDR_WIDTH-1:0]   m_axi_araddr,
  output logic [7:0]              m_axi_arlen,
  output logic [2:0]              m_axi_arsize,
  output logic [1:0]              m_axi_arburst,

  // Read Data Channel
  input  logic                    m_axi_rvalid,
  output logic                    m_axi_rready,
  input  logic [DATA_WIDTH-1:0]   m_axi_rdata,
  input  logic [1:0]              m_axi_rresp,
  input  logic                    m_axi_rlast,

  // Legacy simple DMA interface (directly exposed for backward compatibility)
  output logic                    dma_req,        // DMA request (directly from arvalid)
  output logic                    dma_wr,         // DMA write (vs read)
  output logic [ADDR_WIDTH-1:0]   dma_addr,       // DMA address
  output logic [DATA_WIDTH-1:0]   dma_wdata,      // DMA write data
  input  logic [DATA_WIDTH-1:0]   dma_rdata,      // DMA read data
  input  logic                    dma_ack,        // DMA acknowledge

  // Interrupt
  output logic                    irq,            // Completion interrupt

  // Status outputs (directly accessible)
  output logic                    busy,           // TPU is processing
  output logic                    done            // TPU operation complete
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
  localparam logic [7:0] REG_PERF_CNT   = 8'h1C;  // Cycles while busy
  localparam logic [7:0] REG_PERF_CNT_1 = 8'h20;  // Zero-skip count
  localparam logic [7:0] REG_PERF_CNT_2 = 8'h24;  // Bank conflicts
  localparam logic [7:0] REG_PERF_CNT_3 = 8'h28;  // DMA bytes transferred
  localparam logic [7:0] REG_PERF_CTRL  = 8'h2C;  // Counter control

  // DMA registers
  localparam logic [7:0] REG_DMA_SRC    = 8'h30;  // DMA source address
  localparam logic [7:0] REG_DMA_DST    = 8'h34;  // DMA destination address
  localparam logic [7:0] REG_DMA_LEN    = 8'h38;  // DMA transfer length
  localparam logic [7:0] REG_DMA_CTRL   = 8'h3C;  // DMA control: [0]=start, [1]=dir, [3:2]=mode
  localparam logic [7:0] REG_DMA_STATUS = 8'h40;  // DMA status: [0]=busy, [1]=done, [2]=error

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
  logic [31:0] reg_perf_cnt;     // Cycles while busy
  logic [31:0] reg_perf_cnt_1;   // Accumulated zero-skip count
  logic [31:0] reg_perf_cnt_2;   // Bank conflicts
  logic [31:0] reg_perf_cnt_3;   // DMA bytes transferred
  logic [31:0] reg_perf_ctrl;    // Counter control: [0]=enable, [1]=clear

  // DMA registers
  logic [31:0] reg_dma_src;      // DMA source address
  logic [31:0] reg_dma_dst;      // DMA destination address
  logic [31:0] reg_dma_len;      // DMA transfer length
  logic [31:0] reg_dma_ctrl;     // DMA control
  logic [31:0] reg_dma_status;   // DMA status (read-only)

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
  // DMA control signals
  logic dma_start_pulse;
  logic dma_start_d;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reg_ctrl <= '0;
      reg_weight_addr <= '0;
      reg_act_addr <= '0;
      reg_out_addr <= '0;
      reg_layer_cfg <= '0;
      reg_dma_src <= '0;
      reg_dma_dst <= '0;
      reg_dma_len <= '0;
      reg_dma_ctrl <= '0;
      // Note: reg_perf_cnt, reg_perf_cnt_1/2/3 initialized in perf counter block
      reg_perf_ctrl <= 32'h00000001;  // Enable counters by default
      cpu_ready <= 1'b0;
      dma_start_d <= 1'b0;
    end else begin
      // Auto-clear start bit
      if (ctrl_start && status_busy) begin
        reg_ctrl[0] <= 1'b0;
      end

      // Auto-clear DMA start bit
      if (reg_dma_ctrl[0] && dma_busy) begin
        reg_dma_ctrl[0] <= 1'b0;
      end

      dma_start_d <= reg_dma_ctrl[0];

      // Register writes
      if (cpu_sel && cpu_wen) begin
        case (cpu_addr[7:0])
          REG_CTRL:        reg_ctrl <= cpu_wdata;
          REG_WEIGHT_ADDR: reg_weight_addr <= cpu_wdata;
          REG_ACT_ADDR:    reg_act_addr <= cpu_wdata;
          REG_OUT_ADDR:    reg_out_addr <= cpu_wdata;
          REG_LAYER_CFG:   reg_layer_cfg <= cpu_wdata;
          REG_PERF_CTRL:   reg_perf_ctrl <= cpu_wdata;
          REG_DMA_SRC:     reg_dma_src <= cpu_wdata;
          REG_DMA_DST:     reg_dma_dst <= cpu_wdata;
          REG_DMA_LEN:     reg_dma_len <= cpu_wdata;
          REG_DMA_CTRL:    reg_dma_ctrl <= cpu_wdata;
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

  // DMA start pulse generation
  assign dma_start_pulse = reg_dma_ctrl[0] && !dma_start_d;

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
        REG_PERF_CNT_1:  cpu_rdata = reg_perf_cnt_1;
        REG_PERF_CNT_2:  cpu_rdata = reg_perf_cnt_2;
        REG_PERF_CNT_3:  cpu_rdata = reg_perf_cnt_3;
        REG_PERF_CTRL:   cpu_rdata = reg_perf_ctrl;
        REG_DMA_SRC:     cpu_rdata = reg_dma_src;
        REG_DMA_DST:     cpu_rdata = reg_dma_dst;
        REG_DMA_LEN:     cpu_rdata = reg_dma_len;
        REG_DMA_CTRL:    cpu_rdata = reg_dma_ctrl;
        REG_DMA_STATUS:  cpu_rdata = reg_dma_status;
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
  // Weight Buffer (Simple SRAM) with DMA/Controller Mux
  // ============================================================
  // Controller interface signals
  logic                              ctrl_wgt_wr_en;
  logic [WEIGHT_ADDR_WIDTH-1:0]      ctrl_wgt_wr_addr;
  logic [ARRAY_SIZE-1:0][1:0]        ctrl_wgt_wr_data;
  logic                              wgt_rd_en;
  logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_rd_addr;
  logic [ARRAY_SIZE-1:0][1:0]        wgt_rd_data;

  // Muxed write signals (DMA or Controller)
  logic                              wgt_wr_en;
  logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_wr_addr;
  logic [ARRAY_SIZE-1:0][1:0]        wgt_wr_data;

  // DMA weight write (needs conversion from 32-bit to ARRAY_SIZE*2 bits)
  logic [ARRAY_SIZE-1:0][1:0] dma_wgt_data_converted;
  always_comb begin
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      if (i*2+1 < DATA_WIDTH) begin
        dma_wgt_data_converted[i] = dma_wgt_buf_wr_data[i*2 +: 2];
      end else begin
        dma_wgt_data_converted[i] = 2'b00;
      end
    end
  end

  // Priority: DMA writes take precedence when DMA is busy
  assign wgt_wr_en = dma_busy ? dma_wgt_buf_wr_en : ctrl_wgt_wr_en;
  assign wgt_wr_addr = dma_busy ? dma_wgt_buf_wr_addr[WEIGHT_ADDR_WIDTH-1:0] : ctrl_wgt_wr_addr;
  assign wgt_wr_data = dma_busy ? dma_wgt_data_converted : ctrl_wgt_wr_data;

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
  // Activation Buffer (Simple SRAM) with DMA/Controller Mux
  // ============================================================
  // Controller interface signals
  logic                              ctrl_act_wr_en;
  logic [ACT_ADDR_WIDTH-1:0]         ctrl_act_wr_addr;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] ctrl_act_wr_data;
  logic                              act_rd_en;
  logic [ACT_ADDR_WIDTH-1:0]         act_rd_addr;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_rd_data;

  // Muxed write signals (DMA or Controller)
  logic                              act_wr_en;
  logic [ACT_ADDR_WIDTH-1:0]         act_wr_addr;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_wr_data;

  // DMA activation write (needs conversion from 32-bit to ARRAY_SIZE*ACT_BITS)
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] dma_act_data_converted;
  always_comb begin
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      if ((i+1)*ACT_BITS <= DATA_WIDTH) begin
        dma_act_data_converted[i] = dma_act_buf_wr_data[i*ACT_BITS +: ACT_BITS];
      end else begin
        dma_act_data_converted[i] = '0;
      end
    end
  end

  // Priority: DMA writes take precedence when DMA is busy
  assign act_wr_en = dma_busy ? dma_act_buf_wr_en : ctrl_act_wr_en;
  assign act_wr_addr = dma_busy ? dma_act_buf_wr_addr[ACT_ADDR_WIDTH-1:0] : ctrl_act_wr_addr;
  assign act_wr_data = dma_busy ? dma_act_data_converted : ctrl_act_wr_data;

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
  // Output Buffer (Simple SRAM) with DMA Read Support
  // ============================================================
  logic                              out_wr_en;
  logic [OUT_ADDR_WIDTH-1:0]         out_wr_addr;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_wr_data;

  // Controller read interface
  logic                              ctrl_out_rd_en;
  logic [OUT_ADDR_WIDTH-1:0]         ctrl_out_rd_addr;

  // Muxed read signals (DMA or Controller)
  logic                              out_rd_en;
  logic [OUT_ADDR_WIDTH-1:0]         out_rd_addr;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_rd_data;

  // Priority: DMA reads take precedence when DMA is busy
  assign out_rd_en = dma_busy ? dma_out_buf_rd_en : ctrl_out_rd_en;
  assign out_rd_addr = dma_busy ? dma_out_buf_rd_addr[OUT_ADDR_WIDTH-1:0] : ctrl_out_rd_addr;

  // Output SRAM
  logic [ARRAY_SIZE*ACC_BITS-1:0] out_mem [OUT_BUF_DEPTH-1:0];

  // Output read valid tracking
  logic out_rd_en_d;
  logic out_rd_valid;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_rd_en_d <= 1'b0;
    end else begin
      out_rd_en_d <= out_rd_en;
    end
  end
  assign out_rd_valid = out_rd_en_d;  // Valid one cycle after read enable

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

  // Wire status to output ports
  assign busy = status_busy;
  assign done = status_done;

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

  // ============================================================
  // Performance Counters
  // ============================================================
  // perf_ctrl[0] = enable counters
  // perf_ctrl[1] = clear counters (auto-clears after one cycle)
  logic perf_cnt_enable;
  logic perf_cnt_clear;
  assign perf_cnt_enable = reg_perf_ctrl[0];
  assign perf_cnt_clear = reg_perf_ctrl[1];

  // Bank conflict signals (from banked memory controller when enabled)
  logic [31:0] bank_conflict_count;
  logic bank_conflict_detected;

  // Generate banked memory conflict tracking
  generate
    if (USE_BANKED_MEMORY) begin : gen_banked_conflict
      // When using banked memory, these signals come from the memory controller
      // For now, we provide placeholder signals - actual wiring happens in SoC integration
      // The banked memory controller exposes: weight_bank_conflicts, act_bank_conflicts, total_bank_conflicts
      assign bank_conflict_count = '0;  // Will be connected to memory controller in integration
      assign bank_conflict_detected = 1'b0;
    end else begin : gen_no_banked_conflict
      assign bank_conflict_count = '0;
      assign bank_conflict_detected = 1'b0;
    end
  endgenerate

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reg_perf_cnt <= '0;
      reg_perf_cnt_1 <= '0;
      reg_perf_cnt_2 <= '0;
      reg_perf_cnt_3 <= '0;
    end else if (perf_cnt_clear) begin
      // Clear all counters (software must also clear the clear bit)
      reg_perf_cnt <= '0;
      reg_perf_cnt_1 <= '0;
      reg_perf_cnt_2 <= '0;
      reg_perf_cnt_3 <= '0;
    end else if (perf_cnt_enable && !perf_cnt_clear) begin
      // PERF_CNT_0: Cycles while busy
      if (controller_busy) begin
        reg_perf_cnt <= reg_perf_cnt + 1;
      end

      // PERF_CNT_1: Zero-skip count (same as status_zero_skips but independent)
      if (array_enable) begin
        reg_perf_cnt_1 <= reg_perf_cnt_1 + {16'b0, zero_skip_count_comb};
      end

      // PERF_CNT_2: Bank conflicts (driven by banked memory when enabled)
      if (bank_conflict_detected) begin
        reg_perf_cnt_2 <= reg_perf_cnt_2 + 1;
      end

      // PERF_CNT_3: DMA bytes transferred (updated when DMA completes)
      if (dma_done) begin
        reg_perf_cnt_3 <= reg_perf_cnt_3 + dma_bytes_transferred;
      end
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
  // DMA Engine
  // ============================================================
  // DMA status signals
  logic dma_busy;
  logic dma_done;
  logic dma_error;
  logic [31:0] dma_bytes_transferred;

  // DMA buffer interface signals
  logic dma_wgt_buf_wr_en;
  logic [15:0] dma_wgt_buf_wr_addr;
  logic [DATA_WIDTH-1:0] dma_wgt_buf_wr_data;
  logic dma_act_buf_wr_en;
  logic [15:0] dma_act_buf_wr_addr;
  logic [DATA_WIDTH-1:0] dma_act_buf_wr_data;
  logic dma_out_buf_rd_en;
  logic [15:0] dma_out_buf_rd_addr;
  logic [DATA_WIDTH-1:0] dma_out_buf_rd_data;
  logic dma_out_buf_rd_valid;

  // DMA status register
  assign reg_dma_status = {dma_bytes_transferred[15:0],
                           13'b0,
                           dma_error,
                           dma_done,
                           dma_busy};

  tpu_dma_engine #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .MAX_BURST_LEN(16),
    .BUFFER_DEPTH(64)
  ) u_dma_engine (
    .clk(clk),
    .rst_n(rst_n),

    // Control interface
    .start(dma_start_pulse),
    .src_addr(reg_dma_src),
    .dst_addr(reg_dma_dst),
    .transfer_len(reg_dma_len[15:0]),
    .direction(reg_dma_ctrl[1]),
    .mode(reg_dma_ctrl[3:2]),

    .busy(dma_busy),
    .done(dma_done),
    .error(dma_error),
    .bytes_transferred(dma_bytes_transferred),

    // AXI master interface - fully connected to top-level ports
    // Write Address Channel
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),

    // Write Data Channel
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),

    // Write Response Channel
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready),
    .m_axi_bresp(m_axi_bresp),

    // Read Address Channel
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),

    // Read Data Channel
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rlast(m_axi_rlast),

    // Buffer interface
    .wgt_buf_wr_en(dma_wgt_buf_wr_en),
    .wgt_buf_wr_addr(dma_wgt_buf_wr_addr),
    .wgt_buf_wr_data(dma_wgt_buf_wr_data),

    .act_buf_wr_en(dma_act_buf_wr_en),
    .act_buf_wr_addr(dma_act_buf_wr_addr),
    .act_buf_wr_data(dma_act_buf_wr_data),

    .out_buf_rd_en(dma_out_buf_rd_en),
    .out_buf_rd_addr(dma_out_buf_rd_addr),
    .out_buf_rd_data(out_rd_data[0][DATA_WIDTH-1:0]),  // First word of output buffer
    .out_buf_rd_valid(out_rd_valid)  // Proper valid signal from SRAM read latency
  );

  // Legacy DMA interface signals (directly from AXI interface)
  assign dma_req = m_axi_arvalid;
  assign dma_wr = reg_dma_ctrl[1];
  assign dma_addr = m_axi_arvalid ? m_axi_araddr : m_axi_awaddr;
  assign dma_wdata = m_axi_wdata;

  // Update PERF_CNT_3 with DMA bytes transferred
  // (handled in performance counter block - wire dma_bytes_transferred there)

endmodule
