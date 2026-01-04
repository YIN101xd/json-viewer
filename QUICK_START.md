# 🚀 快速部署到 GitHub Pages

## 📝 超简单 3 步部署

### 第 1 步：创建 GitHub 仓库

1. 打开 https://github.com/new
2. 填写：
   - **Repository name**: `json-viewer`
   - 勾选 **Public**
3. 点击 **Create repository**

### 第 2 步：运行部署脚本

**Mac/Linux 用户：**
```bash
cd /Users/101_y/Desktop/JSON_Viewer_Project
bash deploy.sh
```

**Windows 用户：**
```bash
双击运行 deploy.bat
```

按提示输入：
- 你的 GitHub 用户名
- 仓库名（刚才创建的，如：json-viewer）

### 第 3 步：启用 GitHub Pages

1. 脚本执行完后，会给你一个设置页面链接
2. 点击链接（或手动访问）：`https://github.com/你的用户名/json-viewer/settings/pages`
3. 在 **Source** 下：
   - **Branch**: 选择 `main`
   - **Folder**: 选择 `/ (root)`
4. 点击 **Save**

### ✅ 完成！

等待 1-2 分钟，访问：
```
https://你的用户名.github.io/json-viewer/
```

---

## 🎯 如果遇到问题

### 问题 1: 推送失败，提示需要登录

**解决方法 A - 使用 GitHub CLI（最简单）：**
```bash
# Mac 安装
brew install gh

# Windows: 访问 https://cli.github.com 下载安装

# 登录
gh auth login
# 按提示选择：GitHub.com → HTTPS → Yes → Login with browser

# 然后重新运行 deploy.sh
bash deploy.sh
```

**解决方法 B - 使用 Personal Access Token：**
1. 访问 https://github.com/settings/tokens
2. 点击 **Generate new token** → **Generate new token (classic)**
3. 勾选 **repo** 权限
4. 生成 token（复制保存）
5. 推送时，用户名输入你的 GitHub 用户名，密码输入 token

### 问题 2: 网站显示 404

等待 1-2 分钟，清除浏览器缓存（Ctrl+Shift+R）

### 问题 3: 没有 git

**Mac:**
```bash
brew install git
```

**Windows:**
访问 https://git-scm.com/download/win 下载安装

---

## 📱 分享给别人

部署完成后，直接发送网址：
```
https://你的用户名.github.io/json-viewer/json_viewer_standalone.html
```

对方在浏览器打开，拖拽 JSON 文件即可使用！

---

## 🔄 更新网站

修改代码后，再次运行：
```bash
bash deploy.sh  # Mac/Linux
# 或双击 deploy.bat  # Windows
```

---

## 💡 更多帮助

- 详细部署文档: `GITHUB_DEPLOYMENT.md`
- 使用说明: `README.md`
- 部署选项: `DEPLOYMENT.md`
