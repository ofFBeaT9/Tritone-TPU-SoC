#!/usr/bin/env python3
"""
BTISA Assembler Unit Tests
Tests the assembler for correctness of instruction encoding and parsing
"""

import pytest
import sys
import os

# Add project tools to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'project', 'tools'))

from btisa_assembler import (
    BTISAAssembler, Instruction, OPCODES, REGISTERS,
    int_to_balanced_ternary, parse_register, parse_immediate
)


class TestBalancedTernaryConversion:
    """Test balanced ternary number conversion"""
    
    def test_zero(self):
        """Zero should be all zeros"""
        assert int_to_balanced_ternary(0, 2) == '00'
        assert int_to_balanced_ternary(0, 4) == '0000'
        assert int_to_balanced_ternary(0, 8) == '00000000'
    
    def test_positive_one(self):
        """1 in balanced ternary is +"""
        assert int_to_balanced_ternary(1, 2) == '+0'
    
    def test_negative_one(self):
        """−1 in balanced ternary is −"""
        assert int_to_balanced_ternary(-1, 2) == '-0'
    
    def test_positive_two(self):
        """2 in balanced ternary is +− (1×3 − 1×1)"""
        result = int_to_balanced_ternary(2, 2)
        assert result == '-+', f"Expected '-+' got '{result}'"
    
    def test_negative_two(self):
        """−2 in balanced ternary is −+ (−1×3 + 1×1)"""
        result = int_to_balanced_ternary(-2, 2)
        assert result == '+-', f"Expected '+-' got '{result}'"
    
    def test_positive_three(self):
        """3 in balanced ternary is +0 (1×3 + 0×1)"""
        result = int_to_balanced_ternary(3, 3)
        assert result == '0+0', f"Expected '0+0' got '{result}'"
    
    def test_negative_three(self):
        """−3 in balanced ternary is −0 (−1×3 + 0×1)"""
        result = int_to_balanced_ternary(-3, 3)
        assert result == '0-0', f"Expected '0-0' got '{result}'"
    
    def test_positive_four(self):
        """4 in balanced ternary is ++ (1×3 + 1×1)"""
        result = int_to_balanced_ternary(4, 2)
        assert result == '++', f"Expected '++' got '{result}'"
    
    def test_larger_values(self):
        """Test larger balanced ternary values"""
        # 13 = 1×9 + 1×3 + 1×1 = +++
        result = int_to_balanced_ternary(13, 4)
        assert result == '+++0', f"Expected '+++0' got '{result}'"
        
        # -13 = ---0
        result = int_to_balanced_ternary(-13, 4)
        assert result == '---0', f"Expected '---0' got '{result}'"


class TestRegisterParsing:
    """Test register name parsing"""
    
    def test_basic_registers(self):
        """Test basic R0-R8 registers"""
        assert parse_register('R0') == '00'
        assert parse_register('R1') == '0+'
        assert parse_register('R2') == '0-'
        assert parse_register('R3') == '+0'
        assert parse_register('R4') == '++'
        assert parse_register('R5') == '+-'
        assert parse_register('R6') == '-0'
        assert parse_register('R7') == '-+'
        assert parse_register('R8') == '--'
    
    def test_alias_registers(self):
        """Test register aliases"""
        assert parse_register('ZERO') == '00'  # R0
        assert parse_register('RA') == '--'    # R8
        assert parse_register('T1') == '0+'    # R1
    
    def test_case_insensitive(self):
        """Register names should be case insensitive"""
        assert parse_register('r0') == '00'
        assert parse_register('R0') == '00'
        assert parse_register('zero') == '00'
        assert parse_register('ZERO') == '00'
    
    def test_invalid_register(self):
        """Invalid register should raise ValueError"""
        with pytest.raises(ValueError):
            parse_register('R9')
        with pytest.raises(ValueError):
            parse_register('X0')


class TestImmediateParsing:
    """Test immediate value parsing"""
    
    def test_positive_immediate(self):
        """Test positive immediate values"""
        assert parse_immediate('0') == '00'
        assert parse_immediate('1') == '+0'
    
    def test_negative_immediate(self):
        """Test negative immediate values"""
        assert parse_immediate('-1') == '-0'


class TestInstructionEncoding:
    """Test instruction encoding"""
    
    def test_instruction_encode(self):
        """Test basic instruction encoding"""
        instr = Instruction('000', '0+', '0-', '+0')
        encoded = instr.encode()
        assert encoded == '0000+0-+0'
        assert len(encoded) == 9
    
    def test_nop_encoding(self):
        """NOP should encode correctly"""
        instr = Instruction(OPCODES['NOP'])
        encoded = instr.encode()
        assert encoded == '--0000000'
    
    def test_halt_encoding(self):
        """HALT should encode correctly"""
        instr = Instruction(OPCODES['HALT'])
        encoded = instr.encode()
        assert encoded == '--+000000'


class TestAssemblerBasic:
    """Test basic assembler functionality"""
    
    def test_empty_program(self):
        """Empty program should produce empty output"""
        asm = BTISAAssembler()
        instructions = asm.assemble("")
        assert instructions == []
    
    def test_comment_only(self):
        """Comment-only lines should be skipped"""
        asm = BTISAAssembler()
        instructions = asm.assemble("# This is a comment")
        assert instructions == []
    
    def test_nop_instruction(self):
        """NOP instruction should assemble"""
        asm = BTISAAssembler()
        instructions = asm.assemble("NOP")
        assert len(instructions) == 1
        assert instructions[0].encode().startswith('--0')
    
    def test_halt_instruction(self):
        """HALT instruction should assemble"""
        asm = BTISAAssembler()
        instructions = asm.assemble("HALT")
        assert len(instructions) == 1
        assert instructions[0].encode().startswith('--+')


class TestAssemblerArithmetic:
    """Test arithmetic instruction assembly"""
    
    def test_add_instruction(self):
        """ADD R3, R1, R2 should assemble correctly"""
        asm = BTISAAssembler()
        instructions = asm.assemble("ADD R3, R1, R2")
        assert len(instructions) == 1
        instr = instructions[0]
        assert instr.opcode == OPCODES['ADD']  # 000
        assert instr.rd == REGISTERS['R3']     # +0
        assert instr.rs1 == REGISTERS['R1']    # 0+
        assert instr.rs2_imm == REGISTERS['R2'] # 0-
    
    def test_sub_instruction(self):
        """SUB R4, R2, R1 should assemble correctly"""
        asm = BTISAAssembler()
        instructions = asm.assemble("SUB R4, R2, R1")
        assert len(instructions) == 1
        instr = instructions[0]
        assert instr.opcode == OPCODES['SUB']
        assert instr.rd == REGISTERS['R4']
        assert instr.rs1 == REGISTERS['R2']
        assert instr.rs2_imm == REGISTERS['R1']
    
    def test_neg_instruction(self):
        """NEG R2, R1 should assemble correctly"""
        asm = BTISAAssembler()
        instructions = asm.assemble("NEG R2, R1")
        assert len(instructions) == 1
        instr = instructions[0]
        assert instr.opcode == OPCODES['NEG']
        assert instr.rd == REGISTERS['R2']
        assert instr.rs1 == REGISTERS['R1']


class TestAssemblerPseudoInstructions:
    """Test pseudo-instruction assembly"""
    
    def test_ldi_instruction(self):
        """LDI R1, 1 should expand to ADDI R1, R0, 1"""
        asm = BTISAAssembler()
        instructions = asm.assemble("LDI R1, 1")
        assert len(instructions) == 1
        instr = instructions[0]
        assert instr.opcode == OPCODES['ADDI']
        assert instr.rd == REGISTERS['R1']
        assert instr.rs1 == REGISTERS['R0']  # R0 = 00
    
    def test_mov_instruction(self):
        """MOV R2, R1 should expand to ADD R2, R1, R0"""
        asm = BTISAAssembler()
        instructions = asm.assemble("MOV R2, R1")
        assert len(instructions) == 1
        instr = instructions[0]
        assert instr.opcode == OPCODES['ADD']
        assert instr.rd == REGISTERS['R2']
        assert instr.rs1 == REGISTERS['R1']
        assert instr.rs2_imm == '00'  # R0


class TestAssemblerLabels:
    """Test label handling"""
    
    def test_simple_label(self):
        """Simple label should be resolved"""
        asm = BTISAAssembler()
        source = """
            NOP
LOOP:       ADD R1, R1, R2
            NOP
        """
        instructions = asm.assemble(source)
        assert len(instructions) == 3
        assert 'LOOP' in asm.labels
        assert asm.labels['LOOP'] == 1  # Second instruction
    
    def test_multiple_labels(self):
        """Multiple labels should all be resolved"""
        asm = BTISAAssembler()
        source = """
START:      NOP
MIDDLE:     ADD R1, R1, R2
END:        HALT
        """
        instructions = asm.assemble(source)
        assert len(instructions) == 3
        assert asm.labels['START'] == 0
        assert asm.labels['MIDDLE'] == 1
        assert asm.labels['END'] == 2


class TestAssemblerPrograms:
    """Test complete program assembly"""
    
    def test_arithmetic_program(self):
        """Test arithmetic program assembly"""
        asm = BTISAAssembler()
        source = """
# Simple arithmetic test
LDI R1, 1          # R1 = 1
LDI R2, 1          # R2 = 1
ADD R3, R1, R2     # R3 = 2
SUB R4, R3, R1     # R4 = 1
NEG R5, R4         # R5 = -1
HALT
        """
        instructions = asm.assemble(source)
        assert len(instructions) == 6
        
        # Verify instruction types
        assert instructions[0].opcode == OPCODES['ADDI']  # LDI -> ADDI
        assert instructions[1].opcode == OPCODES['ADDI']
        assert instructions[2].opcode == OPCODES['ADD']
        assert instructions[3].opcode == OPCODES['SUB']
        assert instructions[4].opcode == OPCODES['NEG']
        assert instructions[5].opcode == OPCODES['HALT']
    
    def test_memory_output(self):
        """Test memory file output generation"""
        asm = BTISAAssembler()
        source = """
NOP
HALT
        """
        instructions = asm.assemble(source)
        output = asm.output_mem(instructions)
        
        assert '// BTISA Machine Code' in output
        assert 'T_ZERO' in output or 'T_NEG_ONE' in output or 'T_POS_ONE' in output


class TestAssemblerEdgeCases:
    """Test edge cases and error handling"""
    
    def test_whitespace_handling(self):
        """Extra whitespace should be handled"""
        asm = BTISAAssembler()
        instructions = asm.assemble("   ADD    R1,   R2,    R3   ")
        assert len(instructions) == 1
    
    def test_mixed_case(self):
        """Mixed case should work"""
        asm = BTISAAssembler()
        instructions = asm.assemble("add r1, R2, r3")
        assert len(instructions) == 1
    
    def test_invalid_opcode(self):
        """Invalid opcode should raise error"""
        asm = BTISAAssembler()
        with pytest.raises(ValueError):
            asm.assemble("INVALID R1, R2")
    
    def test_missing_operand(self):
        """Missing operand should raise error"""
        asm = BTISAAssembler()
        with pytest.raises(ValueError):
            asm.assemble("ADD R1, R2")  # Missing RS2


class TestTernaryMathOperations:
    """Test ternary math operations via balanced ternary"""
    
    def test_ternary_range(self):
        """Test values in 2-trit range (−4 to +4)"""
        # 2-trit balanced ternary can represent -4 to +4
        for val in range(-4, 5):
            result = int_to_balanced_ternary(val, 2)
            assert len(result) == 2
    
    def test_roundtrip_conversion(self):
        """Values should survive conversion roundtrip"""
        # Helper to convert back from balanced ternary
        def bt_to_int(bt_str):
            power = 1
            result = 0
            for char in bt_str:
                if char == '+':
                    result += power
                elif char == '-':
                    result -= power
                power *= 3
            return result
        
        for val in range(-40, 41):
            bt = int_to_balanced_ternary(val, 8)
            back = bt_to_int(bt)
            assert back == val, f"Roundtrip failed for {val}: got {back}"


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
