// TPU SRAM Wrapper for Technology Portability
// ============================================
// Generic SRAM wrapper that can be replaced with technology-specific
// macros for ASIC implementation or inferred as BRAM for FPGA.
//
// This module provides a unified interface for all TPU memory elements:
//   - Weight buffers
//   - Activation buffers
//   - Output buffers
//
// Implementation Options:
//   1. BEHAVIORAL: Inferred RAM (default for simulation/FPGA)
//   2. SKY130_SRAM: OpenRAM-generated SRAM for SkyWater 130nm
//   3. ASAP7_SRAM: ASAP7 memory compiler output
//   4. CUSTOM: User-provided technology macro
//
// Author: Tritone Project (Phase 4.4 - SRAM Infrastructure)

// ============================================================
// Single-Port SRAM Wrapper
// ============================================================
module tpu_sram_sp #(
  parameter int DATA_WIDTH = 32,
  parameter int DEPTH = 1024,
  parameter int ADDR_WIDTH = $clog2(DEPTH),
  parameter string IMPL_TYPE = "BEHAVIORAL"  // BEHAVIORAL, SKY130, ASAP7, CUSTOM
)(
  input  logic                    clk,
  input  logic                    cs,         // Chip select (active high)
  input  logic                    we,         // Write enable
  input  logic [ADDR_WIDTH-1:0]   addr,
  input  logic [DATA_WIDTH-1:0]   din,
  output logic [DATA_WIDTH-1:0]   dout
);

  generate
    if (IMPL_TYPE == "BEHAVIORAL") begin : gen_behavioral
      // Behavioral model - inferred as BRAM/registers
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      always_ff @(posedge clk) begin
        if (cs) begin
          if (we) begin
            mem[addr] <= din;
          end
          dout <= mem[addr];
        end
      end

    end else if (IMPL_TYPE == "SKY130") begin : gen_sky130
      // Placeholder for SkyWater 130nm OpenRAM macro
      // Replace with actual macro instantiation:
      //   sky130_sram_1kx32_1rw u_sram (
      //     .clk0(clk), .csb0(~cs), .web0(~we),
      //     .addr0(addr), .din0(din), .dout0(dout)
      //   );

      // Behavioral fallback for simulation
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      always_ff @(posedge clk) begin
        if (cs) begin
          if (we) begin
            mem[addr] <= din;
          end
          dout <= mem[addr];
        end
      end

      `ifdef SIMULATION
      initial $display("WARNING: SKY130 SRAM using behavioral model");
      `endif

    end else if (IMPL_TYPE == "ASAP7") begin : gen_asap7
      // Placeholder for ASAP7 memory compiler output
      // Replace with actual macro instantiation

      logic [DATA_WIDTH-1:0] mem [DEPTH];

      always_ff @(posedge clk) begin
        if (cs) begin
          if (we) begin
            mem[addr] <= din;
          end
          dout <= mem[addr];
        end
      end

      `ifdef SIMULATION
      initial $display("WARNING: ASAP7 SRAM using behavioral model");
      `endif

    end else begin : gen_default
      // Default behavioral model
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      always_ff @(posedge clk) begin
        if (cs) begin
          if (we) begin
            mem[addr] <= din;
          end
          dout <= mem[addr];
        end
      end
    end
  endgenerate

endmodule


// ============================================================
// Dual-Port SRAM Wrapper (1R1W)
// ============================================================
module tpu_sram_1r1w #(
  parameter int DATA_WIDTH = 32,
  parameter int DEPTH = 1024,
  parameter int ADDR_WIDTH = $clog2(DEPTH),
  parameter string IMPL_TYPE = "BEHAVIORAL"
)(
  input  logic                    clk,

  // Write port
  input  logic                    wr_en,
  input  logic [ADDR_WIDTH-1:0]   wr_addr,
  input  logic [DATA_WIDTH-1:0]   wr_data,

  // Read port
  input  logic                    rd_en,
  input  logic [ADDR_WIDTH-1:0]   rd_addr,
  output logic [DATA_WIDTH-1:0]   rd_data,
  output logic                    rd_valid
);

  generate
    if (IMPL_TYPE == "BEHAVIORAL") begin : gen_behavioral
      // Behavioral dual-port model
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      // Write port
      always_ff @(posedge clk) begin
        if (wr_en) begin
          mem[wr_addr] <= wr_data;
        end
      end

      // Read port
      always_ff @(posedge clk) begin
        if (rd_en) begin
          rd_data <= mem[rd_addr];
        end
      end

      // Read valid tracking
      logic rd_valid_reg;
      always_ff @(posedge clk) begin
        rd_valid_reg <= rd_en;
      end
      assign rd_valid = rd_valid_reg;

    end else begin : gen_default
      // Fallback to behavioral
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      always_ff @(posedge clk) begin
        if (wr_en) begin
          mem[wr_addr] <= wr_data;
        end
      end

      always_ff @(posedge clk) begin
        if (rd_en) begin
          rd_data <= mem[rd_addr];
        end
      end

      logic rd_valid_reg;
      always_ff @(posedge clk) begin
        rd_valid_reg <= rd_en;
      end
      assign rd_valid = rd_valid_reg;
    end
  endgenerate

endmodule


// ============================================================
// True Dual-Port SRAM Wrapper (2RW)
// ============================================================
module tpu_sram_2rw #(
  parameter int DATA_WIDTH = 32,
  parameter int DEPTH = 1024,
  parameter int ADDR_WIDTH = $clog2(DEPTH),
  parameter string IMPL_TYPE = "BEHAVIORAL"
)(
  input  logic                    clk,

  // Port A
  input  logic                    cs_a,
  input  logic                    we_a,
  input  logic [ADDR_WIDTH-1:0]   addr_a,
  input  logic [DATA_WIDTH-1:0]   din_a,
  output logic [DATA_WIDTH-1:0]   dout_a,

  // Port B
  input  logic                    cs_b,
  input  logic                    we_b,
  input  logic [ADDR_WIDTH-1:0]   addr_b,
  input  logic [DATA_WIDTH-1:0]   din_b,
  output logic [DATA_WIDTH-1:0]   dout_b
);

  generate
    if (IMPL_TYPE == "BEHAVIORAL") begin : gen_behavioral
      // Behavioral true dual-port model
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      // Port A
      always_ff @(posedge clk) begin
        if (cs_a) begin
          if (we_a) begin
            mem[addr_a] <= din_a;
          end
          dout_a <= mem[addr_a];
        end
      end

      // Port B
      always_ff @(posedge clk) begin
        if (cs_b) begin
          if (we_b) begin
            mem[addr_b] <= din_b;
          end
          dout_b <= mem[addr_b];
        end
      end

      // Note: Simultaneous write to same address is undefined behavior
      `ifdef SIMULATION
      always_ff @(posedge clk) begin
        if (cs_a && we_a && cs_b && we_b && (addr_a == addr_b)) begin
          $warning("SRAM 2RW: Simultaneous write to same address!");
        end
      end
      `endif

    end else begin : gen_default
      // Fallback to behavioral
      logic [DATA_WIDTH-1:0] mem [DEPTH];

      always_ff @(posedge clk) begin
        if (cs_a) begin
          if (we_a) mem[addr_a] <= din_a;
          dout_a <= mem[addr_a];
        end
      end

      always_ff @(posedge clk) begin
        if (cs_b) begin
          if (we_b) mem[addr_b] <= din_b;
          dout_b <= mem[addr_b];
        end
      end
    end
  endgenerate

endmodule


// ============================================================
// Multi-Bank SRAM Array (for weight/activation buffers)
// ============================================================
module tpu_sram_banked #(
  parameter int DATA_WIDTH = 128,         // Width per bank
  parameter int DEPTH = 256,              // Depth per bank
  parameter int NUM_BANKS = 8,            // Number of banks
  parameter int ADDR_WIDTH = $clog2(DEPTH * NUM_BANKS),
  parameter string IMPL_TYPE = "BEHAVIORAL"
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Unified write interface (writes to one bank based on address)
  input  logic                                      wr_en,
  input  logic [ADDR_WIDTH-1:0]                     wr_addr,
  input  logic [DATA_WIDTH-1:0]                     wr_data,

  // Unified read interface
  input  logic                                      rd_en,
  input  logic [ADDR_WIDTH-1:0]                     rd_addr,
  output logic [DATA_WIDTH-1:0]                     rd_data,
  output logic                                      rd_valid,

  // Per-bank parallel read interface (for systolic array feeding)
  input  logic [NUM_BANKS-1:0]                      bank_rd_en,
  input  logic [NUM_BANKS-1:0][$clog2(DEPTH)-1:0]   bank_rd_addr,
  output logic [NUM_BANKS-1:0][DATA_WIDTH-1:0]      bank_rd_data,
  output logic [NUM_BANKS-1:0]                      bank_rd_valid
);

  localparam int BANK_ADDR_WIDTH = $clog2(DEPTH);
  localparam int BANK_SEL_WIDTH = $clog2(NUM_BANKS);

  // Bank selection from unified address
  logic [BANK_SEL_WIDTH-1:0] wr_bank_sel;
  logic [BANK_ADDR_WIDTH-1:0] wr_bank_addr;
  logic [BANK_SEL_WIDTH-1:0] rd_bank_sel;
  logic [BANK_ADDR_WIDTH-1:0] rd_bank_addr;

  assign wr_bank_sel = wr_addr[BANK_SEL_WIDTH-1:0];
  assign wr_bank_addr = wr_addr[ADDR_WIDTH-1:BANK_SEL_WIDTH];
  assign rd_bank_sel = rd_addr[BANK_SEL_WIDTH-1:0];
  assign rd_bank_addr = rd_addr[ADDR_WIDTH-1:BANK_SEL_WIDTH];

  // Per-bank write enables
  logic [NUM_BANKS-1:0] bank_wr_en;
  always_comb begin
    bank_wr_en = '0;
    if (wr_en) begin
      bank_wr_en[wr_bank_sel] = 1'b1;
    end
  end

  // Bank instantiation
  logic [NUM_BANKS-1:0][DATA_WIDTH-1:0] bank_dout;
  logic [NUM_BANKS-1:0] bank_valid;

  genvar b;
  generate
    for (b = 0; b < NUM_BANKS; b++) begin : gen_banks
      // Select address: parallel interface takes priority over unified
      logic [BANK_ADDR_WIDTH-1:0] this_rd_addr;
      logic this_rd_en;

      assign this_rd_en = bank_rd_en[b] | (rd_en && (rd_bank_sel == b));
      assign this_rd_addr = bank_rd_en[b] ? bank_rd_addr[b] : rd_bank_addr;

      tpu_sram_1r1w #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(BANK_ADDR_WIDTH),
        .IMPL_TYPE(IMPL_TYPE)
      ) u_bank (
        .clk(clk),
        .wr_en(bank_wr_en[b]),
        .wr_addr(wr_bank_addr),
        .wr_data(wr_data),
        .rd_en(this_rd_en),
        .rd_addr(this_rd_addr),
        .rd_data(bank_dout[b]),
        .rd_valid(bank_valid[b])
      );

      assign bank_rd_data[b] = bank_dout[b];
      assign bank_rd_valid[b] = bank_valid[b] & bank_rd_en[b];
    end
  endgenerate

  // Unified read output mux
  logic [BANK_SEL_WIDTH-1:0] rd_bank_sel_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_bank_sel_d <= '0;
    end else if (rd_en) begin
      rd_bank_sel_d <= rd_bank_sel;
    end
  end

  assign rd_data = bank_dout[rd_bank_sel_d];
  assign rd_valid = bank_valid[rd_bank_sel_d] & !bank_rd_en[rd_bank_sel_d];

endmodule


// ============================================================
// Register File (for small, fast storage)
// ============================================================
module tpu_regfile #(
  parameter int DATA_WIDTH = 32,
  parameter int NUM_REGS = 32,
  parameter int ADDR_WIDTH = $clog2(NUM_REGS),
  parameter int NUM_READ_PORTS = 2,
  parameter int NUM_WRITE_PORTS = 1
)(
  input  logic                                      clk,
  input  logic                                      rst_n,

  // Write ports
  input  logic [NUM_WRITE_PORTS-1:0]                wr_en,
  input  logic [NUM_WRITE_PORTS-1:0][ADDR_WIDTH-1:0] wr_addr,
  input  logic [NUM_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wr_data,

  // Read ports (combinational)
  input  logic [NUM_READ_PORTS-1:0][ADDR_WIDTH-1:0] rd_addr,
  output logic [NUM_READ_PORTS-1:0][DATA_WIDTH-1:0] rd_data
);

  // Register array
  logic [DATA_WIDTH-1:0] regs [NUM_REGS];

  // Write logic (last write wins if multiple ports write same address)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < NUM_REGS; i++) begin
        regs[i] <= '0;
      end
    end else begin
      for (int p = 0; p < NUM_WRITE_PORTS; p++) begin
        if (wr_en[p]) begin
          regs[wr_addr[p]] <= wr_data[p];
        end
      end
    end
  end

  // Read logic (combinational for register file semantics)
  genvar r;
  generate
    for (r = 0; r < NUM_READ_PORTS; r++) begin : gen_read
      assign rd_data[r] = regs[rd_addr[r]];
    end
  endgenerate

endmodule
