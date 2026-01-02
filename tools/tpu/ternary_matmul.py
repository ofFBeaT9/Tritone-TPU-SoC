#!/usr/bin/env python3
"""
Ternary Matrix Multiply - Golden Reference Model
=================================================
Reference implementation for balanced ternary neural network inference.
Ternary weights {-1, 0, +1} eliminate multiplication (replaced with sign/zero selection).

This serves as the golden model for RTL verification of the Tritone TPU.

Key Insight:
    Standard MAC:  output = input * weight + accumulator  (needs multiplier)
    Ternary MAC:   output = mux(weight, {-input, 0, +input}) + accumulator

Author: Tritone Project
License: MIT
"""

import numpy as np
from typing import Tuple, List, Optional
from dataclasses import dataclass
from enum import IntEnum


class TritWeight(IntEnum):
    """Ternary weight values for TNN inference."""
    NEG_ONE = -1
    ZERO = 0
    POS_ONE = 1


@dataclass
class TernaryMatMulConfig:
    """Configuration for ternary matrix multiply operation."""
    m: int  # Output rows (batch size)
    k: int  # Inner dimension (input features)
    n: int  # Output columns (output features)
    activation_bits: int = 8  # Activation precision in trits
    accumulator_bits: int = 27  # Accumulator precision in trits


def ternary_mac(activation: int, weight: int, accumulator: int) -> Tuple[int, bool]:
    """
    Single ternary MAC operation.

    Args:
        activation: Input activation value (8-trit signed integer)
        weight: Ternary weight {-1, 0, +1}
        accumulator: Current accumulator value (27-trit signed integer)

    Returns:
        Tuple of (new_accumulator, zero_skip) where zero_skip indicates
        the operation was skipped due to zero weight.
    """
    if weight == 0:
        return accumulator, True  # Zero-skip optimization
    elif weight == -1:
        return accumulator - activation, False
    elif weight == 1:
        return accumulator + activation, False
    else:
        raise ValueError(f"Invalid ternary weight: {weight}")


def ternary_matmul(
    activations: np.ndarray,
    weights: np.ndarray,
    config: Optional[TernaryMatMulConfig] = None
) -> Tuple[np.ndarray, dict]:
    """
    Perform ternary matrix multiplication.

    Computes: output = activations @ weights^T
    Where weights are constrained to {-1, 0, +1}

    Args:
        activations: Input matrix of shape (M, K) with integer values
        weights: Weight matrix of shape (N, K) with values in {-1, 0, +1}
        config: Optional configuration (auto-detected if None)

    Returns:
        Tuple of (output_matrix, statistics_dict)
    """
    # Validate inputs
    if weights.min() < -1 or weights.max() > 1:
        raise ValueError("Weights must be in {-1, 0, +1}")

    m, k = activations.shape
    n, k2 = weights.shape

    if k != k2:
        raise ValueError(f"Dimension mismatch: activations have {k} features, weights have {k2}")

    if config is None:
        config = TernaryMatMulConfig(m=m, k=k, n=n)

    # Output matrix
    output = np.zeros((m, n), dtype=np.int64)

    # Statistics tracking
    total_macs = 0
    zero_skipped = 0

    # Perform ternary matrix multiply
    for i in range(m):
        for j in range(n):
            acc = 0
            for kk in range(k):
                act = int(activations[i, kk])
                wgt = int(weights[j, kk])
                acc, skipped = ternary_mac(act, wgt, acc)
                total_macs += 1
                if skipped:
                    zero_skipped += 1
            output[i, j] = acc

    stats = {
        'total_macs': total_macs,
        'zero_skipped': zero_skipped,
        'zero_skip_ratio': zero_skipped / total_macs if total_macs > 0 else 0,
        'effective_ops': total_macs - zero_skipped
    }

    return output, stats


def ternary_matmul_systolic(
    activations: np.ndarray,
    weights: np.ndarray,
    array_size: int = 8
) -> Tuple[np.ndarray, List[np.ndarray]]:
    """
    Simulate weight-stationary systolic array execution.

    This models the dataflow of the Tritone TPU systolic array:
    - Weights are loaded once (stationary)
    - Activations flow horizontally (west to east)
    - Partial sums flow vertically (north to south)

    Args:
        activations: Input matrix of shape (M, K)
        weights: Weight matrix of shape (N, K) in {-1, 0, +1}
        array_size: Systolic array dimension (NxN)

    Returns:
        Tuple of (output_matrix, list_of_partial_sum_snapshots)
    """
    m, k = activations.shape
    n, _ = weights.shape

    # Tile the computation to fit array_size
    output = np.zeros((m, n), dtype=np.int64)
    snapshots = []

    # Process tiles
    for tile_m in range(0, m, array_size):
        for tile_n in range(0, n, array_size):
            tile_m_end = min(tile_m + array_size, m)
            tile_n_end = min(tile_n + array_size, n)

            # Create PE array state
            pe_weights = np.zeros((array_size, array_size), dtype=np.int8)
            pe_psums = np.zeros((array_size, array_size), dtype=np.int64)

            # Load weights (stationary)
            for i in range(tile_n_end - tile_n):
                for j in range(min(array_size, k)):
                    pe_weights[i, j] = weights[tile_n + i, j] if j < k else 0

            # Process K dimension in chunks
            for tile_k in range(0, k, array_size):
                tile_k_end = min(tile_k + array_size, k)

                # Simulate systolic execution
                # Each cycle: activations shift right, psums shift down
                num_cycles = array_size + array_size - 1  # Diagonal wavefront

                act_buffer = np.zeros((array_size, array_size + num_cycles), dtype=np.int64)

                # Stagger activation input (diagonal wavefront)
                for i in range(tile_m_end - tile_m):
                    for j in range(tile_k_end - tile_k):
                        act_buffer[i, j + i] = activations[tile_m + i, tile_k + j]

                # Process cycles
                for cycle in range(num_cycles + array_size):
                    snapshot = pe_psums.copy()

                    # Update each PE
                    for row in range(array_size):
                        for col in range(array_size):
                            if cycle >= col and cycle - col < act_buffer.shape[1]:
                                act_val = act_buffer[row, cycle - col] if row < array_size else 0
                                wgt_val = pe_weights[col, min(cycle - col, array_size - 1)] if col < array_size else 0

                                # MAC operation
                                if wgt_val == 1:
                                    pe_psums[row, col] += act_val
                                elif wgt_val == -1:
                                    pe_psums[row, col] -= act_val

                    snapshots.append(snapshot)

            # Extract results from PE array
            for i in range(tile_m_end - tile_m):
                for j in range(tile_n_end - tile_n):
                    output[tile_m + i, tile_n + j] = pe_psums[i, j]

    return output, snapshots


def validate_against_numpy(activations: np.ndarray, weights: np.ndarray) -> bool:
    """
    Validate ternary matmul against numpy reference.

    Returns True if results match.
    """
    # Our implementation
    ternary_result, _ = ternary_matmul(activations, weights)

    # NumPy reference (weights transposed for dot product)
    numpy_result = activations @ weights.T

    match = np.allclose(ternary_result, numpy_result)

    if not match:
        print("MISMATCH DETECTED!")
        print(f"Ternary result:\n{ternary_result}")
        print(f"NumPy result:\n{numpy_result}")
        print(f"Difference:\n{ternary_result - numpy_result}")

    return match


def demo():
    """Demonstrate ternary matrix multiplication."""
    print("=" * 60)
    print("Ternary Matrix Multiply - Golden Reference Model")
    print("=" * 60)

    # Create sample inputs
    np.random.seed(42)

    # Small example: 4x8 activations, 4x8 weights (4 output neurons, 8 features)
    m, k, n = 4, 8, 4

    # Random activations (8-bit range for 8-trit values)
    # 8-trit balanced ternary range: roughly -3280 to +3280
    activations = np.random.randint(-100, 101, size=(m, k))

    # Random ternary weights
    weights = np.random.choice([-1, 0, 1], size=(n, k))

    print(f"\nInput dimensions: M={m}, K={k}, N={n}")
    print(f"\nActivations ({m}x{k}):")
    print(activations)
    print(f"\nTernary Weights ({n}x{k}):")
    print(weights)

    # Compute ternary matmul
    output, stats = ternary_matmul(activations, weights)

    print(f"\nOutput ({m}x{n}):")
    print(output)

    print(f"\nStatistics:")
    print(f"  Total MACs: {stats['total_macs']}")
    print(f"  Zero-skipped: {stats['zero_skipped']}")
    print(f"  Zero-skip ratio: {stats['zero_skip_ratio']:.1%}")
    print(f"  Effective ops: {stats['effective_ops']}")

    # Validate against numpy
    print(f"\nValidation against NumPy: ", end="")
    if validate_against_numpy(activations, weights):
        print("PASSED")
    else:
        print("FAILED")

    # Demonstrate systolic simulation
    print("\n" + "=" * 60)
    print("Systolic Array Simulation (8x8 array)")
    print("=" * 60)

    systolic_output, _ = ternary_matmul_systolic(activations, weights, array_size=8)
    print(f"\nSystolic output matches: {np.allclose(output, systolic_output)}")

    return output, stats


if __name__ == "__main__":
    demo()
