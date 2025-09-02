@echo off
rem =====================================================
rem llama.cpp CUDA build script for CUDA GPUs
rem =====================================================

cd /d C:\Users\Admin\source\llama.cpp
setlocal

rem -------------------------
rem Clear Miniconda environment variables that cause conflicts
rem -------------------------
set CMAKE_PREFIX_PATH=
set CONDA_PREFIX=
set CONDA_DEFAULT_ENV=

rem -------------------------
rem Build options (ON/OFF)
rem -------------------------
set AVX=ON
set AVX2=OFF
set AVX512=OFF
set CUDA=ON
set CUDA_FORCE_F32=ON  # Forces BF16/FP16 to use FP32

rem -------------------------
rem CUDA environment setup
rem -------------------------
set CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.2
set PATH=%CUDA_PATH%\bin;%PATH%
set INCLUDE=%CUDA_PATH%\include;%INCLUDE%
set LIB=%CUDA_PATH%\lib\x64;%LIB%

rem -------------------------
rem Derived build directory
rem -------------------------
set build=build_avx%AVX%_cuda%CUDA%_cc
set /a CORES=%NUMBER_OF_PROCESSORS%
rmdir /s /q %build% 2>nul

rem -------------------------
rem Configure CMake
rem -------------------------
cmake -S . -B %build% -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DGGML_AVX=%AVX% ^
  -DGGML_AVX2=%AVX2% ^
  -DGGML_AVX512=%AVX512% ^
  -DLLAMA_CUDA=1 ^
  -DCMAKE_CUDA_ARCHITECTURES=all-major ^
  -DGGML_CUDA_FORCE_F32=%CUDA_FORCE_F32%

rem -------------------------
rem Build
rem -------------------------
cmake --build %build% -- -j %CORES%

echo Done.
pause