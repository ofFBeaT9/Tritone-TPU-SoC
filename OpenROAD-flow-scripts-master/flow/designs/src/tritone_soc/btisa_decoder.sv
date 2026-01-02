// BTISA Instruction Decoder
// Decodes 9-trit instructions for Balanced Ternary CPU
//
// Instruction format (9 trits):
//   [8:6] Opcode  (3 trits)
//   [5:4] Rd      (2 trits)
//   [3:2] Rs1     (2 trits)
//   [1:0] Rs2/Imm (2 trits)

module btisa_decoder
  import ternary_pkg::*;
(
  input  trit_t [8:0] instruction,

  // Decoded fields
  output trit_t [2:0] opcode,
  output trit_t [1:0] rd,
  output trit_t [1:0] rs1,
  output trit_t [1:0] rs2_imm,

  // Control signals
  output logic        reg_write,    // Write to register file
  output logic        mem_read,     // Read from data memory
  output logic        mem_write,    // Write to data memory
  output logic        branch,       // Conditional branch
  output logic [1:0]  branch_type,  // Branch type: 00=none, 01=BEQ, 10=BNE, 11=BLT
  output logic        jump,         // Unconditional jump
  output logic        alu_src,      // 0=register, 1=immediate
  output logic [2:0]  alu_op,       // ALU operation code
  output logic        halt,         // Halt CPU execution
  output logic        lui           // LUI instruction (load upper immediate)
);

  // Extract instruction fields
  assign opcode  = instruction[8:6];
  assign rd      = instruction[5:4];
  assign rs1     = instruction[3:2];
  assign rs2_imm = instruction[1:0];

  // Opcode comparison helpers
  wire op_is_add  = (opcode == {T_ZERO, T_ZERO, T_ZERO});       // 000
  wire op_is_sub  = (opcode == {T_ZERO, T_ZERO, T_POS_ONE});    // 00+
  wire op_is_neg  = (opcode == {T_ZERO, T_ZERO, T_NEG_ONE});    // 00-
  wire op_is_mul  = (opcode == {T_ZERO, T_POS_ONE, T_ZERO});    // 0+0
  wire op_is_shl  = (opcode == {T_ZERO, T_POS_ONE, T_POS_ONE}); // 0++
  wire op_is_shr  = (opcode == {T_ZERO, T_POS_ONE, T_NEG_ONE}); // 0+-
  wire op_is_addi = (opcode == {T_ZERO, T_NEG_ONE, T_ZERO});    // 0-0 (ADDI - collision with BEQ resolved)

  wire op_is_beq  = (opcode == {T_NEG_ONE, T_POS_ONE, T_NEG_ONE}); // -+- (moved from 0-0 to resolve collision)
  wire op_is_bne  = (opcode == {T_ZERO, T_NEG_ONE, T_POS_ONE}); // 0-+
  wire op_is_blt  = (opcode == {T_ZERO, T_NEG_ONE, T_NEG_ONE}); // 0--

  wire op_is_min  = (opcode == {T_POS_ONE, T_ZERO, T_ZERO});    // +00
  wire op_is_max  = (opcode == {T_POS_ONE, T_ZERO, T_POS_ONE}); // +0+
  wire op_is_xor  = (opcode == {T_POS_ONE, T_ZERO, T_NEG_ONE}); // +0-
  wire op_is_inv  = (opcode == {T_POS_ONE, T_POS_ONE, T_ZERO}); // ++0
  wire op_is_pti  = (opcode == {T_POS_ONE, T_POS_ONE, T_POS_ONE}); // +++
  wire op_is_nti  = (opcode == {T_POS_ONE, T_POS_ONE, T_NEG_ONE}); // ++-

  wire op_is_jal  = (opcode == {T_POS_ONE, T_NEG_ONE, T_ZERO});    // +-0
  wire op_is_jalr = (opcode == {T_POS_ONE, T_NEG_ONE, T_POS_ONE}); // +-+
  wire op_is_jr   = (opcode == {T_POS_ONE, T_NEG_ONE, T_NEG_ONE}); // +--

  wire op_is_ld   = (opcode == {T_NEG_ONE, T_ZERO, T_ZERO});       // -00
  wire op_is_st   = (opcode == {T_NEG_ONE, T_ZERO, T_POS_ONE});    // -0+
  wire op_is_ldt  = (opcode == {T_NEG_ONE, T_ZERO, T_NEG_ONE});    // -0-
  wire op_is_stt  = (opcode == {T_NEG_ONE, T_POS_ONE, T_ZERO});    // -+0
  wire op_is_lui  = (opcode == {T_NEG_ONE, T_POS_ONE, T_POS_ONE}); // -++

  /* verilator lint_off UNUSED */
  // NOP and ECALL are decoded but intentionally set no control signals
  wire op_is_nop  = (opcode == {T_NEG_ONE, T_NEG_ONE, T_ZERO});    // --0 (no-operation)
  wire op_is_ecall= (opcode == {T_NEG_ONE, T_NEG_ONE, T_NEG_ONE}); // --- (environment call - future)
  /* verilator lint_on UNUSED */
  wire op_is_halt = (opcode == {T_NEG_ONE, T_NEG_ONE, T_POS_ONE}); // --+

  // Group classifications
  wire is_arithmetic = op_is_add | op_is_sub | op_is_neg | op_is_mul | op_is_shl | op_is_shr;
  wire is_logic      = op_is_min | op_is_max | op_is_xor | op_is_inv | op_is_pti | op_is_nti;
  wire is_branch     = op_is_beq | op_is_bne | op_is_blt;
  wire is_jump       = op_is_jal | op_is_jalr | op_is_jr;
  wire is_memory     = op_is_ld | op_is_st | op_is_ldt | op_is_stt | op_is_lui;

  // Decode control signals
  always_comb begin
    // Defaults
    reg_write   = 1'b0;
    mem_read    = 1'b0;
    mem_write   = 1'b0;
    branch      = 1'b0;
    branch_type = 2'b00;  // No branch
    jump        = 1'b0;
    alu_src     = 1'b0;   // Register source
    alu_op      = 3'b000; // ADD
    halt        = 1'b0;
    lui         = 1'b0;   // Not LUI by default

    // Arithmetic operations - write to register
    // Note: In this simple ISA, arithmetic ops use immediate for last operand
    // when Rs1 is R0 (base case for loading constants)
    if (is_arithmetic) begin
      reg_write = 1'b1;
      alu_src   = 1'b1;  // Use immediate as second operand
      case (1'b1)
        op_is_add: alu_op = 3'b000;  // ADD
        op_is_sub: alu_op = 3'b001;  // SUB
        op_is_neg: alu_op = 3'b010;  // NEG
        op_is_mul: alu_op = 3'b111;  // MUL (ternary multiplication)
        op_is_shl: alu_op = 3'b101;  // SHL
        op_is_shr: alu_op = 3'b110;  // SHR
        default:   alu_op = 3'b000;
      endcase
    end

    // Logic operations - write to register
    if (is_logic) begin
      reg_write = 1'b1;
      case (1'b1)
        op_is_min: alu_op = 3'b011;  // MIN
        op_is_max: alu_op = 3'b100;  // MAX
        op_is_xor: alu_op = 3'b000;  // XOR (implement as ADD mod 3)
        op_is_inv: alu_op = 3'b010;  // INV (NEG)
        op_is_pti: alu_op = 3'b010;  // PTI (special handling needed)
        op_is_nti: alu_op = 3'b010;  // NTI (special handling needed)
        default:   alu_op = 3'b011;
      endcase
    end

    // Branch operations - conditional PC update
    if (is_branch) begin
      branch = 1'b1;
      alu_op = 3'b001;  // SUB for comparison
      // Set branch type: 01=BEQ, 10=BNE, 11=BLT
      if (op_is_beq)      branch_type = 2'b01;  // BEQ: branch if equal (zero)
      else if (op_is_bne) branch_type = 2'b10;  // BNE: branch if not equal (!zero)
      else if (op_is_blt) branch_type = 2'b11;  // BLT: branch if less than (negative)
    end

    // Jump operations
    if (is_jump) begin
      jump = 1'b1;
      if (op_is_jal || op_is_jalr) begin
        reg_write = 1'b1;  // Save return address
      end
      alu_op = 3'b000;  // ADD for address calculation
      alu_src = 1'b1;   // Use immediate for JAL
    end

    // Memory operations
    if (op_is_ld || op_is_ldt) begin
      reg_write = 1'b1;
      mem_read  = 1'b1;
      alu_src   = 1'b1;  // Immediate offset
      alu_op    = 3'b000; // ADD for address
    end

    if (op_is_st || op_is_stt) begin
      mem_write = 1'b1;
      alu_src   = 1'b1;  // Immediate offset
      alu_op    = 3'b000; // ADD for address
    end

    // LUI - Load Upper Immediate (Register-based)
    // New semantics: Rd[upper] = Rs1[lower], Rd[lower] = 0
    if (op_is_lui) begin
      reg_write = 1'b1;
      alu_src   = 1'b0;   // Use Rs1 register as source
      lui       = 1'b1;   // Signal LUI operation for special handling
    end

    // ADDI - Add Immediate (separate from regular arithmetic)
    if (op_is_addi) begin
      reg_write = 1'b1;
      alu_src   = 1'b1;   // Use immediate as second operand
      alu_op    = 3'b000; // ADD operation
    end

    // System operations
    if (op_is_halt) begin
      halt = 1'b1;
    end

    // NOP and ECALL don't set any control signals
  end

endmodule
