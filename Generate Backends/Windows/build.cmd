@echo off
setlocal

REM =========================
REM Unified llama.cpp build script for LM Studio backends
REM Usage: build.cmd <backend> [llama_src_dir]
REM   backend: cpu, vulkan, cuda
REM   llama_src_dir: path to llama.cpp source (optional)
REM
REM Examples:
REM   build.cmd cpu
REM   build.cmd vulkan C:\source\llama.cpp
REM   build.cmd cuda
REM =========================

REM --- Parse backend type ---
set "BACKEND=%~1"
if "%BACKEND%"=="" (
    echo Usage: build.cmd ^<backend^> [llama_src_dir]
    echo   backend: cpu, vulkan, cuda
    echo   llama_src_dir: path to llama.cpp source ^(optional^)
    exit /b 1
)

if /i not "%BACKEND%"=="cpu" if /i not "%BACKEND%"=="vulkan" if /i not "%BACKEND%"=="cuda" (
    echo [ERROR] Unknown backend "%BACKEND%". Must be one of: cpu, vulkan, cuda
    exit /b 1
)

REM --- Parse source directory ---
set "DEFAULT_SRC_DIR=C:\Users\Admin\source\llama.cpp"

if "%~2"=="" (
    set "SRC_DIR=%DEFAULT_SRC_DIR%"
) else (
    set "SRC_DIR=%~2"
)

if not exist "%SRC_DIR%" (
    echo [ERROR] Source directory "%SRC_DIR%" does not exist.
    exit /b 1
)

pushd "%SRC_DIR%" >nul 2>&1 || (
    echo [ERROR] Failed to enter "%SRC_DIR%".
    exit /b 1
)

REM -------------------------
REM Set build dir and compiler flags
REM -------------------------
if /i "%BACKEND%"=="cpu"    set "BUILD_DIR=build_cpu"
if /i "%BACKEND%"=="vulkan" set "BUILD_DIR=build_gpu_vulkan"
if /i "%BACKEND%"=="cuda"   set "BUILD_DIR=build_gpu_cuda"

set "CL=/bigobj %CL% /Ot /fp:fast"

if exist "%BUILD_DIR%" (
    echo [INFO] Removing old build directory "%BUILD_DIR%"...
    rmdir /s /q "%BUILD_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to remove dir
        popd
        pause
        exit /b 1
    )
)

REM -------------------------
REM Build backend-specific CMake flags
REM -------------------------
set "EXTRA_FLAGS="
if /i "%BACKEND%"=="vulkan" set "EXTRA_FLAGS=-DGGML_VULKAN=ON"
if /i "%BACKEND%"=="cuda"   set "EXTRA_FLAGS=-DUSE_CUDA=ON -DGGML_CUDA=ON -DCUDA_ARCH_LIST=35"

REM -------------------------
REM Configure with CMake
REM -------------------------
echo [INFO] Building %BACKEND% backend in "%BUILD_DIR%"

cmake -S . -B "%BUILD_DIR%" ^
      -G "Ninja" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DLLAMA_CURL=OFF ^
      -DGGML_NATIVE=ON ^
      %EXTRA_FLAGS%

cmake --build "%BUILD_DIR%" --verbose

if errorlevel 1 (
    echo [ERROR] CMake build failed
    popd
    pause
    exit /b 1
)

echo [SUCCESS] %BACKEND% backend built successfully in "%BUILD_DIR%"
popd
exit /b 0
