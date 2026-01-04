# 📊 JSON Viewer 部署指南

## 🚀 快速开始

### 方法 1: 本地运行（推荐新手）

#### Windows 用户：
```bash
双击运行 start_server.bat
```

#### Mac/Linux 用户：
```bash
bash start_server.sh
```

服务器将自动启动在 `http://localhost:8000`

---

## 📦 部署选项

### 选项 A: FastAPI Web 服务（可多人使用）

适合：需要分享给团队使用，可以部署到服务器

#### 1. 本地开发环境运行

```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
# Mac/Linux:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt

# 启动服务器
python app.py
```

访问: `http://localhost:8000`

#### 2. 部署到云服务器

##### 部署到阿里云/腾讯云/AWS

```bash
# 1. 上传项目到服务器
scp -r JSON_Viewer_Project user@your-server:/path/to/app

# 2. SSH 登录服务器
ssh user@your-server

# 3. 进入项目目录
cd /path/to/app

# 4. 安装依赖
pip3 install -r requirements.txt

# 5. 使用 systemd 设置开机自启（推荐）
sudo nano /etc/systemd/system/json-viewer.service
```

systemd 配置文件内容：
```ini
[Unit]
Description=JSON Viewer Service
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/JSON_Viewer_Project
Environment="PATH=/usr/bin:/usr/local/bin"
ExecStart=/usr/bin/python3 /path/to/JSON_Viewer_Project/app.py
Restart=always

[Install]
WantedBy=multi-user.target
```

启动服务：
```bash
sudo systemctl daemon-reload
sudo systemctl enable json-viewer
sudo systemctl start json-viewer
sudo systemctl status json-viewer
```

##### 使用 Nginx 反向代理（可选，推荐）

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

##### 部署到 Vercel（免费）

1. 安装 Vercel CLI:
```bash
npm install -g vercel
```

2. 在项目根目录创建 `vercel.json`:
```json
{
  "builds": [
    {
      "src": "app.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "app.py"
    }
  ]
}
```

3. 部署:
```bash
vercel
```

##### 部署到 Railway（免费额度）

1. 访问 https://railway.app
2. 连接 GitHub 仓库
3. Railway 会自动检测 Python 项目并部署

##### 部署到 Render（免费额度）

1. 访问 https://render.com
2. 创建新的 Web Service
3. 连接 GitHub 仓库
4. 设置启动命令: `python app.py`

---

### 选项 B: 独立 HTML 文件（最简单）

适合：快速分享给个人使用

直接发送 `json_viewer_standalone.html` 文件给其他人，双击打开即可使用。

**优点：**
- ✅ 无需安装任何东西
- ✅ 数据完全本地处理，安全
- ✅ 离线可用

**缺点：**
- ❌ 每个人需要单独上传 JSON 文件
- ❌ 无法共享数据

---

### 选项 C: Docker 部署（推荐运维）

#### 1. 创建 Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "app.py"]
```

#### 2. 创建 docker-compose.yml

```yaml
version: '3.8'

services:
  json-viewer:
    build: .
    ports:
      - "8000:8000"
    restart: unless-stopped
    volumes:
      - ./data:/app/data
```

#### 3. 启动服务

```bash
# 构建镜像
docker-compose build

# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

---

## 🌐 访问配置

### 局域网访问

如果你想让同一局域网的其他人访问：

1. 修改 `app.py` 中的 host 设置已经是 `0.0.0.0`（默认配置）
2. 查看你的本机 IP:
   ```bash
   # Mac/Linux
   ifconfig | grep "inet "

   # Windows
   ipconfig
   ```
3. 其他人通过 `http://your-ip:8000` 访问

### 公网访问

#### 使用 ngrok（快速测试）

```bash
# 安装 ngrok
brew install ngrok  # Mac
# 或访问 https://ngrok.com 下载

# 启动 JSON Viewer
python app.py

# 在另一个终端启动 ngrok
ngrok http 8000
```

ngrok 会给你一个公网地址，如 `https://xxx.ngrok.io`

#### 使用 frp（内网穿透）

适合需要长期使用的场景，需要有一台公网服务器。

---

## 📱 打包成桌面应用

### 使用 Electron 打包（跨平台）

#### 1. 安装 Node.js

访问 https://nodejs.org 下载安装

#### 2. 创建 Electron 项目

在项目目录下创建以下文件：

**package.json:**
```json
{
  "name": "json-viewer",
  "version": "2.0.0",
  "description": "JSON 评分查看器",
  "main": "electron.js",
  "scripts": {
    "start": "electron .",
    "build": "electron-builder"
  },
  "build": {
    "appId": "com.jsonviewer.app",
    "productName": "JSON Viewer",
    "directories": {
      "output": "dist"
    },
    "files": [
      "electron.js",
      "json_viewer_standalone.html"
    ],
    "mac": {
      "category": "public.app-category.developer-tools",
      "icon": "icon.icns"
    },
    "win": {
      "icon": "icon.ico"
    }
  },
  "devDependencies": {
    "electron": "^28.0.0",
    "electron-builder": "^24.9.1"
  }
}
```

**electron.js:**
```javascript
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 1400,
    height: 900,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true
    }
  });

  win.loadFile('json_viewer_standalone.html');
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});
```

#### 3. 安装依赖并打包

```bash
# 安装依赖
npm install

# 开发模式运行
npm start

# 打包（会生成可执行文件）
npm run build
```

打包后的应用在 `dist/` 目录：
- Mac: `JSON Viewer.app`
- Windows: `JSON Viewer.exe`
- Linux: `json-viewer`

---

## 🔒 安全配置

### 添加密码保护

修改 `app.py` 添加简单的密码验证：

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBasic, HTTPBasicCredentials
import secrets

security = HTTPBasic()

def verify_credentials(credentials: HTTPBasicCredentials = Depends(security)):
    correct_username = secrets.compare_digest(credentials.username, "admin")
    correct_password = secrets.compare_digest(credentials.password, "your_password")

    if not (correct_username and correct_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="用户名或密码错误",
            headers={"WWW-Authenticate": "Basic"},
        )
    return credentials.username

@app.get("/", response_class=HTMLResponse)
async def root(username: str = Depends(verify_credentials)):
    return get_html_content()
```

### HTTPS 配置

使用 Let's Encrypt 免费证书：

```bash
# 安装 certbot
sudo apt-get install certbot

# 获取证书
sudo certbot certonly --standalone -d your-domain.com

# 修改 app.py 启动配置
uvicorn.run(
    "app:app",
    host="0.0.0.0",
    port=443,
    ssl_keyfile="/etc/letsencrypt/live/your-domain.com/privkey.pem",
    ssl_certfile="/etc/letsencrypt/live/your-domain.com/fullchain.pem"
)
```

---

## 📊 性能优化

### 处理大文件

如果 JSON 文件很大（>10MB），建议：

1. 增加上传限制：
```python
from fastapi import FastAPI
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    max_request_size=100 * 1024 * 1024  # 100MB
)
```

2. 使用流式处理
3. 考虑前端分页加载

### 使用缓存

安装 Redis:
```bash
pip install redis
```

添加缓存：
```python
import redis
r = redis.Redis(host='localhost', port=6379, db=0)

@app.get("/api/cached-data/{file_id}")
async def get_cached_data(file_id: str):
    cached = r.get(f"json:{file_id}")
    if cached:
        return json.loads(cached)
    # ... 处理逻辑
```

---

## 🐛 故障排查

### 常见问题

**1. 端口被占用**
```bash
# 查找占用 8000 端口的进程
lsof -i :8000  # Mac/Linux
netstat -ano | findstr :8000  # Windows

# 杀死进程或修改 app.py 中的端口号
```

**2. 依赖安装失败**
```bash
# 升级 pip
pip install --upgrade pip

# 使用国内镜像源
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**3. 浏览器无法访问**
- 检查防火墙设置
- 确认服务器已启动
- 尝试 127.0.0.1 而不是 localhost

---

## 📞 获取帮助

- 查看日志: `tail -f logs/app.log`
- 检查服务状态: `curl http://localhost:8000/api/health`
- API 文档: `http://localhost:8000/docs`

---

## 🎉 推荐方案总结

| 场景 | 推荐方案 | 难度 |
|------|---------|------|
| 个人使用 | 独立 HTML 文件 | ⭐ |
| 团队内网使用 | FastAPI + 局域网访问 | ⭐⭐ |
| 公网分享（临时）| FastAPI + ngrok | ⭐⭐ |
| 公网分享（长期）| 云服务器 + Nginx | ⭐⭐⭐ |
| 桌面应用 | Electron 打包 | ⭐⭐⭐ |
| 企业级部署 | Docker + K8s | ⭐⭐⭐⭐ |

大多数情况下，推荐：
- **快速测试**: 独立 HTML 文件
- **团队使用**: FastAPI + 内网部署
- **对外分享**: Vercel/Railway 免费部署
