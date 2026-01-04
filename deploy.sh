#!/bin/bash

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║      🚀 JSON Viewer - GitHub Pages 部署助手              ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 检查 git
if ! command -v git &> /dev/null; then
    echo "❌ 错误: 未找到 git"
    echo "请先安装 Git: https://git-scm.com/"
    exit 1
fi

echo "✓ Git 已安装"
echo ""

# 获取 GitHub 信息
echo "📝 请输入你的 GitHub 信息："
echo ""
read -p "GitHub 用户名: " username
read -p "仓库名称 (建议: json-viewer): " reponame

if [ -z "$username" ] || [ -z "$reponame" ]; then
    echo "❌ 错误: 用户名和仓库名不能为空"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 开始部署..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 初始化 git
if [ ! -d ".git" ]; then
    git init
    echo "✓ Git 仓库初始化完成"
else
    echo "✓ Git 仓库已存在"
fi

# 更新 index.html 中的 GitHub 链接
if [ -f "index.html" ]; then
    sed -i.bak "s|https://github.com/yourusername/json-viewer|https://github.com/$username/$reponame|g" index.html
    rm -f index.html.bak
    echo "✓ 更新了 index.html 中的 GitHub 链接"
fi

# 添加所有文件
git add .
echo "✓ 文件添加完成"

# 检查是否有更改
if git diff --staged --quiet; then
    echo "ℹ️  没有新的更改需要提交"
else
    # 提交
    git commit -m "Deploy JSON Viewer to GitHub Pages"
    echo "✓ 提交完成"
fi

# 添加远程仓库
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$username/$reponame.git"
echo "✓ 远程仓库配置完成"

# 推送
echo ""
echo "📤 正在推送到 GitHub..."
git branch -M main
git push -u origin main --force

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ 代码已成功推送到 GitHub！"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📍 接下来请按照以下步骤启用 GitHub Pages："
    echo ""
    echo "1. 访问你的仓库设置页面："
    echo "   https://github.com/$username/$reponame/settings/pages"
    echo ""
    echo "2. 在 'Source' 下："
    echo "   - Branch: 选择 'main'"
    echo "   - Folder: 选择 '/ (root)'"
    echo "   - 点击 'Save'"
    echo ""
    echo "3. 等待 1-2 分钟，GitHub 会自动部署"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🌐 部署完成后，你的网站地址将是："
    echo ""
    echo "   主页: https://$username.github.io/$reponame/"
    echo "   查看器: https://$username.github.io/$reponame/json_viewer_standalone.html"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 提示："
    echo "   - 分享网址给其他人，他们就可以直接使用了"
    echo "   - 更新代码后，再次运行此脚本即可重新部署"
    echo ""
else
    echo ""
    echo "❌ 推送失败！"
    echo ""
    echo "可能的原因："
    echo "1. GitHub 仓库不存在 - 请先在 GitHub 创建仓库"
    echo "2. 权限问题 - 请配置 Git 认证"
    echo ""
    echo "详细步骤请查看 GITHUB_DEPLOYMENT.md 文档"
    exit 1
fi
