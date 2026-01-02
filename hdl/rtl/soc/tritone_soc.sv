// Tritone Hybrid SoC: Ternary CPU + TPU Accelerator
// ====================================================
// Complete System-on-Chip combining:
//   - Tritone CPU: 4-stage dual-issue ternary processor
//   - Tritone TPU: Systolic array neural network accelerator
//   - Unified memory system with arbitration
//   - Memory-mapped I/O for CPU-TPU communication
//
// Memory Map:
//   0x0000 - 0x01FF: Instruction Memory (512 x 27-trit)
//   0x0200 - 0x09FF: Data Memory (2048 x 27-trit)
//   0x1000 - 0x1FFF: TPU Registers (memory-mapped)
//   0x2000 - 0x3FFF: TPU Weight Buffer
//   0x4000 - 0x5FFF: TPU Activation Buffer
//   0x6000 - 0x6FFF: TPU Output Buffer
//
// Author: Tritone Project

module tritone_soc
  import ternary_pkg::*;
#(
  parameter int TRIT_WIDTH = 27,
  parameter int ARRAY_SIZE = 8,
  parameter int ACT_BITS = 16,
  parameter int ACC_BITS = 32
)(
  input  logic                      clk,
  input  logic                      rst_n,

  // External interface (optional, for testing/debug)
  input  logic                      ext_sel,
  input  logic                      ext_wen,
  input  logic                      ext_ren,
  input  logic [31:0]               ext_addr,
  input  logic [31:0]               ext_wdata,
  output logic [31:0]               ext_rdata,
  output logic                      ext_ready,

  // Status outputs
  output logic                      cpu_halted,
  output logic                      tpu_busy,
  output logic                      tpu_done,
  output logic                      tpu_irq
);

  // ============================================================
  // Address Decode Constants
  // ============================================================
  localparam logic [31:0] IMEM_BASE     = 32'h0000;
  localparam logic [31:0] DMEM_BASE     = 32'h0200;
  localparam logic [31:0] TPU_REG_BASE  = 32'h1000;
  localparam logic [31:0] TPU_MEM_BASE  = 32'h2000;

  // ============================================================
  // CPU Instance
  // ============================================================
  trit_t [7:0]            cpu_imem_addr;
  trit_t [17:0]           cpu_imem_data;
  trit_t [8:0]            cpu_dmem_addr;
  trit_t [TRIT_WIDTH-1:0] cpu_dmem_wdata;
  trit_t [TRIT_WIDTH-1:0] cpu_dmem_rdata;
  logic                   cpu_dmem_we;
  logic                   cpu_dmem_re;
  trit_t [7:0]            cpu_pc;
  logic                   cpu_valid_a, cpu_valid_b;
  logic [1:0]             cpu_ipc;
  logic                   cpu_stall;

  ternary_cpu #(
    .TRIT_WIDTH(TRIT_WIDTH)
  ) u_cpu (
    .clk(clk),
    .rst_n(rst_n),
    .imem_addr(cpu_imem_addr),
    .imem_data(cpu_imem_data),
    .dmem_addr(cpu_dmem_addr),
    .dmem_wdata(cpu_dmem_wdata),
    .dmem_rdata(cpu_dmem_rdata),
    .dmem_we(cpu_dmem_we),
    .dmem_re(cpu_dmem_re),
    .halted(cpu_halted),
    .pc_out(cpu_pc),
    .valid_out_a(cpu_valid_a),
    .valid_out_b(cpu_valid_b),
    .ipc_out(cpu_ipc),
    .dbg_reg_idx(4'b0),
    .dbg_reg_data(),
    .stall_out(cpu_stall),
    .fwd_a_out(),
    .fwd_b_out()
  );

  // ============================================================
  // Memory System
  // ============================================================

  // Instruction Memory (read-only from CPU perspective)
  localparam int IMEM_DEPTH = 512;
  trit_t [17:0] imem [IMEM_DEPTH];

  // Convert ternary address to binary index
  function automatic int trit_to_int_8(input trit_t [7:0] addr);
    int result = 0;
    int power3 = 1;
    for (int i = 0; i < 8; i++) begin
      case (addr[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  function automatic int trit_to_int_9(input trit_t [8:0] addr);
    int result = 0;
    int power3 = 1;
    for (int i = 0; i < 9; i++) begin
      case (addr[i])
        T_NEG_ONE: result = result - power3;
        T_POS_ONE: result = result + power3;
        default: ;
      endcase
      power3 = power3 * 3;
    end
    return result;
  endfunction

  // Instruction fetch
  always_ff @(posedge clk) begin
    cpu_imem_data <= imem[trit_to_int_8(cpu_imem_addr)];
  end

  // Data Memory
  localparam int DMEM_DEPTH = 2048;
  trit_t [TRIT_WIDTH-1:0] dmem [DMEM_DEPTH];

  // ============================================================
  // CPU Data Memory Interface with TPU Address Decode
  // ============================================================
  // CPU can access:
  //   - Regular data memory (dmem_addr maps to DMEM)
  //   - TPU registers (special addresses)

  // Convert CPU dmem address to linear address
  logic [31:0] cpu_linear_addr;
  assign cpu_linear_addr = DMEM_BASE + trit_to_int_9(cpu_dmem_addr);

  // Detect TPU register access
  logic cpu_accessing_tpu;
  assign cpu_accessing_tpu = (cpu_linear_addr >= TPU_REG_BASE) && (cpu_linear_addr < TPU_MEM_BASE);

  // TPU register access signals
  logic tpu_reg_sel;
  logic tpu_reg_wen;
  logic tpu_reg_ren;
  logic [31:0] tpu_reg_addr;
  logic [31:0] tpu_reg_wdata;
  logic [31:0] tpu_reg_rdata;
  logic tpu_reg_ready;

  // Mux between external and CPU access to TPU
  always_comb begin
    if (ext_sel) begin
      tpu_reg_sel = ext_sel && (ext_addr >= TPU_REG_BASE) && (ext_addr < TPU_MEM_BASE);
      tpu_reg_wen = ext_wen;
      tpu_reg_ren = ext_ren;
      tpu_reg_addr = ext_addr - TPU_REG_BASE;
      tpu_reg_wdata = ext_wdata;
    end else begin
      tpu_reg_sel = cpu_accessing_tpu && (cpu_dmem_we || cpu_dmem_re);
      tpu_reg_wen = cpu_accessing_tpu && cpu_dmem_we;
      tpu_reg_ren = cpu_accessing_tpu && cpu_dmem_re;
      tpu_reg_addr = cpu_linear_addr - TPU_REG_BASE;
      // Convert ternary wdata to 32-bit (take lower 32 bits of 54-bit encoding)
      tpu_reg_wdata = {cpu_dmem_wdata[15], cpu_dmem_wdata[14], cpu_dmem_wdata[13], cpu_dmem_wdata[12],
                       cpu_dmem_wdata[11], cpu_dmem_wdata[10], cpu_dmem_wdata[9], cpu_dmem_wdata[8],
                       cpu_dmem_wdata[7], cpu_dmem_wdata[6], cpu_dmem_wdata[5], cpu_dmem_wdata[4],
                       cpu_dmem_wdata[3], cpu_dmem_wdata[2], cpu_dmem_wdata[1], cpu_dmem_wdata[0]};
    end
  end

  // Data memory read/write
  always_ff @(posedge clk) begin
    if (cpu_dmem_we && !cpu_accessing_tpu) begin
      dmem[trit_to_int_9(cpu_dmem_addr)] <= cpu_dmem_wdata;
    end
  end

  // Data memory read mux (TPU or DMEM)
  trit_t [TRIT_WIDTH-1:0] dmem_rdata_reg;
  always_ff @(posedge clk) begin
    if (cpu_dmem_re && !cpu_accessing_tpu) begin
      dmem_rdata_reg <= dmem[trit_to_int_9(cpu_dmem_addr)];
    end
  end

  // Convert TPU read data back to ternary format (simplified)
  always_comb begin
    if (cpu_accessing_tpu) begin
      // Pack 32-bit binary into 27-trit (simplified: just use lower 16 trits)
      for (int i = 0; i < TRIT_WIDTH; i++) begin
        if (i < 16) begin
          cpu_dmem_rdata[i] = trit_t'(tpu_reg_rdata[i*2 +: 2]);
        end else begin
          cpu_dmem_rdata[i] = T_ZERO;
        end
      end
    end else begin
      cpu_dmem_rdata = dmem_rdata_reg;
    end
  end

  // ============================================================
  // TPU Instance with DMA Memory Interface
  // ============================================================
  logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] tpu_zero_skip_map;

  // DMA AXI interface signals
  logic        tpu_m_axi_awvalid, tpu_m_axi_awready;
  logic [31:0] tpu_m_axi_awaddr;
  logic [7:0]  tpu_m_axi_awlen;
  logic [2:0]  tpu_m_axi_awsize;
  logic [1:0]  tpu_m_axi_awburst;

  logic        tpu_m_axi_wvalid, tpu_m_axi_wready;
  logic [31:0] tpu_m_axi_wdata;
  logic [3:0]  tpu_m_axi_wstrb;
  logic        tpu_m_axi_wlast;

  logic        tpu_m_axi_bvalid, tpu_m_axi_bready;
  logic [1:0]  tpu_m_axi_bresp;

  logic        tpu_m_axi_arvalid, tpu_m_axi_arready;
  logic [31:0] tpu_m_axi_araddr;
  logic [7:0]  tpu_m_axi_arlen;
  logic [2:0]  tpu_m_axi_arsize;
  logic [1:0]  tpu_m_axi_arburst;

  logic        tpu_m_axi_rvalid, tpu_m_axi_rready;
  logic [31:0] tpu_m_axi_rdata;
  logic [1:0]  tpu_m_axi_rresp;
  logic        tpu_m_axi_rlast;

  // Legacy DMA signals (unused but kept for compatibility)
  logic        tpu_dma_req, tpu_dma_wr;
  logic [31:0] tpu_dma_addr, tpu_dma_wdata;

  tpu_top #(
    .ARRAY_SIZE(ARRAY_SIZE),
    .ACT_BITS(ACT_BITS),
    .ACC_BITS(ACC_BITS)
  ) u_tpu (
    .clk(clk),
    .rst_n(rst_n),
    .cpu_sel(tpu_reg_sel),
    .cpu_wen(tpu_reg_wen),
    .cpu_ren(tpu_reg_ren),
    .cpu_addr(tpu_reg_addr),
    .cpu_wdata(tpu_reg_wdata),
    .cpu_rdata(tpu_reg_rdata),
    .cpu_ready(tpu_reg_ready),

    // AXI Master Interface for DMA
    .m_axi_awvalid(tpu_m_axi_awvalid),
    .m_axi_awready(tpu_m_axi_awready),
    .m_axi_awaddr(tpu_m_axi_awaddr),
    .m_axi_awlen(tpu_m_axi_awlen),
    .m_axi_awsize(tpu_m_axi_awsize),
    .m_axi_awburst(tpu_m_axi_awburst),

    .m_axi_wvalid(tpu_m_axi_wvalid),
    .m_axi_wready(tpu_m_axi_wready),
    .m_axi_wdata(tpu_m_axi_wdata),
    .m_axi_wstrb(tpu_m_axi_wstrb),
    .m_axi_wlast(tpu_m_axi_wlast),

    .m_axi_bvalid(tpu_m_axi_bvalid),
    .m_axi_bready(tpu_m_axi_bready),
    .m_axi_bresp(tpu_m_axi_bresp),

    .m_axi_arvalid(tpu_m_axi_arvalid),
    .m_axi_arready(tpu_m_axi_arready),
    .m_axi_araddr(tpu_m_axi_araddr),
    .m_axi_arlen(tpu_m_axi_arlen),
    .m_axi_arsize(tpu_m_axi_arsize),
    .m_axi_arburst(tpu_m_axi_arburst),

    .m_axi_rvalid(tpu_m_axi_rvalid),
    .m_axi_rready(tpu_m_axi_rready),
    .m_axi_rdata(tpu_m_axi_rdata),
    .m_axi_rresp(tpu_m_axi_rresp),
    .m_axi_rlast(tpu_m_axi_rlast),

    // Legacy DMA interface
    .dma_req(tpu_dma_req),
    .dma_wr(tpu_dma_wr),
    .dma_addr(tpu_dma_addr),
    .dma_wdata(tpu_dma_wdata),
    .dma_rdata(dma_mem_rdata),
    .dma_ack(dma_mem_ack),

    .irq(tpu_irq),
    .busy(tpu_busy),
    .done(tpu_done)
  );

  // ============================================================
  // DMA Memory Interface (Simple AXI-to-SRAM Bridge)
  // ============================================================
  // This provides the TPU DMA engine access to data memory
  // For reads: DMA can fetch weights/activations from external memory addresses
  // For writes: DMA can write results back to memory

  // DMA memory interface state machine
  typedef enum logic [2:0] {
    DMA_IDLE,
    DMA_READ_ADDR,
    DMA_READ_DATA,
    DMA_WRITE_ADDR,
    DMA_WRITE_DATA,
    DMA_WRITE_RESP
  } dma_mem_state_t;

  dma_mem_state_t dma_mem_state;
  logic [31:0] dma_mem_addr_reg;
  logic [7:0]  dma_mem_burst_cnt;
  logic [7:0]  dma_mem_burst_len;
  logic [31:0] dma_mem_rdata;
  logic        dma_mem_ack;

  // Simple burst-capable memory interface
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dma_mem_state <= DMA_IDLE;
      dma_mem_addr_reg <= '0;
      dma_mem_burst_cnt <= '0;
      dma_mem_burst_len <= '0;
      tpu_m_axi_arready <= 1'b0;
      tpu_m_axi_rvalid <= 1'b0;
      tpu_m_axi_rdata <= '0;
      tpu_m_axi_rresp <= 2'b00;
      tpu_m_axi_rlast <= 1'b0;
      tpu_m_axi_awready <= 1'b0;
      tpu_m_axi_wready <= 1'b0;
      tpu_m_axi_bvalid <= 1'b0;
      tpu_m_axi_bresp <= 2'b00;
      dma_mem_ack <= 1'b0;
    end else begin
      // Default de-assertions
      tpu_m_axi_arready <= 1'b0;
      tpu_m_axi_awready <= 1'b0;
      dma_mem_ack <= 1'b0;

      case (dma_mem_state)
        DMA_IDLE: begin
          tpu_m_axi_rvalid <= 1'b0;
          tpu_m_axi_rlast <= 1'b0;
          tpu_m_axi_bvalid <= 1'b0;

          // Prioritize read requests
          if (tpu_m_axi_arvalid) begin
            tpu_m_axi_arready <= 1'b1;
            dma_mem_addr_reg <= tpu_m_axi_araddr;
            dma_mem_burst_len <= tpu_m_axi_arlen;
            dma_mem_burst_cnt <= '0;
            dma_mem_state <= DMA_READ_DATA;
          end else if (tpu_m_axi_awvalid) begin
            tpu_m_axi_awready <= 1'b1;
            dma_mem_addr_reg <= tpu_m_axi_awaddr;
            dma_mem_burst_len <= tpu_m_axi_awlen;
            dma_mem_burst_cnt <= '0;
            dma_mem_state <= DMA_WRITE_DATA;
            tpu_m_axi_wready <= 1'b1;
          end
        end

        DMA_READ_DATA: begin
          // Read from data memory (address offset from DMEM_BASE)
          // Convert address to memory index
          if (tpu_m_axi_rready || !tpu_m_axi_rvalid) begin
            // Read word from memory
            // Address is word-aligned, convert to index
            automatic int mem_idx = (dma_mem_addr_reg - DMEM_BASE) >> 2;
            if (mem_idx >= 0 && mem_idx < DMEM_DEPTH) begin
              // Pack ternary data into 32-bit word
              for (int i = 0; i < 16 && i < TRIT_WIDTH; i++) begin
                tpu_m_axi_rdata[i*2 +: 2] <= dmem[mem_idx][i];
              end
            end else begin
              tpu_m_axi_rdata <= '0;  // Out of range
            end

            tpu_m_axi_rvalid <= 1'b1;
            tpu_m_axi_rresp <= 2'b00;  // OKAY
            dma_mem_ack <= 1'b1;

            // Check if this is the last beat
            if (dma_mem_burst_cnt >= dma_mem_burst_len) begin
              tpu_m_axi_rlast <= 1'b1;
              dma_mem_state <= DMA_IDLE;
            end else begin
              tpu_m_axi_rlast <= 1'b0;
              dma_mem_burst_cnt <= dma_mem_burst_cnt + 1;
              dma_mem_addr_reg <= dma_mem_addr_reg + 4;  // Next word
            end
          end
        end

        DMA_WRITE_DATA: begin
          if (tpu_m_axi_wvalid && tpu_m_axi_wready) begin
            // Write word to memory
            automatic int mem_idx = (dma_mem_addr_reg - DMEM_BASE) >> 2;
            if (mem_idx >= 0 && mem_idx < DMEM_DEPTH) begin
              // Unpack 32-bit word into ternary data
              for (int i = 0; i < 16 && i < TRIT_WIDTH; i++) begin
                dmem[mem_idx][i] <= trit_t'(tpu_m_axi_wdata[i*2 +: 2]);
              end
              // Zero upper trits
              for (int i = 16; i < TRIT_WIDTH; i++) begin
                dmem[mem_idx][i] <= T_ZERO;
              end
            end

            // Check if this is the last beat
            if (tpu_m_axi_wlast) begin
              tpu_m_axi_wready <= 1'b0;
              tpu_m_axi_bvalid <= 1'b1;
              tpu_m_axi_bresp <= 2'b00;  // OKAY
              dma_mem_state <= DMA_WRITE_RESP;
            end else begin
              dma_mem_burst_cnt <= dma_mem_burst_cnt + 1;
              dma_mem_addr_reg <= dma_mem_addr_reg + 4;  // Next word
            end
          end
        end

        DMA_WRITE_RESP: begin
          if (tpu_m_axi_bready) begin
            tpu_m_axi_bvalid <= 1'b0;
            dma_mem_state <= DMA_IDLE;
          end
        end

        default: dma_mem_state <= DMA_IDLE;
      endcase
    end
  end

  // TPU status outputs connected directly via u_tpu.busy and u_tpu.done ports

  // ============================================================
  // External Interface
  // ============================================================
  assign ext_rdata = tpu_reg_rdata;
  assign ext_ready = tpu_reg_ready;

  // ============================================================
  // Program Loading (for simulation)
  // ============================================================
`ifdef SIMULATION
  // Allow loading programs via external interface or initial blocks
  initial begin
    // Initialize memories to zero
    for (int i = 0; i < IMEM_DEPTH; i++) begin
      for (int j = 0; j < 18; j++) begin
        imem[i][j] = T_ZERO;
      end
    end
    for (int i = 0; i < DMEM_DEPTH; i++) begin
      for (int j = 0; j < TRIT_WIDTH; j++) begin
        dmem[i][j] = T_ZERO;
      end
    end
  end
`endif

endmodule
