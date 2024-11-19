@echo off
:: obtain privilege
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo switch to privilege mode...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~f0 %*' -Verb RunAs"
    exit /b
)

:: change to correct dir
set "scriptdir=%~dp0"

cd /d "%scriptdir%"

python dot_manager.py

pause