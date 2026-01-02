// Tritone TPU Top-Level Module (v2.3 - 2 GHz Pipeline Support)
// =============================================================
// Complete Ternary Neural Network accelerator integrating:
//   - Systolic array (configurable NxN, default 64×64)
//   - 32-Bank Weight buffer (double-buffered for compute/load overlap)
//   - 64-Bank Activation buffer (column-major for streaming)
//   - Accumulator buffer
//   - Control/status registers with error detection
//   - Memory-mapped CPU interface
//   - DMA engine with AXI master
//   - LUT unit for nonlinear activations (Phase 6)
//   - RSQRT unit for molecular dynamics (Phase 6)
//   - Optional 2 GHz pipelined MAC (Phase 9)
//
// Version 2.3 Changes (Phase 9 - 2 GHz Enhancement):
//   - Added USE_2GHZ_PIPELINE parameter for 2-stage pipelined MACs
//   - Conditionally instantiates ternary_systolic_array_2ghz
//   - Controller extended drain phase for pipeline latency
//   - Target frequency: 2 GHz on ASAP7 7nm
//
// Version 2.2 Changes (Phase 6 - Nonlinear Units):
//   - Added tpu_lut_unit for sigmoid/tanh/exp/log activations
//   - Added tpu_rsqrt_unit for 1/sqrt(x) calculations
//   - New registers: NL_CTRL, NL_STATUS, LUT_PROG
//   - Performance counters for nonlinear operations
//
// Version 2.1 Changes (Phase 4 - 64×64 Scaling):
//   - Default ARRAY_SIZE changed from 8 to 64
//   - Parameterized popcount for any array size
//   - Optional hierarchical array (USE_HIERARCHICAL_ARRAY)
//   - Scaled memory banks: 32 weight banks, 64 activation banks
//   - MAX_K increased to 4096
//
// Register Map:
//   0x000: TPU_CTRL     - Start/stop, mode select ([0]=start, [16]=cmdq_mode)
//   0x004: TPU_STATUS   - Busy, done, error flags, zero-skip count
//   0x008: WEIGHT_ADDR  - Base address for weights
//   0x00C: ACT_ADDR     - Base address for activations (K dim in [31:16])
//   0x010: OUT_ADDR     - Base address for outputs
//   0x014: LAYER_CFG    - Rows[15:0], cols[31:16]
//   0x018: ARRAY_INFO   - Read-only: version, array size, acc bits
//   0x01C: PERF_CNT_0   - Cycles while busy
//   0x020: PERF_CNT_1   - Total zero-skip count
//   0x024: PERF_CNT_2   - Bank conflicts
//   0x028: PERF_CNT_3   - DMA bytes transferred
//   0x02C: PERF_CTRL    - [0]=enable, [1]=clear
//   0x030: DMA_SRC      - DMA source address
//   0x034: DMA_DST      - DMA destination address
//   0x038: DMA_LEN      - DMA transfer length
//   0x03C: DMA_CTRL     - DMA control
//   0x040: DMA_STATUS   - DMA status
//   0x044: CMDQ_CTRL    - [0]=flush (auto-clear), [1]=clear_error (auto-clear)
//   0x048: CMDQ_STATUS  - [3:0]=count, [4]=empty, [5]=full, [6]=error, [7]=irq
//   0x050: CMDQ_DATA0   - Command bits [31:0]
//   0x054: CMDQ_DATA1   - Command bits [63:32]
//   0x058: CMDQ_DATA2   - Command bits [95:64]
//   0x05C: CMDQ_DATA3   - Command bits [127:96] - write triggers push
//   0x060: NL_CTRL      - Nonlinear control [2:0]=func, [3]=bypass, [4]=enable (Phase 6)
//   0x064: NL_STATUS    - Nonlinear status [0]=busy, [1]=done, [31:16]=ops_count
//   0x068: LUT_PROG     - LUT programming: [7:0]=addr, [23:8]=data, [25:24]=lut_sel, [31]=wr_en
//   0x06C: NL_PERF_CNT  - Nonlinear operations count
//
// Author: Tritone Project (v2.3 - Phase 9 2 GHz Enhancement)

module tpu_top_v2
  import ternary_pkg::*;
#(
  parameter int ARRAY_SIZE = 64,          // Systolic array dimension (64×64 default)
  parameter int ACT_BITS = 16,            // Activation bit width
  parameter int ACC_BITS = 32,            // Accumulator bit width
  parameter int WEIGHT_BUF_DEPTH = 8192,  // Weight buffer entries (scaled for 64×64)
  parameter int ACT_BUF_DEPTH = 4096,     // Activation buffer entries (scaled for 64×64)
  parameter int OUT_BUF_DEPTH = 4096,     // Output buffer entries (64×64 outputs)
  parameter int ADDR_WIDTH = 32,          // CPU address width
  parameter int DATA_WIDTH = 32,          // CPU data width
  parameter bit USE_BANKED_MEMORY = 1'b1, // Enable banked memory architecture (v2: default ON)
  parameter bit USE_HIERARCHICAL_ARRAY = 1'b1, // Use 8×8 PE clusters for 64×64 (Phase 4)
  parameter bit USE_2GHZ_PIPELINE = 1'b0, // Enable 2-stage pipelined MACs for 2 GHz (Phase 9)
  parameter int NUM_BANKS = 32,           // Number of weight banks (32 for 64×64)
  parameter int MAX_K = 4096              // Maximum K dimension (scaled for 64×64)
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
  output logic                    done,           // TPU operation complete
  output logic                    status_error    // TPU error status (v2)
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
  localparam logic [7:0] REG_PERF_CNT_1 = 8'h20;
  localparam logic [7:0] REG_PERF_CNT_2 = 8'h24;
  localparam logic [7:0] REG_PERF_CNT_3 = 8'h28;
  localparam logic [7:0] REG_PERF_CTRL  = 8'h2C;
  localparam logic [7:0] REG_DMA_SRC    = 8'h30;
  localparam logic [7:0] REG_DMA_DST    = 8'h34;
  localparam logic [7:0] REG_DMA_LEN    = 8'h38;
  localparam logic [7:0] REG_DMA_CTRL   = 8'h3C;
  localparam logic [7:0] REG_DMA_STATUS = 8'h40;

  // Command Queue Registers (Phase 3)
  localparam logic [7:0] REG_CMDQ_CTRL   = 8'h44;  // [0]=flush, [1]=clear_error
  localparam logic [7:0] REG_CMDQ_STATUS = 8'h48;  // [3:0]=count, [4]=empty, [5]=full, [6]=error, [7]=irq
  localparam logic [7:0] REG_CMDQ_DATA0  = 8'h50;  // Command bits [31:0]
  localparam logic [7:0] REG_CMDQ_DATA1  = 8'h54;  // Command bits [63:32]
  localparam logic [7:0] REG_CMDQ_DATA2  = 8'h58;  // Command bits [95:64]
  localparam logic [7:0] REG_CMDQ_DATA3  = 8'h5C;  // Command bits [127:96] - write triggers push

  // Nonlinear Unit Registers (Phase 6)
  localparam logic [7:0] REG_NL_CTRL     = 8'h60;  // [2:0]=func, [3]=bypass, [4]=enable
  localparam logic [7:0] REG_NL_STATUS   = 8'h64;  // [0]=busy, [1]=done, [31:16]=ops_count
  localparam logic [7:0] REG_LUT_PROG    = 8'h68;  // LUT programming
  localparam logic [7:0] REG_NL_PERF_CNT = 8'h6C;  // Nonlinear ops performance counter

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
  logic [31:0] reg_perf_cnt_1;
  logic [31:0] reg_perf_cnt_2;
  logic [31:0] reg_perf_cnt_3;
  logic [31:0] reg_perf_ctrl;
  logic [31:0] reg_dma_src;
  logic [31:0] reg_dma_dst;
  logic [31:0] reg_dma_len;
  logic [31:0] reg_dma_ctrl;
  logic [31:0] reg_dma_status;

  // Command Queue Registers (Phase 3)
  logic [31:0] reg_cmdq_ctrl;
  logic [31:0] reg_cmdq_status;
  logic [31:0] reg_cmdq_data0;
  logic [31:0] reg_cmdq_data1;
  logic [31:0] reg_cmdq_data2;
  logic [31:0] reg_cmdq_data3;

  // Nonlinear Unit Registers (Phase 6)
  logic [31:0] reg_nl_ctrl;
  logic [31:0] reg_nl_status;
  logic [31:0] reg_lut_prog;
  logic [31:0] reg_nl_perf_cnt;

  // Command Queue Signals
  logic        cmdq_push;
  logic [127:0] cmdq_data;
  logic        cmdq_full;
  logic        cmdq_almost_full;
  logic        cmdq_exec_valid;
  logic [127:0] cmdq_exec_cmd;
  logic        cmdq_exec_done;
  logic        cmdq_exec_error;
  logic        cmdq_flush;
  logic        cmdq_empty;
  logic [3:0]  cmdq_count;
  logic        cmdq_irq;
  logic        cmdq_error_flag;
  logic        cmdq_clear_error;
  logic        cmdq_mode_enabled;  // Use command queue mode vs legacy start

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
  // Note: status_error is now an output port (v2 fix)
  logic [15:0] status_zero_skips;

  // Layer configuration
  logic [15:0] layer_rows;
  logic [15:0] layer_cols;
  logic [15:0] layer_k;

  assign layer_rows = reg_layer_cfg[15:0];
  assign layer_cols = reg_layer_cfg[31:16];
  assign layer_k = reg_act_addr[31:16];

  // Array info (read-only) - v2.3 indicator in version field
  // Bit [31:24] = Major.Minor version (0x02 = v2)
  // Bit [23:16] = Patch + features (0x30 = .3, 0x31 = .3 + 2 GHz mode)
  assign reg_array_info = {8'h02,                  // Major version 2
                           USE_2GHZ_PIPELINE ? 8'h31 : 8'h30, // v2.3 or v2.3+2GHz
                           8'(ARRAY_SIZE),
                           8'(ACC_BITS)};

  // ============================================================
  // DMA Status Signals (forward declarations)
  // ============================================================
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

  // ============================================================
  // Register Interface
  // ============================================================
  logic dma_start_pulse;
  logic dma_start_d;
  logic cmdq_data3_written;  // Edge detection for DATA3 write

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
      reg_perf_ctrl <= 32'h00000001;
      reg_cmdq_ctrl <= '0;
      reg_cmdq_data0 <= '0;
      reg_cmdq_data1 <= '0;
      reg_cmdq_data2 <= '0;
      reg_cmdq_data3 <= '0;
      reg_nl_ctrl <= '0;
      reg_lut_prog <= '0;
      cpu_ready <= 1'b0;
      dma_start_d <= 1'b0;
      cmdq_push <= 1'b0;
      cmdq_data3_written <= 1'b0;
    end else begin
      // Auto-clear start bit when TPU becomes busy
      if (ctrl_start && status_busy) begin
        reg_ctrl[0] <= 1'b0;
      end
      // Auto-clear DMA start bit when DMA becomes busy
      if (reg_dma_ctrl[0] && dma_busy) begin
        reg_dma_ctrl[0] <= 1'b0;
      end
      dma_start_d <= reg_dma_ctrl[0];

      // Auto-clear cmdq push and control bits
      cmdq_push <= 1'b0;
      if (reg_cmdq_ctrl[0]) reg_cmdq_ctrl[0] <= 1'b0;  // Auto-clear flush
      if (reg_cmdq_ctrl[1]) reg_cmdq_ctrl[1] <= 1'b0;  // Auto-clear error_clear

      // Clear DATA3 written flag when transaction ends
      if (!cpu_sel || !cpu_wen) begin
        cmdq_data3_written <= 1'b0;
      end

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
          // Command Queue Registers
          REG_CMDQ_CTRL:   reg_cmdq_ctrl <= cpu_wdata;
          REG_CMDQ_DATA0:  reg_cmdq_data0 <= cpu_wdata;
          REG_CMDQ_DATA1:  reg_cmdq_data1 <= cpu_wdata;
          REG_CMDQ_DATA2:  reg_cmdq_data2 <= cpu_wdata;
          REG_CMDQ_DATA3:  begin
            reg_cmdq_data3 <= cpu_wdata;
            // Only push once per write transaction (edge detection)
            if (!cmdq_data3_written) begin
              cmdq_push <= 1'b1;
              cmdq_data3_written <= 1'b1;
            end
          end
          // Nonlinear Unit Registers (Phase 6)
          REG_NL_CTRL:     reg_nl_ctrl <= cpu_wdata;
          REG_LUT_PROG:    reg_lut_prog <= cpu_wdata;
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
        // Command Queue Registers
        REG_CMDQ_CTRL:   cpu_rdata = reg_cmdq_ctrl;
        REG_CMDQ_STATUS: cpu_rdata = reg_cmdq_status;
        REG_CMDQ_DATA0:  cpu_rdata = reg_cmdq_data0;
        REG_CMDQ_DATA1:  cpu_rdata = reg_cmdq_data1;
        REG_CMDQ_DATA2:  cpu_rdata = reg_cmdq_data2;
        REG_CMDQ_DATA3:  cpu_rdata = reg_cmdq_data3;
        // Nonlinear Unit Registers (Phase 6)
        REG_NL_CTRL:     cpu_rdata = reg_nl_ctrl;
        REG_NL_STATUS:   cpu_rdata = reg_nl_status;
        REG_LUT_PROG:    cpu_rdata = reg_lut_prog;
        REG_NL_PERF_CNT: cpu_rdata = reg_nl_perf_cnt;
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

  // Command Queue status register
  assign reg_cmdq_status = {24'b0,
                            cmdq_irq,
                            cmdq_error_flag,
                            cmdq_full,
                            cmdq_empty,
                            cmdq_count};

  // Command Queue control signals
  assign cmdq_data = {reg_cmdq_data3, reg_cmdq_data2, reg_cmdq_data1, reg_cmdq_data0};
  assign cmdq_flush = reg_cmdq_ctrl[0];
  assign cmdq_clear_error = reg_cmdq_ctrl[1];
  assign cmdq_mode_enabled = reg_ctrl[16];  // Bit 16 of CTRL enables cmdq mode

  // ============================================================
  // Bank Conflict Signals (NEW in v2)
  // ============================================================
  logic [31:0] bank_conflict_count;
  logic [31:0] weight_bank_conflicts;
  logic [31:0] act_bank_conflicts;
  logic [31:0] total_bank_conflicts;

  // ============================================================
  // Memory System (Generate Block for Banked vs Simple)
  // ============================================================
  // Common signals for controller interface
  logic                              wgt_rd_en;
  logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_rd_addr;
  logic [ARRAY_SIZE-1:0][1:0]        wgt_rd_data;
  logic                              wgt_rd_valid;
  logic                              act_rd_en;
  logic [ACT_ADDR_WIDTH-1:0]         act_rd_addr;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_rd_data;
  logic                              act_rd_valid;
  logic                              out_wr_en;
  logic [OUT_ADDR_WIDTH-1:0]         out_wr_addr;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_wr_data;
  logic                              out_rd_en;
  logic [OUT_ADDR_WIDTH-1:0]         out_rd_addr;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] out_rd_data;
  logic                              out_rd_valid;

  // Systolic array signals
  logic                              array_enable;
  logic                              array_weight_load;
  logic [$clog2(ARRAY_SIZE)-1:0]     array_weight_row;
  logic [ARRAY_SIZE-1:0][1:0]        array_weights;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] array_act_in;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_psum_in;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_psum_out;
  logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] zero_skip_map;

  // Controller signals
  logic controller_start;
  logic controller_done;
  logic controller_busy;
  logic swap_weight_banks;
  logic swap_act_banks;

  generate
    if (USE_BANKED_MEMORY) begin : gen_banked_memory
      //=================================================================
      // BANKED MEMORY ARCHITECTURE (32 banks: 8+8 weight, 8+8 activation)
      //=================================================================

      tpu_memory_controller_banked_v2 #(
        .ARRAY_SIZE(ARRAY_SIZE),
        .ACT_BITS(ACT_BITS),
        .ACC_BITS(ACC_BITS),
        .MAX_K(MAX_K),
        .NUM_BANKS(NUM_BANKS),
        .ADDR_WIDTH(16)
      ) u_mem_ctrl_banked (
        .clk(clk),
        .rst_n(rst_n),

        // CPU interface (unused - DMA handles loading)
        .cpu_sel(1'b0),
        .cpu_wen(1'b0),
        .cpu_ren(1'b0),
        .cpu_addr('0),
        .cpu_wdata('0),
        .cpu_rdata(),
        .cpu_ready(),

        // DMA write interface
        .dma_busy(dma_busy),
        .dma_wgt_wr_en(dma_wgt_buf_wr_en),
        .dma_wgt_wr_addr(dma_wgt_buf_wr_addr),
        .dma_wgt_wr_data(dma_wgt_buf_wr_data),
        .dma_act_wr_en(dma_act_buf_wr_en),
        .dma_act_wr_addr(dma_act_buf_wr_addr),
        .dma_act_wr_data(dma_act_buf_wr_data),

        // Controller read interface
        .ctrl_wgt_rd_en(wgt_rd_en),
        .ctrl_wgt_rd_addr({{(16-WEIGHT_ADDR_WIDTH){1'b0}}, wgt_rd_addr}),
        .ctrl_wgt_rd_data(wgt_rd_data),
        .ctrl_wgt_rd_valid(wgt_rd_valid),
        .ctrl_act_rd_en(act_rd_en),
        .ctrl_act_rd_addr({{(16-ACT_ADDR_WIDTH){1'b0}}, act_rd_addr}),
        .ctrl_act_rd_data(act_rd_data),
        .ctrl_act_rd_valid(act_rd_valid),

        // Control interface
        .load_weights_start(1'b0),
        .load_weights_count('0),
        .load_weights_done(),
        .load_acts_start(1'b0),
        .load_acts_count('0),
        .load_acts_done(),
        .compute_start(controller_start),
        .compute_k(layer_k[$clog2(MAX_K)-1:0]),
        .compute_done(),
        .store_results_start(1'b0),
        .store_results_done(),
        .swap_weight_banks(swap_weight_banks),
        .swap_act_banks(swap_act_banks),

        // Systolic array interface - NOT DIRECTLY CONNECTED
        // Controller v2 drives the array; memory controller just provides data
        .array_weights(),           // Unused - controller drives array
        .array_weight_load(),       // Unused - controller drives array
        .array_weight_row(),        // Unused - controller drives array
        .array_activations(),       // Unused - controller drives array
        .array_act_valid(),
        .array_outputs(array_psum_out),
        .array_output_valid(out_wr_en),

        // Conflict counters
        .weight_bank_conflicts(weight_bank_conflicts),
        .act_bank_conflicts(act_bank_conflicts),
        .total_bank_conflicts(total_bank_conflicts),
        .clear_conflict_counters(reg_perf_ctrl[1])
      );

      // Wire bank conflict count
      assign bank_conflict_count = total_bank_conflicts;

      // Output buffer (simple SRAM for now)
      logic [ARRAY_SIZE*ACC_BITS-1:0] out_mem [OUT_BUF_DEPTH-1:0];
      logic out_rd_en_d;

      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          out_rd_en_d <= 1'b0;
        end else begin
          out_rd_en_d <= out_rd_en;
        end
      end
      assign out_rd_valid = out_rd_en_d;

      always_ff @(posedge clk) begin
        if (out_wr_en) begin
          out_mem[out_wr_addr] <= out_wr_data;
        end
        if (out_rd_en) begin
          out_rd_data <= out_mem[out_rd_addr];
        end
      end

      // Swap signals come from controller_v2 (connected in instantiation)

    end else begin : gen_simple_memory
      //=================================================================
      // SIMPLE INLINE SRAM (Original implementation for compatibility)
      //=================================================================

      // Weight buffer signals
      logic                              ctrl_wgt_wr_en;
      logic [WEIGHT_ADDR_WIDTH-1:0]      ctrl_wgt_wr_addr;
      logic [ARRAY_SIZE-1:0][1:0]        ctrl_wgt_wr_data;
      logic                              wgt_wr_en;
      logic [WEIGHT_ADDR_WIDTH-1:0]      wgt_wr_addr;
      logic [ARRAY_SIZE-1:0][1:0]        wgt_wr_data;

      // DMA weight data conversion
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

      assign wgt_wr_en = dma_busy ? dma_wgt_buf_wr_en : ctrl_wgt_wr_en;
      assign wgt_wr_addr = dma_busy ? dma_wgt_buf_wr_addr[WEIGHT_ADDR_WIDTH-1:0] : ctrl_wgt_wr_addr;
      assign wgt_wr_data = dma_busy ? dma_wgt_data_converted : ctrl_wgt_wr_data;

      // Weight SRAM
      logic [ARRAY_SIZE*2-1:0] weight_mem [WEIGHT_BUF_DEPTH-1:0];

      always_ff @(posedge clk) begin
        if (wgt_wr_en) begin
          weight_mem[wgt_wr_addr] <= wgt_wr_data;
        end
        if (wgt_rd_en) begin
          wgt_rd_data <= weight_mem[wgt_rd_addr];
        end
      end

      assign wgt_rd_valid = 1'b1; // Simple SRAM always valid

      // Activation buffer signals
      logic                              ctrl_act_wr_en;
      logic [ACT_ADDR_WIDTH-1:0]         ctrl_act_wr_addr;
      logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] ctrl_act_wr_data;
      logic                              act_wr_en;
      logic [ACT_ADDR_WIDTH-1:0]         act_wr_addr;
      logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_wr_data;

      // DMA activation data conversion
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

      assign act_rd_valid = 1'b1; // Simple SRAM always valid

      // Output buffer signals
      logic                              ctrl_out_rd_en;
      logic [OUT_ADDR_WIDTH-1:0]         ctrl_out_rd_addr;

      assign out_rd_en = dma_busy ? dma_out_buf_rd_en : ctrl_out_rd_en;
      assign out_rd_addr = dma_busy ? dma_out_buf_rd_addr[OUT_ADDR_WIDTH-1:0] : ctrl_out_rd_addr;

      // Output SRAM
      logic [ARRAY_SIZE*ACC_BITS-1:0] out_mem [OUT_BUF_DEPTH-1:0];
      logic out_rd_en_d;

      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          out_rd_en_d <= 1'b0;
        end else begin
          out_rd_en_d <= out_rd_en;
        end
      end
      assign out_rd_valid = out_rd_en_d;

      always_ff @(posedge clk) begin
        if (out_wr_en) begin
          out_mem[out_wr_addr] <= out_wr_data;
        end
        if (out_rd_en) begin
          out_rd_data <= out_mem[out_rd_addr];
        end
      end

      // No bank conflicts in simple mode
      assign bank_conflict_count = '0;
      assign weight_bank_conflicts = '0;
      assign act_bank_conflicts = '0;
      assign total_bank_conflicts = '0;
      assign swap_weight_banks = 1'b0;
      assign swap_act_banks = 1'b0;

    end
  endgenerate

  // ============================================================
  // Systolic Array (Selectable: Flat, Hierarchical, or 2 GHz Pipelined)
  // ============================================================
  // Total zero-skip count from array (for hierarchical/2ghz versions)
  logic [31:0] array_total_zero_skip;
  logic [ARRAY_SIZE-1:0] array_valid_out;  // Valid signals from 2 GHz array

  generate
    if (USE_2GHZ_PIPELINE && ARRAY_SIZE == 64) begin : gen_2ghz_array
      // 2 GHz Pipelined 64×64 array with 2-stage MAC units
      // Target: 2 GHz on ASAP7 7nm, critical path ~280ps
      ternary_systolic_array_2ghz #(
        .ARRAY_SIZE(ARRAY_SIZE),
        .ACT_BITS(ACT_BITS),
        .ACC_BITS(ACC_BITS)
      ) u_systolic_array_2ghz (
        .clk(clk),
        .rst_n(rst_n),
        .enable(array_enable),
        .weight_load(array_weight_load),
        .clear(1'b0),
        .weight_in(array_weights),
        .act_in(array_act_in),
        .psum_in(array_psum_in),
        .psum_out(array_psum_out),
        .valid_out(array_valid_out),
        .zero_skip_count(array_total_zero_skip[$clog2(ARRAY_SIZE*ARRAY_SIZE+1)-1:0])
      );

      // Zero skip map not directly available in 2 GHz mode
      assign zero_skip_map = '0;

    end else if (USE_HIERARCHICAL_ARRAY && ARRAY_SIZE == 64) begin : gen_hierarchical_array
      // Hierarchical 64×64 array using 8×8 PE clusters
      // Better routing and floor planning for large arrays
      ternary_systolic_array_64x64 #(
        .CLUSTER_SIZE(8),
        .NUM_CLUSTERS(8),
        .ARRAY_SIZE(ARRAY_SIZE),
        .ACT_BITS(ACT_BITS),
        .ACC_BITS(ACC_BITS)
      ) u_systolic_array_64x64 (
        .clk(clk),
        .rst_n(rst_n),
        .enable(array_enable),
        .weight_load(array_weight_load),
        .weight_row(array_weight_row),
        .weights_in(array_weights),
        .act_in(array_act_in),
        .psum_in(array_psum_in),
        .psum_out(array_psum_out),
        .total_zero_skip_count(array_total_zero_skip)
      );

      // Extract zero_skip_map from hierarchical array (not directly available)
      // Use the aggregated count instead for performance monitoring
      assign zero_skip_map = '0;  // Individual map not exposed in hierarchical mode
      assign array_valid_out = '1;  // Always valid in hierarchical mode

    end else begin : gen_flat_array
      // Flat NxN array (original implementation)
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

      assign array_total_zero_skip = '0;  // Not used in flat mode
      assign array_valid_out = '1;  // Always valid in flat mode
    end
  endgenerate

  assign array_psum_in = '0; // First row gets zero partial sums

  // ============================================================
  // Controller
  // ============================================================
  logic ctrl_start_d;
  logic legacy_controller_start;
  logic cmdq_controller_start;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ctrl_start_d <= 1'b0;
    end else begin
      ctrl_start_d <= ctrl_start;
    end
  end

  // Legacy start (from REG_CTRL bit 0)
  assign legacy_controller_start = ctrl_start && !ctrl_start_d;

  // Command queue start (when cmdq has valid command and is in executing state)
  assign cmdq_controller_start = cmdq_exec_valid && !controller_busy;

  // Select start source based on mode
  assign controller_start = cmdq_mode_enabled ? cmdq_controller_start : legacy_controller_start;

  // Command queue completion signals
  assign cmdq_exec_done = controller_done;
  assign cmdq_exec_error = status_error;

  ternary_systolic_controller_v2 #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS),
    .WEIGHT_ADDR_WIDTH(WEIGHT_ADDR_WIDTH),
    .ACT_ADDR_WIDTH(ACT_ADDR_WIDTH),
    .OUT_ADDR_WIDTH(OUT_ADDR_WIDTH),
    .USE_2GHZ_PIPELINE(USE_2GHZ_PIPELINE)  // Pass 2 GHz mode to controller
  ) u_controller (
    .clk(clk),
    .rst_n(rst_n),
    .start(controller_start),
    .layer_rows(layer_rows),
    .layer_cols(layer_cols),
    .layer_k(layer_k),
    .done(controller_done),
    .busy(controller_busy),
    .swap_weight_banks(swap_weight_banks),  // v2: Bank swap signals from controller
    .swap_act_banks(swap_act_banks),        // v2: Bank swap signals from controller
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
    .array_psum_in(),  // Unused - first row always gets zero (assigned below)
    .array_psum_out(array_psum_out)
  );

  // ============================================================
  // Status and Interrupt
  // ============================================================
  assign status_busy = controller_busy;
  assign status_done = controller_done;

  // ERROR DETECTION (FIXED in v2)
  // Combine multiple error sources
  logic error_dma_resp;
  logic error_bank_overflow;

  assign error_dma_resp = dma_error;  // DMA error (AXI response error)
  assign error_bank_overflow = (bank_conflict_count > 32'hFFFF_FFFE);  // Near counter overflow
  assign status_error = error_dma_resp | error_bank_overflow;

  // Wire status to output ports
  assign busy = status_busy;
  assign done = status_done;

  // ============================================================
  // Zero-Skip Counting (Parameterized population count for any ARRAY_SIZE)
  // ============================================================
  // Supports 8×8 (64), 16×16 (256), 32×32 (1024), 64×64 (4096) arrays
  localparam int TOTAL_PES = ARRAY_SIZE * ARRAY_SIZE;
  localparam int POPCOUNT_LEVELS = $clog2(TOTAL_PES);  // 6 for 64, 12 for 4096

  wire [TOTAL_PES-1:0] zero_skip_flat;
  genvar gi, gj;
  generate
    for (gi = 0; gi < ARRAY_SIZE; gi = gi + 1) begin : gen_flat_i
      for (gj = 0; gj < ARRAY_SIZE; gj = gj + 1) begin : gen_flat_j
        assign zero_skip_flat[gi*ARRAY_SIZE + gj] = zero_skip_map[gi][gj];
      end
    end
  endgenerate

  // Parameterized adder tree for population count
  // Uses sequential accumulation for large arrays (synthesis-friendly)
  wire [15:0] zero_skip_count_comb;

  generate
    if (ARRAY_SIZE <= 8) begin : gen_popcount_small
      // Original 6-level adder tree for 8×8 = 64 elements
      wire [1:0] popcount_l1 [31:0];
      for (gi = 0; gi < 32; gi = gi + 1) begin : gen_pop_l1
        assign popcount_l1[gi] = {1'b0, zero_skip_flat[gi*2]} + {1'b0, zero_skip_flat[gi*2+1]};
      end

      wire [2:0] popcount_l2 [15:0];
      for (gi = 0; gi < 16; gi = gi + 1) begin : gen_pop_l2
        assign popcount_l2[gi] = {1'b0, popcount_l1[gi*2]} + {1'b0, popcount_l1[gi*2+1]};
      end

      wire [3:0] popcount_l3 [7:0];
      for (gi = 0; gi < 8; gi = gi + 1) begin : gen_pop_l3
        assign popcount_l3[gi] = {1'b0, popcount_l2[gi*2]} + {1'b0, popcount_l2[gi*2+1]};
      end

      wire [4:0] popcount_l4 [3:0];
      for (gi = 0; gi < 4; gi = gi + 1) begin : gen_pop_l4
        assign popcount_l4[gi] = {1'b0, popcount_l3[gi*2]} + {1'b0, popcount_l3[gi*2+1]};
      end

      wire [5:0] popcount_l5 [1:0];
      assign popcount_l5[0] = {1'b0, popcount_l4[0]} + {1'b0, popcount_l4[1]};
      assign popcount_l5[1] = {1'b0, popcount_l4[2]} + {1'b0, popcount_l4[3]};

      assign zero_skip_count_comb = {10'b0, popcount_l5[0]} + {10'b0, popcount_l5[1]};

    end else if (ARRAY_SIZE <= 64) begin : gen_popcount_large
      // 12-level adder tree for 64×64 = 4096 elements
      // Level 1: 2048 pairs → 2048 2-bit sums
      wire [1:0] pop_l1 [2047:0];
      for (gi = 0; gi < 2048; gi = gi + 1) begin : gen_l1
        assign pop_l1[gi] = {1'b0, zero_skip_flat[gi*2]} + {1'b0, zero_skip_flat[gi*2+1]};
      end

      // Level 2: 1024 pairs → 1024 3-bit sums
      wire [2:0] pop_l2 [1023:0];
      for (gi = 0; gi < 1024; gi = gi + 1) begin : gen_l2
        assign pop_l2[gi] = {1'b0, pop_l1[gi*2]} + {1'b0, pop_l1[gi*2+1]};
      end

      // Level 3: 512 pairs → 512 4-bit sums
      wire [3:0] pop_l3 [511:0];
      for (gi = 0; gi < 512; gi = gi + 1) begin : gen_l3
        assign pop_l3[gi] = {1'b0, pop_l2[gi*2]} + {1'b0, pop_l2[gi*2+1]};
      end

      // Level 4: 256 pairs → 256 5-bit sums
      wire [4:0] pop_l4 [255:0];
      for (gi = 0; gi < 256; gi = gi + 1) begin : gen_l4
        assign pop_l4[gi] = {1'b0, pop_l3[gi*2]} + {1'b0, pop_l3[gi*2+1]};
      end

      // Level 5: 128 pairs → 128 6-bit sums
      wire [5:0] pop_l5 [127:0];
      for (gi = 0; gi < 128; gi = gi + 1) begin : gen_l5
        assign pop_l5[gi] = {1'b0, pop_l4[gi*2]} + {1'b0, pop_l4[gi*2+1]};
      end

      // Level 6: 64 pairs → 64 7-bit sums
      wire [6:0] pop_l6 [63:0];
      for (gi = 0; gi < 64; gi = gi + 1) begin : gen_l6
        assign pop_l6[gi] = {1'b0, pop_l5[gi*2]} + {1'b0, pop_l5[gi*2+1]};
      end

      // Level 7: 32 pairs → 32 8-bit sums
      wire [7:0] pop_l7 [31:0];
      for (gi = 0; gi < 32; gi = gi + 1) begin : gen_l7
        assign pop_l7[gi] = {1'b0, pop_l6[gi*2]} + {1'b0, pop_l6[gi*2+1]};
      end

      // Level 8: 16 pairs → 16 9-bit sums
      wire [8:0] pop_l8 [15:0];
      for (gi = 0; gi < 16; gi = gi + 1) begin : gen_l8
        assign pop_l8[gi] = {1'b0, pop_l7[gi*2]} + {1'b0, pop_l7[gi*2+1]};
      end

      // Level 9: 8 pairs → 8 10-bit sums
      wire [9:0] pop_l9 [7:0];
      for (gi = 0; gi < 8; gi = gi + 1) begin : gen_l9
        assign pop_l9[gi] = {1'b0, pop_l8[gi*2]} + {1'b0, pop_l8[gi*2+1]};
      end

      // Level 10: 4 pairs → 4 11-bit sums
      wire [10:0] pop_l10 [3:0];
      for (gi = 0; gi < 4; gi = gi + 1) begin : gen_l10
        assign pop_l10[gi] = {1'b0, pop_l9[gi*2]} + {1'b0, pop_l9[gi*2+1]};
      end

      // Level 11: 2 pairs → 2 12-bit sums
      wire [11:0] pop_l11 [1:0];
      assign pop_l11[0] = {1'b0, pop_l10[0]} + {1'b0, pop_l10[1]};
      assign pop_l11[1] = {1'b0, pop_l10[2]} + {1'b0, pop_l10[3]};

      // Level 12: Final sum (13-bit, max 4096)
      wire [12:0] pop_final;
      assign pop_final = {1'b0, pop_l11[0]} + {1'b0, pop_l11[1]};

      assign zero_skip_count_comb = {3'b0, pop_final};

    end else begin : gen_popcount_fallback
      // Fallback: behavioral popcount (synthesis tool optimizes)
      logic [15:0] pop_sum;
      always_comb begin
        pop_sum = '0;
        for (int k = 0; k < TOTAL_PES; k++) begin
          pop_sum = pop_sum + {15'b0, zero_skip_flat[k]};
        end
      end
      assign zero_skip_count_comb = pop_sum;
    end
  endgenerate

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
  // Performance Counters (PERF_CNT_2 FIXED in v2)
  // ============================================================
  logic perf_cnt_enable;
  logic perf_cnt_clear;
  assign perf_cnt_enable = reg_perf_ctrl[0];
  assign perf_cnt_clear = reg_perf_ctrl[1];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reg_perf_cnt <= '0;
      reg_perf_cnt_1 <= '0;
      reg_perf_cnt_2 <= '0;
      reg_perf_cnt_3 <= '0;
    end else if (perf_cnt_clear) begin
      reg_perf_cnt <= '0;
      reg_perf_cnt_1 <= '0;
      reg_perf_cnt_2 <= '0;
      reg_perf_cnt_3 <= '0;
    end else if (perf_cnt_enable) begin
      // PERF_CNT_0: Cycles while busy
      if (controller_busy) begin
        reg_perf_cnt <= reg_perf_cnt + 1;
      end

      // PERF_CNT_1: Zero-skip count
      if (array_enable) begin
        reg_perf_cnt_1 <= reg_perf_cnt_1 + {16'b0, zero_skip_count_comb};
      end

      // PERF_CNT_2: Bank conflicts (FIXED - use accumulated count)
      reg_perf_cnt_2 <= bank_conflict_count;

      // PERF_CNT_3: DMA bytes transferred
      if (dma_done) begin
        reg_perf_cnt_3 <= reg_perf_cnt_3 + dma_bytes_transferred;
      end
    end
  end

  // ============================================================
  // Interrupt Generation
  // ============================================================
  logic done_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done_d <= 1'b0;
      irq <= 1'b0;
    end else begin
      done_d <= controller_done;
      if (cmdq_mode_enabled) begin
        // Command queue mode: IRQ comes from command queue
        irq <= cmdq_irq;
      end else begin
        // Legacy mode: IRQ on rising edge of done
        if (ctrl_irq_en && controller_done && !done_d) begin
          irq <= 1'b1;
        end else if (cpu_sel && cpu_wen && cpu_addr[7:0] == REG_STATUS) begin
          irq <= 1'b0;
        end
      end
    end
  end

  // ============================================================
  // DMA Engine
  // ============================================================
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
    // AXI interface
    .m_axi_awvalid(m_axi_awvalid),
    .m_axi_awready(m_axi_awready),
    .m_axi_awaddr(m_axi_awaddr),
    .m_axi_awlen(m_axi_awlen),
    .m_axi_awsize(m_axi_awsize),
    .m_axi_awburst(m_axi_awburst),
    .m_axi_wvalid(m_axi_wvalid),
    .m_axi_wready(m_axi_wready),
    .m_axi_wdata(m_axi_wdata),
    .m_axi_wstrb(m_axi_wstrb),
    .m_axi_wlast(m_axi_wlast),
    .m_axi_bvalid(m_axi_bvalid),
    .m_axi_bready(m_axi_bready),
    .m_axi_bresp(m_axi_bresp),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
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
    .out_buf_rd_data(out_rd_data[0][DATA_WIDTH-1:0]),
    .out_buf_rd_valid(out_rd_valid)
  );

  // Legacy DMA interface
  assign dma_req = m_axi_arvalid;
  assign dma_wr = reg_dma_ctrl[1];
  assign dma_addr = m_axi_arvalid ? m_axi_araddr : m_axi_awaddr;
  assign dma_wdata = m_axi_wdata;

  // ============================================================
  // Nonlinear Units (Phase 6)
  // ============================================================
  // LUT unit for activation functions (sigmoid, tanh, exp, log, GELU)
  // RSQRT unit for molecular dynamics force calculations

  // Nonlinear control signals from registers
  logic [2:0]  nl_func_select;
  logic        nl_bypass;
  logic        nl_enable;
  logic        nl_lut_wr_en;
  logic [7:0]  nl_lut_wr_addr;
  logic [15:0] nl_lut_wr_data;
  logic [1:0]  nl_lut_select;

  assign nl_func_select  = reg_nl_ctrl[2:0];     // Function: 0=sigmoid, 1=tanh, 2=exp, 3=log, 4=rsqrt
  assign nl_bypass       = reg_nl_ctrl[3];       // Bypass nonlinear unit
  assign nl_enable       = reg_nl_ctrl[4];       // Enable nonlinear processing

  // LUT programming from REG_LUT_PROG
  assign nl_lut_wr_addr  = reg_lut_prog[7:0];
  assign nl_lut_wr_data  = reg_lut_prog[23:8];
  assign nl_lut_select   = reg_lut_prog[25:24];
  assign nl_lut_wr_en    = reg_lut_prog[31];

  // LUT Unit signals
  logic signed [15:0] lut_data_in;
  logic               lut_data_valid;
  logic               lut_data_ready;
  logic signed [15:0] lut_data_out;
  logic               lut_data_out_valid;
  logic [31:0]        lut_ops_count;
  logic [31:0]        lut_cycles_count;

  // RSQRT Unit signals
  logic [15:0]        rsqrt_data_in;
  logic               rsqrt_data_valid;
  logic               rsqrt_data_ready;
  logic signed [15:0] rsqrt_data_out;
  logic               rsqrt_data_out_valid;
  logic               rsqrt_special_case;
  logic [31:0]        rsqrt_ops_count;
  logic [31:0]        rsqrt_newton_iters;

  // Nonlinear input routing (from output buffer for post-processing)
  // In a full implementation, this would connect to the systolic array output
  assign lut_data_in = out_rd_data[0][15:0];
  assign lut_data_valid = out_rd_valid && nl_enable && (nl_func_select < 3'd4);
  assign rsqrt_data_in = out_rd_data[0][15:0];
  assign rsqrt_data_valid = out_rd_valid && nl_enable && (nl_func_select == 3'd4);

  // LUT Unit Instance
  tpu_lut_unit #(
    .DATA_WIDTH(16),
    .LUT_DEPTH(256),
    .INTERP_BITS(8),
    .ENABLE_INTERP(1),
    .NUM_LUTS(4)
  ) u_lut_unit (
    .clk(clk),
    .rst_n(rst_n),
    .func_select(nl_func_select),
    .enable(nl_enable),
    .bypass(nl_bypass),
    .data_in(lut_data_in),
    .data_valid(lut_data_valid),
    .data_ready(lut_data_ready),
    .data_out(lut_data_out),
    .data_out_valid(lut_data_out_valid),
    .lut_wr_en(nl_lut_wr_en),
    .lut_wr_addr(nl_lut_wr_addr),
    .lut_wr_data(nl_lut_wr_data),
    .lut_select(nl_lut_select),
    .ops_count(lut_ops_count),
    .cycles_count(lut_cycles_count)
  );

  // RSQRT Unit Instance
  tpu_rsqrt_unit #(
    .DATA_WIDTH(16),
    .LUT_DEPTH(256),
    .NUM_ITERATIONS(2),
    .ENABLE_SPECIAL_CASES(1)
  ) u_rsqrt_unit (
    .clk(clk),
    .rst_n(rst_n),
    .enable(nl_enable),
    .data_in(rsqrt_data_in),
    .data_valid(rsqrt_data_valid),
    .data_ready(rsqrt_data_ready),
    .data_out(rsqrt_data_out),
    .data_out_valid(rsqrt_data_out_valid),
    .special_case(rsqrt_special_case),
    .ops_count(rsqrt_ops_count),
    .newton_iters(rsqrt_newton_iters)
  );

  // Nonlinear status register
  logic nl_busy;
  logic nl_done;
  logic nl_done_d;

  assign nl_busy = lut_data_valid || rsqrt_data_valid;
  assign nl_done = lut_data_out_valid || rsqrt_data_out_valid;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      nl_done_d <= 1'b0;
      reg_nl_perf_cnt <= '0;
    end else begin
      nl_done_d <= nl_done;
      // Count completed nonlinear operations
      if (nl_done && !nl_done_d) begin
        reg_nl_perf_cnt <= reg_nl_perf_cnt + 1;
      end
    end
  end

  // Status register assembly
  assign reg_nl_status = {lut_ops_count[15:0],
                          14'b0,
                          nl_done,
                          nl_busy};

  // ============================================================
  // Command Queue (Phase 3)
  // ============================================================
  // Parsed command fields from queue (directly usable by controller in future)
  logic [7:0]  cmdq_opcode;
  logic        cmdq_chain;
  logic        cmdq_irq_en;
  logic        cmdq_dma_en;
  logic        cmdq_pack_w;
  logic        cmdq_acc81_en;
  logic        cmdq_dataflow;
  logic [31:0] cmdq_out_base;
  logic [31:0] cmdq_act_base;
  logic [15:0] cmdq_wgt_base;
  logic [7:0]  cmdq_k_tile;
  logic [3:0]  cmdq_m_tile_sel;
  logic [3:0]  cmdq_n_tile_sel;

  tpu_command_queue #(
    .QUEUE_DEPTH(8),
    .DESC_WIDTH(128)
  ) u_command_queue (
    .clk(clk),
    .rst_n(rst_n),
    // Write interface
    .cmd_push(cmdq_push),
    .cmd_data(cmdq_data),
    .cmd_full(cmdq_full),
    .cmd_almost_full(cmdq_almost_full),
    // Execution interface
    .exec_valid(cmdq_exec_valid),
    .exec_cmd(cmdq_exec_cmd),
    .exec_done(cmdq_exec_done),
    .exec_error(cmdq_exec_error),
    // Status and control
    .flush(cmdq_flush),
    .queue_empty(cmdq_empty),
    .queue_count(cmdq_count),
    .irq(cmdq_irq),
    .error_flag(cmdq_error_flag),
    .clear_error(cmdq_clear_error),
    // Parsed fields
    .cmd_opcode(cmdq_opcode),
    .cmd_chain(cmdq_chain),
    .cmd_irq_en(cmdq_irq_en),
    .cmd_dma_en(cmdq_dma_en),
    .cmd_pack_w(cmdq_pack_w),
    .cmd_acc81_en(cmdq_acc81_en),
    .cmd_dataflow(cmdq_dataflow),
    .cmd_out_base(cmdq_out_base),
    .cmd_act_base(cmdq_act_base),
    .cmd_wgt_base(cmdq_wgt_base),
    .cmd_k_tile(cmdq_k_tile),
    .cmd_m_tile_sel(cmdq_m_tile_sel),
    .cmd_n_tile_sel(cmdq_n_tile_sel)
  );

endmodule
