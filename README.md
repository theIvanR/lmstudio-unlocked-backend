# LM Studio Unlocked Backend

**Premise (short):** the developer team said it wouldn't work. we did it anyway and built our own **unofficial** backends for LM Studio — patched `llama.cpp` backends that let LM Studio run on much wider / older hardware.

## Following backends available: 

- ✅ `cpu-avx1` — CPU-only AVX1 build (confirmed working on Ivy Bridge)  
- ✅ `vulkan-avx1` — Vulkan GPU backend built with AVX1 support (confirmed working on Ivy Bridge + Vulkan-capable GPU)

## Following backends are being developed:
- 🚧 `noavx-experimental` — experimental pure fallback; limited performance and compatibility
- 🚧 `avx512` — coming soon
- 🚧 `cuda` — coming soon
  
> Drag-and-drop deploy: copy any backend folder from this repo into LM Studio's backends directory — restart LM Studio and pick the backend.
> Custom backends can be generated for any architecture using the instructions in `Generate Backends`

# Important Update Regarding Stock GPU Backends: 
In the new versions, it seems the vulkan backend is already built without AVX2 instructions, so simply patching it is suficient and **confirmed working**. This is likely to work on CUDA gpus as well
```
"instruction_set_extensions": [
      "AVX"
    ]
```

---



# What this does

LM Studio is basically a GUI wrapper around `llama.cpp`. Distributed backends often require AVX2 or modern GPU features. These patched/unofficial backends demonstrate that LM Studio can run on much older CPUs/GPUs than the official backends claim — i.e., the GUI will work with:

- CPU-only legacy machines (AVX1 / older Intel generations such as Ivy Bridge)  
- Vulkan-compatible GPUs with AVX1 builds  
- Experimental no-AVX option for extremely old/odd systems
---

# Quick usage — drag & drop

1. Locate LM Studio backends folder on Windows
     ```
     C:\Users\<you>\.lmstudio\extensions\backends\
     ```

2. Copy one or more backend folders from this repo into that directory.

3. Restart LM Studio. Your custom backend(s) should appear in the backend selection list.

# Troubleshooting & tips

- If the backend doesn't show up:
- Verify you copied the backend folder into the correct `backends` path (hidden `.lmstudio` on Windows).  
- Ensure file permissions allow LM Studio to execute the files.  
- Restart LM Studio (full restart — not just window refresh).  
- If the backend crashes on start:
- Try the `noavx-experimental` as a fallback to confirm AVX issues.  
- Check the `stderr` / `stdout` logs produced by LM Studio for the backend process.  
- Performance expectations:
- AVX1 CPU builds will be slower than AVX2/AVX512 builds but are usable for smaller models and experiments.  
- Vulkan backend performance depends heavily on your GPU and driver — older Vulkan-capable GPUs can still be effective for smaller models.
- If you are experiencing issues like 18446744072635812000 and other random model crashes on kepler gpus, set the batch evaluation size lower to say 384. This is a known issue in vulkan which as of September 2025 has not been patched by devs. 
- Flash Attention currently appears broken on Vulkan, issue appears to be with an underflow and a NaN in the llama backend itself, hopefully will be mitigated soon. 
---

# Licensing & disclaimer

- **Unofficial / experimental.** These backends are community patches and are **not** official LM Studio files. Use at your own risk.  
- **License:** MIT (this repo follows the same spirit as `llama.cpp` licensing).  
- We make no warranties about performance or stability. If you need a production-grade setup, please use official backends or adapt these patches carefully.

---

# Credits

- Patches and testing by the repo maintainers (this branch).  
- Based on work and license of `llama.cpp` and LM Studio (this repo does not claim ownership of upstream projects).

---

# Contact / contribute

- Pull requests welcome: add build scripts, CI, or additional patched backends.  
- If you want a custom backend built for a particular CPU/GPU, open an issue or request and we'll try to provide one.

---
