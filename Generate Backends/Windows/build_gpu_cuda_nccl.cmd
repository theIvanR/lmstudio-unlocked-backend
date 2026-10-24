@echo off
setlocal
REM Call your visual studio cmd here (or other version)
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

REM =========================
REM User configuration (optionally pass llama dir as first argument
REM =========================
set "DEFAULT_SRC_DIR=%USERPROFILE%\source\llama.cpp"

if "%~1"=="" (set "SRC_DIR=%DEFAULT_SRC_DIR%") else (set "SRC_DIR=%~1")

pushd "%SRC_DIR%" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Invalid source directory: "%SRC_DIR%"
    exit /b 1
)

echo [INFO] nvcc version:
nvcc --version

REM pause

REM -------------------------
REM Set Flags and Clean up
REM -------------------------
set "CLEAN_BUILD=0"
set "BUILD_DIR=build_gpu_cuda"
set "CL=/bigobj %CL% /Ot /fp:fast"


REM NCCL 1.3.4 built with CUDA 11.8
set "NCCL_ROOT=C:\Users\Admin\source\nccl-on-windows\nccl_all_arch"
set "NCCL_INCLUDE_DIR=%NCCL_ROOT%"
set "NCCL_LIBRARY=%NCCL_ROOT%\nccl64_134.11.8.lib"
set "NCCL_DLL=%NCCL_ROOT%\nccl64_134.11.8.dll"


if "%CLEAN_BUILD%"=="1" (
    if exist "%BUILD_DIR%" (
        echo [INFO] Removing old build directory "%BUILD_DIR%"...

        rmdir /s /q "%BUILD_DIR%"

        if errorlevel 1 (
            echo [ERROR] Failed to remove build directory.
            popd
            pause
            exit /b 1
        )
    )
) else (
    echo [INFO] Keeping existing build directory.
)


if not exist "%NCCL_INCLUDE_DIR%\nccl.h" (
    echo [ERROR] nccl.h not found. Check NCCL_INCLUDE_DIR.
    popd
    pause
    exit /b 1
)

if not exist "%NCCL_LIBRARY%" (
    echo [ERROR] nccl.lib not found. Check NCCL_LIBRARY.
    popd
    pause
    exit /b 1
)

echo [INFO] Building in "%BUILD_DIR%"
echo [INFO] NCCL include: "%NCCL_INCLUDE_DIR%"
echo [INFO] NCCL library: "%NCCL_LIBRARY%"


REM -------------------------
REM Configure with CMake (set architectures to what you have)
REM -------------------------
echo [INFO] Building in "%BUILD_DIR%"
set "BUILD_FAILED=0"

cmake -S . -B "%BUILD_DIR%" ^
      -G "Ninja" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DLLAMA_CURL=OFF ^
      -DGGML_NATIVE=ON ^
      -DGGML_CUDA=ON ^
      -DGGML_CUDA_GRAPHS=ON ^
      -DCMAKE_CUDA_ARCHITECTURES=35 ^
      -DGGML_CUDA_NCCL=ON ^
      -DNCCL_INCLUDE_DIR="%NCCL_INCLUDE_DIR%" ^
      -DNCCL_LIBRARY="%NCCL_LIBRARY%"
	  
cmake --build "%BUILD_DIR%" --verbose
if errorlevel 1 set "BUILD_FAILED=1"

popd

if "%BUILD_FAILED%"=="1" (
    echo [ERROR] CMake failed
    pause
    exit /b 1
)

copy /Y "%NCCL_DLL%" "%BUILD_DIR%\bin\"

echo [SUCCESS] Build finished successfully!
exit /b 0
