// TPU Memory Controller with 8-Bank Architecture
// ================================================
// Coordinates memory access between CPU, DMA, and systolic array using
// 8-bank weight and activation buffers for high-bandwidth operation.
//
// Features:
//   - Integrates 8-bank weight buffer (16 banks with double-buffering)
//   - Integrates 8-bank activation buffer (column-major)
//   - Bank arbiter for conflict-free access
//   - Conflict counting for performance monitoring
//   - CPU write interface for weight/activation loading
//   - Systolic array data feeding
//   - Output accumulator storage
//
// Author: Tritone Project (Phase 1.2-1.4 Upgrade)

module tpu_memory_controller_banked #(
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
  // Weight Buffer (8-Bank with Double-Buffering)
  // ============================================================
  // Unified write interface (from CPU)
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

  tpu_weight_buffer_banked #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .MAX_K(MAX_K),
    .NUM_BANKS(NUM_BANKS),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) u_weight_buffer_banked (
    .clk(clk),
    .rst_n(rst_n),
    .swap_banks(swap_weight_banks),

    // Multi-port interface (unused for now - for DMA)
    .wr_en('0),
    .wr_addr('0),
    .wr_data('0),
    .rd_en('0),
    .rd_addr('0),
    .rd_data(),
    .rd_valid(),

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
  // Unified write interface (from CPU)
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

    // Multi-port interface (unused for now - for DMA)
    .wr_en('0),
    .wr_addr('0),
    .wr_data('0),
    .rd_en('0),
    .rd_addr('0),
    .rd_data(),
    .rd_valid(),

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
  // CPU Write Logic
  // ============================================================
  // Pack CPU writes into weight/activation format
  // Weight packing: 32-bit word holds 16 weights at 2 bits each
  // For ARRAY_SIZE <= 16: single write fills entire row
  // For ARRAY_SIZE > 16: multiple writes needed
  localparam int WEIGHTS_PER_WORD = 16;  // 32 bits / 2 bits per weight
  localparam int WEIGHT_WORDS_NEEDED = (ARRAY_SIZE + WEIGHTS_PER_WORD - 1) / WEIGHTS_PER_WORD;

  // Activation packing: 32-bit word holds 2 activations at 16 bits each
  localparam int ACTS_PER_WORD = 2;
  localparam int ACT_WORDS_NEEDED = (ARRAY_SIZE + ACTS_PER_WORD - 1) / ACTS_PER_WORD;

  logic [$clog2(WEIGHT_WORDS_NEEDED+1)-1:0] weight_pack_cnt;
  logic [ARRAY_SIZE-1:0][1:0] weight_pack_reg;

  logic [$clog2(ACT_WORDS_NEEDED+1)-1:0] act_pack_cnt;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_pack_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weight_unified_wr_en <= 1'b0;
      act_unified_wr_en <= 1'b0;
      weight_pack_cnt <= '0;
      act_pack_cnt <= '0;
      cpu_ready <= 1'b1;
      weight_pack_reg <= '0;
      act_pack_reg <= '0;
    end else begin
      weight_unified_wr_en <= 1'b0;
      act_unified_wr_en <= 1'b0;

      if (cpu_sel && cpu_wen) begin
        cpu_ready <= 1'b1;

        if (addr_is_weight) begin
          // Pack weights from 32-bit words
          // Each 32-bit word contains up to 16 weights (2 bits each)
          for (int i = 0; i < WEIGHTS_PER_WORD && (weight_pack_cnt * WEIGHTS_PER_WORD + i) < ARRAY_SIZE; i++) begin
            weight_pack_reg[weight_pack_cnt * WEIGHTS_PER_WORD + i] <= cpu_wdata[i*2 +: 2];
          end

          if (weight_pack_cnt == WEIGHT_WORDS_NEEDED - 1) begin
            weight_unified_wr_en <= 1'b1;
            weight_unified_wr_addr <= cpu_addr[ADDR_WIDTH+1:2];
            weight_unified_wr_data <= weight_pack_reg;
            weight_pack_cnt <= '0;
          end else begin
            weight_pack_cnt <= weight_pack_cnt + 1;
          end
        end else if (addr_is_act) begin
          // Pack activations from 32-bit words
          // Each 32-bit word contains 2 activations (16 bits each)
          for (int i = 0; i < ACTS_PER_WORD && (act_pack_cnt * ACTS_PER_WORD + i) < ARRAY_SIZE; i++) begin
            act_pack_reg[act_pack_cnt * ACTS_PER_WORD + i] <= cpu_wdata[i*16 +: 16];
          end

          if (act_pack_cnt == ACT_WORDS_NEEDED - 1) begin
            act_unified_wr_en <= 1'b1;
            act_unified_wr_addr <= cpu_addr[ADDR_WIDTH+2:3];
            act_unified_wr_data <= act_pack_reg;
            act_pack_cnt <= '0;
          end else begin
            act_pack_cnt <= act_pack_cnt + 1;
          end
        end
      end else if (cpu_sel && cpu_ren) begin
        cpu_ready <= 1'b1;

        if (addr_is_out) begin
          // Read from output buffer
          output_rd_ptr <= cpu_addr[$clog2(OUT_DEPTH)+1:2];
        end
      end
    end
  end

  // CPU read data
  assign cpu_rdata = output_buffer[output_rd_ptr][0];

  // ============================================================
  // Weight Loading FSM (for systolic array)
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

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wl_state <= WL_IDLE;
      wl_row_cnt <= '0;
      wl_k_cnt <= '0;
      weight_unified_rd_en <= 1'b0;
      array_weight_load <= 1'b0;
    end else begin
      weight_unified_rd_en <= 1'b0;
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
          weight_unified_rd_en <= 1'b1;
          weight_unified_rd_row <= wl_k_cnt;

          if (weight_unified_rd_valid) begin
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

  assign load_acts_done = 1'b1;  // Simplified: CPU writes complete the load

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
