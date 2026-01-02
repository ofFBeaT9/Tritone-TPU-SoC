#!/usr/bin/env python3
"""
Ternary Neural Network (TNN) Layer Model
=========================================
Reference implementation for complete TNN layer computation including:
- Ternary convolution
- Batch normalization (folded)
- Activation functions
- Pooling operations

This serves as the golden model for end-to-end TPU verification.

Author: Tritone Project
License: MIT
"""

import numpy as np
from typing import Tuple, Optional, Dict, Any, List
from dataclasses import dataclass
from enum import Enum
from ternary_matmul import ternary_matmul, TernaryMatMulConfig


class ActivationType(Enum):
    """Supported activation functions."""
    NONE = "none"
    RELU = "relu"
    SIGN = "sign"  # Ternary activation: output in {-1, 0, +1}
    HTANH = "htanh"  # Hard tanh (clipped linear)


class PoolingType(Enum):
    """Supported pooling operations."""
    NONE = "none"
    MAX = "max"
    AVG = "avg"


@dataclass
class TNNLayerConfig:
    """Configuration for a TNN layer."""
    # Input shape
    input_height: int
    input_width: int
    input_channels: int

    # Convolution parameters
    output_channels: int
    kernel_size: int = 3
    stride: int = 1
    padding: int = 1

    # Activation
    activation: ActivationType = ActivationType.RELU

    # Pooling
    pooling: PoolingType = PoolingType.NONE
    pool_size: int = 2

    # Quantization
    activation_bits: int = 8  # Trits for activations
    accumulator_bits: int = 27  # Trits for accumulator


def im2col(input_data: np.ndarray, kernel_size: int, stride: int, padding: int) -> np.ndarray:
    """
    Transform input tensor to column format for matrix multiplication.

    Args:
        input_data: Input tensor of shape (C, H, W)
        kernel_size: Convolution kernel size
        stride: Convolution stride
        padding: Zero-padding amount

    Returns:
        Column matrix of shape (K*K*C, OH*OW) where OH, OW are output dimensions
    """
    c, h, w = input_data.shape

    # Add padding
    if padding > 0:
        padded = np.pad(input_data, ((0, 0), (padding, padding), (padding, padding)), mode='constant')
    else:
        padded = input_data

    # Output dimensions
    oh = (h + 2 * padding - kernel_size) // stride + 1
    ow = (w + 2 * padding - kernel_size) // stride + 1

    # Create column matrix
    col = np.zeros((c * kernel_size * kernel_size, oh * ow), dtype=input_data.dtype)

    col_idx = 0
    for y in range(0, h + 2 * padding - kernel_size + 1, stride):
        for x in range(0, w + 2 * padding - kernel_size + 1, stride):
            patch = padded[:, y:y + kernel_size, x:x + kernel_size]
            col[:, col_idx] = patch.flatten()
            col_idx += 1

    return col


def col2im(col: np.ndarray, output_channels: int, output_height: int, output_width: int) -> np.ndarray:
    """
    Transform column format back to tensor.

    Args:
        col: Column matrix of shape (output_channels, oh*ow)
        output_channels: Number of output channels
        output_height: Output height
        output_width: Output width

    Returns:
        Output tensor of shape (C, H, W)
    """
    return col.reshape(output_channels, output_height, output_width)


def apply_activation(data: np.ndarray, activation: ActivationType, scale: float = 1.0) -> np.ndarray:
    """
    Apply activation function.

    Args:
        data: Input data
        activation: Activation function type
        scale: Scaling factor (for quantization)

    Returns:
        Activated output
    """
    if activation == ActivationType.NONE:
        return data

    elif activation == ActivationType.RELU:
        return np.maximum(data, 0)

    elif activation == ActivationType.SIGN:
        # Ternary activation: {-1, 0, +1}
        result = np.zeros_like(data)
        result[data > 0] = 1
        result[data < 0] = -1
        return result

    elif activation == ActivationType.HTANH:
        # Hard tanh: clip to [-scale, +scale]
        return np.clip(data, -scale, scale)

    else:
        raise ValueError(f"Unknown activation: {activation}")


def apply_pooling(data: np.ndarray, pooling: PoolingType, pool_size: int) -> np.ndarray:
    """
    Apply pooling operation.

    Args:
        data: Input tensor of shape (C, H, W)
        pooling: Pooling type
        pool_size: Pooling window size

    Returns:
        Pooled output tensor
    """
    if pooling == PoolingType.NONE:
        return data

    c, h, w = data.shape
    oh = h // pool_size
    ow = w // pool_size

    output = np.zeros((c, oh, ow), dtype=data.dtype)

    for ch in range(c):
        for y in range(oh):
            for x in range(ow):
                window = data[ch, y * pool_size:(y + 1) * pool_size,
                         x * pool_size:(x + 1) * pool_size]
                if pooling == PoolingType.MAX:
                    output[ch, y, x] = np.max(window)
                elif pooling == PoolingType.AVG:
                    output[ch, y, x] = np.mean(window)

    return output


class TNNLayer:
    """
    Ternary Neural Network Layer.

    Implements a complete TNN convolution layer with:
    - Ternary weights {-1, 0, +1}
    - Integer activations
    - Optional batch normalization (folded into threshold)
    - Activation function
    - Optional pooling
    """

    def __init__(self, config: TNNLayerConfig, weights: Optional[np.ndarray] = None):
        """
        Initialize TNN layer.

        Args:
            config: Layer configuration
            weights: Ternary weight tensor of shape (OC, IC, K, K)
                    If None, random ternary weights are generated
        """
        self.config = config

        # Initialize weights
        if weights is None:
            weight_shape = (
                config.output_channels,
                config.input_channels,
                config.kernel_size,
                config.kernel_size
            )
            self.weights = np.random.choice([-1, 0, 1], size=weight_shape).astype(np.int8)
        else:
            self.weights = weights.astype(np.int8)

        # Validate weights are ternary
        assert np.all(np.isin(self.weights, [-1, 0, 1])), "Weights must be ternary {-1, 0, +1}"

        # Reshape weights for matrix multiply: (OC, IC*K*K)
        self.weights_mat = self.weights.reshape(config.output_channels, -1).astype(np.int8)

        # Batch norm parameters (folded as threshold + scale)
        self.bn_threshold = np.zeros(config.output_channels)
        self.bn_scale = np.ones(config.output_channels)

    def set_batch_norm(self, mean: np.ndarray, var: np.ndarray, gamma: np.ndarray, beta: np.ndarray):
        """
        Fold batch normalization parameters.

        BN: y = gamma * (x - mean) / sqrt(var + eps) + beta
        Folded: y = scale * x + threshold

        where:
            scale = gamma / sqrt(var + eps)
            threshold = beta - gamma * mean / sqrt(var + eps)
        """
        eps = 1e-5
        std = np.sqrt(var + eps)
        self.bn_scale = gamma / std
        self.bn_threshold = beta - gamma * mean / std

    def forward(self, input_data: np.ndarray) -> Tuple[np.ndarray, Dict[str, Any]]:
        """
        Forward pass through the TNN layer.

        Args:
            input_data: Input tensor of shape (C, H, W)

        Returns:
            Tuple of (output_tensor, statistics_dict)
        """
        cfg = self.config
        stats = {}

        # Input validation
        assert input_data.shape == (cfg.input_channels, cfg.input_height, cfg.input_width), \
            f"Expected input shape {(cfg.input_channels, cfg.input_height, cfg.input_width)}, got {input_data.shape}"

        # Step 1: im2col transformation
        col = im2col(input_data, cfg.kernel_size, cfg.stride, cfg.padding)
        stats['col_shape'] = col.shape

        # Step 2: Ternary matrix multiply
        # output = weights @ col
        # weights: (OC, IC*K*K), col: (IC*K*K, OH*OW)
        # result: (OC, OH*OW)
        # ternary_matmul(activations, weights) computes activations @ weights^T
        # So we pass col^T as activations and weights_mat as weights
        matmul_output, matmul_stats = ternary_matmul(col.T, self.weights_mat)
        # Result has shape (OH*OW, OC), transpose to (OC, OH*OW)
        matmul_output = matmul_output.T
        stats.update(matmul_stats)

        # Output dimensions
        oh = (cfg.input_height + 2 * cfg.padding - cfg.kernel_size) // cfg.stride + 1
        ow = (cfg.input_width + 2 * cfg.padding - cfg.kernel_size) // cfg.stride + 1

        # Step 3: Apply batch normalization (folded)
        for ch in range(cfg.output_channels):
            matmul_output[ch, :] = matmul_output[ch, :] * self.bn_scale[ch] + self.bn_threshold[ch]

        # Reshape to tensor
        output = col2im(matmul_output, cfg.output_channels, oh, ow)
        stats['pre_activation_shape'] = output.shape

        # Step 4: Apply activation
        output = apply_activation(output, cfg.activation)

        # Step 5: Apply pooling
        if cfg.pooling != PoolingType.NONE:
            output = apply_pooling(output, cfg.pooling, cfg.pool_size)

        stats['output_shape'] = output.shape

        return output, stats


class TNNModel:
    """
    Multi-layer TNN model for inference.

    Supports stacking multiple TNN layers for complete network inference.
    """

    def __init__(self, layers: List[TNNLayer] = None):
        """Initialize TNN model."""
        self.layers = layers if layers is not None else []

    def add_layer(self, layer: TNNLayer):
        """Add a layer to the model."""
        self.layers.append(layer)

    def forward(self, input_data: np.ndarray) -> Tuple[np.ndarray, List[Dict]]:
        """
        Forward pass through all layers.

        Args:
            input_data: Input tensor

        Returns:
            Tuple of (output_tensor, list_of_layer_statistics)
        """
        x = input_data
        all_stats = []

        for i, layer in enumerate(self.layers):
            x, stats = layer.forward(x)
            stats['layer_index'] = i
            all_stats.append(stats)

        return x, all_stats


def create_simple_cnn(input_shape: Tuple[int, int, int] = (1, 28, 28),
                      num_classes: int = 10) -> TNNModel:
    """
    Create a simple TNN CNN for MNIST-like tasks.

    Architecture:
        Input: 1x28x28
        Conv1: 32 filters, 3x3, stride 1, padding 1 -> 32x28x28
        MaxPool: 2x2 -> 32x14x14
        Conv2: 64 filters, 3x3, stride 1, padding 1 -> 64x14x14
        MaxPool: 2x2 -> 64x7x7
        FC: 64*7*7 -> num_classes (implemented as 1x1 conv)
    """
    c, h, w = input_shape

    # Layer 1
    cfg1 = TNNLayerConfig(
        input_height=h, input_width=w, input_channels=c,
        output_channels=32, kernel_size=3, stride=1, padding=1,
        activation=ActivationType.RELU,
        pooling=PoolingType.MAX, pool_size=2
    )
    layer1 = TNNLayer(cfg1)

    # Layer 2
    cfg2 = TNNLayerConfig(
        input_height=h // 2, input_width=w // 2, input_channels=32,
        output_channels=64, kernel_size=3, stride=1, padding=1,
        activation=ActivationType.RELU,
        pooling=PoolingType.MAX, pool_size=2
    )
    layer2 = TNNLayer(cfg2)

    model = TNNModel([layer1, layer2])

    return model


def demo():
    """Demonstrate TNN layer computation."""
    print("=" * 60)
    print("Ternary Neural Network Layer Model")
    print("=" * 60)

    # Create a simple layer
    config = TNNLayerConfig(
        input_height=8,
        input_width=8,
        input_channels=3,
        output_channels=16,
        kernel_size=3,
        stride=1,
        padding=1,
        activation=ActivationType.RELU,
        pooling=PoolingType.MAX,
        pool_size=2
    )

    layer = TNNLayer(config)

    # Random input
    np.random.seed(42)
    input_data = np.random.randint(-50, 51, size=(3, 8, 8))

    print(f"\nLayer Configuration:")
    print(f"  Input: {config.input_channels}x{config.input_height}x{config.input_width}")
    print(f"  Output channels: {config.output_channels}")
    print(f"  Kernel: {config.kernel_size}x{config.kernel_size}")
    print(f"  Activation: {config.activation.value}")
    print(f"  Pooling: {config.pooling.value} {config.pool_size}x{config.pool_size}")

    print(f"\nWeight tensor shape: {layer.weights.shape}")
    print(f"Weight sparsity (zeros): {np.mean(layer.weights == 0):.1%}")

    # Forward pass
    output, stats = layer.forward(input_data)

    print(f"\nInput shape: {input_data.shape}")
    print(f"Output shape: {output.shape}")
    print(f"\nComputation Statistics:")
    print(f"  Total MACs: {stats['total_macs']}")
    print(f"  Zero-skipped: {stats['zero_skipped']}")
    print(f"  Zero-skip ratio: {stats['zero_skip_ratio']:.1%}")

    # Test multi-layer model
    print("\n" + "=" * 60)
    print("Multi-Layer TNN Model Test")
    print("=" * 60)

    model = create_simple_cnn(input_shape=(1, 28, 28))

    print(f"\nModel has {len(model.layers)} layers")

    input_mnist = np.random.randint(-100, 101, size=(1, 28, 28))
    output, all_stats = model.forward(input_mnist)

    print(f"\nInput shape: {input_mnist.shape}")
    print(f"Final output shape: {output.shape}")

    total_macs = sum(s['total_macs'] for s in all_stats)
    total_skipped = sum(s['zero_skipped'] for s in all_stats)

    print(f"\nTotal network statistics:")
    print(f"  Total MACs: {total_macs:,}")
    print(f"  Zero-skipped: {total_skipped:,}")
    print(f"  Overall zero-skip ratio: {total_skipped / total_macs:.1%}")


if __name__ == "__main__":
    demo()
