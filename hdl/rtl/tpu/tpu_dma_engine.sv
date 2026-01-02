// TPU DMA Engine
// ===============
// High-performance DMA engine for bulk data transfers between external memory
// and TPU internal buffers. Supports burst transfers and double-buffering.
//
// Features:
//   - AXI-Lite master interface for memory access
//   - Configurable burst length (up to 16 beats)
//   - Three transfer modes: weight prefetch, activation prefetch, result writeback
//   - Double-buffer support for compute/data overlap
//   - Transfer status and byte counting
//   - Interrupt on completion
//
// Register Interface (from tpu_top):
//   0x030: DMA_SRC_ADDR  - Source address in external memory
//   0x034: DMA_DST_ADDR  - Destination address in buffer/external memory
//   0x038: DMA_LEN       - Transfer length in bytes
//   0x03C: DMA_CTRL      - [0]=start, [1]=direction (0=read, 1=write), [3:2]=mode
//   0x040: DMA_STATUS    - [0]=busy, [1]=done, [2]=error, [31:16]=bytes transferred
//
// Author: Tritone Project (Phase 2.1 Upgrade)

module tpu_dma_engine #(
  parameter int ADDR_WIDTH = 32,          // Address width
  parameter int DATA_WIDTH = 32,          // Data width
  parameter int MAX_BURST_LEN = 16,       // Maximum burst length
  parameter int BUFFER_DEPTH = 64         // Internal FIFO depth
)(
  input  logic                    clk,
  input  logic                    rst_n,

  // ============================================================
  // Control Interface (from TPU top)
  // ============================================================
  input  logic                    start,          // Start transfer (pulse)
  input  logic [ADDR_WIDTH-1:0]   src_addr,       // Source address
  input  logic [ADDR_WIDTH-1:0]   dst_addr,       // Destination address
  input  logic [15:0]             transfer_len,   // Length in bytes
  input  logic                    direction,      // 0=read (ext->buf), 1=write (buf->ext)
  input  logic [1:0]              mode,           // 00=weight, 01=activation, 10=output

  output logic                    busy,           // Transfer in progress
  output logic                    done,           // Transfer complete (pulse)
  output logic                    error,          // Error occurred
  output logic [31:0]             bytes_transferred,

  // ============================================================
  // AXI-Lite Master Interface (to external memory)
  // ============================================================
  // Write Address Channel
  output logic                    m_axi_awvalid,
  input  logic                    m_axi_awready,
  output logic [ADDR_WIDTH-1:0]   m_axi_awaddr,
  output logic [7:0]              m_axi_awlen,    // Burst length - 1
  output logic [2:0]              m_axi_awsize,   // Bytes per beat (log2)
  output logic [1:0]              m_axi_awburst,  // Burst type (INCR)

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
  output logic [7:0]              m_axi_arlen,    // Burst length - 1
  output logic [2:0]              m_axi_arsize,   // Bytes per beat (log2)
  output logic [1:0]              m_axi_arburst,  // Burst type (INCR)

  // Read Data Channel
  input  logic                    m_axi_rvalid,
  output logic                    m_axi_rready,
  input  logic [DATA_WIDTH-1:0]   m_axi_rdata,
  input  logic [1:0]              m_axi_rresp,
  input  logic                    m_axi_rlast,

  // ============================================================
  // Buffer Interface (to internal TPU buffers)
  // ============================================================
  // Weight buffer write
  output logic                    wgt_buf_wr_en,
  output logic [15:0]             wgt_buf_wr_addr,
  output logic [DATA_WIDTH-1:0]   wgt_buf_wr_data,

  // Activation buffer write
  output logic                    act_buf_wr_en,
  output logic [15:0]             act_buf_wr_addr,
  output logic [DATA_WIDTH-1:0]   act_buf_wr_data,

  // Output buffer read
  output logic                    out_buf_rd_en,
  output logic [15:0]             out_buf_rd_addr,
  input  logic [DATA_WIDTH-1:0]   out_buf_rd_data,
  input  logic                    out_buf_rd_valid
);

  // ============================================================
  // Constants
  // ============================================================
  localparam int BYTES_PER_BEAT = DATA_WIDTH / 8;
  localparam int BEAT_ADDR_BITS = $clog2(BYTES_PER_BEAT);

  // AXI constants
  localparam logic [2:0] AXI_SIZE = BEAT_ADDR_BITS[2:0];  // log2(bytes per beat)
  localparam logic [1:0] AXI_BURST_INCR = 2'b01;

  // ============================================================
  // State Machine
  // ============================================================
  typedef enum logic [3:0] {
    S_IDLE,
    S_CALC_BURST,
    S_READ_ADDR,
    S_READ_DATA,
    S_WRITE_ADDR,
    S_WRITE_DATA,
    S_WRITE_RESP,
    S_BUFFER_WRITE,
    S_BUFFER_READ,
    S_DONE,
    S_ERROR
  } dma_state_t;

  dma_state_t state, next_state;

  // ============================================================
  // Transfer Tracking
  // ============================================================
  logic [ADDR_WIDTH-1:0] current_src_addr;
  logic [ADDR_WIDTH-1:0] current_dst_addr;
  logic [15:0] bytes_remaining;
  logic [31:0] bytes_transferred_reg;
  logic [15:0] buffer_addr;

  // Burst calculation
  logic [7:0] current_burst_len;  // Beats in current burst - 1
  logic [7:0] beat_count;         // Current beat within burst

  // Mode registers
  logic direction_reg;
  logic [1:0] mode_reg;

  // ============================================================
  // Burst Length Calculation
  // ============================================================
  // Calculate optimal burst length based on remaining bytes and alignment
  logic [15:0] bytes_this_burst;
  logic [7:0] beats_this_burst;

  always_comb begin
    // Maximum bytes in this burst
    if (bytes_remaining >= MAX_BURST_LEN * BYTES_PER_BEAT) begin
      bytes_this_burst = MAX_BURST_LEN * BYTES_PER_BEAT;
    end else begin
      bytes_this_burst = bytes_remaining;
    end

    // Convert to beats (round up)
    beats_this_burst = (bytes_this_burst + BYTES_PER_BEAT - 1) / BYTES_PER_BEAT;

    // AXI burst length is beats - 1
    if (beats_this_burst > 0) begin
      current_burst_len = beats_this_burst - 1;
    end else begin
      current_burst_len = 0;
    end
  end

  // ============================================================
  // State Machine - Next State Logic
  // ============================================================
  always_comb begin
    next_state = state;

    case (state)
      S_IDLE: begin
        if (start) begin
          next_state = S_CALC_BURST;
        end
      end

      S_CALC_BURST: begin
        if (bytes_remaining == 0) begin
          next_state = S_DONE;
        end else if (direction_reg == 1'b0) begin
          // Read from external memory
          next_state = S_READ_ADDR;
        end else begin
          // Write to external memory - first read from buffer
          next_state = S_BUFFER_READ;
        end
      end

      S_READ_ADDR: begin
        if (m_axi_arvalid && m_axi_arready) begin
          next_state = S_READ_DATA;
        end
      end

      S_READ_DATA: begin
        // Buffer writes happen during each beat (see Buffer Write Outputs section)
        // On last beat, check if more bursts needed or if we're done
        if (m_axi_rvalid && m_axi_rready) begin
          if (m_axi_rlast) begin
            // Calculate if this was the final burst (use combinational check)
            // bytes_remaining will be updated next cycle, so check current value
            if (bytes_remaining <= ((current_burst_len + 1) * BYTES_PER_BEAT)) begin
              next_state = S_DONE;  // This burst completes the transfer
            end else begin
              next_state = S_CALC_BURST;  // More bursts needed
            end
          end
        end
        if (m_axi_rresp != 2'b00 && m_axi_rvalid) begin
          next_state = S_ERROR;
        end
      end

      S_BUFFER_WRITE: begin
        // Legacy state - kept for compatibility but not used in normal flow
        next_state = S_CALC_BURST;
      end

      S_BUFFER_READ: begin
        // Read from output buffer before writing to external
        if (out_buf_rd_valid) begin
          next_state = S_WRITE_ADDR;
        end
      end

      S_WRITE_ADDR: begin
        if (m_axi_awvalid && m_axi_awready) begin
          next_state = S_WRITE_DATA;
        end
      end

      S_WRITE_DATA: begin
        if (m_axi_wvalid && m_axi_wready && m_axi_wlast) begin
          next_state = S_WRITE_RESP;
        end
      end

      S_WRITE_RESP: begin
        if (m_axi_bvalid && m_axi_bready) begin
          if (m_axi_bresp == 2'b00) begin
            // Check if transfer is complete (same timing fix as read path)
            if (bytes_remaining <= ((current_burst_len + 1) * BYTES_PER_BEAT)) begin
              next_state = S_DONE;
            end else begin
              next_state = S_CALC_BURST;
            end
          end else begin
            next_state = S_ERROR;
          end
        end
      end

      S_DONE: begin
        next_state = S_IDLE;
      end

      S_ERROR: begin
        next_state = S_IDLE;
      end

      default: next_state = S_IDLE;
    endcase
  end

  // ============================================================
  // State Machine - Sequential Logic
  // ============================================================
  // Buffer write address tracking (increments each beat during read)
  logic [15:0] buffer_wr_addr;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= S_IDLE;
      current_src_addr <= '0;
      current_dst_addr <= '0;
      bytes_remaining <= '0;
      bytes_transferred_reg <= '0;
      buffer_addr <= '0;
      buffer_wr_addr <= '0;
      beat_count <= '0;
      direction_reg <= 1'b0;
      mode_reg <= 2'b00;
    end else begin
      state <= next_state;

      case (state)
        S_IDLE: begin
          if (start) begin
            current_src_addr <= src_addr;
            current_dst_addr <= dst_addr;
            bytes_remaining <= transfer_len;
            bytes_transferred_reg <= '0;
            buffer_addr <= dst_addr[15:0];  // Buffer address from lower bits
            buffer_wr_addr <= dst_addr[15:0];  // Initialize write address
            direction_reg <= direction;
            mode_reg <= mode;
            beat_count <= '0;
          end
        end

        S_READ_ADDR: begin
          // Address accepted, prepare for data
          if (m_axi_arvalid && m_axi_arready) begin
            beat_count <= '0;
          end
        end

        S_READ_DATA: begin
          if (m_axi_rvalid && m_axi_rready) begin
            beat_count <= beat_count + 1;

            // Increment buffer write address for each beat
            buffer_wr_addr <= buffer_wr_addr + BYTES_PER_BEAT;

            // Update tracking
            bytes_transferred_reg <= bytes_transferred_reg + BYTES_PER_BEAT;

            if (m_axi_rlast) begin
              // Update source address for next burst
              current_src_addr <= current_src_addr + ((current_burst_len + 1) * BYTES_PER_BEAT);
              // buffer_addr already updated via buffer_wr_addr
              buffer_addr <= buffer_wr_addr + BYTES_PER_BEAT;
              if (bytes_remaining >= ((current_burst_len + 1) * BYTES_PER_BEAT)) begin
                bytes_remaining <= bytes_remaining - ((current_burst_len + 1) * BYTES_PER_BEAT);
              end else begin
                bytes_remaining <= '0;
              end
            end
          end
        end

        S_BUFFER_READ: begin
          if (out_buf_rd_valid) begin
            beat_count <= '0;
          end
        end

        S_WRITE_DATA: begin
          if (m_axi_wvalid && m_axi_wready) begin
            beat_count <= beat_count + 1;
            buffer_wr_addr <= buffer_wr_addr + BYTES_PER_BEAT;
            bytes_transferred_reg <= bytes_transferred_reg + BYTES_PER_BEAT;

            if (m_axi_wlast) begin
              current_dst_addr <= current_dst_addr + ((current_burst_len + 1) * BYTES_PER_BEAT);
              buffer_addr <= buffer_wr_addr + BYTES_PER_BEAT;
              if (bytes_remaining >= ((current_burst_len + 1) * BYTES_PER_BEAT)) begin
                bytes_remaining <= bytes_remaining - ((current_burst_len + 1) * BYTES_PER_BEAT);
              end else begin
                bytes_remaining <= '0;
              end
            end
          end
        end

        default: ;
      endcase
    end
  end

  // ============================================================
  // AXI Read Channel Outputs
  // ============================================================
  assign m_axi_arvalid = (state == S_READ_ADDR);
  assign m_axi_araddr = current_src_addr;
  assign m_axi_arlen = current_burst_len;
  assign m_axi_arsize = AXI_SIZE;
  assign m_axi_arburst = AXI_BURST_INCR;
  assign m_axi_rready = (state == S_READ_DATA);

  // ============================================================
  // AXI Write Channel Outputs
  // ============================================================
  assign m_axi_awvalid = (state == S_WRITE_ADDR);
  assign m_axi_awaddr = current_dst_addr;
  assign m_axi_awlen = current_burst_len;
  assign m_axi_awsize = AXI_SIZE;
  assign m_axi_awburst = AXI_BURST_INCR;

  assign m_axi_wvalid = (state == S_WRITE_DATA);
  assign m_axi_wdata = out_buf_rd_data;
  assign m_axi_wstrb = {(DATA_WIDTH/8){1'b1}};  // All bytes valid
  assign m_axi_wlast = (state == S_WRITE_DATA) && (beat_count == current_burst_len);

  assign m_axi_bready = (state == S_WRITE_RESP);

  // ============================================================
  // Buffer Write Outputs
  // ============================================================
  // Write received data directly to buffer during each beat (no intermediate register)
  // This fixes the burst data loss issue - each beat is written immediately

  // Determine if we're receiving valid read data
  logic read_data_valid;
  assign read_data_valid = (state == S_READ_DATA) && m_axi_rvalid && m_axi_rready;

  // Weight buffer write - write each beat directly during S_READ_DATA
  assign wgt_buf_wr_en = read_data_valid && (mode_reg == 2'b00);
  assign wgt_buf_wr_addr = buffer_wr_addr;
  assign wgt_buf_wr_data = m_axi_rdata;

  // Activation buffer write - write each beat directly during S_READ_DATA
  assign act_buf_wr_en = read_data_valid && (mode_reg == 2'b01);
  assign act_buf_wr_addr = buffer_wr_addr;
  assign act_buf_wr_data = m_axi_rdata;

  // Output buffer read (for writeback to external memory)
  assign out_buf_rd_en = (state == S_BUFFER_READ) || (state == S_WRITE_DATA);
  assign out_buf_rd_addr = buffer_wr_addr;

  // ============================================================
  // Status Outputs
  // ============================================================
  assign busy = (state != S_IDLE);
  assign done = (state == S_DONE);
  assign error = (state == S_ERROR);
  assign bytes_transferred = bytes_transferred_reg;

endmodule
