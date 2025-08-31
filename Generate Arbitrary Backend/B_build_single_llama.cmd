@echo off
rem =====================================================
rem llama.cpp build script (patched for Vulkan support)
rem =====================================================

rem Navigate to llama.cpp source
cd /d C:\Users\Admin\source\llama.cpp
setlocal

rem -------------------------
rem Build options (ON/OFF)
rem -------------------------
set AVX=ON
set AVX2=OFF
set AVX512=OFF
set F16=OFF
set VULKAN=ON

rem -------------------------
rem Vulkan environment
rem -------------------------
set VULKAN_SDK=C:\VulkanSDK\1.4.321.1
set PATH=%VULKAN_SDK%\Bin;%PATH%
set INCLUDE=%VULKAN_SDK%\Include;%INCLUDE%
set LIB=%VULKAN_SDK%\Lib;%LIB%

rem -------------------------
rem Derived build directory
rem -------------------------
set build=build_avx%AVX%_avx2%AVX2%_avx512%AVX512%_f16%F16%_vk%VULKAN%
set /a CORES=%NUMBER_OF_PROCESSORS%
rmdir /s /q %build%

rem -------------------------
rem Configure CMake
rem -------------------------
cmake -S . -B %build% -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DGGML_AVX=%AVX% ^
  -DGGML_AVX2=%AVX2% ^
  -DGGML_AVX512=%AVX512% ^
  -DGGML_F16=%F16% ^
  -DLLAMA_VULKAN=%VULKAN% ^
  -DVulkan_INCLUDE_DIR="%VULKAN_SDK%\Include" ^
  -DVulkan_LIBRARY="%VULKAN_SDK%\Lib\vulkan-1.lib"

rem -------------------------
rem Build
rem -------------------------
cmake --build %build% -- -j %CORES%

echo Done.
pause
