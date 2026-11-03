#!/usr/bin/env bash
set -euo pipefail
# cyber-xiaoya-live 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme
# 更新日期：2026-11-03
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/cyber-xiaoya/cyber-xiaoya-live.git
cd cyber-xiaoya-live
pip install uv
uv venv .venv --python 3.12
uv pip install -r requirements.txt
cp config.example.json config.json
.venv/bin/python -m src.main

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:8795/stage"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:8795/stage" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:8795/stage，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:8795/stage 确认"
fi
echo "部署完成，浏览器访问 http://127.0.0.1:8795/stage"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme"
