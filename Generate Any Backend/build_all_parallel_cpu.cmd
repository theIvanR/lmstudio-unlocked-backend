@echo off
setlocal enabledelayedexpansion

cd /d C:\Users\Admin\source\llama.cpp

rem -------------------------
rem Define all 8 permutations
rem Format: BuildDir AVX AVX2 AVX512
rem -------------------------
set builds0=build_noavx OFF OFF OFF
set builds1=build_avx1 ON OFF OFF
set builds2=build_avx2 ON ON OFF
set builds3=build_avx512 ON ON ON
set builds4=build_avx1_512 ON OFF ON
set builds5=build_avx2_only OFF ON OFF
set builds6=build_avx2_512 OFF ON ON
set builds7=build_avx512_only OFF OFF ON

rem Number of CPU cores for parallel build
set /a CORES=%NUMBER_OF_PROCESSORS%

rem -------------------------
rem Loop over all builds and launch each in a new window
rem -------------------------
for /L %%i in (0,1,7) do (
    rem Dynamically get the permutation line
    set "line=!builds%%i!"
    for /f "tokens=1,2,3,4" %%a in ("!line!") do (
        echo Starting build %%a with AVX=%%b AVX2=%%c AVX512=%%d
        rem Delete any leftover build directory
        rmdir /s /q %%a
        rem Launch build in a new window
        start "" cmd /c "cmake -S . -B %%a -G Ninja -DCMAKE_BUILD_TYPE=Release -DGGML_AVX=%%b -DGGML_AVX2=%%c -DGGML_AVX512=%%d && cmake --build %%a -- -j %CORES%"
    )
)

echo All CPU builds started. Each will run in its own window.
pause
