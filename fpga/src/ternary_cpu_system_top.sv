// Ternary CPU System FPGA Top-Level Wrapper
// For Vivado synthesis targeting Artix-7 / UltraScale+ FPGAs
//
// This module wraps the ternary_cpu_system for FPGA implementation:
// - Adds clock and reset management
// - Provides LED/button debug interface
// - Includes ILA debug probes (optional)

module ternary_cpu_system_top
  import ternary_pkg::*;
#(
  parameter int TRIT_WIDTH = 27,
  parameter int IMEM_DEPTH = 243,
  parameter int DMEM_DEPTH = 729
)(
  // Clock and Reset
  input  logic        sys_clk,      // System clock (100 MHz typical)
  input  logic        sys_rst_n,    // Active-low reset button

  // LED Status Outputs
  output logic [3:0]  led,          // Status LEDs

  // Debug Interface (directly expose CPU signals)
  output logic        halted_led,   // CPU halted indicator
  output logic        valid_a_led,  // Slot A valid indicator
  output logic        valid_b_led,  // Slot B valid indicator

  // Debug Register Access (directly expose CPU signals)
  input  logic [1:0]  debug_sel,    // Register select (directly to CPU)
  output logic [7:0]  debug_data    // Debug data output (directly from CPU)
);

  // ============================================================
  // Internal Signals
  // ============================================================

  logic clk;
  logic rst_n;

  // CPU system signals
  logic                   halted;
  trit_t [7:0]            pc_out;
  logic                   valid_out_a;
  logic                   valid_out_b;
  logic [1:0]             ipc_out;
  trit_t [TRIT_WIDTH-1:0] debug_reg_data;

  // Convert debug_sel to 2-trit format
  trit_t [1:0] debug_reg_addr;

  always_comb begin
    // Simple mapping: 2-bit binary to 2-trit
    case (debug_sel)
      2'b00: begin debug_reg_addr[0] = T_ZERO;    debug_reg_addr[1] = T_ZERO;    end  // R0
      2'b01: begin debug_reg_addr[0] = T_POS_ONE; debug_reg_addr[1] = T_ZERO;    end  // R1
      2'b10: begin debug_reg_addr[0] = T_NEG_ONE; debug_reg_addr[1] = T_ZERO;    end  // R2
      2'b11: begin debug_reg_addr[0] = T_ZERO;    debug_reg_addr[1] = T_POS_ONE; end  // R3
    endcase
  end

  // ============================================================
  // Clock and Reset
  // ============================================================

  // For simple FPGA implementation, use system clock directly
  // For higher performance, instantiate a PLL/MMCM
  assign clk = sys_clk;

  // Synchronize reset
  logic [2:0] rst_sync;
  always_ff @(posedge clk) begin
    rst_sync <= {rst_sync[1:0], sys_rst_n};
  end
  assign rst_n = rst_sync[2];

  // ============================================================
  // CPU System Instance
  // ============================================================

  ternary_cpu_system #(
    .TRIT_WIDTH (TRIT_WIDTH),
    .IMEM_DEPTH (IMEM_DEPTH),
    .DMEM_DEPTH (DMEM_DEPTH)
  ) u_cpu_system (
    .clk            (clk),
    .rst_n          (rst_n),

    // Program loading interface (directly route to CPU)
    .prog_mode      (1'b0),
    .prog_addr      (8'b0),
    .prog_data      (9'b0),
    .prog_we        (1'b0),

    // Status outputs
    .halted         (halted),
    .pc_out         (pc_out),
    .valid_out_a    (valid_out_a),
    .valid_out_b    (valid_out_b),
    .ipc_out        (ipc_out),

    // Debug interface
    .debug_reg_addr (debug_reg_addr),
    .debug_reg_data (debug_reg_data)
  );

  // ============================================================
  // LED Status Mapping
  // ============================================================

  // LED[0]: CPU running (not halted)
  // LED[1]: Valid instruction in Slot A
  // LED[2]: Valid instruction in Slot B
  // LED[3]: Dual-issue active (IPC = 2)
  assign led[0] = ~halted;
  assign led[1] = valid_out_a;
  assign led[2] = valid_out_b;
  assign led[3] = (ipc_out == 2'd2);

  // Dedicated status LEDs
  assign halted_led  = halted;
  assign valid_a_led = valid_out_a;
  assign valid_b_led = valid_out_b;

  // Debug data output (lower 8 bits of register, converted to binary)
  // Simple conversion: take lower 4 trits and map to 8-bit binary
  always_comb begin
    integer i, val;
    val = 0;
    for (i = 0; i < 4; i++) begin
      case (debug_reg_data[i])
        T_POS_ONE: val = val + (1 << i);
        T_NEG_ONE: val = val - (1 << i);
        default:   val = val;  // T_ZERO adds 0
      endcase
    end
    debug_data = val[7:0];
  end

endmodule
