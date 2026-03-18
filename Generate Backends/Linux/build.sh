#!/usr/bin/env bash
set -e

# Unified llama.cpp build script for LM Studio backends (Linux)
# Usage: ./build.sh <backend> [llama_src_dir]
#   backend: cpu, vulkan, cuda
#   llama_src_dir: path to llama.cpp source (default: current directory)
#
# Examples:
#   ./build.sh cpu
#   ./build.sh vulkan /home/user/llama.cpp
#   ./build.sh cuda

BACKEND="${1}"
SRC_DIR="${2:-.}"

if [ -z "$BACKEND" ]; then
    echo "Usage: ./build.sh <backend> [llama_src_dir]"
    echo "  backend: cpu, vulkan, cuda"
    exit 1
fi

case "$BACKEND" in
    cpu|vulkan|cuda) ;;
    *) echo "[ERROR] Unknown backend '$BACKEND'. Must be one of: cpu, vulkan, cuda"; exit 1 ;;
esac

if [ ! -d "$SRC_DIR" ]; then
    echo "[ERROR] Source directory '$SRC_DIR' does not exist."
    exit 1
fi

cd "$SRC_DIR"

BUILD_DIR="build-${BACKEND}"

# Common CMake flags
CMAKE_FLAGS=(
    -DLLAMA_BUILD_EXAMPLES=OFF
    -DLLAMA_BUILD_TESTS=OFF
    -DLLAMA_BUILD_TOOLS=OFF
    -DCMAKE_BUILD_TYPE=Release
    -DGGML_AVX=ON
    -DGGML_AVX2=OFF
    -DGGML_FMA=OFF
)

# Backend-specific flags
case "$BACKEND" in
    vulkan)
        CMAKE_FLAGS+=(
            -DGGML_VULKAN=ON
            -DGGML_VULKAN_MXFP=OFF
        )
        ;;
    cuda)
        CMAKE_FLAGS+=(
            -DUSE_CUDA=ON
            -DGGML_CUDA=ON
            -DCUDA_ARCH_LIST=35
        )
        ;;
esac

echo "[INFO] Building $BACKEND backend in $BUILD_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake .. "${CMAKE_FLAGS[@]}"
cmake --build . -j"$(nproc)"

echo "[SUCCESS] $BACKEND backend built successfully in $BUILD_DIR/bin"
