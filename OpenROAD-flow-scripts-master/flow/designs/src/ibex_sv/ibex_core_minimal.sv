// Minimal IBEX wrapper for RV32E comparison
// RV32E = 16 registers, no hardware multiplier
// This provides a fairer comparison baseline to Tritone

module ibex_core_minimal (
    // Clock and Reset
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic        test_en_i,

    input  logic [31:0] hart_id_i,
    input  logic [31:0] boot_addr_i,

    // Instruction memory interface
    output logic        instr_req_o,
    input  logic        instr_gnt_i,
    input  logic        instr_rvalid_i,
    output logic [31:0] instr_addr_o,
    input  logic [31:0] instr_rdata_i,
    input  logic        instr_err_i,

    // Data memory interface
    output logic        data_req_o,
    input  logic        data_gnt_i,
    input  logic        data_rvalid_i,
    output logic        data_we_o,
    output logic [3:0]  data_be_o,
    output logic [31:0] data_addr_o,
    output logic [31:0] data_wdata_o,
    input  logic [31:0] data_rdata_i,
    input  logic        data_err_i,

    // Interrupt inputs
    input  logic        irq_software_i,
    input  logic        irq_timer_i,
    input  logic        irq_external_i,
    input  logic [14:0] irq_fast_i,
    input  logic        irq_nm_i,

    // Debug Interface
    input  logic        debug_req_i,

    // CPU Control Signals
    output logic        fetch_enable_o,
    output logic        alert_minor_o,
    output logic        alert_major_o,
    output logic        core_sleep_o
);

  ibex_core #(
      .PMPEnable        (1'b0),
      .PMPGranularity   (0),
      .PMPNumRegions    (1),  // Minimum 1 to avoid zero-size array
      .MHPMCounterNum   (0),
      .MHPMCounterWidth (40),
      .RV32E            (1'b1),              // Enable RV32E (16 registers)
      .RV32M            (ibex_pkg::RV32MNone), // No hardware multiplier
      .RV32B            (ibex_pkg::RV32BNone),
      .RegFile          (ibex_pkg::RegFileFF),
      .BranchTargetALU  (1'b0),
      .WritebackStage   (1'b0),
      .ICache           (1'b0),
      .ICacheECC        (1'b0),
      .BranchPredictor  (1'b0),
      .DbgTriggerEn     (1'b0),
      .DbgHwBreakNum    (0),
      .SecureIbex       (1'b0),
      .DmHaltAddr       (32'h1A110800),
      .DmExceptionAddr  (32'h1A110808)
  ) u_ibex_core (
      .clk_i           (clk_i),
      .rst_ni          (rst_ni),
      .test_en_i       (test_en_i),
      .hart_id_i       (hart_id_i),
      .boot_addr_i     (boot_addr_i),
      .instr_req_o     (instr_req_o),
      .instr_gnt_i     (instr_gnt_i),
      .instr_rvalid_i  (instr_rvalid_i),
      .instr_addr_o    (instr_addr_o),
      .instr_rdata_i   (instr_rdata_i),
      .instr_err_i     (instr_err_i),
      .data_req_o      (data_req_o),
      .data_gnt_i      (data_gnt_i),
      .data_rvalid_i   (data_rvalid_i),
      .data_we_o       (data_we_o),
      .data_be_o       (data_be_o),
      .data_addr_o     (data_addr_o),
      .data_wdata_o    (data_wdata_o),
      .data_rdata_i    (data_rdata_i),
      .data_err_i      (data_err_i),
      .irq_software_i  (irq_software_i),
      .irq_timer_i     (irq_timer_i),
      .irq_external_i  (irq_external_i),
      .irq_fast_i      (irq_fast_i),
      .irq_nm_i        (irq_nm_i),
      .debug_req_i     (debug_req_i),
      .fetch_enable_i  (1'b1),
      .alert_minor_o   (alert_minor_o),
      .alert_major_o   (alert_major_o),
      .core_sleep_o    (core_sleep_o)
  );

  assign fetch_enable_o = 1'b1;

endmodule
