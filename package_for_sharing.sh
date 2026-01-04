#!/bin/bash

# JSON Viewer 打包脚本
# 用于创建可分享的压缩包

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║         📦 JSON Viewer - 打包工具                         ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 检查文件是否存在
if [ ! -f "json_viewer_standalone.html" ]; then
    echo "❌ 错误: 未找到 json_viewer_standalone.html"
    exit 1
fi

# 创建打包目录
PACKAGE_DIR="JSON_Viewer_Package"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PACKAGE_NAME="JSON_Viewer_${TIMESTAMP}"

echo "📁 创建打包目录..."
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"

# 复制文件
echo "📋 复制文件..."
cp json_viewer_standalone.html "$PACKAGE_DIR/"
cp STANDALONE_README.md "$PACKAGE_DIR/使用说明.md"

# 创建快速开始指南
cat > "$PACKAGE_DIR/快速开始.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║            📊 JSON Viewer - 快速开始                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

🚀 三步开始使用：

1️⃣  双击打开 json_viewer_standalone.html

2️⃣  拖拽JSON文件或文件夹到页面

3️⃣  查看美化后的数据！

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 主要特点：

  • 无需安装任何软件
  • 纯前端，数据不上传
  • 支持拖拽文件和文件夹
  • 自动智能映射字段
  • 美观的界面展示

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📖 详细说明请查看"使用说明.md"

🌐 浏览器支持：Chrome、Firefox、Safari、Edge

🔒 隐私安全：所有数据本地处理，绝不上传

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

有问题？参考常见问题：

Q: 数据会上传吗？
A: 不会！完全在本地浏览器中处理。

Q: 需要安装什么吗？
A: 不需要！只要有浏览器就能用。

Q: 可以处理多个文件吗？
A: 可以！支持批量上传和文件夹拖拽。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 JSON Viewer v2.0
🎉 祝使用愉快！
EOF

# 创建示例JSON文件（如果需要）
cat > "$PACKAGE_DIR/示例_sample.json" << 'EOF'
{
  "uid": "demo_001",
  "case_id": "example_case",
  "type": "示例",
  "category": "演示数据",
  "domain": {
    "level1": "技术",
    "level2": "数据分析",
    "level3": null
  },
  "scene": {
    "level1": "数据处理",
    "level2": "JSON解析",
    "level3": "可视化展示"
  },
  "prompt": "这是一个示例JSON文件，展示JSON Viewer的功能。您可以上传自己的JSON文件来查看效果。",
  "example_answer_reference": "JSON Viewer可以自动识别和美化显示JSON数据结构，支持元数据、内容、评估标准等多种字段类型的智能映射。",
  "rubrics": [
    {
      "rubric_number": 1,
      "rubric_tag": "功能",
      "rubric_tag_level_2": "展示",
      "rubric_weight": 10,
      "rubric_detail": "能够清晰展示JSON数据结构",
      "rubric_human_score_model1": 1,
      "rubric_human_score_reason_model1": "展示效果优秀",
      "rubric_human_score_model2": 1,
      "rubric_human_score_reason_model2": "功能完整"
    },
    {
      "rubric_number": 2,
      "rubric_tag": "易用性",
      "rubric_tag_level_2": "操作",
      "rubric_weight": 8,
      "rubric_detail": "操作简单，无需安装",
      "rubric_human_score_model1": 1,
      "rubric_human_score_reason_model1": "一键启动",
      "rubric_human_score_model2": 1,
      "rubric_human_score_reason_model2": "界面友好"
    },
    {
      "rubric_number": 3,
      "rubric_tag": "性能",
      "rubric_tag_level_2": "速度",
      "rubric_weight": 7,
      "rubric_detail": "加载和渲染速度",
      "rubric_human_score_model1": 1,
      "rubric_human_score_reason_model1": "响应迅速",
      "rubric_human_score_model2": 0,
      "rubric_human_score_reason_model2": "大文件略慢"
    }
  ]
}
EOF

# 统计文件信息
FILE_SIZE=$(du -sh "$PACKAGE_DIR" | cut -f1)
FILE_COUNT=$(find "$PACKAGE_DIR" -type f | wc -l | tr -d ' ')

echo ""
echo "✅ 打包完成！"
echo ""
echo "📊 包内容："
echo "  • json_viewer_standalone.html - 主程序（双击打开）"
echo "  • 使用说明.md - 详细使用文档"
echo "  • 快速开始.txt - 快速上手指南"
echo "  • 示例_sample.json - 示例数据文件"
echo ""
echo "📦 统计信息："
echo "  • 文件数量: $FILE_COUNT"
echo "  • 总大小: $FILE_SIZE"
echo ""

# 询问是否创建压缩包
read -p "是否创建ZIP压缩包？(y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 正在创建压缩包..."

    # 检查zip命令
    if command -v zip &> /dev/null; then
        ZIP_FILE="${PACKAGE_NAME}.zip"
        cd "$PACKAGE_DIR" && zip -r "../$ZIP_FILE" . && cd ..
        ZIP_SIZE=$(du -sh "$ZIP_FILE" | cut -f1)

        echo ""
        echo "✅ 压缩包创建成功！"
        echo "📦 文件名: $ZIP_FILE"
        echo "📊 大小: $ZIP_SIZE"
        echo ""
        echo "💡 可以直接将此压缩包发送给他人"
    else
        echo "⚠️  未找到 zip 命令"
        echo "💡 请手动压缩 $PACKAGE_DIR 文件夹"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📁 打包目录: $PACKAGE_DIR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎉 完成！现在可以："
echo ""
echo "  1. 进入 $PACKAGE_DIR 目录"
echo "  2. 双击 json_viewer_standalone.html 测试"
echo "  3. 将整个文件夹或ZIP文件发送给他人"
echo ""
echo "💡 接收者只需双击 json_viewer_standalone.html 即可使用！"
echo ""
