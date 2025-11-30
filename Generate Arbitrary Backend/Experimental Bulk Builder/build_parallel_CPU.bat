@echo off
setlocal enabledelayedexpansion

rem -------------------------
rem Basic paths & config
rem -------------------------
cd /d C:\Users\Admin\source\llama.cpp

rem Define all 8 permutations (BuildDir AVX AVX2 AVX512)
set builds0=build_noavx OFF OFF OFF
set builds1=build_avx1 ON OFF OFF
set builds2=build_avx2 ON ON OFF
set builds3=build_avx512 ON ON ON
set builds4=build_avx1_512 ON OFF ON
set builds5=build_avx2_only OFF ON OFF
set builds6=build_avx2_512 OFF ON ON
set builds7=build_avx512_only OFF OFF ON

set /a CORES=%NUMBER_OF_PROCESSORS%

rem -------------------------
rem Verify MSVC available
rem -------------------------
cl >nul 2>&1
if errorlevel 1 (
    echo ERROR: cl.exe (MSVC) not found on PATH.
    echo Please run this script from "x64 Native Tools Command Prompt for VS".
    pause
    exit /b 1
)

echo Running bulk builds using %CORES% threads each.
echo Per-build logs and helper scripts will be created in %TEMP%.
echo.

rem -------------------------
rem Loop through permutations
rem -------------------------
for /L %%i in (0,1,7) do (
    set "line=!builds%%i!"
    for /f "tokens=1,2,3,4" %%a in ("!line!") do (

        rem Set per-build variables
        set "BUILD_DIR=%%a"
        set "AVX=%%b"
        set "AVX2=%%c"
        set "AVX512=%%d"

        echo Preparing build: !BUILD_DIR! (AVX=!AVX! AVX2=!AVX2! AVX512=!AVX512!)

        rem Remove any stale build dir
        rmdir /s /q "!BUILD_DIR!" 2>nul

        rem Select /arch flag
        set "ARCH_FLAG="
        if /I "!AVX512!"=="ON" (
            set "ARCH_FLAG=/arch:AVX512"
        ) else if /I "!AVX2!"=="ON" (
            set "ARCH_FLAG=/arch:AVX2"
        ) else if /I "!AVX!"=="ON" (
            set "ARCH_FLAG=/arch:AVX"
        )

        rem Optimization and linker flags (same aggressive flags as single-build script)
        set "OPT_FLAGS=!ARCH_FLAG! /O2 /Ot /fp:fast /GL /DNDEBUG"
        set "LINK_FLAGS=/LTCG"

        rem Create a per-build helper batch in %TEMP% to avoid quoting issues with start
        set "TMPBAT=%TEMP%\llama_build_!BUILD_DIR!.bat"
        (
            echo @echo off
            echo cd /d C:\Users\Admin\source\llama.cpp
            echo echo.
            echo echo Configuring build: !BUILD_DIR! ^(AVX=!AVX! AVX2=!AVX2! AVX512=!AVX512!^)
            echo cmake -S . -B "!BUILD_DIR!" -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS_RELEASE="!OPT_FLAGS!" -DCMAKE_CXX_FLAGS_RELEASE="!OPT_FLAGS!" -DCMAKE_EXE_LINKER_FLAGS_RELEASE="!LINK_FLAGS!" -DGGML_AVX=!AVX! -DGGML_AVX2=!AVX2! -DGGML_AVX512=!AVX512!
            echo if errorlevel 1 ( echo Configure failed. & pause & exit /b 1 )
            echo echo Starting build (verbose)...
            echo cmake --build "!BUILD_DIR!" -- -j %CORES% --verbose
            echo if errorlevel 1 ( echo Build failed. & pause & exit /b 1 )
            echo echo.
            echo echo Build complete for !BUILD_DIR! - listing executables...
            echo dir /s "!BUILD_DIR!\*.exe"
            echo echo.
            echo echo Done.
            echo pause
        ) > "!TMPBAT!"

        rem Start the per-build batch in a new window so builds run concurrently and logs are visible.
        start "" "%TMPBAT%"
        rem small sleep could be inserted if windows spawn races are a concern:
        rem ping -n 1 -w 200 127.0.0.1 >nul

    )
)

echo All builds launched. Watch the separate windows for configure/build output.
echo Per-build helper scripts are in %TEMP% (named llama_build_<builddir>.bat).
pause
