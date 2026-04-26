# Building llama.cpp on Arch/Artix Linux

This guide explains how to build llama.cpp on Arch/Artix Linux with Vulkan support.

## Install Dependencies

```bash
sudo pacman -S base-devel gcc cmake git python python-pip \
  vulkan-validation-layers vulkan-tools mesa \
  vulkan-radeon vulkan-intel \
  libx11 libxrandr libxcursor libxi libxxf86vm
```

## Build with Vulkan

```bash
mkdir build-vulkan
cd build-vulkan

cmake .. \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_TOOLS=OFF \
  -DGGML_VULKAN=ON \
  -DGGML_VULKAN_MXFP=OFF

cmake --build . -j$(nproc)
```

## Why MXFP4 is disabled

The Vulkan backend currently lacks MXFP4 shader implementations, causing link failures on Arch/Artix.  
Disabling MXFP4 ensures a clean build.

## Build with CUDA + AVX1

For NVIDIA GPU acceleration with AVX1 CPU compatibility, see [cuda-avx1-backend.md](cuda-avx1-backend.md).

This approach provides:
- **GPU acceleration** via CUDA (NVIDIA GPUs only)
- **Hardware compatibility** with older CPUs (Ivy Bridge 2012+)
- **Optimal performance** for GPU-bound workloads

Quick build:
```bash
mkdir build-cuda-avx1
cd build-cuda-avx1

cmake .. \
  -DCMAKE_C_COMPILER=gcc-10 \
  -DCMAKE_CXX_COMPILER=g++-10 \
  -DCMAKE_CUDA_HOST_COMPILER=g++-10 \
  -DCMAKE_CUDA_ARCHITECTURES="70;75" \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_TOOLS=OFF \
  -DGGML_CUDA=ON \
  -DGGML_CUDA_F16=ON \
  -DGGML_AVX=ON \
  -DGGML_AVX2=OFF \
  -DGGML_FMA=OFF

cmake --build . -j$(nproc)
```
