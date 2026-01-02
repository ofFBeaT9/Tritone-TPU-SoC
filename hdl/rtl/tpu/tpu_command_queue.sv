// TPU Command Queue Module
// =========================
// 8-entry descriptor queue for batch kernel dispatch.
// Supports chained execution and interrupt generation.
//
// Descriptor Format (128-bit):
//   [127:120] OPCODE      - Operation type (GEMM_TILE, REDUCE, NOP)
//   [119]     CHAIN       - Auto-start next descriptor on completion
//   [118]     IRQ_EN      - Raise IRQ on completion
//   [117]     DMA_EN      - Use DMA prefetch/evict
//   [116]     PACK_W      - Packed weight mode
//   [115]     ACC81_EN    - 81-trit accumulator path
//   [114]     DATAFLOW    - 0=output-stationary, 1=weight-stationary
//   [113:96]  RESERVED    - Future use / TILE_ID
//   [95:64]   OUT_BASE    - Output base address
//   [63:32]   ACT_BASE    - Activation base address
//   [31:16]   WGT_BASE    - Weight base address
//   [15:8]    K_TILE      - K dimension for tile
//   [7:4]     M_TILE_SEL  - Tile height selector
//   [3:0]     N_TILE_SEL  - Tile width selector
//
// Author: Tritone Project (Phase 3)

module tpu_command_queue #(
  parameter int QUEUE_DEPTH = 8,
  parameter int DESC_WIDTH = 128
)(
  input  logic                    clk,
  input  logic                    rst_n,

  // ============================================================
  // Command Write Interface (from CPU/external)
  // ============================================================
  input  logic                    cmd_push,       // Push new command
  input  logic [DESC_WIDTH-1:0]   cmd_data,       // Command descriptor
  output logic                    cmd_full,       // Queue is full
  output logic                    cmd_almost_full,// Queue has 1 slot left

  // ============================================================
  // Command Execution Interface (to TPU controller)
  // ============================================================
  output logic                    exec_valid,     // Valid command ready
  output logic [DESC_WIDTH-1:0]   exec_cmd,       // Current command to execute
  input  logic                    exec_done,      // Current command completed
  input  logic                    exec_error,     // Execution error

  // ============================================================
  // Status and Control
  // ============================================================
  input  logic                    flush,          // Clear all pending commands
  output logic                    queue_empty,    // No commands pending
  output logic [$clog2(QUEUE_DEPTH):0] queue_count, // Number of commands in queue
  output logic                    irq,            // Interrupt request
  output logic                    error_flag,     // Sticky error flag
  input  logic                    clear_error,    // Clear error flag

  // ============================================================
  // Parsed Command Fields (for direct use by controller)
  // ============================================================
  output logic [7:0]              cmd_opcode,
  output logic                    cmd_chain,
  output logic                    cmd_irq_en,
  output logic                    cmd_dma_en,
  output logic                    cmd_pack_w,
  output logic                    cmd_acc81_en,
  output logic                    cmd_dataflow,
  output logic [31:0]             cmd_out_base,
  output logic [31:0]             cmd_act_base,
  output logic [15:0]             cmd_wgt_base,
  output logic [7:0]              cmd_k_tile,
  output logic [3:0]              cmd_m_tile_sel,
  output logic [3:0]              cmd_n_tile_sel
);

  // ============================================================
  // Opcode Definitions
  // ============================================================
  localparam logic [7:0] OP_GEMM_TILE = 8'h00;
  localparam logic [7:0] OP_REDUCE    = 8'h01;
  localparam logic [7:0] OP_NOP       = 8'hFF;

  // ============================================================
  // Queue Storage
  // ============================================================
  logic [DESC_WIDTH-1:0] queue [QUEUE_DEPTH];
  logic [$clog2(QUEUE_DEPTH)-1:0] wr_ptr;
  logic [$clog2(QUEUE_DEPTH)-1:0] rd_ptr;
  logic [$clog2(QUEUE_DEPTH):0] count;

  // ============================================================
  // State Machine
  // ============================================================
  typedef enum logic [1:0] {
    S_IDLE,
    S_EXECUTING,
    S_CHAIN_WAIT,
    S_ERROR
  } state_t;

  state_t state, next_state;

  // ============================================================
  // Queue Status Signals
  // ============================================================
  assign queue_empty = (count == 0);
  assign cmd_full = (count == QUEUE_DEPTH);
  assign cmd_almost_full = (count >= QUEUE_DEPTH - 1);
  assign queue_count = count;

  // ============================================================
  // Queue Write Logic
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= '0;
    end else if (flush) begin
      wr_ptr <= '0;
    end else if (cmd_push && !cmd_full) begin
      queue[wr_ptr] <= cmd_data;
      wr_ptr <= wr_ptr + 1;
    end
  end

  // ============================================================
  // Queue Read Logic (dequeue on completion)
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_ptr <= '0;
    end else if (flush) begin
      rd_ptr <= '0;
    end else if (exec_done && !queue_empty) begin
      rd_ptr <= rd_ptr + 1;
    end
  end

  // ============================================================
  // Count Management
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= '0;
    end else if (flush) begin
      count <= '0;
    end else begin
      case ({cmd_push && !cmd_full, exec_done && !queue_empty})
        2'b10: count <= count + 1;  // Push only
        2'b01: count <= count - 1;  // Pop only
        default: count <= count;    // Both or neither
      endcase
    end
  end

  // ============================================================
  // Current Command Output
  // ============================================================
  assign exec_cmd = queue[rd_ptr];

  // Parse command fields
  assign cmd_opcode     = exec_cmd[127:120];
  assign cmd_chain      = exec_cmd[119];
  assign cmd_irq_en     = exec_cmd[118];
  assign cmd_dma_en     = exec_cmd[117];
  assign cmd_pack_w     = exec_cmd[116];
  assign cmd_acc81_en   = exec_cmd[115];
  assign cmd_dataflow   = exec_cmd[114];
  // [113:96] reserved
  assign cmd_out_base   = exec_cmd[95:64];
  assign cmd_act_base   = exec_cmd[63:32];
  assign cmd_wgt_base   = exec_cmd[31:16];
  assign cmd_k_tile     = exec_cmd[15:8];
  assign cmd_m_tile_sel = exec_cmd[7:4];
  assign cmd_n_tile_sel = exec_cmd[3:0];

  // ============================================================
  // State Machine
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= S_IDLE;
    end else if (flush) begin
      state <= S_IDLE;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      S_IDLE: begin
        if (!queue_empty) begin
          next_state = S_EXECUTING;
        end
      end

      S_EXECUTING: begin
        if (exec_error) begin
          next_state = S_ERROR;
        end else if (exec_done) begin
          // Check if we should chain to next command
          if (cmd_chain && (count > 1)) begin
            next_state = S_CHAIN_WAIT;
          end else if (queue_empty || count == 1) begin
            next_state = S_IDLE;
          end
        end
      end

      S_CHAIN_WAIT: begin
        // One cycle delay for pointer update, then continue
        if (!queue_empty) begin
          next_state = S_EXECUTING;
        end else begin
          next_state = S_IDLE;
        end
      end

      S_ERROR: begin
        if (clear_error) begin
          next_state = S_IDLE;
        end
      end

      default: next_state = S_IDLE;
    endcase
  end

  // ============================================================
  // Execution Valid Signal
  // ============================================================
  assign exec_valid = (state == S_EXECUTING) && !queue_empty;

  // ============================================================
  // IRQ Generation
  // ============================================================
  logic irq_pending;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      irq_pending <= 1'b0;
    end else if (flush || clear_error) begin
      irq_pending <= 1'b0;
    end else if (exec_done && cmd_irq_en) begin
      irq_pending <= 1'b1;
    end else if (irq_pending && queue_empty) begin
      // Clear IRQ when queue drains (software should have serviced it)
      irq_pending <= 1'b0;
    end
  end

  assign irq = irq_pending;

  // ============================================================
  // Error Flag (Sticky)
  // ============================================================
  logic error_sticky;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      error_sticky <= 1'b0;
    end else if (clear_error || flush) begin
      error_sticky <= 1'b0;
    end else if (exec_error) begin
      error_sticky <= 1'b1;
    end
  end

  assign error_flag = error_sticky;

  // ============================================================
  // Debug/Performance Counters (optional)
  // ============================================================
  `ifdef SIMULATION
  logic [31:0] total_cmds_executed;
  logic [31:0] total_chains;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      total_cmds_executed <= '0;
      total_chains <= '0;
    end else if (flush) begin
      total_cmds_executed <= '0;
      total_chains <= '0;
    end else begin
      if (exec_done) begin
        total_cmds_executed <= total_cmds_executed + 1;
        if (cmd_chain) begin
          total_chains <= total_chains + 1;
        end
      end
    end
  end
  `endif

endmodule
