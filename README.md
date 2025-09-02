# LM Studio Unlocked Backend

**Premise (short):** the developer team said it wouldn't work. we did it anyway and built our own **unofficial** backends for LM Studio — patched `llama.cpp` backends that let LM Studio run on much wider / older hardware.

This repo contains ready-to-drop backend folders you can copy into LM Studio's backend directory. So far I have two *confirmed working* backends on my Ivy Bridge system:

- **AVX1 CPU-only** (stable)  
- **Vulkan (AVX1) GPU backend** (stable)  

Others can be created on request or by following the instructions in **Generate arbitrary backend** (see docs/pdf).

> Drag-and-drop deploy: copy any backend folder from this repo into LM Studio's backends directory — restart LM Studio and pick the backend.

---

# What this does

LM Studio is basically a GUI wrapper around `llama.cpp`. Distributed backends often require AVX2 or modern GPU features. These patched/unofficial backends demonstrate that LM Studio can run on much older CPUs/GPUs than the official backends claim — i.e., the GUI will work with:

- CPU-only legacy machines (AVX1 / older Intel generations such as Ivy Bridge)  
- Vulkan-compatible GPUs with AVX1 builds  
- Experimental no-AVX option for extremely old/odd systems

---

# Included backends

- ✅ `cpu-avx1` — CPU-only AVX1 build (confirmed working on Ivy Bridge)  
- ✅ `vulkan-avx1` — Vulkan GPU backend built with AVX1 support (confirmed working on Ivy Bridge + Vulkan-capable GPU)  
- 🚧 `noavx-experimental` — experimental pure fallback; limited performance and compatibility  
- 🚧 `cuda` — planned (works analogously; older CUDA GPUs < CC 5.0 require BF16 fixes — coming soon)

(Exact folder names are provided in the repo. Example folder: `llama.cpp-win-x86_64-vulkan-avx-1.48.0`.)

---

# Quick usage — drag & drop

1. Locate LM Studio backends folder. Example paths:
   - Windows:  
     ```
     C:\Users\<you>\.lmstudio\extensions\backends\
     ```
   - Linux (example):  
     ```
     ~/.lmstudio/extensions/backends/
     ```

2. Copy one or more backend folders from this repo into that directory.

3. Restart LM Studio. Your custom backend(s) should appear in the backend selection list.

---

# Generate arbitrary backend (short guide)

If you want to build your own backend or adapt one to different CPU/GPU targets, follow the full instructions in `docs/generate-arbitrary-backend.pdf`. Quick summary of the workflow:

1. **Clone `llama.cpp` (or fork)** and check out the tag/version you want to target.  
2. **Apply patches** contained in this repo (or adapt them): these patches add legacy CPU fallbacks (AVX1 / no-AVX), Vulkan tweaks, and packaging conventions compatible with LM Studio.  
3. **Build** for your target:
- Create a clean build directory.  
- Use your platform's build tools (CMake / make / MSVC) and specify the proper target options for CPU/GPU.  
- Confirm the binary runs on the target machine (smoke-test with `--help` / small model run).  
4. **Package** the resulting binaries and required DLLs into a folder named with the same style LM Studio expects (example: `llama.cpp-win-x86_64-vulkan-avx-1.48.0`). Include a small `manifest` or `README.txt` inside the folder describing the build (platform, date, special notes).  
5. **Drop** the folder into LM Studio's backends dir and restart LM Studio.

If you prefer a one-line script or CI example, check `docs/generate-arbitrary-backend.pdf` for step-by-step commands and sample scripts.

---

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

## TL;DR
We were told it couldn't be done. We did it anyway. Drop the included backend folder(s) into LM Studio's `backends` folder, restart, and enjoy your legacy-hardware-friendly backend.

