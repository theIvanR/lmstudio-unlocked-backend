#!/usr/bin/env bash
set -e

# LM Studio Unlocked Backend - CUDA AVX1 Build Script for Linux
# This script builds llama.cpp with CUDA support and AVX1 CPU compatibility
# Compatible with NVIDIA GPUs (Compute Capability 6.1 - 8.9) and older CPUs (Ivy Bridge 2012+)

BUILD_DIR="build-cuda-avx1"

echo "=== Building llama.cpp with CUDA (6.1-8.9) + AVX1 ==="
echo "Build directory: $BUILD_DIR"
echo ""

# Clean previous build
if [ -d "$BUILD_DIR" ]; then
    echo "Cleaning previous build..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure with CUDA and AVX1
echo "Configuring CMake..."
cmake .. \
  -DCMAKE_C_COMPILER=gcc-10 \
  -DCMAKE_CXX_COMPILER=g++-10 \
  -DCMAKE_CUDA_COMPILER=nvcc \
  -DCMAKE_CUDA_HOST_COMPILER=g++-10 \
  -DCMAKE_CUDA_ARCHITECTURES="61;62;70;72;75;80;86;87;89" \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_TOOLS=OFF \
  -DGGML_CUDA=ON \
  -DGGML_CUDA_F16=ON \
  -DGGML_AVX=ON \
  -DGGML_AVX2=OFF \
  -DGGML_FMA=OFF

# Build
echo "Building..."
cmake --build . -j$(nproc)

echo ""
echo "? CUDA (6.1-8.9) AVX1 build complete!"
echo "  Binaries located at: $BUILD_DIR/bin"
echo ""
echo "Supported GPU Architectures:"
echo "  61 - Pascal (GTX 1000 series)"
echo "  62 - Pascal Mobile"
echo "  70 - Volta (V100)"
echo "  72 - Volta Mobile"
echo "  75 - Turing (RTX 2000 series)"
echo "  80 - Ampere (RTX 3000 series, A100)"
echo "  86 - Ampere Mobile (RTX 3000 Mobile)"
echo "  87 - Ampere Mobile"
echo "  89 - Ada Lovelace (RTX 4000 series)"