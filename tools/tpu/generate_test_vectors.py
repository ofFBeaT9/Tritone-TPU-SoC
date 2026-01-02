#!/usr/bin/env python3
"""
RTL Test Vector Generator for Tritone TPU
==========================================
Generates test vectors for SystemVerilog testbenches, using the Python
golden model as reference.

Output Formats:
- Memory initialization files (.mem) for $readmemh
- SystemVerilog test stimulus files
- Expected output files for automatic checking

Author: Tritone Project
License: MIT
"""

import numpy as np
import os
from pathlib import Path
from typing import List, Tuple, Dict, Any
from dataclasses import dataclass
from ternary_matmul import ternary_mac, ternary_matmul, TernaryMatMulConfig


@dataclass
class TestCase:
    """Single test case for RTL verification."""
    name: str
    activations: np.ndarray
    weights: np.ndarray
    expected_output: np.ndarray
    stats: Dict[str, Any]


def int_to_balanced_ternary(val: int, num_trits: int = 27) -> List[int]:
    """
    Convert integer to balanced ternary representation.

    Returns list of trits [trit_0, trit_1, ...] where trit_0 is LST.
    Each trit is in {-1, 0, +1}.
    """
    trits = []
    temp = val

    for _ in range(num_trits):
        rem = temp % 3
        if rem == 0:
            trits.append(0)
        elif rem == 1:
            trits.append(1)
        else:  # rem == 2
            trits.append(-1)
            temp += 1  # Adjust for balanced representation
        temp //= 3

    return trits


def balanced_ternary_to_int(trits: List[int]) -> int:
    """Convert balanced ternary to integer."""
    result = 0
    power = 1
    for trit in trits:
        result += trit * power
        power *= 3
    return result


def trit_to_2bit_encoding(trit: int) -> str:
    """
    Convert trit to 2-bit encoding string.

    Encoding:
        0  -> 00
        +1 -> 01
        -1 -> 10
        invalid -> 11
    """
    if trit == 0:
        return "00"
    elif trit == 1:
        return "01"
    elif trit == -1:
        return "10"
    else:
        return "11"


def weight_to_2bit_encoding(weight: int) -> str:
    """
    Convert ternary weight to 2-bit encoding for RTL.

    Encoding:
        -1 -> 00
         0 -> 01
        +1 -> 10
    """
    if weight == -1:
        return "00"
    elif weight == 0:
        return "01"
    elif weight == 1:
        return "10"
    else:
        return "11"  # Invalid


def encode_trit_vector_hex(val: int, num_trits: int) -> str:
    """
    Encode integer as hex string of 2-bit encoded trits.

    Returns hex string for $readmemh.
    """
    trits = int_to_balanced_ternary(val, num_trits)

    # Build binary string (MST first for hex conversion)
    binary = ""
    for trit in reversed(trits):
        binary += trit_to_2bit_encoding(trit)

    # Pad to multiple of 4 bits
    while len(binary) % 4 != 0:
        binary = "00" + binary

    # Convert to hex
    hex_str = hex(int(binary, 2))[2:].upper()

    # Pad hex to expected length
    expected_hex_len = (num_trits * 2 + 3) // 4
    hex_str = hex_str.zfill(expected_hex_len)

    return hex_str


def generate_mac_test_vectors(output_dir: Path) -> List[TestCase]:
    """
    Generate test vectors for single MAC unit.

    Tests all combinations of:
    - Weight values: {-1, 0, +1}
    - Various activation values
    - Various accumulator values
    """
    test_cases = []

    # Test all weight values with representative activations
    activations_test = [0, 1, -1, 127, -128, 42, -42, 100, -100]
    accumulators_test = [0, 1000, -1000, 5000000, -5000000]
    weights_test = [-1, 0, 1]

    vectors = []

    for act in activations_test:
        for acc in accumulators_test:
            for wgt in weights_test:
                new_acc, zero_skip = ternary_mac(act, wgt, acc)
                vectors.append({
                    'activation': act,
                    'weight': wgt,
                    'acc_in': acc,
                    'acc_out': new_acc,
                    'zero_skip': zero_skip
                })

    # Write to file
    mac_vectors_file = output_dir / "mac_test_vectors.txt"
    with open(mac_vectors_file, 'w') as f:
        f.write("// MAC Unit Test Vectors\n")
        f.write("// Format: activation weight acc_in | acc_out zero_skip\n")
        f.write("// Activation: 8-trit signed, Weight: 2-bit, Acc: 27-trit signed\n")
        f.write(f"// Total vectors: {len(vectors)}\n")
        f.write("//\n")

        for v in vectors:
            act_hex = encode_trit_vector_hex(v['activation'], 8)
            acc_in_hex = encode_trit_vector_hex(v['acc_in'], 27)
            acc_out_hex = encode_trit_vector_hex(v['acc_out'], 27)
            wgt_enc = weight_to_2bit_encoding(v['weight'])

            f.write(f"{act_hex} {wgt_enc} {acc_in_hex} {acc_out_hex} {1 if v['zero_skip'] else 0}\n")

    print(f"Generated {len(vectors)} MAC test vectors -> {mac_vectors_file}")

    return vectors


def generate_pe_test_vectors(output_dir: Path) -> List[Dict]:
    """
    Generate test vectors for Processing Element.

    Tests:
    - Weight loading
    - Activation flow (west to east)
    - Partial sum flow (north to south)
    """
    vectors = []

    # Sequence of operations
    # 1. Load weight
    # 2. Stream activations and psums

    test_weights = [-1, 0, 1]
    test_activations = [10, 20, -15, 0, 50]

    for wgt in test_weights:
        psum = 0
        for i, act in enumerate(test_activations):
            new_psum, _ = ternary_mac(act, wgt, psum)
            vectors.append({
                'weight': wgt,
                'weight_load': 1 if i == 0 else 0,
                'act_in': act,
                'psum_in': psum,
                'act_out': act,  # Passes through
                'psum_out': new_psum
            })
            psum = new_psum

    # Write to file
    pe_vectors_file = output_dir / "pe_test_vectors.txt"
    with open(pe_vectors_file, 'w') as f:
        f.write("// PE Test Vectors\n")
        f.write("// Format: weight weight_load act_in psum_in | act_out psum_out\n")
        f.write(f"// Total vectors: {len(vectors)}\n")
        f.write("//\n")

        for v in vectors:
            f.write(f"{weight_to_2bit_encoding(v['weight'])} ")
            f.write(f"{v['weight_load']} ")
            f.write(f"{encode_trit_vector_hex(v['act_in'], 8)} ")
            f.write(f"{encode_trit_vector_hex(v['psum_in'], 27)} ")
            f.write(f"{encode_trit_vector_hex(v['act_out'], 8)} ")
            f.write(f"{encode_trit_vector_hex(v['psum_out'], 27)}\n")

    print(f"Generated {len(vectors)} PE test vectors -> {pe_vectors_file}")

    return vectors


def generate_matmul_test_vectors(output_dir: Path, sizes: List[Tuple[int, int, int]] = None) -> List[TestCase]:
    """
    Generate test vectors for matrix multiply operations.

    Args:
        output_dir: Output directory for test files
        sizes: List of (M, K, N) tuples for test matrices
    """
    if sizes is None:
        sizes = [
            (2, 2, 2),    # Minimal 2x2
            (4, 4, 4),    # Small
            (8, 8, 8),    # Systolic array size
            (4, 8, 4),    # Rectangular
            (8, 16, 8),   # Larger K
        ]

    test_cases = []
    np.random.seed(42)

    for m, k, n in sizes:
        # Random activations in 8-trit range (roughly -3280 to +3280)
        activations = np.random.randint(-1000, 1001, size=(m, k))

        # Random ternary weights
        weights = np.random.choice([-1, 0, 1], size=(n, k))

        # Compute expected output
        output, stats = ternary_matmul(activations, weights)

        test_name = f"matmul_{m}x{k}x{n}"

        test_cases.append(TestCase(
            name=test_name,
            activations=activations,
            weights=weights,
            expected_output=output,
            stats=stats
        ))

        # Write test files
        _write_matmul_test_files(output_dir, test_name, activations, weights, output)

    print(f"Generated {len(test_cases)} matmul test cases")

    return test_cases


def _write_matmul_test_files(output_dir: Path, name: str,
                              activations: np.ndarray, weights: np.ndarray,
                              expected: np.ndarray):
    """Write memory files for a matrix multiply test."""
    m, k = activations.shape
    n, _ = weights.shape

    # Create subdirectory
    test_dir = output_dir / name
    test_dir.mkdir(exist_ok=True)

    # Write activations (row-major)
    act_file = test_dir / "activations.mem"
    with open(act_file, 'w') as f:
        f.write(f"// Activations: {m}x{k} matrix\n")
        for i in range(m):
            for j in range(k):
                f.write(f"{encode_trit_vector_hex(int(activations[i, j]), 8)}\n")

    # Write weights (row-major)
    wgt_file = test_dir / "weights.mem"
    with open(wgt_file, 'w') as f:
        f.write(f"// Weights: {n}x{k} matrix (ternary)\n")
        for i in range(n):
            for j in range(k):
                f.write(f"{weight_to_2bit_encoding(int(weights[i, j]))}\n")

    # Write expected output
    exp_file = test_dir / "expected.mem"
    with open(exp_file, 'w') as f:
        f.write(f"// Expected output: {m}x{n} matrix\n")
        for i in range(m):
            for j in range(n):
                f.write(f"{encode_trit_vector_hex(int(expected[i, j]), 27)}\n")

    # Write config file
    cfg_file = test_dir / "config.txt"
    with open(cfg_file, 'w') as f:
        f.write(f"M={m}\n")
        f.write(f"K={k}\n")
        f.write(f"N={n}\n")

    print(f"  -> {test_dir}")


def generate_systolic_test_vectors(output_dir: Path, array_size: int = 8):
    """
    Generate test vectors specifically for systolic array verification.

    Includes timing information for cycle-accurate simulation.
    """
    np.random.seed(123)

    # Simple case: identity-like weight matrix
    weights = np.eye(array_size, dtype=np.int8)
    activations = np.arange(1, array_size * array_size + 1).reshape(array_size, array_size)

    output, _ = ternary_matmul(activations, weights)

    systolic_dir = output_dir / f"systolic_{array_size}x{array_size}"
    systolic_dir.mkdir(exist_ok=True)

    # Write weight loading sequence
    wgt_file = systolic_dir / "weight_load.mem"
    with open(wgt_file, 'w') as f:
        f.write(f"// Weight loading sequence for {array_size}x{array_size} array\n")
        f.write("// One row per cycle, weights stationary after load\n")
        for i in range(array_size):
            row_str = ""
            for j in range(array_size):
                row_str += weight_to_2bit_encoding(int(weights[i, j]))
            f.write(f"{hex(int(row_str, 2))[2:].zfill((array_size * 2 + 3) // 4)}\n")

    # Write activation stream (staggered for systolic)
    act_file = systolic_dir / "activation_stream.mem"
    with open(act_file, 'w') as f:
        f.write(f"// Activation stream for systolic array\n")
        f.write("// Staggered input: row i delayed by i cycles\n")
        num_cycles = 2 * array_size - 1

        for cycle in range(num_cycles + array_size):
            f.write(f"// Cycle {cycle}\n")
            for row in range(array_size):
                col = cycle - row
                if 0 <= col < array_size:
                    val = activations[row, col]
                else:
                    val = 0
                f.write(f"{encode_trit_vector_hex(int(val), 8)} ")
            f.write("\n")

    # Write expected output
    exp_file = systolic_dir / "expected.mem"
    with open(exp_file, 'w') as f:
        f.write(f"// Expected output: {array_size}x{array_size} matrix\n")
        for i in range(array_size):
            for j in range(array_size):
                f.write(f"{encode_trit_vector_hex(int(output[i, j]), 27)}\n")

    print(f"Generated systolic test vectors -> {systolic_dir}")


def generate_all_test_vectors(output_base: str = None):
    """Generate all test vectors for RTL verification."""
    if output_base is None:
        # Default to hdl/tb/tpu/vectors
        script_dir = Path(__file__).parent
        output_base = script_dir.parent.parent / "hdl" / "tb" / "tpu" / "vectors"

    output_dir = Path(output_base)
    output_dir.mkdir(parents=True, exist_ok=True)

    print("=" * 60)
    print("Generating RTL Test Vectors for Tritone TPU")
    print("=" * 60)
    print(f"Output directory: {output_dir}")
    print()

    # MAC unit vectors
    print("[1/4] MAC unit test vectors...")
    generate_mac_test_vectors(output_dir)

    # PE vectors
    print("\n[2/4] Processing Element test vectors...")
    generate_pe_test_vectors(output_dir)

    # Matrix multiply vectors
    print("\n[3/4] Matrix multiply test vectors...")
    generate_matmul_test_vectors(output_dir)

    # Systolic array vectors
    print("\n[4/4] Systolic array test vectors...")
    generate_systolic_test_vectors(output_dir, array_size=8)

    print("\n" + "=" * 60)
    print("Test vector generation complete!")
    print("=" * 60)


if __name__ == "__main__":
    generate_all_test_vectors()
