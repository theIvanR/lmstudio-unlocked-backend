@echo off
setlocal enabledelayedexpansion

rem ==========================================
rem Fetch or update the latest llama.cpp from GitHub
rem ==========================================

rem Set target directory
set "TARGET_DIR=C:\Users\Admin\source\llama.cpp"

rem Ensure target directory exists
if not exist "%TARGET_DIR%" (
    echo [INFO] Directory "%TARGET_DIR%" does not exist. Creating...
    mkdir "%TARGET_DIR%"
)

rem Navigate to target directory
pushd "%TARGET_DIR%" >nul 2>&1 || (
    echo [ERROR] Failed to enter "%TARGET_DIR%".
    exit /b 1
)

rem Update existing repository or clone if missing
if exist ".git" (
    echo [INFO] Git repository detected. Pulling latest changes...
    git reset --hard >nul 2>&1
    git clean -fd >nul 2>&1
    git pull origin main
    if errorlevel 1 (
        echo [ERROR] Failed to update repository.
        popd
        exit /b 1
    )
) else (
    echo [INFO] No Git repository found. Cloning llama.cpp...
    rem Go up to parent directory to safely clone
    pushd .. >nul
    git clone https://github.com/ggerganov/llama.cpp.git "%TARGET_DIR%"
    if errorlevel 1 (
        echo [ERROR] Failed to clone repository.
        popd
        exit /b 1
    )
    popd
)

echo [SUCCESS] Latest llama.cpp fetched/updated successfully.
popd
pause
