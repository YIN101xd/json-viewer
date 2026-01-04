# 📊 JSON Viewer - 智能评分查看器

一个功能强大的 JSON 文件查看和分析工具，特别适合查看多模型评分数据。

## ✨ 主要特性

- 🎨 **现代化界面** - 左右分栏设计，清晰直观
- 📝 **Markdown 渲染** - 支持完整的 Markdown 语法展示
- 🤖 **多模型支持** - 同时展示多个 AI 模型的回答和评分
- 📊 **聚合评分表格** - 一目了然地查看所有模型的评分
- 🔍 **详细评判理由** - 点击查看每个评分项的详细说明
- 🚀 **多种部署方式** - 支持独立 HTML、Web 服务、桌面应用等

## 🚀 快速开始

### 方式 1: 独立 HTML 文件（最简单）

适合个人使用或快速分享：

1. 双击打开 `json_viewer_standalone.html`
2. 拖拽 JSON 文件到页面
3. 开始查看！

**特点：**
- ✅ 无需安装
- ✅ 完全本地运行，数据安全
- ✅ 支持拖拽上传文件/文件夹

### 方式 2: FastAPI Web 服务（团队使用）

适合团队共享使用：

#### Windows:
```bash
双击运行 start_server.bat
```

#### Mac/Linux:
```bash
bash start_server.sh
```

然后访问: `http://localhost:8000`

**特点：**
- ✅ 多人同时使用
- ✅ 支持内网/公网部署
- ✅ RESTful API 接口

### 方式 3: Python 命令行版本

```bash
python json_viewer.py
```

**特点：**
- ✅ 彩色终端输出
- ✅ 交互式菜单
- ✅ 适合快速查看

## 📦 项目文件说明

```
JSON_Viewer_Project/
├── json_viewer_standalone.html  # 独立 HTML 版本（推荐）
├── json_viewer.py               # Python 命令行版本
├── app.py                       # FastAPI 服务器
├── requirements.txt             # Python 依赖
├── start_server.sh              # Mac/Linux 启动脚本
├── start_server.bat             # Windows 启动脚本
├── DEPLOYMENT.md                # 详细部署指南
├── README.md                    # 本文件
└── data/                        # JSON 文件目录
    └── sample/                  # 示例数据
```

## 🎯 使用场景

### 查看 AI 模型评分数据

系统会自动识别以下数据结构：

```json
{
  "uid": "task_001",
  "case_id": "case_123",
  "prompt": "提示词内容...",
  "example_answer_reference": "参考答案...",
  "model_responses": {
    "claude-sonnet-4.5": "Claude 的回答...",
    "gpt-5.2": "GPT 的回答...",
    "kimi-k2": "Kimi 的回答..."
  },
  "rubrics": [
    {
      "rubric_tag": "准确性",
      "rubric_weight": 0.3,
      "rubric_detail": "评分说明...",
      "auto_score_claude_sonnet_4.5": 1,
      "auto_judge_cot_claude_sonnet_4.5": "评判理由...",
      "auto_score_gpt_5.2": 0,
      "auto_judge_cot_gpt_5.2": "评判理由..."
    }
  ]
}
```

## 🌟 界面功能

### 左侧面板
- 📁 上传区域（支持拖拽）
- 📋 任务文件列表
- 🔍 文件信息（大小、评分项数）

### 右侧面板
- 📌 任务元数据标签
- 📝 提示词（Markdown 渲染）
- ✅ 参考答案（Markdown 渲染）
- 🤖 模型回答（Tab 切换，Markdown 渲染）
- 📊 评分表格（聚合显示所有模型）
- 🔍 详情弹窗（点击查看评判理由）

## 🚀 部署选项

### 1. 局域网部署

让同事通过局域网访问：

```bash
# 启动服务器（默认已配置为 0.0.0.0）
bash start_server.sh

# 查看本机 IP
ifconfig | grep "inet "   # Mac/Linux
ipconfig                   # Windows

# 同事访问 http://your-ip:8000
```

### 2. 云服务器部署

详见 `DEPLOYMENT.md` 文档，包括：
- 阿里云/腾讯云/AWS 部署
- Vercel/Railway 免费部署
- Docker 容器化部署
- Nginx 反向代理配置

### 3. 打包成桌面应用

使用 Electron 打包成 `.exe` 或 `.app`：

```bash
# 安装依赖
npm install

# 打包
npm run build
```

详见 `DEPLOYMENT.md` 的完整说明。

## 🔧 高级配置

### 修改端口

编辑 `app.py`:
```python
uvicorn.run(
    "app:app",
    host="0.0.0.0",
    port=8080,  # 改为你想要的端口
    reload=True
)
```

### 添加密码保护

参见 `DEPLOYMENT.md` 中的"安全配置"章节。

### 处理大文件

如果 JSON 文件很大（>10MB），建议：
1. 使用 FastAPI 版本（支持流式处理）
2. 增加浏览器内存限制
3. 分批加载数据

## 📊 数据格式要求

支持标准 JSON 格式，特别优化了以下字段：

**元数据字段:**
- `uid`, `case_id`, `client_id`, `type`, `category`
- `domain` (支持嵌套), `scene` (支持嵌套)

**内容字段:**
- `prompt` - 提示词
- `example_answer_reference` - 参考答案
- `system_prompt` - 系统提示
- `model_responses` - 模型回答（对象）

**评分字段:**
- `rubrics` - 评分标准数组
  - `rubric_number` - 序号
  - `rubric_tag` - 评分项名称
  - `rubric_tag_level_2` - 二级标签
  - `rubric_weight` - 权重
  - `rubric_detail` - 评分说明
  - `auto_score_*` - 自动评分
  - `auto_judge_cot_*` - 评判理由

## 🐛 常见问题

### Q: 为什么打不开 HTML 文件？
A: 确保使用现代浏览器（Chrome/Firefox/Safari/Edge 最新版）

### Q: 上传后看不到内容？
A: 检查 JSON 文件格式是否正确，打开浏览器控制台查看错误信息

### Q: FastAPI 启动失败？
A:
1. 检查 Python 版本（需要 3.7+）
2. 检查端口是否被占用
3. 尝试手动安装依赖: `pip install -r requirements.txt`

### Q: 如何查看大量文件？
A: 建议使用 FastAPI 版本，性能更好

### Q: 支持哪些浏览器？
A:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

## 📝 更新日志

### v2.0 (2026-01-04)
- ✨ 全新的左右分栏界面
- ✨ 支持多模型回答展示
- ✨ Markdown 渲染支持
- ✨ 聚合评分表格
- ✨ FastAPI Web 服务
- ✨ 详细部署文档

### v1.0
- 🎉 初始版本
- 基础 JSON 查看功能
- 命令行界面

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 💬 联系方式

如有问题或建议，欢迎反馈！

---

**🎉 享受使用 JSON Viewer！**
