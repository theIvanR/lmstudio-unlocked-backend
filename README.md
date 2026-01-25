# Update Regarding LM Studio App: 
Changes have been made to the app breaking the lmstudio uninstaller and there appears to be a bug with surveying hardware. 

Specifically, for the uninstall, the uninstaller leaves a mess in the system in the following locations: 
- HKEY_CURRENT_USER\Software\Classes\
- user
- appdata
- localappdata

The surveying hardware bug is intermittent and testers on various machines are needed. It seems to afflict nvidia gpus in TCC mode, switching to WDDM appears to resolve the issue. 

Recommended action: 
- Short term: Dont update! Actively being investigated!
- Long term: Switch to llamacpp webui. It is actively superior and completely open source software.

---
# LM Studio Unlocked Backend

**Premise:** the developer team said it wouldn't work. we did it anyway and built our own **unofficial** backends for LM Studio — patched `llama.cpp` backends that let LM Studio run on much wider / older hardware.

## Backends Available: 

- ✅ `cpu-avx1` — CPU-only AVX1 build (confirmed working on Ivy Bridge)  
- ✅ `vulkan-avx1` — Vulkan GPU backend built with AVX1 support (confirmed working on Ivy Bridge + Vulkan-capable GPU)

## Backends in Developed:
- 🚧 `noavx-experimental` — experimental pure fallback; limited performance and compatibility
- 🚧 `avx512++` — coming soon
- 🚧 `cuda` — coming soon
  
## Important Update Regarding Stock GPU Backends: 
In new versions, Vulkan backend is already built without AVX2 so patching it is and **confirmed working**. This is likely to work on CUDA gpus as well however is untested at the monent.
```
"instruction_set_extensions": [
      "AVX"
    ]
```
  
# Quick usage — drag & drop

1. Locate LM Studio backends folder on Windows
     ```
     C:\Users\%USERNAME%\.lmstudio\extensions\backends\
     ```

2. Copy one or more backend folders from `Releases` in this repo into LM Studio directory.

3. Restart LM Studio. Your custom backend(s) should appear in the backend selection list.
   
4. Want to Build your own? Follow instructions in `Generate Backends`

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

## Licensing, Disclaimer, Credits

- **Unofficial / experimental:** Community-made patches; use at your own risk.  
- **License:** MIT, following `llama.cpp` conventions.  
- **No warranties:** Not guaranteed for production or mission-critical use—use official LM Studio backends for stability.  
- **Credits:** Patches tested by repo maintainers; based on `llama.cpp` and LM Studio work.


# Contact / contribute

- Pull requests welcome: add build scripts, CI, or additional patched backends.  
- If you want a custom backend built for a particular CPU/GPU, open an issue or request and we'll try to provide one.
