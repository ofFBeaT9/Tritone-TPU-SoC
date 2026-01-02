#!/usr/bin/env python3
"""
BTISA Decoder Golden Model and Test Vector Generator

Generates exhaustive test vectors for the BTISA instruction decoder.
Tests all 27 opcodes × 9 rd × 9 rs1 × 9 rs2_imm = 19,683 instruction combinations.

Usage:
    python generate_decoder_tests.py [--output decoder_test_vectors.txt]

Output format (one line per test):
    instruction[17:0] reg_write mem_read mem_write branch branch_type[1:0] jump alu_src alu_op[2:0] halt lui

Author: Generated for Tritone BTISA v0.2
"""

import argparse
from dataclasses import dataclass
from typing import Tuple, List

# Trit values (2-bit encoding)
T_ZERO = 0b00      # 0
T_POS_ONE = 0b01   # +1
T_NEG_ONE = 0b10   # -1
T_INVALID = 0b11   # Invalid

# Trit names for readability
TRIT_NAMES = {T_ZERO: '0', T_POS_ONE: '+', T_NEG_ONE: '-', T_INVALID: 'X'}

# Opcode definitions (3 trits = 6 bits)
OPCODES = {
    'ADD':  (T_ZERO, T_ZERO, T_ZERO),       # 000
    'SUB':  (T_ZERO, T_ZERO, T_POS_ONE),    # 00+
    'NEG':  (T_ZERO, T_ZERO, T_NEG_ONE),    # 00-
    'MUL':  (T_ZERO, T_POS_ONE, T_ZERO),    # 0+0
    'SHL':  (T_ZERO, T_POS_ONE, T_POS_ONE), # 0++
    'SHR':  (T_ZERO, T_POS_ONE, T_NEG_ONE), # 0+-
    'ADDI': (T_ZERO, T_NEG_ONE, T_ZERO),    # 0-0
    'BNE':  (T_ZERO, T_NEG_ONE, T_POS_ONE), # 0-+
    'BLT':  (T_ZERO, T_NEG_ONE, T_NEG_ONE), # 0--
    'MIN':  (T_POS_ONE, T_ZERO, T_ZERO),    # +00
    'MAX':  (T_POS_ONE, T_ZERO, T_POS_ONE), # +0+
    'XOR':  (T_POS_ONE, T_ZERO, T_NEG_ONE), # +0-
    'INV':  (T_POS_ONE, T_POS_ONE, T_ZERO), # ++0
    'PTI':  (T_POS_ONE, T_POS_ONE, T_POS_ONE), # +++
    'NTI':  (T_POS_ONE, T_POS_ONE, T_NEG_ONE), # ++-
    'JAL':  (T_POS_ONE, T_NEG_ONE, T_ZERO),    # +-0
    'JALR': (T_POS_ONE, T_NEG_ONE, T_POS_ONE), # +-+
    'JR':   (T_POS_ONE, T_NEG_ONE, T_NEG_ONE), # +--
    'LD':   (T_NEG_ONE, T_ZERO, T_ZERO),       # -00
    'ST':   (T_NEG_ONE, T_ZERO, T_POS_ONE),    # -0+
    'LDT':  (T_NEG_ONE, T_ZERO, T_NEG_ONE),    # -0-
    'STT':  (T_NEG_ONE, T_POS_ONE, T_ZERO),    # -+0
    'LUI':  (T_NEG_ONE, T_POS_ONE, T_POS_ONE), # -++
    'BEQ':  (T_NEG_ONE, T_POS_ONE, T_NEG_ONE), # -+- (moved from 0-0 in v0.2)
    'NOP':  (T_NEG_ONE, T_NEG_ONE, T_ZERO),    # --0
    'HALT': (T_NEG_ONE, T_NEG_ONE, T_POS_ONE), # --+
    'ECALL':(T_NEG_ONE, T_NEG_ONE, T_NEG_ONE), # ---
}

# ALU operation codes (3-bit binary)
ALU_ADD = 0b000
ALU_SUB = 0b001
ALU_NEG = 0b010
ALU_MIN = 0b011
ALU_MAX = 0b100
ALU_SHL = 0b101
ALU_SHR = 0b110
ALU_MUL = 0b111

# Branch types
BR_NONE = 0b00
BR_BEQ = 0b01
BR_BNE = 0b10
BR_BLT = 0b11


@dataclass
class DecoderOutput:
    """Expected decoder output signals"""
    reg_write: int = 0
    mem_read: int = 0
    mem_write: int = 0
    branch: int = 0
    branch_type: int = 0  # 2 bits
    jump: int = 0
    alu_src: int = 0
    alu_op: int = 0  # 3 bits
    halt: int = 0
    lui: int = 0


def opcode_to_bits(opcode: Tuple[int, int, int]) -> int:
    """Convert 3-trit opcode to 6-bit value"""
    return (opcode[0] << 4) | (opcode[1] << 2) | opcode[2]


def trit2_to_bits(t1: int, t0: int) -> int:
    """Convert 2-trit field to 4-bit value"""
    return (t1 << 2) | t0


def instruction_to_bits(opcode: Tuple[int, int, int], rd: Tuple[int, int],
                        rs1: Tuple[int, int], rs2_imm: Tuple[int, int]) -> int:
    """Convert instruction fields to 18-bit instruction word"""
    # [17:12] opcode (6 bits), [11:8] rd (4 bits), [7:4] rs1 (4 bits), [3:0] rs2_imm (4 bits)
    return ((opcode[0] << 16) | (opcode[1] << 14) | (opcode[2] << 12) |
            (rd[0] << 10) | (rd[1] << 8) |
            (rs1[0] << 6) | (rs1[1] << 4) |
            (rs2_imm[0] << 2) | rs2_imm[1])


def decode_instruction(opcode: Tuple[int, int, int]) -> DecoderOutput:
    """
    Golden model: decode instruction opcode and return expected control signals.
    This implements the exact same logic as btisa_decoder.sv
    """
    out = DecoderOutput()

    # Find matching opcode
    mnemonic = None
    for name, op in OPCODES.items():
        if op == opcode:
            mnemonic = name
            break

    if mnemonic is None:
        # Unknown opcode - return defaults
        return out

    # Arithmetic operations
    if mnemonic in ('ADD', 'SUB', 'NEG', 'MUL', 'SHL', 'SHR'):
        out.reg_write = 1
        out.alu_src = 1  # Use immediate as second operand (current RTL behavior)
        if mnemonic == 'ADD':
            out.alu_op = ALU_ADD
        elif mnemonic == 'SUB':
            out.alu_op = ALU_SUB
        elif mnemonic == 'NEG':
            out.alu_op = ALU_NEG
        elif mnemonic == 'MUL':
            out.alu_op = ALU_MUL
        elif mnemonic == 'SHL':
            out.alu_op = ALU_SHL
        elif mnemonic == 'SHR':
            out.alu_op = ALU_SHR

    # Logic operations
    elif mnemonic in ('MIN', 'MAX', 'XOR', 'INV', 'PTI', 'NTI'):
        out.reg_write = 1
        if mnemonic == 'MIN':
            out.alu_op = ALU_MIN
        elif mnemonic == 'MAX':
            out.alu_op = ALU_MAX
        elif mnemonic == 'XOR':
            out.alu_op = ALU_ADD  # XOR implemented as ADD mod 3
        elif mnemonic in ('INV', 'PTI', 'NTI'):
            out.alu_op = ALU_NEG  # INV/PTI/NTI use NEG

    # Branch operations
    elif mnemonic in ('BEQ', 'BNE', 'BLT'):
        out.branch = 1
        out.alu_op = ALU_SUB  # SUB for comparison
        if mnemonic == 'BEQ':
            out.branch_type = BR_BEQ
        elif mnemonic == 'BNE':
            out.branch_type = BR_BNE
        elif mnemonic == 'BLT':
            out.branch_type = BR_BLT

    # Jump operations
    elif mnemonic in ('JAL', 'JALR', 'JR'):
        out.jump = 1
        out.alu_op = ALU_ADD
        out.alu_src = 1
        if mnemonic in ('JAL', 'JALR'):
            out.reg_write = 1

    # Memory load operations
    elif mnemonic in ('LD', 'LDT'):
        out.reg_write = 1
        out.mem_read = 1
        out.alu_src = 1
        out.alu_op = ALU_ADD

    # Memory store operations
    elif mnemonic in ('ST', 'STT'):
        out.mem_write = 1
        out.alu_src = 1
        out.alu_op = ALU_ADD

    # LUI - Load Upper Immediate (register-based in v0.2)
    elif mnemonic == 'LUI':
        out.reg_write = 1
        out.alu_src = 0  # Use Rs1 register as source
        out.lui = 1

    # ADDI - Add Immediate
    elif mnemonic == 'ADDI':
        out.reg_write = 1
        out.alu_src = 1
        out.alu_op = ALU_ADD

    # HALT
    elif mnemonic == 'HALT':
        out.halt = 1

    # NOP and ECALL - no control signals
    elif mnemonic in ('NOP', 'ECALL'):
        pass

    return out


def opcode_name(opcode: Tuple[int, int, int]) -> str:
    """Get the mnemonic name for an opcode"""
    for name, op in OPCODES.items():
        if op == opcode:
            return name
    return "UNKNOWN"


def trit_string(t: int) -> str:
    """Convert trit value to string representation"""
    return TRIT_NAMES.get(t, '?')


def generate_all_test_vectors() -> List[str]:
    """Generate test vectors for all 19,683 instruction combinations"""
    vectors = []
    trit_values = [T_ZERO, T_POS_ONE, T_NEG_ONE]  # Valid trits only

    # All 27 opcodes
    for opcode in OPCODES.values():
        # All 9 rd combinations
        for rd0 in trit_values:
            for rd1 in trit_values:
                rd = (rd0, rd1)
                # All 9 rs1 combinations
                for rs1_0 in trit_values:
                    for rs1_1 in trit_values:
                        rs1 = (rs1_0, rs1_1)
                        # All 9 rs2_imm combinations
                        for rs2_0 in trit_values:
                            for rs2_1 in trit_values:
                                rs2_imm = (rs2_0, rs2_1)

                                # Build instruction word
                                instr = instruction_to_bits(opcode, rd, rs1, rs2_imm)

                                # Get expected outputs
                                out = decode_instruction(opcode)

                                # Format: instruction expected_outputs
                                # instruction is 18 bits (9 trits × 2 bits each)
                                # outputs: reg_write mem_read mem_write branch branch_type jump alu_src alu_op halt lui
                                vector = (
                                    f"{instr:05X} "  # 18-bit instruction in hex (5 hex digits)
                                    f"{out.reg_write} "
                                    f"{out.mem_read} "
                                    f"{out.mem_write} "
                                    f"{out.branch} "
                                    f"{out.branch_type:02b} "
                                    f"{out.jump} "
                                    f"{out.alu_src} "
                                    f"{out.alu_op:03b} "
                                    f"{out.halt} "
                                    f"{out.lui}"
                                )
                                vectors.append(vector)

    return vectors


def generate_opcode_summary() -> str:
    """Generate a summary of all opcodes for documentation"""
    lines = ["# BTISA v0.2 Opcode Summary", "#"]
    lines.append("# Opcode  Name   Binary(6b)  Trit Pattern")
    lines.append("# " + "-" * 50)

    for name, opcode in sorted(OPCODES.items(), key=lambda x: opcode_to_bits(x[1])):
        bits = opcode_to_bits(opcode)
        pattern = ''.join(trit_string(t) for t in opcode)
        lines.append(f"# {bits:06b}  {name:6s} {bits:02X}         {pattern}")

    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description='Generate BTISA decoder test vectors')
    parser.add_argument('--output', '-o', default='decoder_test_vectors.txt',
                        help='Output file for test vectors')
    parser.add_argument('--summary', '-s', action='store_true',
                        help='Print opcode summary')
    args = parser.parse_args()

    if args.summary:
        print(generate_opcode_summary())
        return

    print(f"Generating exhaustive decoder test vectors...")
    print(f"Total combinations: 27 opcodes × 9 rd × 9 rs1 × 9 rs2_imm = {27*9*9*9}")

    vectors = generate_all_test_vectors()

    # Write to file
    with open(args.output, 'w') as f:
        # Header
        f.write("# BTISA Decoder Test Vectors\n")
        f.write("# Generated by generate_decoder_tests.py\n")
        f.write("# BTISA v0.2 - All 27 opcodes unique (BEQ at -+-, no collision)\n")
        f.write("#\n")
        f.write("# Format: INSTR REG_WR MEM_RD MEM_WR BR BR_TYPE JMP ALU_SRC ALU_OP HALT LUI\n")
        f.write("# INSTR: 18-bit instruction (5 hex digits)\n")
        f.write("# REG_WR, MEM_RD, MEM_WR, BR, JMP, HALT, LUI: 1-bit signals\n")
        f.write("# BR_TYPE: 2-bit branch type (00=none, 01=BEQ, 10=BNE, 11=BLT)\n")
        f.write("# ALU_SRC: 0=register, 1=immediate\n")
        f.write("# ALU_OP: 3-bit ALU operation (000=ADD, 001=SUB, 010=NEG, 011=MIN, 100=MAX, 101=SHL, 110=SHR, 111=MUL)\n")
        f.write("#\n")
        f.write(generate_opcode_summary() + "\n")
        f.write("#\n")
        f.write(f"# Total test vectors: {len(vectors)}\n")
        f.write("#\n")

        for v in vectors:
            f.write(v + "\n")

    print(f"Generated {len(vectors)} test vectors to {args.output}")

    # Verify count
    expected = 27 * 9 * 9 * 9
    if len(vectors) != expected:
        print(f"WARNING: Expected {expected} vectors, got {len(vectors)}")
    else:
        print(f"Verification: {len(vectors)} == {expected} (27 × 9 × 9 × 9) ✓")


if __name__ == '__main__':
    main()
