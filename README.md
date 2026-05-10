# LM Studio Unlocked Backend

**Premise:** the developer team said it wouldn't work. we did it anyway and built our own **unofficial** backends for LM Studio — patched `llama.cpp` backends that let LM Studio run on much wider / older hardware.

## Backends Available: 

- ✅ `windows-cpu-avx1` — CPU-only AVX1 build (confirmed working on Ivy Bridge)  
- ✅ `windows-vulkan-avx1` — Vulkan GPU backend built with AVX1 support (confirmed working on Ivy Bridge + Vulkan-capable GPU)
- 🌀 Arch Linux build script (testers especially wanted!)

## Backends in Developed:
- 🚧 `noavx-experimental` — experimental pure fallback; limited performance and compatibility
- 🚧 `avx512++` — coming soon
- 🚧 `cuda` — coming soon

## Custom Backends for your System 🚀 ?
- Follow the instructions in `Generate Backends`. Windows confirmed working, (Arch) Linux experimental, patches with MXFP4 required.
  
**NOTE** : To save time building, on newer Windoes versions Vulkan backend is already built without AVX2 so patching it is and **confirmed working**. This is likely to work on CUDA gpus as well however is untested at the monent. (Patch in the manifest json file)
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
- Flash Attention currently appears broken on Vulkan, issue appears to be with an underflow and a NaN in the llama backend itself, hopefully will be mitigated soon.
- The surveying hardware bug is intermittent and testers on various machines are needed. It seems to afflict nvidia gpus in TCC mode, switching to WDDM appears to resolve the issue. 

# ** IMPORTANT UPDATE REGARDING LMSTUDIO **
### 1: Uninstall on Windows is currently broken and leaves a mess in the system in the following locations: 
- HKEY_CURRENT_USER\Software\Classes\
- user
- appdata
- localappdata


### 2: With recent improvements to llama cpp web ui I can no longer recommend to use LM Studio especially on legacy systems. Instead, run the llama cpp backends directly via the web UI. Instructions provided in my other repository: 
https://github.com/theIvanR/llama-on-legacy-gpu/tree/main
---

## Licensing, Disclaimer, Credits

- **Unofficial / experimental:** Community-made patches; use at your own risk.  
- **License:** MIT, following `llama.cpp` conventions.  
- **No warranties:** Not guaranteed for production or mission-critical use—use official LM Studio backends for stability.  
- **Credits:** Patches tested by repo maintainers; based on `llama.cpp` and LM Studio work.


# Contact / contribute

- Pull requests welcome: add build scripts, CI, or additional patched backends.  
- If you want a custom backend built for a particular CPU/GPU, open an issue or request and we'll try to provide one.

