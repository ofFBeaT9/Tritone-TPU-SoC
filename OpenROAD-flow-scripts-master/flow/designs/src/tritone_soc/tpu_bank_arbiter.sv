// TPU Bank Arbiter
// =================
// Arbitrates access to banked memory buffers when multiple requestors
// target the same bank. Provides round-robin fairness and conflict reporting.
//
// Features:
//   - Round-robin arbitration per bank
//   - Conflict detection and counting
//   - Grant signals for requestors
//   - Stall signal when arbitration needed
//   - Support for multiple priority levels
//
// Use Cases:
//   - DMA vs CPU write conflicts
//   - Multiple read ports to same bank
//   - Systolic array vs diagnostic access
//
// Author: Tritone Project (Phase 1.4 Upgrade)

module tpu_bank_arbiter #(
  parameter int NUM_BANKS = 8,            // Number of memory banks
  parameter int NUM_REQUESTORS = 4,       // Number of requestors per bank
  parameter int ADDR_WIDTH = 16           // Address width
)(
  input  logic                                                clk,
  input  logic                                                rst_n,

  // Request Interface (from multiple sources)
  input  logic [NUM_REQUESTORS-1:0]                           req_valid,      // Request valid
  input  logic [NUM_REQUESTORS-1:0][ADDR_WIDTH-1:0]           req_addr,       // Request address
  input  logic [NUM_REQUESTORS-1:0]                           req_write,      // 1=write, 0=read
  input  logic [NUM_REQUESTORS-1:0][1:0]                      req_priority,   // 0=low, 3=high

  // Grant Interface (to requestors)
  output logic [NUM_REQUESTORS-1:0]                           grant,          // Request granted
  output logic [NUM_REQUESTORS-1:0]                           stall,          // Request stalled

  // Bank Access Output (to memory banks)
  output logic [NUM_BANKS-1:0]                                bank_access,    // Bank is being accessed
  output logic [NUM_BANKS-1:0][$clog2(NUM_REQUESTORS)-1:0]    bank_owner,     // Which requestor owns bank

  // Conflict Reporting
  output logic                                                conflict_detected,
  output logic [NUM_BANKS-1:0]                                conflict_banks, // Which banks had conflicts
  output logic [31:0]                                         total_conflicts,
  output logic [31:0]                                         total_stalls,

  // Performance Counters
  output logic [31:0]                                         cycles_with_conflict,
  output logic [31:0]                                         max_requestors_per_bank,

  // Control
  input  logic                                                clear_counters
);

  // ============================================================
  // Constants
  // ============================================================
  localparam int BANK_SEL_BITS = $clog2(NUM_BANKS);
  localparam int REQ_IDX_BITS = $clog2(NUM_REQUESTORS);

  // ============================================================
  // Bank Request Mapping
  // ============================================================
  // Determine which bank each requestor is accessing
  logic [NUM_REQUESTORS-1:0][BANK_SEL_BITS-1:0] req_bank;

  always_comb begin
    for (int r = 0; r < NUM_REQUESTORS; r++) begin
      req_bank[r] = req_addr[r][BANK_SEL_BITS-1:0];
    end
  end

  // ============================================================
  // Per-Bank Request Aggregation
  // ============================================================
  // For each bank, collect which requestors want it
  logic [NUM_BANKS-1:0][NUM_REQUESTORS-1:0] bank_requests;
  logic [NUM_BANKS-1:0][NUM_REQUESTORS-1:0] bank_requests_write;
  logic [NUM_BANKS-1:0][3:0] bank_request_count;  // Up to 16 requestors

  always_comb begin
    for (int b = 0; b < NUM_BANKS; b++) begin
      bank_requests[b] = '0;
      bank_requests_write[b] = '0;
      bank_request_count[b] = '0;
      for (int r = 0; r < NUM_REQUESTORS; r++) begin
        if (req_valid[r] && req_bank[r] == b) begin
          bank_requests[b][r] = 1'b1;
          bank_requests_write[b][r] = req_write[r];
          bank_request_count[b] = bank_request_count[b] + 1;
        end
      end
    end
  end

  // ============================================================
  // Conflict Detection
  // ============================================================
  // Conflict when multiple requestors want same bank
  logic [NUM_BANKS-1:0] bank_has_conflict;

  always_comb begin
    for (int b = 0; b < NUM_BANKS; b++) begin
      bank_has_conflict[b] = (bank_request_count[b] > 1);
    end
  end

  assign conflict_banks = bank_has_conflict;
  assign conflict_detected = |bank_has_conflict;

  // ============================================================
  // Round-Robin Arbitration State (per bank)
  // ============================================================
  logic [NUM_BANKS-1:0][REQ_IDX_BITS-1:0] rr_priority;  // Next requestor to prioritize

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int b = 0; b < NUM_BANKS; b++) begin
        rr_priority[b] <= '0;
      end
    end else begin
      for (int b = 0; b < NUM_BANKS; b++) begin
        if (bank_access[b]) begin
          // Rotate to next requestor for fairness
          rr_priority[b] <= (rr_priority[b] + 1) % NUM_REQUESTORS;
        end
      end
    end
  end

  // ============================================================
  // Grant Logic (priority-aware round-robin)
  // ============================================================
  logic [NUM_BANKS-1:0][REQ_IDX_BITS-1:0] bank_winner;
  logic [NUM_BANKS-1:0] bank_winner_valid;

  always_comb begin
    for (int b = 0; b < NUM_BANKS; b++) begin
      bank_winner[b] = '0;
      bank_winner_valid[b] = 1'b0;

      if (|bank_requests[b]) begin
        // First: check for high priority requests (priority == 3)
        // Use found flag instead of break for Icarus compatibility
        for (int r = 0; r < NUM_REQUESTORS; r++) begin
          if (!bank_winner_valid[b] && bank_requests[b][r] && req_priority[r] == 2'b11) begin
            bank_winner[b] = r[REQ_IDX_BITS-1:0];
            bank_winner_valid[b] = 1'b1;
          end
        end

        // If no high priority, use round-robin
        if (!bank_winner_valid[b]) begin
          for (int i = 0; i < NUM_REQUESTORS; i++) begin
            // Use calculated index with found flag instead of break
            if (!bank_winner_valid[b]) begin
              int r_idx;
              r_idx = (rr_priority[b] + i) % NUM_REQUESTORS;
              if (bank_requests[b][r_idx]) begin
                bank_winner[b] = r_idx[REQ_IDX_BITS-1:0];
                bank_winner_valid[b] = 1'b1;
              end
            end
          end
        end
      end
    end
  end

  // Generate grant and stall signals for each requestor
  always_comb begin
    grant = '0;
    stall = '0;

    for (int r = 0; r < NUM_REQUESTORS; r++) begin
      if (req_valid[r]) begin
        logic [BANK_SEL_BITS-1:0] target_bank;
        target_bank = req_bank[r];

        if (bank_winner_valid[target_bank] && bank_winner[target_bank] == r) begin
          grant[r] = 1'b1;
        end else begin
          stall[r] = 1'b1;
        end
      end
    end
  end

  // Bank access and owner outputs
  always_comb begin
    bank_access = '0;
    for (int b = 0; b < NUM_BANKS; b++) begin
      bank_owner[b] = bank_winner[b];
      bank_access[b] = bank_winner_valid[b];
    end
  end

  // ============================================================
  // Performance Counters
  // ============================================================
  logic [31:0] total_conflicts_reg;
  logic [31:0] total_stalls_reg;
  logic [31:0] cycles_with_conflict_reg;
  logic [31:0] max_requestors_per_bank_reg;

  // Combinational count of conflicts this cycle (properly sums multiple bank conflicts)
  logic [3:0] conflicts_this_cycle;
  logic [3:0] max_req_this_cycle;

  always_comb begin
    conflicts_this_cycle = '0;
    max_req_this_cycle = '0;
    for (int b = 0; b < NUM_BANKS; b++) begin
      if (bank_has_conflict[b]) begin
        conflicts_this_cycle = conflicts_this_cycle + 1;
      end
      if (bank_request_count[b] > max_req_this_cycle) begin
        max_req_this_cycle = bank_request_count[b];
      end
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      total_conflicts_reg <= '0;
      total_stalls_reg <= '0;
      cycles_with_conflict_reg <= '0;
      max_requestors_per_bank_reg <= '0;
    end else if (clear_counters) begin
      total_conflicts_reg <= '0;
      total_stalls_reg <= '0;
      cycles_with_conflict_reg <= '0;
      max_requestors_per_bank_reg <= '0;
    end else begin
      // Count total conflicts (properly summed across all banks this cycle)
      total_conflicts_reg <= total_conflicts_reg + {28'b0, conflicts_this_cycle};

      // Count stall cycles
      if (|stall) begin
        total_stalls_reg <= total_stalls_reg + 1;
      end

      // Count cycles with any conflict
      if (conflict_detected) begin
        cycles_with_conflict_reg <= cycles_with_conflict_reg + 1;
      end

      // Track max requestors per bank (ever seen)
      if (max_req_this_cycle > max_requestors_per_bank_reg[3:0]) begin
        max_requestors_per_bank_reg <= {28'b0, max_req_this_cycle};
      end
    end
  end

  assign total_conflicts = total_conflicts_reg;
  assign total_stalls = total_stalls_reg;
  assign cycles_with_conflict = cycles_with_conflict_reg;
  assign max_requestors_per_bank = max_requestors_per_bank_reg;

  // ============================================================
  // Assertions (for simulation)
  // ============================================================
  `ifdef SIMULATION
  // Ensure only one grant per bank per cycle
  always_ff @(posedge clk) begin
    for (int b = 0; b < NUM_BANKS; b++) begin
      int grant_count;
      grant_count = 0;
      for (int r = 0; r < NUM_REQUESTORS; r++) begin
        if (grant[r] && req_bank[r] == b) begin
          grant_count++;
        end
      end
      assert (grant_count <= 1)
        else $error("Multiple grants to bank %0d", b);
    end
  end
  `endif

endmodule
