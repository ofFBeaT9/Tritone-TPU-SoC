# Balanced Ternary Instruction Set Architecture (BTISA) v0.2

## Overview
- **Word size**: 27 trits (equivalent to ~42.8 bits of information)
- **Register count**: 9 general-purpose (R0-R8)
- **Memory**: Word-addressed, 729 data words (3^6) + 243 instruction words (3^5)
- **Encoding**: All instructions are 9 trits (fixed-width)

## Balanced Ternary Notation
In this ISA, we use the following notation:
- `-` represents -1 (T_NEG_ONE)
- `0` represents 0 (T_ZERO)
- `+` represents +1 (T_POS_ONE)

---

## Register Set

| Register | Alias | Description |
|----------|-------|-------------|
| R0 | zero | Always zero (hardwired) |
| R1 | t1 | General purpose |
| R2 | t2 | General purpose |
| R3 | t3 | General purpose |
| R4 | t4 | General purpose |
| R5 | t5 | General purpose |
| R6 | t6 | General purpose |
| R7 | t7 | General purpose |
| R8 | ra | Return address |

### Register Encoding (2 trits)
| Register | Encoding | Decimal Value |
|----------|----------|---------------|
| R0 | 00 | 0 |
| R1 | 0+ | 1 |
| R2 | 0- | -1 (maps to reg 2) |
| R3 | +0 | 3 |
| R4 | ++ | 4 |
| R5 | +- | 2 (maps to reg 5) |
| R6 | -0 | -3 (maps to reg 6) |
| R7 | -+ | -2 (maps to reg 7) |
| R8 | -- | -4 (maps to reg 8) |

---

## Instruction Encoding

### Base Format (9 trits)
```
[8:6] Opcode  (3 trits = 27 unique opcodes)
[5:4] Rd      (2 trits = 9 registers)
[3:2] Rs1     (2 trits = 9 registers)
[1:0] Rs2/Imm (2 trits = register OR immediate)
```

### Instruction Formats

#### R-Type (Register-Register): ADD, SUB, MUL, MIN, MAX, XOR, NEG, SHL, SHR, INV, PTI, NTI
```
| [8:6]  | [5:4] | [3:2] | [1:0] |
|--------|-------|-------|-------|
| opcode |  rd   |  rs1  |  rs2  |
```
**Operation:** `rd = rs1 OP rs2` (or `rd = OP(rs1)` for unary)

#### I-Type (Immediate): ADDI, LD, LDT
```
| [8:6]  | [5:4] | [3:2] | [1:0] |
|--------|-------|-------|-------|
| opcode |  rd   |  rs1  | imm2  |
```
**Operation:** `rd = rs1 OP sign_ext(imm2)`

#### S-Type (Store): ST, STT
```
| [8:6]  | [5:4] | [3:2] | [1:0] |
|--------|-------|-------|-------|
| opcode |  rs2  | base  | off2  |
```
**Operation:** `Mem[base + sign_ext(off2)] = rs2`
**Note:** The rd field is repurposed to hold the source register (data to store).

#### B-Type (Branch): BEQ, BNE, BLT
```
| [8:6]  | [5:4] | [3:2] | [1:0] |
|--------|-------|-------|-------|
| opcode |  rs2  |  rs1  | off2  |
```
**Operation:** `if (rs1 CMP rs2) then PC += sign_ext(off2)`
**Note:** The rd field is repurposed as the second comparison register.

#### U-Type (Upper): LUI
```
| [8:6]  | [5:4] | [3:2] | [1:0]   |
|--------|-------|-------|---------|
| opcode |  rd   |  rs1  | (unused)|
```
**Operation:** `rd[26:18] = rs1[8:0], rd[17:0] = 0`

#### J-Type (Jump): JAL, JALR, JR
```
| [8:6]  | [5:4] | [3:2] | [1:0] |
|--------|-------|-------|-------|
| opcode |  rd   |  rs1  | off2  |
```
**Operations:**
- JAL:  `rd = PC + 1; PC = rs1 + sign_ext(off2)`
- JALR: `rd = PC + 1; PC = rs1` (off2 ignored)
- JR:   `PC = rs1` (rd and off2 ignored)

---

## Immediate Value Encoding

### 2-Trit Signed Immediate Range
The 2-trit immediate field encodes values in balanced ternary:

| Encoding | Balanced Value | Decimal |
|----------|----------------|---------|
| -- | -1×3 + -1×1 | -4 |
| -0 | -1×3 + 0×1 | -3 |
| -+ | -1×3 + +1×1 | -2 |
| 0- | 0×3 + -1×1 | -1 |
| 00 | 0×3 + 0×1 | 0 |
| 0+ | 0×3 + +1×1 | +1 |
| +- | +1×3 + -1×1 | +2 |
| +0 | +1×3 + 0×1 | +3 |
| ++ | +1×3 + +1×1 | +4 |

**Valid immediate range: [-4, +4]**

### Sign Extension
Immediates are sign-extended from 2 trits to 27 trits by replicating the MSB (trit [1]):
```
sign_ext(imm2) = {25 copies of imm2[1], imm2[1], imm2[0]}
```

---

## Pseudo-Instructions

For programmer convenience, the assembler supports these pseudo-instructions:

| Pseudo | Expansion | Description |
|--------|-----------|-------------|
| LDI Rd, imm | ADDI Rd, R0, imm | Load immediate (must be in [-4,+4]) |
| SUBI Rd, Rs, imm | ADDI Rd, Rs, -imm | Subtract immediate |
| MV Rd, Rs | ADD Rd, Rs, R0 | Move register to register |
| NOP | ADD R0, R0, R0 | No operation (canonical) |
| RET | JR R8 | Return from subroutine |

**Loading large constants:** Use LD from data memory, or LUI+ADDI sequence.

---

## Instruction Set

### Arithmetic Operations

| Opcode | Mnemonic | Format | Operation | Description |
|--------|----------|--------|-----------|-------------|
| 000 | ADD | R | Rd = Rs1 + Rs2 | Ternary addition |
| 00+ | SUB | R | Rd = Rs1 - Rs2 | Ternary subtraction |
| 00- | NEG | R | Rd = -Rs1 | Negate (flip all trits) |
| 0+0 | MUL | R | Rd = Rs1 × Rs2 | Ternary multiplication |
| 0++ | SHL | R | Rd = Rs1 << 1 | Shift left (multiply by 3) |
| 0+- | SHR | R | Rd = Rs1 >> 1 | Shift right (divide by 3) |
| 0-0 | ADDI | I | Rd = Rs1 + sign_ext(imm2) | Add immediate |

### Logic Operations

| Opcode | Mnemonic | Format | Operation | Description |
|--------|----------|--------|-----------|-------------|
| +00 | MIN | R | Rd = MIN(Rs1, Rs2) | Tritwise minimum (AND) |
| +0+ | MAX | R | Rd = MAX(Rs1, Rs2) | Tritwise maximum (OR) |
| +0- | XOR | R | Rd = Rs1 XOR Rs2 | Tritwise mod-3 addition |
| ++0 | INV | R | Rd = INV(Rs1) | Standard ternary invert |
| +++ | PTI | R | Rd = PTI(Rs1) | Positive threshold invert |
| ++- | NTI | R | Rd = NTI(Rs1) | Negative threshold invert |

### Memory Operations

| Opcode | Mnemonic | Format | Operation | Description |
|--------|----------|--------|-----------|-------------|
| -00 | LD | I | Rd = Mem[Rs1 + sign_ext(imm2)] | Load 27-trit word |
| -0+ | ST | S | Mem[base + sign_ext(off2)] = rs2 | Store 27-trit word |
| -0- | LDT | I | Rd = Mem[Rs1 + sign_ext(imm2)] | Load word (trit access) |
| -+0 | STT | S | Mem[base + sign_ext(off2)][0] = rs2[0] | Store single trit |
| -++ | LUI | U | Rd[26:18] = Rs1[8:0], Rd[17:0] = 0 | Load upper from register |

### Control Flow

| Opcode | Mnemonic | Format | Operation | Description |
|--------|----------|--------|-----------|-------------|
| -+- | BEQ | B | if Rs1 = Rs2: PC += sign_ext(off2) | Branch if equal |
| 0-+ | BNE | B | if Rs1 != Rs2: PC += sign_ext(off2) | Branch if not equal |
| 0-- | BLT | B | if Rs1 < Rs2: PC += sign_ext(off2) | Branch if less than |
| +-0 | JAL | J | Rd = PC+1; PC = Rs1 + sign_ext(off2) | Jump and link |
| +-+ | JALR | J | Rd = PC+1; PC = Rs1 | Jump and link register |
| +-- | JR | J | PC = Rs1 | Jump register |

### System Operations

| Opcode | Mnemonic | Format | Operation | Description |
|--------|----------|--------|-----------|-------------|
| --0 | NOP | - | (no operation) | No operation |
| --+ | HALT | - | halt execution | Halt CPU |
| --- | ECALL | - | environment call | System call |

---

## Ternary Logic Operation Semantics

### INV (Standard Ternary Inverter)
Per-trit inversion through zero:

| Input | Output |
|-------|--------|
| +1 | -1 |
| 0 | 0 |
| -1 | +1 |

**Semantics:** `INV(A) = -A` (symmetric negation)

### PTI (Positive Threshold Inverter)
Outputs HIGH (+1) unless input is HIGH:

| Input | Output |
|-------|--------|
| +1 | -1 |
| 0 | +1 |
| -1 | +1 |

**Semantics:** `PTI(A) = +1 if A < +1, else -1`

### NTI (Negative Threshold Inverter)
Outputs HIGH (+1) only when input is LOW (-1):

| Input | Output |
|-------|--------|
| +1 | -1 |
| 0 | -1 |
| -1 | +1 |

**Semantics:** `NTI(A) = +1 if A = -1, else -1`

### MIN (Tritwise Minimum / Ternary AND)
Returns the smaller trit value (applied tritwise):

| A | B | MIN(A,B) |
|---|---|----------|
| +1 | +1 | +1 |
| +1 | 0 | 0 |
| +1 | -1 | -1 |
| 0 | +1 | 0 |
| 0 | 0 | 0 |
| 0 | -1 | -1 |
| -1 | +1 | -1 |
| -1 | 0 | -1 |
| -1 | -1 | -1 |

**Ordering:** -1 < 0 < +1

### MAX (Tritwise Maximum / Ternary OR)
Returns the larger trit value (applied tritwise):

| A | B | MAX(A,B) |
|---|---|----------|
| +1 | +1 | +1 |
| +1 | 0 | +1 |
| +1 | -1 | +1 |
| 0 | +1 | +1 |
| 0 | 0 | 0 |
| 0 | -1 | 0 |
| -1 | +1 | +1 |
| -1 | 0 | 0 |
| -1 | -1 | -1 |

### XOR (Tritwise Mod-3 Addition)
Adds trits modulo 3, remapped to balanced ternary:

| A | B | XOR(A,B) |
|---|---|----------|
| +1 | +1 | -1 |
| +1 | 0 | +1 |
| +1 | -1 | 0 |
| 0 | +1 | +1 |
| 0 | 0 | 0 |
| 0 | -1 | -1 |
| -1 | +1 | 0 |
| -1 | 0 | -1 |
| -1 | -1 | +1 |

**Formula:** `XOR(A,B) = (A + B) mod 3`, remapped to {-1, 0, +1}

---

## Arithmetic Operation Semantics

### SHL (Shift Left by 1 Trit)
- **Operation:** `Rd = Rs1 << 1`
- Shifts all trits one position toward MSB
- Inserts T_ZERO at LSB (position 0)
- MSB (position 26) is discarded
- **Mathematically:** `Rd = Rs1 × 3`

### SHR (Shift Right by 1 Trit)
- **Operation:** `Rd = Rs1 >> 1`
- **Type:** Logical shift (NOT arithmetic)
- Shifts all trits one position toward LSB
- Inserts T_ZERO at MSB (position 26)
- LSB (position 0) is discarded
- **Mathematically:** `Rd = floor(Rs1 / 3)`
- **Rounding:** Truncation toward zero

### MUL (Ternary Multiplication)
- **Operation:** `Rd = Rs1 × Rs2`
- **Result:** Lower 27 trits of the product (truncated)
- **Overflow:** High trits are discarded; no overflow flag
- **Algorithm:** Shift-and-add with balanced ternary multipliers
  ```
  accumulator = 0
  for each trit b[i] in Rs2:
    if b[i] = +1: accumulator += Rs1 << i
    if b[i] = -1: accumulator -= Rs1 << i
    if b[i] = 0:  no change
  Rd = accumulator[26:0]  // truncate to 27 trits
  ```

### BLT (Branch if Less Than)
- **Comparison:** Computes `diff = Rs1 - Rs2`
- **Branch condition:** Takes branch if `diff < 0`
- **Implementation:** Checks if MSB trit of diff equals -1
- **Ordering:** Full 27-trit signed balanced ternary comparison
  - Values with MSB = -1 are negative
  - Values with MSB = 0 or +1 are non-negative

---

## Memory Architecture

### Address Spaces
| Region | Address Range | Size | Word Size |
|--------|---------------|------|-----------|
| IMEM | 0 - 242 | 243 words | 9 trits (instruction) |
| DMEM | 0 - 728 | 729 words | 27 trits (data) |

### Addressing Model
- **Word-addressed** (NOT trit-addressed)
- PC counts instruction words (each 9 trits)
- Data memory addresses point to 27-trit words
- Address calculations use balanced ternary arithmetic

### Program Counter Behavior
- `PC + 1` = next sequential instruction
- Branch offset is in instruction words
- Dual-issue mode: `PC += 2` when both slots execute

### LDT/STT Semantics
These instructions provide trit-level access within words:

**LDT Rd, Rs1, imm2:**
```
addr = Rs1 + sign_ext(imm2)   // Word address
Rd = Mem[addr]                // Load full 27-trit word
// Software selects desired trit from Rd
```

**STT Rs2, Rs1, imm2:**
```
addr = Rs1 + sign_ext(imm2)   // Word address
Mem[addr][0] = Rs2[0]         // Store LSB trit only
// Other trits of Mem[addr] unchanged
```

**Note:** Current implementation loads/stores full words; trit selection is handled by software masking.

---

## Status Flags

| Flag | Condition | Description |
|------|-----------|-------------|
| Z (Zero) | All result trits = 0 | Set when result is exactly zero |
| N (Negative) | Result MSB = -1 | Set when result is negative |
| C (Carry) | Carry-out from MSB | Overflow/underflow indicator |

### Carry in Balanced Ternary
- Carry occurs when trit sum exceeds +1 or falls below -1
- Carry values: {-1, 0, +1}
- Propagates through BTFA (Balanced Ternary Full Adder)
- Sum: `S = (A + B + Cin) mod 3`
- Carry: `Cout = floor((A + B + Cin) / 3)`

---

## ALU Operation Codes

Internal 3-bit binary encoding for ALU operations:

| ALU Op | Binary | Operation |
|--------|--------|-----------|
| ADD | 000 | Addition |
| SUB | 001 | Subtraction |
| NEG | 010 | Negation |
| MIN | 011 | Tritwise minimum |
| MAX | 100 | Tritwise maximum |
| SHL | 101 | Shift left |
| SHR | 110 | Shift right |
| MUL | 111 | Multiplication |

---

## Opcode Encoding Summary

All 27 opcodes are unique (no collisions):

| Opcode | Mnemonic | Category |
|--------|----------|----------|
| 000 | ADD | Arithmetic |
| 00+ | SUB | Arithmetic |
| 00- | NEG | Arithmetic |
| 0+0 | MUL | Arithmetic |
| 0++ | SHL | Arithmetic |
| 0+- | SHR | Arithmetic |
| 0-0 | ADDI | Arithmetic |
| 0-+ | BNE | Control |
| 0-- | BLT | Control |
| +00 | MIN | Logic |
| +0+ | MAX | Logic |
| +0- | XOR | Logic |
| ++0 | INV | Logic |
| +++ | PTI | Logic |
| ++- | NTI | Logic |
| +-0 | JAL | Control |
| +-+ | JALR | Control |
| +-- | JR | Control |
| -00 | LD | Memory |
| -0+ | ST | Memory |
| -0- | LDT | Memory |
| -+0 | STT | Memory |
| -++ | LUI | Memory |
| -+- | BEQ | Control |
| --0 | NOP | System |
| --+ | HALT | System |
| --- | ECALL | System |

---

## Pipeline Architecture

The BTISA CPU uses a 4-stage dual-issue pipeline:

1. **IF** - Instruction Fetch (fetches 2 instructions)
2. **ID** - Instruction Decode / Register Read
3. **EX** - Execute / Memory Address Calculation
4. **WB** - Write Back

### Hazard Handling
- Data forwarding from EX to ID stage
- Pipeline stalls for load-use hazards
- Branch prediction with BTB

---

## Example Programs

### Example 1: Compute Fibonacci(5)
```asm
# R1 = n, R2 = fib(n-1), R3 = fib(n-2), R4 = result

    ADDI R1, R0, 4    # n = 4 (max immediate)
    ADDI R1, R1, 1    # n = 5 (need two instructions)
    ADDI R2, R0, 1    # fib(1) = 1
    ADD  R3, R0, R0   # fib(0) = 0

loop:
    BEQ  R1, R0, done # if n == 0, exit
    ADD  R4, R2, R3   # result = fib(n-1) + fib(n-2)
    ADD  R3, R2, R0   # fib(n-2) = fib(n-1)
    ADD  R2, R4, R0   # fib(n-1) = result
    ADDI R1, R1, -1   # n = n - 1
    BNE  R1, R0, loop # continue loop

done:
    HALT
```

### Example 2: Memory Copy (3 words)
```asm
# Copy 3 words from address in R1 to address in R2
# R3 = counter, R4 = temp

    ADDI R3, R0, 3    # counter = 3

copy_loop:
    BEQ  R3, R0, done # if counter == 0, done
    LD   R4, R1, 0    # load from source
    ST   R4, R2, 0    # store to destination
    ADDI R1, R1, 1    # source++
    ADDI R2, R2, 1    # dest++
    ADDI R3, R3, -1   # counter--
    BNE  R3, R0, copy_loop

done:
    HALT
```

---

## Design Notes

1. **R0 is hardwired to zero:** Writes to R0 are ignored; reads always return 0.

2. **Balanced ternary is symmetric:** Negation is trivial (flip all trits); no two's complement needed.

3. **2-trit immediates are limited:** Values outside [-4, +4] require memory loads or LUI+ADDI.

4. **LUI is register-based:** Due to the 2-trit immediate limitation, LUI copies bits from a source register rather than using an immediate.

5. **SHR is logical, not arithmetic:** Always inserts zero at MSB; for signed division, check sign and adjust.

6. **MUL truncates to 27 trits:** No high-word result; for wide multiplication, implement in software.

---

## Changelog

### v0.2 (2025-12-28)
- **BEQ opcode moved:** Changed from `0-0` to `-+-` to resolve collision with ADDI
- **ADDI now exclusive:** Opcode `0-0` is now exclusively ADDI
- **MUL implemented:** Ternary multiplication fully implemented
- **LUI redesigned:** Changed from immediate-based to register-based semantics
  - Old: `Rd = Imm << 18`
  - New: `Rd[26:18] = Rs1[8:0], Rd[17:0] = 0`
- **ALU op 111:** Changed from CMP to MUL
- **Documentation:** Added instruction formats, truth tables, and semantics
- **Memory model:** Clarified as word-addressed (not trit-addressed)
- **Examples fixed:** All immediates now within valid range [-4, +4]

### v0.1 (2025-12-01)
- Initial specification

---

**Version:** 0.2
**Date:** 2025-12-28
**Status:** Complete specification with formal semantics
