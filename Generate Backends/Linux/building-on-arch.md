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
