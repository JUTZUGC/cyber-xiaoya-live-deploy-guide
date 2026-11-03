# cyber-xiaoya-live 一键部署指南

> 第三方部署指南 · 非 cyber-xiaoya-live 官方仓库。官方项目：[cyber-xiaoya/cyber-xiaoya-live](https://github.com/cyber-xiaoya/cyber-xiaoya-live)
> 内容来自官方文档（2026-11-03）。项目迭代快，请以[官方文档](https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 数字人不一定整套买：形象、声音与脑子都可以自己配。

⚠️ 仅支持 Windows 10/11 + NVIDIA 显卡（≥8 GB 显存），TTS 在本机跑，推荐 WSL2 + Ubuntu 22.04。必须自备 Vidu 账号与 API Key，连线即按秒计费（1 积分/秒）。仓库不含作者的人物形象、克隆音色、人设、动作库与歌库，这些都要自己准备。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/cyber-xiaoya-live-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会装好 Python 3.12 与 uv、拉齐依赖，并提示填写 Vidu 与 LLM 的 Key，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:8795/stage](http://127.0.0.1:8795/stage)，按官方引导完成初始化配置。

## cyber-xiaoya-live 是什么？

cyber-xiaoya-live 是开源的浏览器舞台页打字，本地桥把话送到云端渲染，数字人张嘴说出来（协议：AGPL-3.0，<img src="https://img.shields.io/github/stars/cyber-xiaoya/cyber-xiaoya-live?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

组件版数字人直播：本地 FastAPI 桥接页面与 Vidu 云端渲染，支持打字对话、动作指令、弹幕接入与本地 TTS 音色热切。

- 浏览器舞台页，本地操作
- Vidu 负责渲染与推流
- 本地 OmniVoice 支持音色克隆
- 弹幕、动作与直发指令
- 组件化，可替换各环节
- AGPL-3.0，可自建

（来源：[官方仓库](https://github.com/cyber-xiaoya/cyber-xiaoya-live)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 478 stars | 名称搜索仅 3 条结果 |
| 本地桥 + 云端渲染 | 结构清晰 |
| 支持音色克隆与热切 | — |
| 舞台页可直接操作 | — |
| 弹幕与动作指令齐备 | — |
| AGPL-3.0 | 可自建 |

| 需要注意 | 说明 |
|---|---|
| 仅 Windows + NVIDIA | — |
| Vidu 按秒计费 | 成本敏感 |
| TTS 部署要 WSL2 | 容易卡 |
| 不含形象与音色素材 | — |
| 项目很新 | 流程可能变 |

> 以上基于官方文档与社区反馈整理（2026-11-03），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/cyber-xiaoya/cyber-xiaoya-live.git
cd cyber-xiaoya-live
pip install uv
uv venv .venv --python 3.12
uv pip install -r requirements.txt
cp config.example.json config.json
.venv/bin/python -m src.main
```

启动后浏览器访问 [http://127.0.0.1:8795/stage](http://127.0.0.1:8795/stage)（管理面板）。（来源：[https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme](https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Windows + NVIDIA、Vidu 计费与 8795 端口 | 已核对 2026-11-03 |
| 确认仓库不含形象、音色与人设素材 | 已核对 2026-11-03 |
| 未实测部署与连线 | 说明 2026-11-03 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-03 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-03 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-03）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\cyber-xiaoya-live-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 需要准备

| 项目 | 要求 |
|---|---|
| 系统 | Windows 10/11 + NVIDIA ≥8 GB 显存 |
| Python | 3.12 + uv |
| ffmpeg | 在 PATH 中 |
| Vidu | 账号与 API Key，按秒计费 |
| LLM | DeepSeek 或任意 OpenAI 兼容 Key |

TTS 推荐 WSL2 + Ubuntu 22.04，显存占用约 11 GB。

## 启动

```powershell
.venv\Scripts\python.exe -m src.main
```

打开 [http://127.0.0.1:8795/stage](http://127.0.0.1:8795/stage)，点「开始连线」。

## 计费提醒

- 连线即开始计费，1 积分/秒
- 测完立刻点「断开」
- 先用短文验证流程，再长时间开播

## 注意

- 仓库不含人物形象与克隆音色，需自备
- WSL2 里的 OmniVoice 要单独按 `tools/omnivoice` 部署
- 配置里有密钥，不要提交
- AGPL-3.0，二次分发前先读许可证
- 直播内容合规由使用者负责

## 常见坑

- 装依赖失败：用 Python 3.12 与国内 PyPI 镜像
- TTS 起不来：按 `tools/omnivoice/README.md` 在 WSL2 里单独部署
- 舞台页空白：确认桥已监听 8795，浏览器访问 `/stage`
- 连线失败：检查 Vidu Key 与账户余额
- 显存不足：关闭其他占卡程序，或降低分辨率
- 费用超预期：测完马上断开，别挂着
- 配置泄露：`config.json` 不要提交到仓库

## 免责声明

本仓库为第三方指南，与 cyber-xiaoya-live 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-03），项目迭代快，请以[官方文档](https://github.com/cyber-xiaoya/cyber-xiaoya-live#readme)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
