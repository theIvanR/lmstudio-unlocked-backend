@echo off
rem ==========================================
rem Pull latest llama.cpp from GitHub
rem ==========================================

rem Set target directory
set TARGET_DIR=C:\Users\Admin\source\llama.cpp

rem Check if directory exists
if not exist "%TARGET_DIR%" (
    echo Directory does not exist, creating it...
    mkdir "%TARGET_DIR%"
)

rem Go to the target directory
cd /d "%TARGET_DIR%"

rem Check if git repo already exists
if exist ".git" (
    echo Git repository found. Pulling latest changes...
    git reset --hard
    git clean -fd
    git pull origin main
) else (
    echo No git repository found. Cloning llama.cpp...
    git clone https://github.com/ggerganov/llama.cpp.git "%TARGET_DIR%"
)

echo Done fetching latest llama.cpp
pause
