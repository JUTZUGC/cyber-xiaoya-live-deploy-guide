# cyber-xiaoya-live 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme
# 更新日期：2026-11-03
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw '需要先安装 Python 3' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/cyber-xiaoya/cyber-xiaoya-live.git
Set-Location cyber-xiaoya-live
pip install uv
uv venv .venv --python 3.12
uv pip install -r requirements.txt --default-index https://pypi.tuna.tsinghua.edu.cn/simple
copy config.example.json config.json
.venv\Scripts\python.exe -m src.main

Write-Host ''
$url = 'http://127.0.0.1:8795/stage'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成，浏览器访问 http://127.0.0.1:8795/stage'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme'
