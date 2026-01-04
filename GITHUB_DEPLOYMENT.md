# 🚀 GitHub Pages 部署指南

## 📝 部署步骤

### 1. 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `json-viewer` （或其他名字）
   - **Description**: `智能 JSON 评分查看器`
   - **Public** (公开) 或 **Private** (私有，需要 GitHub Pro)
3. **不要**勾选 "Add a README file"
4. 点击 "Create repository"

### 2. 上传代码到 GitHub

在项目目录下执行：

```bash
# 初始化 git（如果还没初始化）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: JSON Viewer"

# 添加远程仓库（替换成你的 GitHub 用户名和仓库名）
git remote add origin https://github.com/你的用户名/json-viewer.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

### 3. 启用 GitHub Pages

1. 进入你的仓库页面
2. 点击 **Settings** (设置)
3. 在左侧菜单找到 **Pages**
4. 在 **Source** 下：
   - Branch: 选择 `main`
   - Folder: 选择 `/ (root)`
5. 点击 **Save**

### 4. 等待部署完成

- GitHub 会自动部署，通常需要 1-2 分钟
- 部署完成后会显示你的网站地址
- 地址格式：`https://你的用户名.github.io/json-viewer/`

### 5. 访问你的应用

直接访问：
```
https://你的用户名.github.io/json-viewer/
```

或者带 index.html:
```
https://你的用户名.github.io/json-viewer/index.html
```

直接使用查看器:
```
https://你的用户名.github.io/json-viewer/json_viewer_standalone.html
```

---

## 🎯 快速命令（复制粘贴版）

### 如果你还没有 GitHub 账号

1. 访问 https://github.com/signup 注册

### 一键部署脚本

创建一个 `deploy.sh` 文件：

```bash
#!/bin/bash

echo "🚀 开始部署到 GitHub Pages..."

# 检查 git
if ! command -v git &> /dev/null; then
    echo "❌ 错误: 未找到 git"
    echo "请先安装 Git: https://git-scm.com/"
    exit 1
fi

# 获取 GitHub 用户名和仓库名
read -p "请输入你的 GitHub 用户名: " username
read -p "请输入仓库名 (如 json-viewer): " reponame

# 初始化 git
if [ ! -d ".git" ]; then
    git init
    echo "✓ Git 仓库初始化完成"
fi

# 添加文件
git add .
echo "✓ 文件添加完成"

# 提交
git commit -m "Deploy to GitHub Pages"
echo "✓ 提交完成"

# 添加远程仓库
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$username/$reponame.git"
echo "✓ 远程仓库添加完成"

# 推送
git branch -M main
git push -u origin main

echo ""
echo "✅ 部署完成！"
echo ""
echo "📍 请按照以下步骤启用 GitHub Pages："
echo "1. 访问 https://github.com/$username/$reponame/settings/pages"
echo "2. 在 Source 下选择 main 分支和 / (root) 文件夹"
echo "3. 点击 Save"
echo ""
echo "🌐 部署后的访问地址："
echo "https://$username.github.io/$reponame/"
echo ""
```

使用方法：
```bash
chmod +x deploy.sh
./deploy.sh
```

---

## 🔧 更新网站内容

以后想更新网站时：

```bash
# 修改文件后

# 添加更改
git add .

# 提交更改
git commit -m "描述你的更改"

# 推送到 GitHub
git push

# GitHub Pages 会自动重新部署（1-2分钟）
```

---

## 📱 自定义域名（可选）

如果你有自己的域名：

### 1. 添加 CNAME 文件

在项目根目录创建 `CNAME` 文件：
```
your-domain.com
```

### 2. 配置 DNS

在你的域名服务商（如阿里云、腾讯云）添加以下 DNS 记录：

**方式 A: 使用 A 记录（推荐）**
```
类型: A
主机记录: @
记录值: 185.199.108.153
记录值: 185.199.109.153
记录值: 185.199.110.153
记录值: 185.199.111.153
```

**方式 B: 使用 CNAME 记录**
```
类型: CNAME
主机记录: www
记录值: 你的用户名.github.io
```

### 3. 在 GitHub 设置

1. 进入 Settings → Pages
2. 在 Custom domain 输入你的域名
3. 勾选 "Enforce HTTPS"
4. 保存

等待 DNS 生效（可能需要几小时），然后就可以通过你的域名访问了！

---

## 🎨 优化建议

### 添加网站图标 (favicon)

在项目根目录添加 `favicon.ico` 文件，然后在 `index.html` 和 `json_viewer_standalone.html` 的 `<head>` 中添加：

```html
<link rel="icon" type="image/x-icon" href="favicon.ico">
```

### SEO 优化

在 `index.html` 的 `<head>` 中已经包含了基本的 SEO 标签：
- `<meta name="description">`
- `<meta name="keywords">`

你可以进一步添加：

```html
<!-- Open Graph (社交媒体分享) -->
<meta property="og:title" content="JSON Viewer - 智能评分查看器">
<meta property="og:description" content="功能强大的 JSON 评分查看器">
<meta property="og:image" content="https://你的域名/preview.png">
<meta property="og:url" content="https://你的域名">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="JSON Viewer">
<meta name="twitter:description" content="智能 JSON 评分查看器">
<meta name="twitter:image" content="https://你的域名/preview.png">
```

### 添加 Google Analytics（可选）

如果想统计访问量，可以添加 Google Analytics：

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

---

## 🐛 常见问题

### Q: 推送失败，提示 "Permission denied"
A: 需要配置 GitHub 认证：
```bash
# 方式 1: 使用 GitHub CLI
brew install gh  # Mac
gh auth login

# 方式 2: 使用 SSH
ssh-keygen -t rsa -b 4096
# 将 ~/.ssh/id_rsa.pub 内容添加到 GitHub Settings → SSH keys

# 方式 3: 使用 Personal Access Token
# 访问 GitHub Settings → Developer settings → Personal access tokens
# 生成 token，推送时使用 token 作为密码
```

### Q: GitHub Pages 显示 404
A: 检查：
1. 确认已在 Settings → Pages 中启用
2. 确认选择了正确的分支和文件夹
3. 等待 1-2 分钟让部署完成
4. 访问 `https://你的用户名.github.io/仓库名/`（注意仓库名）

### Q: 更新代码后网站没变化
A:
1. 等待 1-2 分钟
2. 清除浏览器缓存（Ctrl+Shift+R 或 Cmd+Shift+R）
3. 检查 Actions 标签页查看部署状态

### Q: 想让主页直接是查看器，不要欢迎页
A: 删除或重命名 `index.html`，将 `json_viewer_standalone.html` 重命名为 `index.html`

---

## 📊 部署后的功能

部署完成后，用户可以：

1. **直接访问网站**
   - 无需下载任何文件
   - 在浏览器中直接使用

2. **拖拽上传 JSON**
   - 支持单个文件
   - 支持批量文件
   - 支持文件夹（整个文件夹拖进去）

3. **分享给他人**
   - 发送网址即可
   - 对方无需安装任何东西
   - 手机、平板、电脑都能用

4. **书签收藏**
   - 用户可以把网址加入书签
   - 随时访问使用

---

## 🎉 完成！

部署完成后，你的 JSON Viewer 就可以像小程序一样使用了！

访问地址示例：
- 主页: `https://yourusername.github.io/json-viewer/`
- 直接使用: `https://yourusername.github.io/json-viewer/json_viewer_standalone.html`

分享给别人时，直接发送这个网址即可！
