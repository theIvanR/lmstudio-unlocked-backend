A: Prerequisites:
--------------
- LLM Studio installed
- CUDA toolkit (if building GPU backend)
- Vulkan SDK (if building Vulkan backend)
- Visual Studio 2019 (or newer) with C++ build tools

B: Steps to Build and Update Backend:
----------------------------------
0. Make a backup of the original backend as a fallback in case something breaks.

1. Open the "x64 Native Tools Command Prompt for VS 2019" (or whichever one you use).

2. Run the fetch script

3. Run the build script of your choice using desired flags (for example, no avx or avx 512 and all cuda versions etc etc)
   Stock Flags: 
   - AVX1
   - DCUDA_ARCH_LIST=35

4. Once the build completes, go to the build output folder and copy the following files:
   - ggml-base.dll
   - ggml-cpu.dll

5. Patch the JSON files in the LLM Studio backend folder:
   - backend-manifest.json → set "instruction_set_extensions" to desired value (e.g., AVX, AVX2, or leave blank)
   - display-data.json → set "displayName" and "description" to something friendly

6. Give the backend folder a descriptive name for easy identification in LLM Studio.

C: Important Notes:
----------------
- Always keep a backup of the original backend folder in case something breaks.
- Only ggml-base.dll and ggml-cpu.dll should be replaced.  
- Do NOT replace llama.dll, ggml_llamacpp.dll, or any .node files (e.g., llm_engine_vulkan.node). These are part of LLM Studio's custom wrapper and breaking them will prevent the engine from loading.
- Vulkan builds currently do not generate a separate ggml-vulkan.dll. Only CPU and CUDA DLLs are replaceable.

D: Outcome:
--------
Following these steps will update LLM Studio to use your custom-built llama.cpp backend with the latest performance improvements.

