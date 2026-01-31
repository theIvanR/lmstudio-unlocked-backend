#!/usr/bin/env bash
set -e

# Minimal upstream-safe Vulkan build script for llama.cpp
# No LM Studio packaging, no Node.js, no backend.node

BUILD_DIR="build-vulkan"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake .. \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_TOOLS=OFF \
  -DGGML_VULKAN=ON \
  -DGGML_VULKAN_MXFP=OFF \
  -DGGML_AVX=ON \
  -DGGML_AVX2=OFF \
  -DGGML_FMA=OFF

cmake --build . -j$(nproc)

echo "Vulkan build complete. Binaries are in: $BUILD_DIR/bin"
