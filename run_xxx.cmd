@echo off
:: 检查是否以管理员权限运行
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as an administrator.
    :: 使用runas动词启动一个新的命令行窗口
    powershell -Command "Start-Process cmd -ArgumentList '/c %0 %*' -Verb RunAs"
    exit /b
)

:: 脚本主体
echo Running with admin privileges...
pause