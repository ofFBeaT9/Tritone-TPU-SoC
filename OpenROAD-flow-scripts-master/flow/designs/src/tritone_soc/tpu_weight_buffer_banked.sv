// TPU Weight Buffer with 8-Bank Architecture
// ===========================================
// High-bandwidth weight storage with 8 independent banks for parallel access.
// Supports double-buffering via shadow banks (16 total banks).
//
// Features:
//   - 8 independent banks for conflict-free parallel access
//   - 16 total banks (8 active + 8 shadow) for compute/load overlap
//   - Address interleaving: bank_idx = addr[2:0]
//   - Bank conflict detection output
//   - Row-major storage for systolic array feeding
//
// Memory Organization:
//   - Each bank: DEPTH/8 rows, each row = ARRAY_SIZE weights (2-bit)
//   - Total capacity: DEPTH * ARRAY_SIZE * 2 bits per buffer set
//
// Author: Tritone Project (Phase 1.2 Upgrade)

module tpu_weight_buffer_banked #(
  parameter int ARRAY_SIZE = 8,           // Systolic array dimension
  parameter int MAX_K = 256,              // Maximum K dimension
  parameter int NUM_BANKS = 8,            // Number of parallel banks
  parameter int ADDR_WIDTH = 16           // Address width for external interface
)(
  input  logic                            clk,
  input  logic                            rst_n,

  // Control
  input  logic                            swap_banks,     // Swap active/shadow banks (pulse)

  // Multi-port Write Interface (for DMA/CPU loading)
  input  logic [NUM_BANKS-1:0]            wr_en,          // Per-bank write enable
  input  logic [NUM_BANKS-1:0][ADDR_WIDTH-1:0] wr_addr,   // Per-bank write address
  input  logic [NUM_BANKS-1:0][ARRAY_SIZE-1:0][1:0] wr_data, // Per-bank write data

  // Single-port Unified Write Interface (alternative for sequential access)
  input  logic                            unified_wr_en,
  input  logic [ADDR_WIDTH-1:0]           unified_wr_addr,
  input  logic [ARRAY_SIZE-1:0][1:0]      unified_wr_data,

  // Multi-port Read Interface (for systolic array parallel feeding)
  input  logic [NUM_BANKS-1:0]            rd_en,          // Per-bank read enable
  input  logic [NUM_BANKS-1:0][$clog2(MAX_K)-1:0] rd_addr, // Per-bank read address
  output logic [NUM_BANKS-1:0][ARRAY_SIZE-1:0][1:0] rd_data, // Per-bank read data
  output logic [NUM_BANKS-1:0]            rd_valid,       // Per-bank read valid

  // Single-port Unified Read Interface (for sequential access)
  input  logic                            unified_rd_en,
  input  logic [$clog2(MAX_K)-1:0]        unified_rd_row,
  output logic [ARRAY_SIZE-1:0][1:0]      unified_rd_data,
  output logic                            unified_rd_valid,

  // Bank Conflict Detection
  output logic                            conflict_detected,
  output logic [$clog2(NUM_BANKS)-1:0]    conflict_bank,
  output logic [31:0]                     conflict_count
);

  // ============================================================
  // Parameters and Types
  // ============================================================
  localparam int BANK_DEPTH = MAX_K / NUM_BANKS;  // Depth per bank
  localparam int BANK_ADDR_BITS = $clog2(BANK_DEPTH);
  localparam int BANK_SEL_BITS = $clog2(NUM_BANKS);

  // ============================================================
  // Memory Arrays (16 Banks: 8 Active + 8 Shadow)
  // ============================================================
  // Bank set 0: Banks 0-7 (active or shadow based on active_set)
  // Bank set 1: Banks 8-15 (shadow or active)
  logic [ARRAY_SIZE-1:0][1:0] bank_set0 [NUM_BANKS][BANK_DEPTH];
  logic [ARRAY_SIZE-1:0][1:0] bank_set1 [NUM_BANKS][BANK_DEPTH];

  // Active set tracking (0 = set0 active for read, set1 for write; 1 = opposite)
  logic active_set;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      active_set <= 1'b0;
    end else if (swap_banks) begin
      active_set <= ~active_set;
    end
  end

  // ============================================================
  // Address Decoding Functions
  // ============================================================
  function automatic logic [BANK_SEL_BITS-1:0] get_bank_idx(input logic [ADDR_WIDTH-1:0] addr);
    return addr[BANK_SEL_BITS-1:0];  // Lower bits select bank
  endfunction

  function automatic logic [BANK_ADDR_BITS-1:0] get_bank_addr(input logic [ADDR_WIDTH-1:0] addr);
    return addr[BANK_ADDR_BITS+BANK_SEL_BITS-1:BANK_SEL_BITS];  // Upper bits select row within bank
  endfunction

  // ============================================================
  // Unified Write Interface (sequential access)
  // ============================================================
  // Writes go to shadow set (opposite of active)
  logic [BANK_SEL_BITS-1:0] unified_wr_bank;
  logic [BANK_ADDR_BITS-1:0] unified_wr_bank_addr;

  assign unified_wr_bank = get_bank_idx(unified_wr_addr);
  assign unified_wr_bank_addr = get_bank_addr(unified_wr_addr);

  // ============================================================
  // Multi-port Write Logic (to shadow banks)
  // ============================================================
  genvar b;
  generate
    for (b = 0; b < NUM_BANKS; b++) begin : gen_bank_write
      logic do_write;
      logic [BANK_ADDR_BITS-1:0] write_addr;
      logic [ARRAY_SIZE-1:0][1:0] write_data;

      // Priority: explicit per-bank write > unified write to this bank
      always_comb begin
        if (wr_en[b]) begin
          do_write = 1'b1;
          write_addr = get_bank_addr(wr_addr[b]);
          write_data = wr_data[b];
        end else if (unified_wr_en && (unified_wr_bank == b)) begin
          do_write = 1'b1;
          write_addr = unified_wr_bank_addr;
          write_data = unified_wr_data;
        end else begin
          do_write = 1'b0;
          write_addr = '0;
          write_data = '0;
        end
      end

      // Write to shadow set
      always_ff @(posedge clk) begin
        if (do_write) begin
          if (active_set == 1'b0) begin
            // Set 0 is active for read, write to set 1
            bank_set1[b][write_addr] <= write_data;
          end else begin
            // Set 1 is active for read, write to set 0
            bank_set0[b][write_addr] <= write_data;
          end
        end
      end
    end
  endgenerate

  // ============================================================
  // Multi-port Read Logic (from active banks)
  // ============================================================
  generate
    for (b = 0; b < NUM_BANKS; b++) begin : gen_bank_read
      logic [ARRAY_SIZE-1:0][1:0] rd_data_set0;
      logic [ARRAY_SIZE-1:0][1:0] rd_data_set1;
      logic rd_valid_reg;

      always_ff @(posedge clk) begin
        if (rd_en[b]) begin
          rd_data_set0 <= bank_set0[b][rd_addr[b][BANK_ADDR_BITS-1:0]];
          rd_data_set1 <= bank_set1[b][rd_addr[b][BANK_ADDR_BITS-1:0]];
        end
      end

      // Select from active set
      assign rd_data[b] = active_set ? rd_data_set1 : rd_data_set0;

      // Read valid tracking
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          rd_valid_reg <= 1'b0;
        end else begin
          rd_valid_reg <= rd_en[b];
        end
      end

      assign rd_valid[b] = rd_valid_reg;
    end
  endgenerate

  // ============================================================
  // Unified Read Interface (sequential access)
  // ============================================================
  logic [BANK_SEL_BITS-1:0] unified_rd_bank;
  logic [BANK_ADDR_BITS-1:0] unified_rd_bank_addr;

  assign unified_rd_bank = get_bank_idx({{(ADDR_WIDTH-$clog2(MAX_K)){1'b0}}, unified_rd_row});
  assign unified_rd_bank_addr = get_bank_addr({{(ADDR_WIDTH-$clog2(MAX_K)){1'b0}}, unified_rd_row});

  logic [ARRAY_SIZE-1:0][1:0] unified_rd_data_set0;
  logic [ARRAY_SIZE-1:0][1:0] unified_rd_data_set1;
  logic unified_rd_valid_reg;

  always_ff @(posedge clk) begin
    if (unified_rd_en) begin
      // Read from the bank at the interleaved address
      unified_rd_data_set0 <= bank_set0[unified_rd_bank][unified_rd_bank_addr];
      unified_rd_data_set1 <= bank_set1[unified_rd_bank][unified_rd_bank_addr];
    end
  end

  assign unified_rd_data = active_set ? unified_rd_data_set1 : unified_rd_data_set0;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      unified_rd_valid_reg <= 1'b0;
    end else begin
      unified_rd_valid_reg <= unified_rd_en;
    end
  end

  assign unified_rd_valid = unified_rd_valid_reg;

  // ============================================================
  // Bank Conflict Detection
  // ============================================================
  // Detect when multiple ports try to access the same bank simultaneously
  logic [NUM_BANKS-1:0] bank_rd_active;
  logic [NUM_BANKS-1:0] bank_wr_active;
  logic [NUM_BANKS-1:0] bank_conflict;
  logic [31:0] conflict_count_reg;

  // Track which banks have active read requests
  always_comb begin
    bank_rd_active = rd_en;
    if (unified_rd_en) begin
      bank_rd_active[unified_rd_bank] = 1'b1;
    end
  end

  // Track which banks have active write requests
  always_comb begin
    bank_wr_active = wr_en;
    if (unified_wr_en) begin
      bank_wr_active[unified_wr_bank] = 1'b1;
    end
  end

  // Conflict exists when same bank has both read and write in same cycle
  // Note: With shadow banking, this shouldn't happen normally since reads go to
  // active set and writes go to shadow set. This detects architectural violations.
  assign bank_conflict = bank_rd_active & bank_wr_active;
  assign conflict_detected = |bank_conflict;

  // Find first conflicting bank (priority encoder)
  // Use found flag instead of break for Icarus compatibility
  always_comb begin
    logic found;
    conflict_bank = '0;
    found = 1'b0;
    for (int i = 0; i < NUM_BANKS; i++) begin
      if (!found && bank_conflict[i]) begin
        conflict_bank = i[BANK_SEL_BITS-1:0];
        found = 1'b1;
      end
    end
  end

  // Conflict counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      conflict_count_reg <= '0;
    end else if (conflict_detected) begin
      conflict_count_reg <= conflict_count_reg + 1;
    end
  end

  assign conflict_count = conflict_count_reg;

  // ============================================================
  // Assertions (for simulation)
  // ============================================================
  `ifdef SIMULATION
  // Check that bank depth is power of 2
  initial begin
    assert (BANK_DEPTH == (1 << BANK_ADDR_BITS))
      else $error("BANK_DEPTH must be power of 2");
    assert (NUM_BANKS == 8)
      else $warning("Design optimized for 8 banks");
  end
  `endif

endmodule
