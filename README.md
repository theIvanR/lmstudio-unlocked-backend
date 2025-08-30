# LM Studio Unlocked Backend

This repo provides patched **llama.cpp** backends for [LM Studio](https://lmstudio.ai/), allowing it to run on a much wider range of hardware.  

LM Studio is just a GUI wrapper around `llama.cpp`. By default, its distributed backends require **AVX2** or specific modern GPU features.  
This project shows how to **patch the backend folders** so that LM Studio runs on:  

- **CPU-only (AVX1 / legacy CPUs)**  
- **GPU (Vulkan, AVX1 builds)**  
- *(CUDA coming soon — works analogously, but older GPUs < CC 5.0 need BF16 fixes)*  

## Included backends

- ✅ CPU-only (AVX1)  
- ✅ Vulkan backend (AVX1)  
- 🚧 CUDA backend (planned — needs BF16 patching for older cards)
- More backends and newer versions can be made availble either upon request or via the provided pdf tutorials

## Usage

1. Find LM Studio’s backend directory, for example:
```
C:\Users<you>.lmstudio\extensions\backends\
```

2. Copy one (or multiple) of the provided backend folders into this directory.  
Example: 
```
llama.cpp-win-x86_64-vulkan-avx-1.48.0
```

3. (Optional) Edit the metadata (`backend-manifest.json` / `display-data.json`) if you want to adjust the display name or required features.  
4. Restart LM Studio — your custom backend should now appear.  

## Notes
- LM Studio is **just a wrapper** — these patched backends prove it can run on much older CPUs and GPUs than claimed.  
- CUDA support will be added later.  
- Licensed under MIT (same as `llama.cpp`).  
