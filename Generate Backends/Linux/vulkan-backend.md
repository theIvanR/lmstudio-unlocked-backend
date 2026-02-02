# Vulkan Backend Notes

The Vulkan backend in llama.cpp provides GPU acceleration on systems without CUDA.

## Recommended CMake Flags

```bash
-DGGML_VULKAN=ON
-DGGML_VULKAN_MXFP=OFF
-DLLAMA_BUILD_EXAMPLES=OFF
-DLLAMA_BUILD_TESTS=OFF
-DLLAMA_BUILD_TOOLS=OFF
```

## MXFP4 Issue

MXFP4 shaders are not yet implemented in the Vulkan backend.  
If enabled, the build fails with missing symbols.

Until MXFP4 support is added, always disable it:

```bash
-DGGML_VULKAN_MXFP=OFF
```

## Supported GPUs

- AMD (RADV)
- Intel (ANV)
- NVIDIA (via Vulkan ICD, performance varies)
