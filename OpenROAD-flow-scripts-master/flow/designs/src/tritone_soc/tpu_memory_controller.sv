// TPU Memory Controller
// =======================
// Coordinates memory access between CPU, buffers, and systolic array.
// Handles DMA-style transfers and buffer management.
//
// Features:
//   - CPU write interface for weight/activation loading
//   - Systolic array data feeding
//   - Double-buffer management
//   - Output accumulator storage
//
// Author: Tritone Project

module tpu_memory_controller #(
  parameter int ARRAY_SIZE = 8,
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32,
  parameter int MAX_K = 256,
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
  input  logic                                     array_output_valid
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
  // Weight Buffer Interface
  // ============================================================
  logic                            weight_wr_en;
  logic [ADDR_WIDTH-1:0]           weight_wr_addr;
  logic [ARRAY_SIZE-1:0][1:0]      weight_wr_data;
  logic                            weight_rd_en;
  logic [$clog2(MAX_K)-1:0]        weight_rd_row;
  logic [ARRAY_SIZE-1:0][1:0]      weight_rd_data;
  logic                            weight_rd_valid;

  tpu_weight_buffer #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .MAX_K(MAX_K),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) u_weight_buffer (
    .clk(clk),
    .rst_n(rst_n),
    .bank_select(1'b0),
    .swap_banks(swap_weight_banks),
    .wr_en(weight_wr_en),
    .wr_addr(weight_wr_addr),
    .wr_data(weight_wr_data),
    .rd_en(weight_rd_en),
    .rd_row(weight_rd_row),
    .rd_data(weight_rd_data),
    .rd_valid(weight_rd_valid)
  );

  // ============================================================
  // Activation Buffer Interface
  // ============================================================
  logic                                     act_wr_en;
  logic [ADDR_WIDTH-1:0]                    act_wr_addr;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      act_wr_data;
  logic                                     act_stream_start;
  logic [$clog2(MAX_K)-1:0]                 act_stream_count;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0]      act_stream_data;
  logic                                     act_stream_valid;
  logic                                     act_stream_done;

  tpu_activation_buffer #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .MAX_K(MAX_K),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) u_act_buffer (
    .clk(clk),
    .rst_n(rst_n),
    .bank_select(1'b0),
    .swap_banks(swap_act_banks),
    .wr_en(act_wr_en),
    .wr_addr(act_wr_addr),
    .wr_data(act_wr_data),
    .stream_start(act_stream_start),
    .stream_count(act_stream_count),
    .stream_data(act_stream_data),
    .stream_valid(act_stream_valid),
    .stream_done(act_stream_done)
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
  // For simplicity, assume 32-bit writes pack into larger vectors

  logic [3:0] weight_pack_cnt;
  logic [ARRAY_SIZE-1:0][1:0] weight_pack_reg;

  logic [1:0] act_pack_cnt;
  logic [ARRAY_SIZE-1:0][ACT_BITS-1:0] act_pack_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      weight_wr_en <= 1'b0;
      act_wr_en <= 1'b0;
      weight_pack_cnt <= '0;
      act_pack_cnt <= '0;
      cpu_ready <= 1'b1;
    end else begin
      weight_wr_en <= 1'b0;
      act_wr_en <= 1'b0;

      if (cpu_sel && cpu_wen) begin
        cpu_ready <= 1'b1;

        if (addr_is_weight) begin
          // Pack 16 weights per 32-bit word (2 bits each)
          weight_pack_reg[weight_pack_cnt*16 +: 16] <= cpu_wdata[31:0];
          if (weight_pack_cnt == (ARRAY_SIZE/16 - 1)) begin
            weight_wr_en <= 1'b1;
            weight_wr_addr <= cpu_addr[ADDR_WIDTH+1:2];
            weight_wr_data <= weight_pack_reg;
            weight_pack_cnt <= '0;
          end else begin
            weight_pack_cnt <= weight_pack_cnt + 1;
          end
        end else if (addr_is_act) begin
          // Pack 2 activations per 32-bit word (16 bits each)
          act_pack_reg[act_pack_cnt*2 +: 2] <= {{(ACT_BITS-16){cpu_wdata[31]}}, cpu_wdata[31:16],
                                                 {(ACT_BITS-16){cpu_wdata[15]}}, cpu_wdata[15:0]};
          if (act_pack_cnt == (ARRAY_SIZE/2 - 1)) begin
            act_wr_en <= 1'b1;
            act_wr_addr <= cpu_addr[ADDR_WIDTH+2:3];
            act_wr_data <= act_pack_reg;
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

  // CPU read data (simplified - would need proper output muxing)
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
      weight_rd_en <= 1'b0;
      array_weight_load <= 1'b0;
    end else begin
      weight_rd_en <= 1'b0;
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
          weight_rd_en <= 1'b1;
          weight_rd_row <= wl_k_cnt;

          if (weight_rd_valid) begin
            array_weight_load <= 1'b1;
            array_weight_row <= wl_row_cnt;
            array_weights <= weight_rd_data;

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

endmodule
