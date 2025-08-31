LLM Studio Custom Llama.cpp Backend Update Instructions
=======================================================

Prerequisites:
--------------
- LLM Studio installed
- CUDA toolkit (if building GPU backend)
- Vulkan SDK (if building Vulkan backend)
- Visual Studio 2019 (or newer) with C++ build tools

Steps to Build and Update Backend:
----------------------------------
1. Open the "x64 Native Tools Command Prompt for VS 2019".
2. Navigate to your llama.cpp source folder:
   cd /d C:\Users\Admin\source\llama.cpp
3. Run the fetch script to download the latest llama.cpp:
   A_fetch_llama.cmd
4. Run the build script with your desired system settings:
   B_build_single_llama.cmd

5. Once the build completes, go to the build output folder and copy the following files:
   - ggml-base.dll
   - ggml-cpu.dll

6. Patch the JSON files in the LLM Studio backend folder:
   - backend-manifest.json → set "instruction_set_extensions" to desired value (e.g., AVX, AVX2, or leave blank)
   - display-data.json → set "displayName" and "description" to something friendly

7. Give the backend folder a descriptive name for easy identification in LLM Studio.

Important Notes:
----------------
- Only ggml-base.dll and ggml-cpu.dll should be replaced.  
- Do NOT replace llama.dll, ggml_llamacpp.dll, or any .node files (e.g., llm_engine_vulkan.node). These are part of LLM Studio's custom wrapper and breaking them will prevent the engine from loading.
- Vulkan builds currently do not generate a separate ggml-vulkan.dll. Only CPU and CUDA DLLs are replaceable.
- Always keep a backup of the original backend folder in case something breaks.

Outcome:
--------
Following these steps will update LLM Studio to use your custom-built llama.cpp backend with the latest performance improvements.
