@echo off
setlocal

REM Call your visual studio cmd here (or other version)
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=14.29

REM =========================
REM User configuration (optionally pass llama dir as first argument
REM =========================
set "DEFAULT_SRC_DIR=%USERPROFILE%\source\llama.cpp"

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
set "CLEAN_BUILD=1"
set "BUILD_DIR=build_gpu_cuda"
set "CL=/bigobj %CL% /Ot /fp:fast"


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


REM -------------------------
REM Configure with CMake
REM -------------------------
echo [INFO] Building in "%BUILD_DIR%"

cmake -S . -B "%BUILD_DIR%" ^
      -G "Ninja" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DGGML_VULKAN=ON ^
      -DLLAMA_CURL=OFF ^
      -DGGML_NATIVE=ON

REM remove release to build *everything* and not just core
cmake --build "%BUILD_DIR%" --verbose

if errorlevel 1 (
    echo [ERROR] CMake failed
    popd
    pause
    exit /b 1
)

echo [SUCCESS] Build finished successfully!
popd
exit /b 0
