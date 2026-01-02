// TPU Reduction Unit
// ===================
// Phase 5.4: Vector/Row Sum Reduction for FEP and Molecular Kernels
//
// Features:
//   - Tree reduction in 128-bit internal format (81 trits)
//   - Configurable vector length and stride
//   - Output cast to 32-bit with saturation
//   - DMA streaming support
//   - Performance counters
//
// Reduction Operations:
//   - REDUCE_SUM: Sum all elements
//   - REDUCE_MAX: Maximum element
//   - REDUCE_MIN: Minimum element
//   - REDUCE_ABSSUM: Sum of absolute values (L1 norm)
//
// Author: Tritone Project (Phase 5.4: 81-Trit Reductions)

module tpu_reduce_unit #(
  parameter int DATA_WIDTH = 32,         // Input element width
  parameter int ACC_WIDTH = 128,         // Internal accumulator (81 trits)
  parameter int MAX_LENGTH = 4096,       // Maximum reduction length
  parameter int OUT_WIDTH = 32           // Output width
)(
  input  logic                          clk,
  input  logic                          rst_n,

  // Control interface
  input  logic                          start,
  input  logic [1:0]                    op_mode,         // 00=sum, 01=max, 10=min, 11=abssum
  input  logic [$clog2(MAX_LENGTH)-1:0] length,          // Number of elements
  input  logic [3:0]                    out_shift,       // Right shift before output

  output logic                          busy,
  output logic                          done,

  // Streaming input interface
  input  logic signed [DATA_WIDTH-1:0]  data_in,
  input  logic                          data_valid,
  output logic                          data_ready,

  // Result output
  output logic signed [OUT_WIDTH-1:0]   result,
  output logic                          result_valid,
  output logic                          saturated,

  // Debug output (full precision)
  output logic signed [ACC_WIDTH-1:0]   result_wide,

  // Performance counters
  output logic [31:0]                   cycles_count,
  output logic [31:0]                   elements_count
);

  // ============================================================
  // State Machine
  // ============================================================
  typedef enum logic [2:0] {
    IDLE,
    ACCUMULATE,
    FINALIZE,
    OUTPUT,
    DONE
  } state_t;

  state_t state, next_state;

  // Reduction modes
  localparam logic [1:0] OP_SUM    = 2'b00;
  localparam logic [1:0] OP_MAX    = 2'b01;
  localparam logic [1:0] OP_MIN    = 2'b10;
  localparam logic [1:0] OP_ABSSUM = 2'b11;

  // ============================================================
  // Accumulator
  // ============================================================
  logic signed [ACC_WIDTH-1:0] accumulator;
  logic [$clog2(MAX_LENGTH)-1:0] count;
  logic [$clog2(MAX_LENGTH)-1:0] target_length;
  logic [1:0] current_op;
  logic [3:0] current_shift;

  // Extended input for accumulation
  logic signed [ACC_WIDTH-1:0] data_ext;
  logic signed [ACC_WIDTH-1:0] data_abs;

  // Sign extension
  assign data_ext = $signed({{(ACC_WIDTH-DATA_WIDTH){data_in[DATA_WIDTH-1]}}, data_in});
  assign data_abs = (data_in[DATA_WIDTH-1]) ? -data_ext : data_ext;

  // ============================================================
  // State Machine Logic
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (start) next_state = ACCUMULATE;
      end
      ACCUMULATE: begin
        if (count >= target_length) next_state = FINALIZE;
      end
      FINALIZE: begin
        next_state = OUTPUT;
      end
      OUTPUT: begin
        next_state = DONE;
      end
      DONE: begin
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  // ============================================================
  // Accumulation Logic
  // ============================================================
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      accumulator <= '0;
      count <= '0;
      target_length <= '0;
      current_op <= '0;
      current_shift <= '0;
    end else begin
      case (state)
        IDLE: begin
          if (start) begin
            count <= '0;
            target_length <= length;
            current_op <= op_mode;
            current_shift <= out_shift;

            // Initialize accumulator based on operation
            case (op_mode)
              OP_SUM:    accumulator <= '0;
              OP_MAX:    accumulator <= {1'b1, {(ACC_WIDTH-1){1'b0}}};  // Min value
              OP_MIN:    accumulator <= {1'b0, {(ACC_WIDTH-1){1'b1}}};  // Max value
              OP_ABSSUM: accumulator <= '0;
            endcase
          end
        end

        ACCUMULATE: begin
          if (data_valid) begin
            count <= count + 1;

            case (current_op)
              OP_SUM: begin
                accumulator <= accumulator + data_ext;
              end
              OP_MAX: begin
                if (data_ext > accumulator) begin
                  accumulator <= data_ext;
                end
              end
              OP_MIN: begin
                if (data_ext < accumulator) begin
                  accumulator <= data_ext;
                end
              end
              OP_ABSSUM: begin
                accumulator <= accumulator + data_abs;
              end
            endcase
          end
        end

        default: begin
          // Hold values
        end
      endcase
    end
  end

  // Data ready (backpressure)
  assign data_ready = (state == ACCUMULATE);

  // ============================================================
  // Output Generation with Saturation
  // ============================================================
  logic signed [ACC_WIDTH-1:0] shifted_result;
  logic signed [OUT_WIDTH-1:0] result_reg;
  logic result_valid_reg;
  logic saturated_reg;

  assign shifted_result = accumulator >>> current_shift;

  // Saturation bounds
  localparam logic signed [OUT_WIDTH-1:0] SAT_MAX = {1'b0, {(OUT_WIDTH-1){1'b1}}};
  localparam logic signed [OUT_WIDTH-1:0] SAT_MIN = {1'b1, {(OUT_WIDTH-1){1'b0}}};
  localparam logic signed [ACC_WIDTH-1:0] SAT_MAX_EXT = {{(ACC_WIDTH-OUT_WIDTH){1'b0}}, SAT_MAX};
  localparam logic signed [ACC_WIDTH-1:0] SAT_MIN_EXT = {{(ACC_WIDTH-OUT_WIDTH){1'b1}}, SAT_MIN};

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      result_reg <= '0;
      result_valid_reg <= 1'b0;
      saturated_reg <= 1'b0;
    end else begin
      result_valid_reg <= (state == OUTPUT);

      if (state == FINALIZE) begin
        // Apply saturation
        if (shifted_result > SAT_MAX_EXT) begin
          result_reg <= SAT_MAX;
          saturated_reg <= 1'b1;
        end else if (shifted_result < SAT_MIN_EXT) begin
          result_reg <= SAT_MIN;
          saturated_reg <= 1'b1;
        end else begin
          result_reg <= shifted_result[OUT_WIDTH-1:0];
          saturated_reg <= 1'b0;
        end
      end
    end
  end

  assign result = result_reg;
  assign result_valid = result_valid_reg;
  assign saturated = saturated_reg;
  assign result_wide = accumulator;

  // ============================================================
  // Status Signals
  // ============================================================
  assign busy = (state != IDLE);
  assign done = (state == DONE);

  // ============================================================
  // Performance Counters
  // ============================================================
  logic [31:0] cycles_reg;
  logic [31:0] elements_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cycles_reg <= '0;
      elements_reg <= '0;
    end else begin
      if (state == IDLE && start) begin
        cycles_reg <= '0;
        elements_reg <= '0;
      end else if (state == ACCUMULATE || state == FINALIZE || state == OUTPUT) begin
        cycles_reg <= cycles_reg + 1;
        if (data_valid && state == ACCUMULATE) begin
          elements_reg <= elements_reg + 1;
        end
      end
    end
  end

  assign cycles_count = cycles_reg;
  assign elements_count = elements_reg;

endmodule


// ============================================================
// Parallel Reduction Tree (for row-wise reduction)
// ============================================================
// Reduces a full row (ARRAY_SIZE elements) in log2 stages

module tpu_reduce_tree #(
  parameter int ARRAY_SIZE = 64,
  parameter int DATA_WIDTH = 32,
  parameter int ACC_WIDTH = 128
)(
  input  logic                                        clk,
  input  logic                                        rst_n,
  input  logic                                        enable,

  input  logic [1:0]                                  op_mode,  // 00=sum, 01=max, 10=min

  // Input: full row of data
  input  logic signed [ARRAY_SIZE-1:0][DATA_WIDTH-1:0] data_in,
  input  logic                                        data_valid,

  // Output: single reduced value
  output logic signed [ACC_WIDTH-1:0]                 result,
  output logic                                        result_valid
);

  // Number of reduction stages
  localparam int NUM_STAGES = $clog2(ARRAY_SIZE);  // 6 for 64 elements

  // Reduction modes
  localparam logic [1:0] OP_SUM = 2'b00;
  localparam logic [1:0] OP_MAX = 2'b01;
  localparam logic [1:0] OP_MIN = 2'b10;

  // Stage arrays
  logic signed [ACC_WIDTH-1:0] stage [NUM_STAGES+1][ARRAY_SIZE];
  logic valid_pipe [NUM_STAGES+1];

  // Stage 0: Sign-extend inputs
  genvar i, s;
  generate
    for (i = 0; i < ARRAY_SIZE; i++) begin : gen_input
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          stage[0][i] <= '0;
        end else if (enable && data_valid) begin
          stage[0][i] <= $signed({{(ACC_WIDTH-DATA_WIDTH){data_in[i][DATA_WIDTH-1]}}, data_in[i]});
        end
      end
    end
  endgenerate

  // Valid pipeline
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      valid_pipe[0] <= 1'b0;
    end else if (enable) begin
      valid_pipe[0] <= data_valid;
    end
  end

  // Reduction stages
  generate
    for (s = 0; s < NUM_STAGES; s++) begin : gen_stages
      localparam int PAIRS = ARRAY_SIZE >> (s + 1);

      for (i = 0; i < PAIRS; i++) begin : gen_pairs
        always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            stage[s+1][i] <= '0;
          end else if (enable && valid_pipe[s]) begin
            case (op_mode)
              OP_SUM: stage[s+1][i] <= stage[s][i*2] + stage[s][i*2+1];
              OP_MAX: stage[s+1][i] <= (stage[s][i*2] > stage[s][i*2+1]) ? stage[s][i*2] : stage[s][i*2+1];
              OP_MIN: stage[s+1][i] <= (stage[s][i*2] < stage[s][i*2+1]) ? stage[s][i*2] : stage[s][i*2+1];
              default: stage[s+1][i] <= stage[s][i*2] + stage[s][i*2+1];
            endcase
          end
        end
      end

      // Zero unused slots
      for (i = PAIRS; i < ARRAY_SIZE; i++) begin : gen_zero
        always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            stage[s+1][i] <= '0;
          end
        end
      end

      // Valid pipeline
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          valid_pipe[s+1] <= 1'b0;
        end else if (enable) begin
          valid_pipe[s+1] <= valid_pipe[s];
        end
      end
    end
  endgenerate

  // Output
  assign result = stage[NUM_STAGES][0];
  assign result_valid = valid_pipe[NUM_STAGES];

endmodule


// ============================================================
// Multi-Row Reduction Controller
// ============================================================
// Reduces multiple rows with DMA interface

module tpu_reduce_controller #(
  parameter int ARRAY_SIZE = 64,
  parameter int DATA_WIDTH = 32,
  parameter int ACC_WIDTH = 128,
  parameter int OUT_WIDTH = 32,
  parameter int MAX_ROWS = 4096
)(
  input  logic                                        clk,
  input  logic                                        rst_n,

  // Configuration
  input  logic                                        start,
  input  logic [1:0]                                  op_mode,
  input  logic [$clog2(MAX_ROWS)-1:0]                 num_rows,
  input  logic [3:0]                                  out_shift,

  output logic                                        busy,
  output logic                                        done,

  // Input data (row at a time)
  input  logic signed [ARRAY_SIZE-1:0][DATA_WIDTH-1:0] row_in,
  input  logic                                        row_valid,
  output logic                                        row_ready,

  // Output (one result per row)
  output logic signed [OUT_WIDTH-1:0]                 result_out,
  output logic                                        result_valid,

  // Performance
  output logic [31:0]                                 rows_processed
);

  // State machine
  typedef enum logic [1:0] {
    R_IDLE,
    R_PROCESSING,
    R_DONE
  } rstate_t;

  rstate_t rstate;

  logic [$clog2(MAX_ROWS)-1:0] row_count;
  logic [$clog2(MAX_ROWS)-1:0] target_rows;
  logic [1:0] saved_op;
  logic [3:0] saved_shift;

  // Reduction tree instance
  logic signed [ACC_WIDTH-1:0] tree_result;
  logic tree_valid;

  tpu_reduce_tree #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
  ) u_tree (
    .clk(clk),
    .rst_n(rst_n),
    .enable(1'b1),
    .op_mode(saved_op),
    .data_in(row_in),
    .data_valid(row_valid && rstate == R_PROCESSING),
    .result(tree_result),
    .result_valid(tree_valid)
  );

  // Output cast and saturation
  logic signed [ACC_WIDTH-1:0] shifted;
  localparam logic signed [OUT_WIDTH-1:0] SAT_MAX = {1'b0, {(OUT_WIDTH-1){1'b1}}};
  localparam logic signed [OUT_WIDTH-1:0] SAT_MIN = {1'b1, {(OUT_WIDTH-1){1'b0}}};

  assign shifted = tree_result >>> saved_shift;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rstate <= R_IDLE;
      row_count <= '0;
      target_rows <= '0;
      saved_op <= '0;
      saved_shift <= '0;
      result_out <= '0;
      result_valid <= 1'b0;
      rows_processed <= '0;
    end else begin
      result_valid <= 1'b0;

      case (rstate)
        R_IDLE: begin
          if (start) begin
            rstate <= R_PROCESSING;
            row_count <= '0;
            target_rows <= num_rows;
            saved_op <= op_mode;
            saved_shift <= out_shift;
            rows_processed <= '0;
          end
        end

        R_PROCESSING: begin
          if (tree_valid) begin
            row_count <= row_count + 1;
            rows_processed <= rows_processed + 1;

            // Saturate and output
            if (shifted > $signed({{(ACC_WIDTH-OUT_WIDTH){1'b0}}, SAT_MAX})) begin
              result_out <= SAT_MAX;
            end else if (shifted < $signed({{(ACC_WIDTH-OUT_WIDTH){1'b1}}, SAT_MIN})) begin
              result_out <= SAT_MIN;
            end else begin
              result_out <= shifted[OUT_WIDTH-1:0];
            end
            result_valid <= 1'b1;

            if (row_count + 1 >= target_rows) begin
              rstate <= R_DONE;
            end
          end
        end

        R_DONE: begin
          rstate <= R_IDLE;
        end
      endcase
    end
  end

  assign busy = (rstate != R_IDLE);
  assign done = (rstate == R_DONE);
  assign row_ready = (rstate == R_PROCESSING);

endmodule
