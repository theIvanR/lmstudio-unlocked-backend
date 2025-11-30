@echo off
setlocal

rem -------------------------
rem User configuration
rem -------------------------
cd /d C:\Users\Admin\source\llama.cpp

set BUILD_DIR=build_cpu
set AVX=ON
set AVX2=OFF
set AVX512=OFF
set CORES=%NUMBER_OF_PROCESSORS%

rem -------------------------
rem Ensure MSVC is available
cl >nul 2>&1
if errorlevel 1 (
    echo ERROR: cl.exe not found on PATH.
    echo Please run this script from "x64 Native Tools Command Prompt for VS".
    pause
    exit /b 1
)

echo.
echo Building %BUILD_DIR% (AVX=%AVX% AVX2=%AVX2% AVX512=%AVX512%) using %CORES% threads
echo.

rem -------------------------
rem Remove old build directory
rmdir /s /q "%BUILD_DIR%"

rem -------------------------
rem Select proper /arch flag
set "ARCH_FLAG="
if /I "%AVX512%"=="ON" ( set "ARCH_FLAG=/arch:AVX512") 
	else if /I "%AVX2%"=="ON" (set "ARCH_FLAG=/arch:AVX2") 
	else if /I "%AVX%"=="ON" ( set "ARCH_FLAG=/arch:AVX" 
)

echo Using ARCH_FLAG=%ARCH_FLAG%
echo.

rem -------------------------
rem Set optimization and linker flags
set "OPT_FLAGS=%ARCH_FLAG% /O2 /Ot /fp:fast /GL /DNDEBUG"
set "LINK_FLAGS=/LTCG"

rem -------------------------
rem Configure CMake
echo Configuring CMake...
cmake -S . -B "%BUILD_DIR%" -G Ninja -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_C_FLAGS_RELEASE="%OPT_FLAGS%" ^
    -DCMAKE_CXX_FLAGS_RELEASE="%OPT_FLAGS%" ^
    -DCMAKE_EXE_LINKER_FLAGS_RELEASE="%LINK_FLAGS%" ^
    -DGGML_AVX=%AVX% -DGGML_AVX2=%AVX2% -DGGML_AVX512=%AVX512%

if errorlevel 1 (
    echo Configure failed. Exiting.
    pause
    exit /b 1
)

rem -------------------------
rem Build project
echo.
echo Building project (verbose)...
cmake --build "%BUILD_DIR%" -- -j %CORES% --verbose
if errorlevel 1 (
    echo Build failed. Exiting.
    pause
    exit /b 1
)

rem -------------------------
rem List resulting executables
echo.
echo Build finished successfully!
echo Executables found:
dir /s "%BUILD_DIR%\*.exe"

exit /b 0
