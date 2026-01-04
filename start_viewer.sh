#!/bin/bash

# JSON Viewer 快速启动脚本

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║         📊 JSON Viewer - 智能JSON查看器                   ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 检查Python版本
if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到 python3"
    echo "请先安装 Python 3.7 或更高版本"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "✓ Python 版本: $PYTHON_VERSION"
echo ""

# 检查data目录
if [ ! -d "./data" ]; then
    echo "⚠️  警告: 未找到 ./data 目录"
    echo "创建示例目录..."
    mkdir -p ./data/sample
    echo "请将JSON文件放入 ./data 目录"
    echo ""
fi

# 统计JSON文件数量
JSON_COUNT=$(find ./data -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
echo "📁 找到 $JSON_COUNT 个JSON文件"
echo ""

# 运行查看器
echo "🚀 启动 JSON Viewer..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

python3 json_viewer.py

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👋 JSON Viewer 已关闭"
echo ""
