# Building llama.cpp on Linux with CUDA + AVX1

This guide explains how to build llama.cpp on Linux with CUDA GPU acceleration and AVX1 CPU instruction set support for maximum hardware compatibility.  Built for compute 61-89, Pascal to Ada.

## Install Dependencies

### For Arch/Artix:
```bash
sudo pacman -S base-devel gcc cmake git cuda
```


### For Ubuntu/Debian:
# We need gcc 10 to play nice with nvcc compiler.
```bash
sudo apt-get update
sudo apt-get install -y build-essential gcc-10 g++-10 cmake git
# Add NVIDIA CUDA repository
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update
# Install CUDA 12.8
sudo apt install -y cuda-toolkit-12-8
# Confirm Version
nvcc --version
# Should show: cuda_12.8
which nvcc
# Should show: /usr/local/cuda-12.8/bin/nvcc
```


## Build with CUDA + AVX1

Copy the build_cuda_avx1.sh script to your llama.cpp directory and chmod +x it.
Make any edits you need on architecture or gpu support by modifying the list of architectures in the `-DCMAKE_CUDA_ARCHITECTURES` line in the script

## Supported CUDA Architectures
-  **61** - Pascal (GTX 1000 series) 
-  **62** - Pascal Mobile
-  **70** - Volta (V100)
-  **72** - Volta Mobile
-  **75** - Turing (RTX 2000 series)
-  **80** - Ampere (RTX 3000 series, A100)
-  **86** - Ampere Mobile (RTX 3000 Mobile)
-  **87** - Ampere Mobile
-  **89** - Ada Lovelace (RTX 4000 series)



## Installing to LMStudio
Copy an existing avx2 backend to a new folder inside .lmstudio/extensions/backends and change the avx2 name to avx1
For example:
```
cp llama.cpp-linux-x86_64-nvidia-cuda12-avx2-2.13.0 llama.cpp-linux-x86_64-nvidia-cuda12-avx1-2.13.0
```

Then, copy your newly built libs over
```
cp lib*.so ~/.lmstudio/extensions/backends/llama.cpp-linux-x86_64-nvidia-cuda12-avx1-2.13.0/

```

## Edit backend-manifest.json
#Make sure to change the NAME to your new version, INSTRUCTION SET to AVX, and TARGETS to the compute versions you compiled
```
{
  "version": "2.13.0",
  "domains": ["llm", "embedding"],
  "engine": "llama.cpp",
  "extension_type": "engine",
  "target_libraries": [
    {"name": "llm_engine_cuda12.node", "type": "llm_engine", "version": "0.1.2"},
    {"name": "liblmstudio_bindings_cuda12.node", "type": "liblmstudio", "version": "0.2.26"}
  ],
  "platform": "linux",
  "cpu": {
    "architecture": "x86_64",
    "instruction_set_extensions": ["AVX"]
  },
  "gpu": {
    "make": "Nvidia",
    "framework": "CUDA",
    "targets": ["6.1", "6.2", "7.0", "7.2", "7.5", "8.0", "8.6", "8.7", "8.9"],
    "minimum_driver_version": "12040"
  },
  "supported_model_formats": ["gguf"],
  "manifest_version": "4",
  "minimum_lmstudio_version": "0.4.0+15",
  "name": "llama.cpp-linux-x86_64-nvidia-cuda12-avx1"
}
```


