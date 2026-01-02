#!/usr/bin/env python3
"""
BTISA Assembler
Assembles BTISA assembly language into ternary machine code

Usage: python btisa_assembler.py input.asm [-o output.mem]
"""

import re
import sys
from dataclasses import dataclass
from typing import Dict, List, Tuple, Optional

# Ternary trit values
T_NEG = '-'
T_ZERO = '0'
T_POS = '+'

# Opcode definitions (3 trits each)
OPCODES = {
    # Arithmetic
    'ADD':  '000',
    'SUB':  '00+',
    'NEG':  '00-',
    'MUL':  '0+0',
    'SHL':  '0++',
    'SHR':  '0+-',
    'ADDI': '0-0',
    # Logic
    'MIN':  '+00',
    'MAX':  '+0+',
    'XOR':  '+0-',
    'INV':  '++0',
    'PTI':  '+++',
    'NTI':  '++-',
    # Control
    'BEQ':  '0-0',
    'BNE':  '0-+',
    'BLT':  '0--',
    'JAL':  '+-0',
    'JALR': '+-+',
    'JR':   '+--',
    # Memory
    'LD':   '-00',
    'ST':   '-0+',
    'LDT':  '-0-',
    'STT':  '-+0',
    'LUI':  '-++',
    # System
    'NOP':  '--0',
    'HALT': '--+',
    'ECALL': '---',
}

# Register aliases
REGISTERS = {
    'R0': '00', 'ZERO': '00',
    'R1': '0+', 'T1': '0+',
    'R2': '0-', 'T2': '0-',
    'R3': '+0', 'T3': '+0',
    'R4': '++', 'T4': '++',
    'R5': '+-', 'T5': '+-',
    'R6': '-0', 'T6': '-0',
    'R7': '-+', 'T7': '-+',
    'R8': '--', 'RA': '--',
}


def int_to_balanced_ternary(n: int, width: int) -> str:
    """Convert integer to balanced ternary string."""
    if n == 0:
        return '0' * width
    
    result = []
    is_negative = n < 0
    n = abs(n)
    
    while n > 0:
        remainder = n % 3
        if remainder == 0:
            result.append('0')
        elif remainder == 1:
            result.append('+')
        else:  # remainder == 2
            result.append('-')
            n += 1
        n //= 3
    
    # Pad to width
    while len(result) < width:
        result.append('0')
    
    # Truncate if too long
    result = result[:width]
    
    # If original was negative, negate the result
    if is_negative:
        result = ['-' if t == '+' else '+' if t == '-' else '0' for t in result]
    
    return ''.join(result)


def parse_register(reg_str: str) -> str:
    """Parse a register name and return its 2-trit encoding."""
    reg_str = reg_str.upper().strip()
    if reg_str in REGISTERS:
        return REGISTERS[reg_str]
    raise ValueError(f"Unknown register: {reg_str}")


def parse_immediate(imm_str: str) -> str:
    """Parse an immediate value and return its 2-trit encoding."""
    imm_str = imm_str.strip()
    try:
        value = int(imm_str)
        return int_to_balanced_ternary(value, 2)
    except ValueError:
        # Maybe it's a label reference
        raise ValueError(f"Cannot parse immediate: {imm_str}")


@dataclass
class Instruction:
    opcode: str
    rd: str = '00'
    rs1: str = '00'
    rs2_imm: str = '00'
    
    def encode(self) -> str:
        """Encode instruction as 9-trit string."""
        return self.opcode + self.rd + self.rs1 + self.rs2_imm
    
    def to_binary(self) -> str:
        """Convert to 18-bit binary (2 bits per trit)."""
        encoding = {'-': '10', '0': '00', '+': '01'}
        return ''.join(encoding[t] for t in self.encode())
    
    def to_hex(self) -> str:
        """Convert to hexadecimal."""
        binary = self.to_binary()
        return hex(int(binary, 2))[2:].zfill(5)


class BTISAAssembler:
    def __init__(self):
        self.labels: Dict[str, int] = {}
        self.instructions: List[Tuple[int, str, Instruction]] = []
        self.current_addr = 0
    
    def first_pass(self, lines: List[str]):
        """First pass: collect labels."""
        self.current_addr = 0
        for line in lines:
            line = self._clean_line(line)
            if not line:
                continue
            
            # Check for label
            if ':' in line:
                label, rest = line.split(':', 1)
                self.labels[label.strip().upper()] = self.current_addr
                line = rest.strip()
                if not line:
                    continue
            
            # Count instruction
            self.current_addr += 1
    
    def second_pass(self, lines: List[str]) -> List[Instruction]:
        """Second pass: assemble instructions."""
        self.current_addr = 0
        result = []
        
        for line_num, line in enumerate(lines, 1):
            line = self._clean_line(line)
            if not line:
                continue
            
            # Skip label definition
            if ':' in line:
                _, line = line.split(':', 1)
                line = line.strip()
                if not line:
                    continue
            
            try:
                instr = self._parse_instruction(line)
                result.append(instr)
                self.instructions.append((self.current_addr, line, instr))
                self.current_addr += 1
            except Exception as e:
                print(f"Error at line {line_num}: {e}")
                print(f"  {line}")
                raise
        
        return result
    
    def _clean_line(self, line: str) -> str:
        """Remove comments and whitespace."""
        # Remove comments
        if '#' in line:
            line = line[:line.index('#')]
        if ';' in line:
            line = line[:line.index(';')]
        return line.strip()
    
    def _parse_instruction(self, line: str) -> Instruction:
        """Parse a single instruction line."""
        parts = re.split(r'[,\s]+', line)
        parts = [p for p in parts if p]
        
        if not parts:
            return Instruction(OPCODES['NOP'])
        
        mnemonic = parts[0].upper()
        
        # Handle pseudo-instructions first
        # LDI RD, IMM -> ADDI RD, R0, IMM
        if mnemonic == 'LDI':
            if len(parts) < 3:
                raise ValueError("LDI requires 2 operands (LDI RD, IMM)")
            rd = parse_register(parts[1])
            imm = self._parse_immediate_or_label(parts[2])
            return Instruction(OPCODES['ADDI'], rd, '00', imm)  # R0 = '00'
        
        # MOV RD, RS -> ADD RD, RS, R0
        if mnemonic == 'MOV':
            if len(parts) < 3:
                raise ValueError("MOV requires 2 operands (MOV RD, RS)")
            rd = parse_register(parts[1])
            rs = parse_register(parts[2])
            return Instruction(OPCODES['ADD'], rd, rs, '00')  # R0 = '00'
        
        # BEQZ RS, LABEL -> BEQ RS, R0, LABEL
        if mnemonic == 'BEQZ':
            if len(parts) < 3:
                raise ValueError("BEQZ requires 2 operands (BEQZ RS, LABEL)")
            rs = parse_register(parts[1])
            offset = self._parse_branch_target(parts[2])
            return Instruction(OPCODES['BEQ'], offset, rs, '00')  # Compare with R0
        
        # BNEZ RS, LABEL -> BNE RS, R0, LABEL
        if mnemonic == 'BNEZ':
            if len(parts) < 3:
                raise ValueError("BNEZ requires 2 operands (BNEZ RS, LABEL)")
            rs = parse_register(parts[1])
            offset = self._parse_branch_target(parts[2])
            return Instruction(OPCODES['BNE'], offset, rs, '00')  # Compare with R0
        
        # JMP LABEL -> JAL R0, LABEL (discard return address)
        if mnemonic == 'JMP':
            if len(parts) < 2:
                raise ValueError("JMP requires 1 operand (JMP LABEL)")
            offset = self._parse_immediate_or_label(parts[1])
            return Instruction(OPCODES['JAL'], '00', '00', offset)  # R0 = discard
        
        # RET -> JR R8 (return via RA register)
        if mnemonic == 'RET':
            return Instruction(OPCODES['JR'], '00', '--', '00')  # R8 = '--'
        
        # FENCE -> NOP (no memory ordering in this simple design)
        if mnemonic == 'FENCE':
            return Instruction(OPCODES['NOP'])
        
        if mnemonic not in OPCODES:
            raise ValueError(f"Unknown instruction: {mnemonic}")
        
        opcode = OPCODES[mnemonic]
        
        # R-type: OP RD, RS1, RS2
        if mnemonic in ['ADD', 'SUB', 'MIN', 'MAX', 'XOR']:
            if len(parts) < 4:
                raise ValueError(f"{mnemonic} requires 3 operands")
            rd = parse_register(parts[1])
            rs1 = parse_register(parts[2])
            rs2 = parse_register(parts[3])
            return Instruction(opcode, rd, rs1, rs2)
        
        # I-type: OP RD, RS1, IMM
        if mnemonic in ['ADDI', 'LD', 'ST', 'LDT', 'STT']:
            if len(parts) < 4:
                # Allow LD RD, RS1 (imm=0)
                if len(parts) == 3:
                    rd = parse_register(parts[1])
                    rs1 = parse_register(parts[2])
                    return Instruction(opcode, rd, rs1, '00')
                raise ValueError(f"{mnemonic} requires 3 operands")
            rd = parse_register(parts[1])
            rs1 = parse_register(parts[2])
            imm = self._parse_immediate_or_label(parts[3])
            return Instruction(opcode, rd, rs1, imm)
        
        # Unary: OP RD, RS1
        if mnemonic in ['NEG', 'INV', 'PTI', 'NTI', 'SHL', 'SHR']:
            if len(parts) < 3:
                raise ValueError(f"{mnemonic} requires 2 operands")
            rd = parse_register(parts[1])
            rs1 = parse_register(parts[2])
            return Instruction(opcode, rd, rs1, '00')
        
        # Branch: OP RS1, RS2, LABEL
        if mnemonic in ['BEQ', 'BNE', 'BLT']:
            if len(parts) < 4:
                raise ValueError(f"{mnemonic} requires 3 operands")
            rs1 = parse_register(parts[1])
            rs2 = parse_register(parts[2])
            offset = self._parse_branch_target(parts[3])
            return Instruction(opcode, offset, rs1, rs2)
        
        # Jump: JAL RD, LABEL or JR RS1
        if mnemonic == 'JAL':
            if len(parts) < 3:
                raise ValueError("JAL requires 2 operands")
            rd = parse_register(parts[1])
            offset = self._parse_immediate_or_label(parts[2])
            return Instruction(opcode, rd, '00', offset)
        
        if mnemonic in ['JALR', 'JR']:
            if len(parts) < 2:
                raise ValueError(f"{mnemonic} requires 1 operand")
            rs1 = parse_register(parts[1])
            rd = '00' if mnemonic == 'JR' else parse_register(parts[2]) if len(parts) > 2 else '--'
            return Instruction(opcode, rd, rs1, '00')
        
        # LUI: LUI RD, IMM
        if mnemonic == 'LUI':
            if len(parts) < 3:
                raise ValueError("LUI requires 2 operands")
            rd = parse_register(parts[1])
            imm = self._parse_immediate_or_label(parts[2])
            return Instruction(opcode, rd, '00', imm)
        
        # System: NOP, HALT, ECALL
        if mnemonic in ['NOP', 'HALT', 'ECALL']:
            return Instruction(opcode)
        
        raise ValueError(f"Cannot parse instruction: {line}")
    
    def _parse_immediate_or_label(self, s: str) -> str:
        """Parse immediate value or label reference."""
        s = s.strip()
        if s.upper() in self.labels:
            return int_to_balanced_ternary(self.labels[s.upper()], 2)
        return parse_immediate(s)
    
    def _parse_branch_target(self, s: str) -> str:
        """Parse branch target (relative offset)."""
        s = s.strip()
        if s.upper() in self.labels:
            target = self.labels[s.upper()]
            offset = target - self.current_addr - 1  # PC-relative
            return int_to_balanced_ternary(offset, 2)
        return parse_immediate(s)
    
    def assemble(self, source: str) -> List[Instruction]:
        """Assemble source code."""
        lines = source.split('\n')
        self.first_pass(lines)
        return self.second_pass(lines)
    
    def output_mem(self, instructions: List[Instruction]) -> str:
        """Generate memory initialization file."""
        lines = ["// BTISA Machine Code"]
        lines.append("// Format: address: ternary_encoding // mnemonic")
        lines.append("")
        
        for addr, (_, src, instr) in enumerate(self.instructions):
            encoding = instr.encode()
            lines.append(f"// {addr:3d}: {encoding}  // {src}")
        
        lines.append("")
        lines.append("// SystemVerilog initialization:")
        for addr, (_, _, instr) in enumerate(self.instructions):
            enc = instr.encode()
            sv_trits = []
            for t in reversed(enc):  # MSB first for SV
                if t == '-':
                    sv_trits.append("T_NEG_ONE")
                elif t == '0':
                    sv_trits.append("T_ZERO")
                else:
                    sv_trits.append("T_POS_ONE")
            lines.append(f"imem[{addr}] = '{{ {', '.join(sv_trits)} }};")
        
        return '\n'.join(lines)


def main():
    if len(sys.argv) < 2:
        # Demo program
        demo = """
# Simple arithmetic test
        ADD R1, R0, R1      # R1 = 0 + R1 (assuming R1 has immediate interpretation)
        ADDI R1, R0, 1      # R1 = 0 + 1 = 1
        ADDI R2, R1, 1      # R2 = 1 + 1 = 2
        ADD R3, R1, R2      # R3 = 1 + 2 = 3
        SHL R4, R3          # R4 = R3 << 1 = 9
        NOP
        HALT
"""
        print("BTISA Assembler Demo")
        print("=" * 40)
        print("Source:")
        print(demo)
        print("=" * 40)
        
        asm = BTISAAssembler()
        instructions = asm.assemble(demo)
        
        print("Assembled output:")
        print(asm.output_mem(instructions))
        return
    
    # Read input file
    with open(sys.argv[1], 'r') as f:
        source = f.read()
    
    asm = BTISAAssembler()
    instructions = asm.assemble(source)
    
    output = asm.output_mem(instructions)
    
    # Write output
    if len(sys.argv) > 2 and sys.argv[2] == '-o' and len(sys.argv) > 3:
        with open(sys.argv[3], 'w') as f:
            f.write(output)
        print(f"Output written to {sys.argv[3]}")
    else:
        print(output)


if __name__ == '__main__':
    main()
