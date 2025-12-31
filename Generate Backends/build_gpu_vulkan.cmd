@echo off
setlocal

REM =========================
REM User configuration (optionally pass llama dir as first argument
REM =========================
set "DEFAULT_SRC_DIR=C:\Users\Admin\source\llama.cpp"

if "%~1"=="" (
    set "SRC_DIR=%DEFAULT_SRC_DIR%"
) else (
    set "SRC_DIR=%~1"
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
REM Set Flags and Clean up
REM -------------------------
set "BUILD_DIR=build_gpu_vulkan"
set "CL=/bigobj %CL% /Ot /fp:fast"


if exist "%BUILD_DIR%" (
    echo [INFO] Removing old build directory "%BUILD_DIR%"...
    
	rmdir /s /q "%BUILD_DIR%"
    
	if errorlevel 1 (
		echo [ERROR] Failed to Remove Dir
		popd
		pause
		exit /b 1
	)
)


REM -------------------------
REM Configure with CMake
REM -------------------------
echo [INFO] Building in "%BUILD_DIR%"

cmake -S . -B "%BUILD_DIR%" ^
      -G "Ninja" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DGGML_AVX=ON ^
      -DGGML_AVX2=OFF ^
      -DGGML_AVX512=OFF ^
      -DGGML_VULKAN=ON

REM remove release to build *everything* and not just core
cmake --build "%BUILD_DIR%" --config Release --verbose

if errorlevel 1 (
    echo [ERROR] CMake failed
    popd
    pause
    exit /b 1
)

echo [SUCCESS] Build finished successfully!
popd
exit /b 0
