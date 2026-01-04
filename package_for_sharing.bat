@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║         📦 JSON Viewer - 打包工具 (Windows)               ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

REM 检查文件是否存在
if not exist "json_viewer_standalone.html" (
    echo ❌ 错误: 未找到 json_viewer_standalone.html
    pause
    exit /b 1
)

REM 创建打包目录
set PACKAGE_DIR=JSON_Viewer_Package
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set PACKAGE_NAME=JSON_Viewer_%TIMESTAMP%

echo 📁 创建打包目录...
if exist "%PACKAGE_DIR%" rmdir /s /q "%PACKAGE_DIR%"
mkdir "%PACKAGE_DIR%"

REM 复制文件
echo 📋 复制文件...
copy /y json_viewer_standalone.html "%PACKAGE_DIR%\" >nul
copy /y STANDALONE_README.md "%PACKAGE_DIR%\使用说明.md" >nul

REM 创建快速开始指南
(
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║            📊 JSON Viewer - 快速开始                      ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo 🚀 三步开始使用：
echo.
echo 1️⃣  双击打开 json_viewer_standalone.html
echo.
echo 2️⃣  拖拽JSON文件或文件夹到页面
echo.
echo 3️⃣  查看美化后的数据！
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo ✨ 主要特点：
echo.
echo   • 无需安装任何软件
echo   • 纯前端，数据不上传
echo   • 支持拖拽文件和文件夹
echo   • 自动智能映射字段
echo   • 美观的界面展示
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📖 详细说明请查看"使用说明.md"
echo.
echo 🌐 浏览器支持：Chrome、Firefox、Safari、Edge
echo.
echo 🔒 隐私安全：所有数据本地处理，绝不上传
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📊 JSON Viewer v2.0
echo 🎉 祝使用愉快！
) > "%PACKAGE_DIR%\快速开始.txt"

REM 创建示例JSON文件
(
echo {
echo   "uid": "demo_001",
echo   "case_id": "example_case",
echo   "type": "示例",
echo   "category": "演示数据",
echo   "domain": {
echo     "level1": "技术",
echo     "level2": "数据分析"
echo   },
echo   "prompt": "这是一个示例JSON文件，展示JSON Viewer的功能。",
echo   "rubrics": [
echo     {
echo       "rubric_number": 1,
echo       "rubric_tag": "功能",
echo       "rubric_weight": 10,
echo       "rubric_detail": "能够清晰展示JSON数据结构",
echo       "rubric_human_score_model1": 1,
echo       "rubric_human_score_model2": 1
echo     }
echo   ]
echo }
) > "%PACKAGE_DIR%\示例_sample.json"

echo.
echo ✅ 打包完成！
echo.
echo 📊 包内容：
echo   • json_viewer_standalone.html - 主程序（双击打开）
echo   • 使用说明.md - 详细使用文档
echo   • 快速开始.txt - 快速上手指南
echo   • 示例_sample.json - 示例数据文件
echo.

REM 询问是否创建压缩包
set /p "CREATE_ZIP=是否创建ZIP压缩包？(y/n): "

if /i "%CREATE_ZIP%"=="y" (
    echo.
    echo 📦 正在创建压缩包...

    REM 使用PowerShell创建ZIP
    powershell -command "Compress-Archive -Path '%PACKAGE_DIR%\*' -DestinationPath '%PACKAGE_NAME%.zip' -Force"

    if exist "%PACKAGE_NAME%.zip" (
        echo.
        echo ✅ 压缩包创建成功！
        echo 📦 文件名: %PACKAGE_NAME%.zip
        echo.
        echo 💡 可以直接将此压缩包发送给他人
    ) else (
        echo.
        echo ⚠️  压缩失败，请手动压缩 %PACKAGE_DIR% 文件夹
    )
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📁 打包目录: %PACKAGE_DIR%
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎉 完成！现在可以：
echo.
echo   1. 进入 %PACKAGE_DIR% 目录
echo   2. 双击 json_viewer_standalone.html 测试
echo   3. 将整个文件夹或ZIP文件发送给他人
echo.
echo 💡 接收者只需双击 json_viewer_standalone.html 即可使用！
echo.
pause
