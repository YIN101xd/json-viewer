@echo off
chcp 65001 > nul

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║         📊 JSON Viewer - FastAPI 服务器启动              ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

REM 检查 Python
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误: 未找到 Python
    echo 请先安装 Python 3.7 或更高版本
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✓ Python 版本: %PYTHON_VERSION%
echo.

REM 检查虚拟环境
if not exist "venv" (
    echo 📦 创建虚拟环境...
    python -m venv venv
    echo ✓ 虚拟环境创建完成
    echo.
)

REM 激活虚拟环境
echo 🔧 激活虚拟环境...
call venv\Scripts\activate.bat

REM 安装依赖
echo 📥 安装依赖包...
pip install -q --upgrade pip
pip install -q -r requirements.txt
echo ✓ 依赖安装完成
echo.

REM 启动服务器
echo 🚀 启动 FastAPI 服务器...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

python app.py
