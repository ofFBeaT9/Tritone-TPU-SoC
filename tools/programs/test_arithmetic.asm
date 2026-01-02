# BTISA Test Program: Arithmetic Operations
# Tests basic arithmetic and logic instructions
#
# Expected results:
#   R1 = 1
#   R2 = 2
#   R3 = 3
#   R4 = 9 (3 shifted left = 3*3)
#   R5 = 1 (MIN of 3 and 1)
#   R6 = 3 (MAX of 3 and 1)
#   R7 = -3 (negation of R3)

# Initialize registers
        ADDI R1, R0, 1      # R1 = 1
        ADDI R2, R1, 1      # R2 = R1 + 1 = 2
        ADD  R3, R1, R2     # R3 = R1 + R2 = 3

# Test shift operations
        SHL  R4, R3         # R4 = R3 << 1 = 9 (multiply by 3)

# Test logic operations
        MIN  R5, R3, R1     # R5 = MIN(3, 1) = 1
        MAX  R6, R3, R1     # R6 = MAX(3, 1) = 3

# Test negation
        NEG  R7, R3         # R7 = -R3 = -3

# End program
        NOP
        NOP
        HALT
