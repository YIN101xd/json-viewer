"""
JSON Viewer - FastAPI Web Application
一个基于 FastAPI 的 JSON 评分查看器
"""

from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import json
import os
from typing import List
import uvicorn

app = FastAPI(title="JSON Viewer", description="智能 JSON 评分查看器")

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 读取 HTML 文件
def get_html_content():
    html_path = os.path.join(os.path.dirname(__file__), "json_viewer_standalone.html")
    with open(html_path, "r", encoding="utf-8") as f:
        return f.read()

@app.get("/", response_class=HTMLResponse)
async def root():
    """返回主页面"""
    return get_html_content()

@app.post("/api/upload")
async def upload_files(files: List[UploadFile] = File(...)):
    """
    上传 JSON 文件
    支持批量上传
    """
    results = []

    for file in files:
        if not file.filename.endswith('.json'):
            continue

        try:
            content = await file.read()
            json_data = json.loads(content.decode('utf-8'))

            results.append({
                "filename": file.filename,
                "size": len(content),
                "data": json_data,
                "success": True
            })
        except json.JSONDecodeError as e:
            results.append({
                "filename": file.filename,
                "success": False,
                "error": f"JSON 解析错误: {str(e)}"
            })
        except Exception as e:
            results.append({
                "filename": file.filename,
                "success": False,
                "error": f"文件读取错误: {str(e)}"
            })

    return JSONResponse(content={
        "total": len(files),
        "success": len([r for r in results if r.get("success")]),
        "results": results
    })

@app.get("/api/health")
async def health_check():
    """健康检查接口"""
    return {"status": "ok", "message": "JSON Viewer is running"}

@app.get("/api/info")
async def app_info():
    """应用信息"""
    return {
        "name": "JSON Viewer",
        "version": "2.0",
        "description": "智能 JSON 评分查看器",
        "features": [
            "支持多模型评分查看",
            "Markdown 渲染",
            "聚合评分表格",
            "详细评判理由展示"
        ]
    }

if __name__ == "__main__":
    print("=" * 60)
    print("🚀 JSON Viewer 启动中...")
    print("=" * 60)
    print(f"📊 访问地址: http://localhost:8000")
    print(f"📖 API 文档: http://localhost:8000/docs")
    print(f"🔧 健康检查: http://localhost:8000/api/health")
    print("=" * 60)
    print("按 Ctrl+C 停止服务")
    print("=" * 60)

    uvicorn.run(
        "app:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
