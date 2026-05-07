# Claude Code API 配置工具

> 一键配置 Claude Code 使用第三方 API（MIMO、DeepSeek）的 Windows 自动化脚本

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)

## 项目简介

本工具帮助 Windows 用户快速配置 Claude Code 使用第三方 API 服务，无需手动设置环境变量。通过交互式界面，您可以轻松切换不同的 API 提供商。

## 功能特性

- **交互式菜单** - 简单直观的选项界面
- **多 API 支持** - 支持 MIMO（套餐/按量）和 DeepSeek
- **密钥安全输入** - 输入时隐藏字符，保护 API 密钥
- **自动验证** - 配置前自动验证 API 密钥有效性
- **环境检测** - 自动检测 Claude Code 是否已安装
- **持久化配置** - 使用 `setx` 永久保存环境变量
- **彩色输出** - 清晰的状态提示和错误信息

## 支持的 API 提供商

### 1. MIMO API（套餐计费）

| 项目 | 值 |
|------|-----|
| 官网 | [MIMO API](https://platform.xiaomimimo.com/console/plan-manage) |
| 端点 | 中国：`https://token-plan-cn.xiaomimimo.com/anthropic`<br>新加坡：`https://token-plan-sgp.xiaomimimo.com/anthropic`<br>欧洲：`https://token-plan-ams.xiaomimimo.com/anthropic` |
| 主模型 | `mimo-v2.5-pro` |
| 轻量模型 | `mimo-v2.5` |
| 特点 | 固定套餐，适合高频使用 |

### 2. MIMO API（按量计费）

| 项目 | 值 |
|------|-----|
| 官网 | [MIMO API](https://platform.xiaomimimo.com/console/api-keys) |
| 端点 | `https://api.xiaomimimo.com/anthropic` |
| 主模型 | `mimo-v2.5-pro` |
| 轻量模型 | `mimo-v2.5` |
| 特点 | 按使用量计费，灵活可控 |

### 3. DeepSeek API

| 项目 | 值 |
|------|-----|
| 官网 | [ DeepSeek API ](https://platform.deepseek.com/usage) |
| 端点 | `https://api.deepseek.com/anthropic` |
| 主模型 | `deepseek-v4-pro[1m]` |
| 轻量模型 | `deepseek-v4-flash` |
| 特点 | 国产大模型，性价比高 |

## 系统要求

- **操作系统**: Windows 10/11
- **PowerShell**: 5.1 或更高版本
- **Node.js**: 16.0 或更高版本（用于安装 Claude Code）
- **Claude Code**: 已通过 `npm install -g @anthropic-ai/claude-code` 安装

## 安装方法

### 方式一：一键运行 (推荐)

如果您不想克隆仓库，可以直接运行以下命令。

**在 PowerShell 中运行：**

```powershell
iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')
```

**在 CMD 命令提示符中运行：**

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')"
```

> **注意**: 此命令会下载并直接执行配置脚本，请确保您的网络环境可以访问 GitHub。

### 方式二：下载发布版本

1. 前往 [Releases](https://github.com/dreamforthat/claude-code-api-config/releases) 页面
2. 下载最新版本的 `claude-code-api-config.zip`
3. 解压到任意目录
4. 双击运行 `setup-claude-api.bat`

### 方式三：克隆仓库

```bash
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
```

## 使用方法

### 快速开始

**方法 1：双击运行（推荐）**

直接双击 `setup-claude-api.bat` 文件，按照提示操作即可。

**方法 2：PowerShell 运行**

```powershell
# 进入脚本目录
cd path\to\claude-code-api-config

# 运行脚本
.\setup-claude-api.ps1

# 查看帮助
.\setup-claude-api.ps1 -Help
```

### 操作流程

```
1. 运行脚本
   ↓
2. 检测 Claude Code 安装状态
   ↓
3. 选择 API 提供商（1/2/3）
   ↓
4. 输入 API 密钥（不显示字符）
   ↓
5. 自动验证密钥有效性
   ↓
6. 配置环境变量
   ↓
7. 重启终端生效
```

### 配置验证

配置完成后，重启终端，运行以下命令验证：

```powershell
# 查看 Anthropic 相关环境变量
Get-ChildItem Env:ANTHROPIC*

# 查看 Claude 相关环境变量
Get-ChildItem Env:CLAUDE*

# 测试 Claude Code 是否正常工作
claude --version
```

## 环境变量说明

配置完成后，脚本将设置以下系统环境变量：

| 环境变量 | 说明 | 示例值 |
|---------|------|--------|
| `ANTHROPIC_BASE_URL` | API 代理地址 | `https://api.deepseek.com/anthropic` |
| `ANTHROPIC_AUTH_TOKEN` | API 密钥 | `sk-xxxxxxxx` |
| `ANTHROPIC_MODEL` | 指定主模型 | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | 映射 Opus 模型 | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | 映射 Sonnet 模型 | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | 映射 Haiku 模型 | `deepseek-v4-flash` |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Subagent 辅助模型 | `deepseek-v4-flash` |
| `CLAUDE_CODE_EFFORT_LEVEL` | 思考程度 | `max` |
| `CLAUDE_CONTEXT_CAPACITY_OVERRIDE` | 上下文限制  | `1000000` |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | 自动压缩阈值  | `100` |

## 常见问题

### Q1: 提示"未检测到 Claude Code"

**解决方案：**

```bash
npm install -g @anthropic-ai/claude-code
```

### Q2: API 密钥验证失败

**可能原因：**
- 密钥输入错误
- 密钥已过期或余额不足
- 网络连接问题

**解决方案：**
1. 检查密钥是否正确
2. 登录 API 提供商官网查看密钥状态
3. 检查网络连接

### Q3: 配置后不生效

**解决方案：**
1. 确保已重启终端
2. 检查环境变量是否正确设置：`set ANTHROPIC`
3. 尝试注销并重新登录 Windows

### Q4: 如何切换 API 提供商？

重新运行配置脚本，选择新的 API 提供商即可。新的配置会覆盖旧配置。

### Q5: 如何恢复默认配置？

```powershell
# 删除所有相关环境变量
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $null, "User")
# ... 其他变量类似
```

## 安全说明

- API 密钥在输入时不会显示在屏幕上
- 密钥保存在 Windows 用户环境变量中，仅当前用户可见
- 脚本不会上传或存储任何敏感信息
- 建议定期更换 API 密钥

## 开发说明

### 项目结构

```
claude-code-api-config/
├── setup-claude-api.ps1    # PowerShell 主脚本
├── setup-claude-api.bat    # 批处理启动文件
└── README.md               # 本文件
```

### 本地开发

```powershell
# 克隆仓库
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config

# 运行测试
.\setup-claude-api.ps1 -Help
```

### 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 提交 Pull Request

## 更新日志

### v1.0.0 (2025-05-22)

- 初始发布
- 支持 MIMO API（套餐计费）
- 支持 MIMO API（按量计费）
- 支持 DeepSeek API
- 自动验证 API 密钥
- 检测 Claude Code 安装状态

## 相关链接

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [MIMO API 官网](https://platform.xiaomimimo.com/console/plan-manage)
- [DeepSeek API 官网](https://platform.deepseek.com)

## 许可证

本项目采用 [MIT 许可证](LICENSE) 开源。

## 致谢

感谢以下项目和社区的支持：

- [Anthropic](https://www.anthropic.com) - Claude Code 开发者
- [MIMO](https://xiaomimimo.com) - API 服务提供商
- [DeepSeek](https://deepseek.com) - API 服务提供商

---

**如果这个项目对您有帮助，请给个 Star 支持一下！**
