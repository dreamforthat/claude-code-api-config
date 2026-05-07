[简体中文](#简体中文) | [English](#english)

---

<a id="简体中文"></a>
# Claude Code API 配置工具

> 一键配置 Claude Code 使用第三方 API（MIMO、DeepSeek）的 Windows 自动化脚本

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)

## 项目简介

本工具帮助 Windows 用户快速配置 Claude Code 使用第三方 API 服务，无需手动设置环境变量。通过交互式界面，您可以轻松切换不同的 API 提供商。脚本内置中英双语支持，可自由切换语言。

## 功能特性

- **交互式菜单** - 简单直观的选项界面
- **中英双语** - 脚本内置简体中文和 English，无第三方依赖
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
2. 选择语言（中文/English）
   ↓
3. 检测 Claude Code 安装状态
   ↓
4. 选择 API 提供商（1/2/3）
   ↓
5. 输入 API 密钥（不显示字符）
   ↓
6. 自动验证密钥有效性
   ↓
7. 配置环境变量
   ↓
8. 重启终端生效
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

| 环境变量 | 说明 | MIMO 示例值 | DeepSeek 示例值 |
|---------|------|--------|--------|
| `ANTHROPIC_BASE_URL` | API 代理地址 | `https://token-plan-cn.xiaomimimo.com/anthropic` | `https://api.deepseek.com/anthropic` |
| `ANTHROPIC_AUTH_TOKEN` | API 密钥 | `sk-xxxxxxxx` | `sk-xxxxxxxx` |
| `ANTHROPIC_MODEL` | 指定主模型 | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | 映射 Opus 模型 | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | 映射 Sonnet 模型 | `mimo-v2.5-pro` | `deepseek-v4-pro` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | 映射 Haiku 模型 (1M 上下文) | `mimo-v2.5[1m]` | `deepseek-v4-flash[1m]` |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Subagent 辅助模型 | `mimo-v2.5` | `deepseek-v4-flash` |
| `CLAUDE_CODE_EFFORT_LEVEL` | 思考程度 | `max` | `max` |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | 自动压缩阈值  | `80` | - |

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
- 支持中英双语输出

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

<a id="english"></a>
# Claude Code API Config Tool

> A one-click Windows automation script to configure Claude Code for third-party APIs (MIMO, DeepSeek).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)

## Introduction

This tool helps Windows users quickly configure Claude Code to use third-party API services without manually setting environment variables. With an interactive interface, you can easily switch between different API providers. The script has built-in bilingual support (English and Simplified Chinese) without relying on any external tools.

## Features

- **Interactive Menu** - Simple and intuitive interface
- **Bilingual** - Built-in Chinese and English output
- **Multi-API Support** - Supports MIMO (Plan/Pay-as-you-go) and DeepSeek
- **Secure Key Input** - Characters are hidden during input to protect API keys
- **Auto Validation** - Automatically verifies API key validity before applying config
- **Environment Detection** - Detects if Claude Code is installed
- **Persistent Config** - Uses `setx` to permanently save environment variables
- **Colorful Output** - Clear status prompts and error messages

## Supported API Providers

### 1. MIMO API (Plan)

| Item | Value |
|------|-----|
| Website | [MIMO API](https://platform.xiaomimimo.com/console/plan-manage) |
| Endpoint | China: `https://token-plan-cn.xiaomimimo.com/anthropic`<br>Singapore: `https://token-plan-sgp.xiaomimimo.com/anthropic`<br>Europe: `https://token-plan-ams.xiaomimimo.com/anthropic` |
| Main Model | `mimo-v2.5-pro` |
| Light Model | `mimo-v2.5` |
| Features | Fixed plan, suitable for high-frequency usage |

### 2. MIMO API (Pay-as-you-go)

| Item | Value |
|------|-----|
| Website | [MIMO API](https://platform.xiaomimimo.com/console/api-keys) |
| Endpoint | `https://api.xiaomimimo.com/anthropic` |
| Main Model | `mimo-v2.5-pro` |
| Light Model | `mimo-v2.5` |
| Features | Pay-as-you-go, flexible and controllable |

### 3. DeepSeek API

| Item | Value |
|------|-----|
| Website | [ DeepSeek API ](https://platform.deepseek.com/usage) |
| Endpoint | `https://api.deepseek.com/anthropic` |
| Main Model | `deepseek-v4-pro[1m]` |
| Light Model | `deepseek-v4-flash` |
| Features | Chinese LLM, highly cost-effective |

## System Requirements

- **OS**: Windows 10/11
- **PowerShell**: 5.1 or higher
- **Node.js**: 16.0 or higher (for installing Claude Code)
- **Claude Code**: Installed via `npm install -g @anthropic-ai/claude-code`

## Installation

### Method 1: One-click run (Recommended)

If you don't want to clone the repository, you can run the following command directly.

**Run in PowerShell:**

```powershell
iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')
```

**Run in CMD Prompt:**

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')"
```

> **Note**: This command will download and execute the configuration script directly. Please ensure your network can access GitHub.

### Method 2: Download Release

1. Go to the [Releases](https://github.com/dreamforthat/claude-code-api-config/releases) page
2. Download the latest `claude-code-api-config.zip`
3. Extract to any directory
4. Double-click `setup-claude-api.bat` to run

### Method 3: Clone Repository

```bash
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
```

## Usage

### Quick Start

**Option 1: Double-click to run (Recommended)**

Directly double-click the `setup-claude-api.bat` file and follow the prompts.

**Option 2: Run in PowerShell**

```powershell
# Enter script directory
cd path\to\claude-code-api-config

# Run script
.\setup-claude-api.ps1

# View help
.\setup-claude-api.ps1 -Help
```

### Operation Flow

```
1. Run script
   ↓
2. Select Language (CN/EN)
   ↓
3. Detect Claude Code installation
   ↓
4. Select API provider (1/2/3)
   ↓
5. Input API Key (Hidden characters)
   ↓
6. Auto validate key
   ↓
7. Configure environment variables
   ↓
8. Restart terminal to take effect
```

### Configuration Validation

After configuration, restart your terminal and run the following commands to verify:

```powershell
# Check Anthropic related variables
Get-ChildItem Env:ANTHROPIC*

# Check Claude related variables
Get-ChildItem Env:CLAUDE*

# Test if Claude Code works properly
claude --version
```

## Environment Variables Reference

The script sets the following system environment variables:

| Variable | Description | MIMO Example | DeepSeek Example |
|---------|------|--------|--------|
| `ANTHROPIC_BASE_URL` | API proxy URL | `https://token-plan-cn.xiaomimimo.com/anthropic` | `https://api.deepseek.com/anthropic` |
| `ANTHROPIC_AUTH_TOKEN` | API Key | `sk-xxxxxxxx` | `sk-xxxxxxxx` |
| `ANTHROPIC_MODEL` | Main model | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Mapped Opus model | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Mapped Sonnet model | `mimo-v2.5-pro` | `deepseek-v4-pro` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Mapped Haiku model (1M context) | `mimo-v2.5[1m]` | `deepseek-v4-flash[1m]` |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Subagent model | `mimo-v2.5` | `deepseek-v4-flash` |
| `CLAUDE_CODE_EFFORT_LEVEL` | Thinking effort | `max` | `max` |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Auto-compact threshold | `80` | - |

## FAQ

### Q1: "Claude Code not detected" prompt

**Solution:**
```bash
npm install -g @anthropic-ai/claude-code
```

### Q2: API Key verification failed

**Possible Causes:**
- Incorrect key input
- Key expired or insufficient balance
- Network connection issues

**Solutions:**
1. Check if the key is correct
2. Login to the provider's website to check key status
3. Check your network connection

### Q3: Configuration does not take effect

**Solutions:**
1. Make sure you have restarted the terminal
2. Check variables: `set ANTHROPIC`
3. Try logging out and logging back into Windows

### Q4: How to switch API provider?

Simply run the script again and select a new provider. The new config will overwrite the old one.

### Q5: How to restore default configuration?

```powershell
# Remove all related environment variables
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $null, "User")
# ... Similar for other variables
```

## Security Notes

- API Keys are hidden during input
- Keys are stored in Windows User Environment Variables (visible only to the current user)
- The script does NOT upload or store any sensitive information
- It is recommended to rotate API keys periodically

## Development

### Project Structure

```
claude-code-api-config/
├── setup-claude-api.ps1    # Main PowerShell script
├── setup-claude-api.bat    # Batch launcher
└── README.md               # This file
```

### Local Development

```powershell
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
.\setup-claude-api.ps1 -Help
```

### Contributing

Issues and Pull Requests are welcome!

1. Fork the repo
2. Create feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m 'Add some feature'`
4. Push branch: `git push origin feature/your-feature`
5. Submit Pull Request

## Changelog

### v1.0.0 (2025-05-22)
- Initial Release
- Support MIMO API (Plan & Pay-as-you-go)
- Support DeepSeek API
- Auto validate API keys
- Detect Claude Code installation
- Bilingual (Chinese/English) support built-in

## Related Links

- [Claude Code Official Docs](https://docs.anthropic.com/claude-code)
- [MIMO API](https://platform.xiaomimimo.com/console/plan-manage)
- [DeepSeek API](https://platform.deepseek.com)

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- [Anthropic](https://www.anthropic.com) - Creators of Claude Code
- [MIMO](https://xiaomimimo.com) - API Provider
- [DeepSeek](https://deepseek.com) - API Provider
