// TPU Memory Controller with 8-Bank Architecture (v2)
// ====================================================
// Coordinates memory access between CPU, DMA, and systolic array using
// 8-bank weight and activation buffers for high-bandwidth operation.
//
// Version 2 Changes:
//   - Added DMA write interface (dma_wgt_*, dma_act_*)
//   - Added controller read interface (ctrl_wgt_rd_*, ctrl_act_rd_*)
//   - DMA takes priority over CPU for writes
//
// Features:
//   - Integrates 8-bank weight buffer (16 banks with double-buffering)
//   - Integrates 8-bank activation buffer (column-major)
//   - Bank arbiter for conflict-free access
//   - Conflict counting for performance monitoring
//   - CPU/DMA write interface for weight/activation loading
//   - Systolic array data feeding
//   - Output accumulator storage
//
// Author: Tritone Project (Phase 1.2-1.4 Upgrade - v2)

module tpu_memory_controller_banked_v2 #(
  parameter int ARRAY_SIZE = 8,
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32,
  parameter int MAX_K = 256,
  parameter int NUM_BANKS = 8,
  parameter int ADDR_WIDTH = 16
)(
  input  logic                                     clk,
  input  logic                                     rst_n,

  // ============================================================
  // CPU Interface (AXI-Lite style)
  // ============================================================
  input  logic                                     cpu_sel,
  input  logic                                     cpu_wen,
  input  logic                                     cpu_ren,
  input  logic [31:0]                              cpu_addr,
  input  logic [31:0]                              cpu_wdata,
  output logic [31:0]                              cpu_rdata,
  output logic                                     cpu_ready,

  // ============================================================
  // DMA Write Interface (NEW in v2)
  // ============================================================
  input  logic                                     dma_busy,         // DMA priority flag
  input  logic                                     dma_wgt_wr_en,    // Weight write enable
  input  logic [15:0]                              dma_wgt_wr_addr,  // Weight address
  input  logic [31:0]                              dma_wgt_wr_data,  // Weight data (packed)
  input  logic                                     dma_act_wr_en,    // Activation write enable
  input  logic [15:0]                              dma_act_wr_addr,  // Activation address
  input  logic [31:0]                              dma_act_wr_data,  // Activation data (packed)

  // ============================================================
  // Controller Read Interface (NEW in v2)
  // ============================================================
  input  logic                                     ctrl_wgt_rd_en,
  input  logic [ADDR_WIDTH-1:0]                    ctrl_wgt_rd_addr,
  output logic [ARRAY_SIZE-1:0][1:0]               ctrl_wgt_rd_data,
  output logic                                     ctrl_wgt_rd_valid,
  input  logic                                     ctrl_act_rd_en,
  input  logic [ADDR_WIDTH-1:0]                    ctrl_act_rd_addr,
  output logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] ctrl_act_rd_data,
  output logic                                     ctrl_act_rd_valid,

  // ============================================================
  // Control Interface (from TPU controller)
  // ============================================================
  input  logic                                     load_weights_start,
  input  logic [$clog2(MAX_K)-1:0]                 load_weights_count,
  output logic                                     load_weights_done,

  input  logic                                     load_acts_start,
  input  logic [$clog2(MAX_K)-1:0]                 load_acts_count,
  output logic                                     load_acts_done,

  input  logic                                     compute_start,
  input  logic [$clog2(MAX_K)-1:0]                 compute_k,
  output logic                                     compute_done,

  input  logic                                     store_results_start,
  output logic                                     store_results_done,

  input  logic                                     swap_weight_banks,
  input  logic                                     swap_act_banks,

  // ============================================================
  // Systolic Array Interface
  // ============================================================
  output logic [ARRAY_SIZE-1:0][1:0]               array_weights,
  output logic                                     array_weight_load,
  output logic [$clog2(ARRAY_SIZE)-1:0]            array_weight_row,

  output logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] array_activations,
  output logic                                     array_act_valid,

  input  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] array_outputs,
  input  logic                                     array_output_valid,

  // ============================================================
  // Performance Counter Interface
  // ============================================================
  output logic [31:0]                              weight_bank_conflicts,
  output logic [31:0]                              act_bank_conflicts,
  output logic [31:0]                              total_bank_conflicts,
  input  logic                                     clear_conflict_counters
);

  // ============================================================
  // Address Decode
  // ============================================================
  // Memory map:
  //   0x0000 - 0x3FFF: Weight buffer (16KB)
  //   0x4000 - 0x5FFF: Activation buffer (8KB)
  //   0x6000 - 0x6FFF: Output buffer (4KB) - read only
  localparam logic [31:0] WEIGHT_BASE = 32'h0000;
  localparam logic [31:0] ACT_BASE    = 32'h4000;
  localparam logic [31:0] OUT_BASE    = 32'h6000;

  logic addr_is_weight, addr_is_act, addr_is_out;
  assign addr_is_weight = (cpu_addr >= WEIGHT_BASE) && (cpu_addr < ACT_BASE);
  assign addr_is_act    = (cpu_addr >= ACT_BASE) && (cpu_addr < OUT_BASE);
  assign addr_is_out    = (cpu_addr >= OUT_BASE);

  // ============================================================
  // DMA Data Unpacking (NEW in v2)
  // ============================================================
  // Convert 32-bit DMA data to array-sized format
  logic [ARRAY_SIZE-1:0][1:0] dma_wgt_unpacked;
  logic signed [ARRAY_SIZE-1:0][ACT_BITS-1:0] dma_act_unpacked;

  always_comb begin
    // Unpack weights: 32-bit word holds up to 16 weights (2 bits each)
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      if (i*2+1 < 32) begin
        dma_wgt_unpacked[i] = dma_wgt_wr_data[i*2 +: 2];
      end else begin
        dma_wgt_unpacked[i] = 2'b00;
      end
    end
    // Unpack activations: 32-bit word holds 2 activations (16 bits each)
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      if ((i+1)*ACT_BITS <= 32) begin
        dma_act_unpacked[i] = dma_act_wr_data[i*ACT_BITS +: ACT_BITS];
      end else begin
        dma_act_unpacked[i] = '0;
      end
    end
  end

  // ============================================================
  // Weight Buffer (8-Bank with Double-Buffering)
  // ============================================================
  // Unified write interface (muxed: DMA has priority over CPU)
  logic                            weight_unified_wr_en;
  logic [ADDR_WIDTH-1:0]           weight_unified_wr_addr;
  logic [ARRAY_SIZE-1:0][1:0]      weight_unified_wr_data;

  // Unified read interface (for systolic array)
  logic                            weight_unified_rd_en;
  logic [$clog2(MAX_K)-1:0]        weight_unified_rd_row;
  logic [ARRAY_SIZE-1:0][1:0]      weight_unified_rd_data;
  logic                            weight_unified_rd_valid;

  // Conflict signals
  logic                            weight_conflict_detected;
  logic [31:0]                     weight_conflict_count;

  // Multi-port interface signals (for DMA parallel access)
  logic [NUM_BANKS-1:0]                          mp_wgt_wr_en;
  logic [NUM_BANKS-1:0][ADDR_WIDTH-1:0]          mp_wgt_wr_addr;
  logic [NUM_BANKS-1:0][ARRAY_SIZE-1:0][1:0]     mp_wgt_wr_data;
  logic [NUM_BANKS-1:0]                          mp_wgt_rd_en;
  logic [NUM_BANKS-1:0][ADDR_WIDTH-1:0]          mp_wgt_rd_addr;
  logic [NUM_BANKS-1:0][ARRAY_SIZE-1:0][1:0]     mp_wgt_rd_data;
  logic [NUM_BANKS-1:0]                          mp_wgt_rd_valid;

  tpu_weight_buffer_banked #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .MAX_K(MAX_K),
    .NUM_BANKS(NUM_BANKS),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) u_weight_buffer_banked (
    .clk(clk),
    .rst_n(rst_n),
    .swap_banks(swap_weight_banks),

    // Multi-port interface (for DMA parallel access)
    .wr_en(mp_wgt_wr_en),
    .wr_addr(mp_wgt_wr_addr),
    .wr_data(mp_wgt_wr_data),
    .rd_en(mp_wgt_rd_en),
    .rd_addr(mp_wgt_rd_addr),
    .rd_data(mp_wgt_rd_data),
    .rd_valid(mp_wgt_rd_valid),

    // Unified interface (CPU + systolic)
    .unified_wr_en(weight_unified_wr_en),
    .unified_wr_addr(weight_unified_wr_addr),
    .unified_wr_data(weight_unified_wr_data),
    .unified_rd_en(weight_unified_rd_en),
    .unified_rd_row(weight_unified_rd_row),
    .unified_rd_data(weight_unified_rd_data),
    .unified_rd_valid(weight_unified_rd_valid),

    // Conflict reporting
    .conflict_detected(weight_conflict_detected),
    .conflict_bank(),
    .conflict_count(weight_conflict_count)
  );

  // ============================================================
  // Activation Buffer (8-Bank with Double-Buffering)
  // ============================================================
  // Unified write interface (muxed: DMA has priority over CPU)
  logic                                     act_unified_wr_en;
  logic [ADDR_WIDTH-1:0]                    act_unified_wr_addr;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      act_unified_wr_data;

  // Streaming interface (for systolic array)
  logic                                     act_stream_start;
  logic [$clog2(MAX_K)-1:0]                 act_stream_count;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      act_stream_data;
  logic                                     act_stream_valid;
  logic                                     act_stream_done;

  // Conflict signals
  logic                                     act_conflict_detected;
  logic [31:0]                              act_conflict_count;

  // Multi-port interface signals (for DMA parallel access)
  logic [NUM_BANKS-1:0]                                    mp_act_wr_en;
  logic [NUM_BANKS-1:0][ADDR_WIDTH-1:0]                    mp_act_wr_addr;
  logic [NUM_BANKS-1:0][ARRAY_SIZE-1:0][ACT_BITS-1:0]      mp_act_wr_data;
  logic [NUM_BANKS-1:0]                                    mp_act_rd_en;
  logic [NUM_BANKS-1:0][ADDR_WIDTH-1:0]                    mp_act_rd_addr;
  logic [NUM_BANKS-1:0][ARRAY_SIZE-1:0][ACT_BITS-1:0]      mp_act_rd_data;
  logic [NUM_BANKS-1:0]                                    mp_act_rd_valid;

  tpu_activation_buffer_banked #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .MAX_K(MAX_K),
    .NUM_BANKS(NUM_BANKS),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) u_act_buffer_banked (
    .clk(clk),
    .rst_n(rst_n),
    .swap_banks(swap_act_banks),

    // Multi-port interface (for DMA parallel access)
    .wr_en(mp_act_wr_en),
    .wr_addr(mp_act_wr_addr),
    .wr_data(mp_act_wr_data),
    .rd_en(mp_act_rd_en),
    .rd_addr(mp_act_rd_addr),
    .rd_data(mp_act_rd_data),
    .rd_valid(mp_act_rd_valid),

    // Unified write interface
    .unified_wr_en(act_unified_wr_en),
    .unified_wr_addr(act_unified_wr_addr),
    .unified_wr_data(act_unified_wr_data),

    // Streaming read interface
    .stream_start(act_stream_start),
    .stream_count(act_stream_count),
    .stream_data(act_stream_data),
    .stream_valid(act_stream_valid),
    .stream_done(act_stream_done),

    // Conflict reporting
    .conflict_detected(act_conflict_detected),
    .conflict_bank(),
    .conflict_count(act_conflict_count)
  );

  // ============================================================
  // Output Buffer (simple single-port SRAM)
  // ============================================================
  localparam int OUT_DEPTH = 256;
  logic signed [ARRAY_SIZE-1:0][ACC_BITS-1:0] output_buffer [OUT_DEPTH];
  logic [$clog2(OUT_DEPTH)-1:0] output_wr_ptr;
  logic [$clog2(OUT_DEPTH)-1:0] output_rd_ptr;

  // ============================================================
  // DMA/CPU Write Mux (NEW in v2 - DMA has priority)
  // ============================================================
  logic                       use_dma_wgt;
  logic                       use_dma_act;

  assign use_dma_wgt = dma_busy && dma_wgt_wr_en;
  assign use_dma_act = dma_busy && dma_act_wr_en;

  // CPU packing state
  localparam int WEIGHTS_PER_WORD = 16;
  localparam int WEIGHT_WORDS_NEEDED = (ARRAY_SIZE + WEIGHTS_PER_WORD - 1) / WEIGHTS_PER_WORD;
  localparam int ACTS_PER_WORD = 2;
  localparam int ACT_WORDS_NEEDED = (ARRAY_SIZE + ACTS_PER_WORD - 1) / ACTS_PER_WORD;

  logic [$clog2(WEIGHT_WORDS_NEEDED+1)-1:0] weight_pack_cnt;
  logic [ARRAY_SIZE-1:0][1:0] weight_pack_reg;
  logic [$clog2(ACT_WORDS_NEEDED+1)-1:0] act_pack_cnt;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_pack_reg;

  // CPU-driven write signals
  logic                       cpu_wgt_wr_en;
  logic [ADDR_WIDTH-1:0]      cpu_wgt_wr_addr;
  logic [ARRAY_SIZE-1:0][1:0] cpu_wgt_wr_data;
  logic                       cpu_act_wr_en;
  logic [ADDR_WIDTH-1:0]      cpu_act_wr_addr;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0] cpu_act_wr_data;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cpu_wgt_wr_en <= 1'b0;
      cpu_act_wr_en <= 1'b0;
      weight_pack_cnt <= '0;
      act_pack_cnt <= '0;
      cpu_ready <= 1'b1;
      weight_pack_reg <= '0;
      act_pack_reg <= '0;
    end else begin
      cpu_wgt_wr_en <= 1'b0;
      cpu_act_wr_en <= 1'b0;

      if (cpu_sel && cpu_wen && !use_dma_wgt && !use_dma_act) begin
        cpu_ready <= 1'b1;

        if (addr_is_weight) begin
          for (int i = 0; i < WEIGHTS_PER_WORD && (weight_pack_cnt * WEIGHTS_PER_WORD + i) < ARRAY_SIZE; i++) begin
            weight_pack_reg[weight_pack_cnt * WEIGHTS_PER_WORD + i] <= cpu_wdata[i*2 +: 2];
          end

          if (weight_pack_cnt == WEIGHT_WORDS_NEEDED - 1) begin
            cpu_wgt_wr_en <= 1'b1;
            cpu_wgt_wr_addr <= cpu_addr[ADDR_WIDTH+1:2];
            cpu_wgt_wr_data <= weight_pack_reg;
            weight_pack_cnt <= '0;
          end else begin
            weight_pack_cnt <= weight_pack_cnt + 1;
          end
        end else if (addr_is_act) begin
          for (int i = 0; i < ACTS_PER_WORD && (act_pack_cnt * ACTS_PER_WORD + i) < ARRAY_SIZE; i++) begin
            act_pack_reg[act_pack_cnt * ACTS_PER_WORD + i] <= cpu_wdata[i*16 +: 16];
          end

          if (act_pack_cnt == ACT_WORDS_NEEDED - 1) begin
            cpu_act_wr_en <= 1'b1;
            cpu_act_wr_addr <= cpu_addr[ADDR_WIDTH+2:3];
            cpu_act_wr_data <= act_pack_reg;
            act_pack_cnt <= '0;
          end else begin
            act_pack_cnt <= act_pack_cnt + 1;
          end
        end
      end else if (cpu_sel && cpu_ren) begin
        cpu_ready <= 1'b1;

        if (addr_is_out) begin
          output_rd_ptr <= cpu_addr[$clog2(OUT_DEPTH)+1:2];
        end
      end else if (use_dma_wgt || use_dma_act) begin
        // DMA is active - stall CPU
        cpu_ready <= 1'b0;
      end
    end
  end

  // Mux between DMA and CPU for unified write interface
  always_comb begin
    if (use_dma_wgt) begin
      weight_unified_wr_en = 1'b1;
      weight_unified_wr_addr = dma_wgt_wr_addr[ADDR_WIDTH-1:0];
      weight_unified_wr_data = dma_wgt_unpacked;
    end else begin
      weight_unified_wr_en = cpu_wgt_wr_en;
      weight_unified_wr_addr = cpu_wgt_wr_addr;
      weight_unified_wr_data = cpu_wgt_wr_data;
    end

    if (use_dma_act) begin
      act_unified_wr_en = 1'b1;
      act_unified_wr_addr = dma_act_wr_addr[ADDR_WIDTH-1:0];
      act_unified_wr_data = dma_act_unpacked;
    end else begin
      act_unified_wr_en = cpu_act_wr_en;
      act_unified_wr_addr = cpu_act_wr_addr;
      act_unified_wr_data = cpu_act_wr_data;
    end
  end

  // Multi-port interfaces unused for now (reserved for future burst DMA)
  assign mp_wgt_wr_en = '0;
  assign mp_wgt_wr_addr = '0;
  assign mp_wgt_wr_data = '0;
  assign mp_wgt_rd_en = '0;
  assign mp_wgt_rd_addr = '0;
  assign mp_act_wr_en = '0;
  assign mp_act_wr_addr = '0;
  assign mp_act_wr_data = '0;
  assign mp_act_rd_en = '0;
  assign mp_act_rd_addr = '0;

  // CPU read data
  assign cpu_rdata = output_buffer[output_rd_ptr][0];

  // ============================================================
  // Weight Loading FSM (for systolic array) - Declaration moved before use
  // ============================================================
  typedef enum logic [1:0] {
    WL_IDLE,
    WL_LOADING,
    WL_DONE
  } weight_load_state_t;

  weight_load_state_t wl_state;
  logic [$clog2(ARRAY_SIZE)-1:0] wl_row_cnt;
  logic [$clog2(MAX_K)-1:0] wl_k_cnt;
  logic [$clog2(MAX_K)-1:0] wl_k_end;

  // ============================================================
  // Controller Read Interface (NEW in v2)
  // ============================================================
  // Provide direct read access for the systolic controller
  // Weight reads go through the unified interface
  // Activation reads can use streaming or direct access

  logic ctrl_wgt_rd_en_d;
  logic ctrl_act_rd_en_d;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ctrl_wgt_rd_en_d <= 1'b0;
      ctrl_act_rd_en_d <= 1'b0;
    end else begin
      ctrl_wgt_rd_en_d <= ctrl_wgt_rd_en;
      ctrl_act_rd_en_d <= ctrl_act_rd_en;
    end
  end

  // Weight controller read - use unified read interface
  assign weight_unified_rd_en = ctrl_wgt_rd_en || (wl_state == WL_LOADING);
  assign weight_unified_rd_row = ctrl_wgt_rd_en ? ctrl_wgt_rd_addr[$clog2(MAX_K)-1:0] : wl_k_cnt;
  assign ctrl_wgt_rd_data = weight_unified_rd_data;
  assign ctrl_wgt_rd_valid = ctrl_wgt_rd_en_d && weight_unified_rd_valid;

  // Activation controller read - use streaming interface data
  assign ctrl_act_rd_data = act_stream_data;
  assign ctrl_act_rd_valid = ctrl_act_rd_en_d && act_stream_valid;

  // ============================================================
  // Weight Loading FSM Logic
  // ============================================================

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wl_state <= WL_IDLE;
      wl_row_cnt <= '0;
      wl_k_cnt <= '0;
      array_weight_load <= 1'b0;
    end else begin
      array_weight_load <= 1'b0;

      case (wl_state)
        WL_IDLE: begin
          if (load_weights_start) begin
            wl_state <= WL_LOADING;
            wl_row_cnt <= '0;
            wl_k_cnt <= '0;
            wl_k_end <= load_weights_count;
          end
        end

        WL_LOADING: begin
          if (weight_unified_rd_valid && !ctrl_wgt_rd_en) begin
            array_weight_load <= 1'b1;
            array_weight_row <= wl_row_cnt;
            array_weights <= weight_unified_rd_data;

            if (wl_row_cnt == ARRAY_SIZE - 1) begin
              wl_row_cnt <= '0;
              if (wl_k_cnt >= wl_k_end) begin
                wl_state <= WL_DONE;
              end else begin
                wl_k_cnt <= wl_k_cnt + 1;
              end
            end else begin
              wl_row_cnt <= wl_row_cnt + 1;
            end
          end
        end

        WL_DONE: begin
          wl_state <= WL_IDLE;
        end
      endcase
    end
  end

  assign load_weights_done = (wl_state == WL_DONE);

  // ============================================================
  // Activation Streaming
  // ============================================================
  assign act_stream_start = compute_start;
  assign act_stream_count = compute_k;
  assign array_activations = act_stream_data;
  assign array_act_valid = act_stream_valid;
  assign compute_done = act_stream_done;

  assign load_acts_done = 1'b1;  // Simplified: CPU/DMA writes complete the load

  // ============================================================
  // Output Storage
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      output_wr_ptr <= '0;
    end else if (store_results_start) begin
      output_wr_ptr <= '0;
    end else if (array_output_valid) begin
      output_buffer[output_wr_ptr] <= array_outputs;
      output_wr_ptr <= output_wr_ptr + 1;
    end
  end

  assign store_results_done = 1'b1;  // Simplified

  // ============================================================
  // Conflict Counter Aggregation
  // ============================================================
  logic [31:0] total_conflict_count_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      total_conflict_count_reg <= '0;
    end else if (clear_conflict_counters) begin
      total_conflict_count_reg <= '0;
    end else begin
      if (weight_conflict_detected || act_conflict_detected) begin
        total_conflict_count_reg <= total_conflict_count_reg + 1;
      end
    end
  end

  assign weight_bank_conflicts = weight_conflict_count;
  assign act_bank_conflicts = act_conflict_count;
  assign total_bank_conflicts = total_conflict_count_reg;

endmodule
