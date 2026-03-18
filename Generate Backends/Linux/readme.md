# Building llama.cpp on Arch/Artix Linux

This guide explains how to build llama.cpp on Arch/Artix Linux with Vulkan support.

## Install Dependencies

```bash
sudo pacman -S base-devel gcc cmake git python python-pip \
  vulkan-validation-layers vulkan-tools mesa \
  vulkan-radeon vulkan-intel \
  libx11 libxrandr libxcursor libxi libxxf86vm
```

## Build

Use the unified build script:

```bash
# Vulkan backend
./build.sh vulkan

# CPU-only backend
./build.sh cpu

# CUDA backend
./build.sh cuda

# With a custom llama.cpp source directory
./build.sh vulkan /path/to/llama.cpp
```

The old `build_vulkan.sh` script is still available if you prefer it.

## Why MXFP4 is disabled

The Vulkan backend currently lacks MXFP4 shader implementations, causing link failures on Arch/Artix.  
Disabling MXFP4 ensures a clean build.
