// Ternary Logic Definitions for Yosys Compatibility
// Replaces ternary_pkg.sv with synthesizable defines
// Based on ROADMAP Phase 2 - RTL Synthesis Flow

`ifndef TERNARY_DEFS_VH
`define TERNARY_DEFS_VH

// 2-bit encoding for ternary values
// 00 = 0 (zero)
// 01 = +1 (positive one)
// 10 = -1 (negative one)
// 11 = X (invalid/error)

`define T_ZERO    2'b00
`define T_POS_ONE 2'b01
`define T_NEG_ONE 2'b10
`define T_INVALID 2'b11

// Trit width constant
`define TRIT_BITS 2

// Helper macros for zero constants (packed format)
`define TRIT2_ZERO  4'b0000
`define TRIT3_ZERO  6'b000000
`define TRIT8_ZERO  16'b0000000000000000
`define TRIT9_ZERO  18'b000000000000000000
`define TRIT27_ZERO 54'b0

// Constant 1 in 8-trit format (LSB = +1, rest = 0)
`define TRIT8_ONE   16'b0000000000000001

// Constant 2 in balanced ternary (for dual-issue PC+2)
// 2 = 1×3 + (-1)×1 = trit[1]=+1, trit[0]=-1
// Layout: {trit7..trit1, trit0} = {00..00 01, 10} = 16'b0000_0000_0000_0110
`define TRIT8_TWO   16'b0000000000000110

`endif
