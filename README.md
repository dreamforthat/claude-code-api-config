[简体中文](#简体中文) | [English](#english)

---

<a id="简体中文"></a>
# Claude Code API 配置工具

> 一键配置 Claude Code 使用第三方 API（MIMO、DeepSeek）的自动化脚本，支持 Windows、Linux 和 macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue.svg)](https://github.com/dreamforthat/claude-code-api-config)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)

## 项目简介

本工具帮助 Windows 和 Linux/macOS 用户快速配置 Claude Code 使用第三方 API 服务，无需手动设置环境变量。通过交互式界面，您可以轻松切换不同的 API 提供商。脚本内置中英双语支持，可自由切换语言。

## 功能特性

- **跨平台支持** - 支持 Windows (PowerShell) 和 Linux/macOS (Bash)
- **交互式菜单** - 简单直观的选项界面
- **中英双语** - 脚本内置简体中文和 English，无第三方依赖
- **多 API 支持** - 支持 DeepSeek、MIMO（套餐/按量）和自定义 API
- **密钥安全输入** - 输入时隐藏字符，保护 API 密钥
- **自动验证** - 配置前自动验证 API 密钥有效性
- **环境检测** - 自动检测 Claude Code 是否已安装
- **持久化配置** - 使用 `setx` 永久保存环境变量
- **彩色输出** - 清晰的状态提示和错误信息

## 支持的 API 提供商

### 1. DeepSeek API

| 项目 | 值 |
|------|-----|
| 官网 | [ DeepSeek API ](https://platform.deepseek.com/usage) |
| 端点 | `https://api.deepseek.com/anthropic` |
| 主模型 | `deepseek-v4-pro[1m]` |
| 轻量模型 | `deepseek-v4-flash[1m]` |
| 特点 | 国产大模型，性价比高 |

### 2. MIMO API

包含两个二级子选项：
- **套餐计费 (Plan)**：支持中国（`https://token-plan-cn.xiaomimimo.com/anthropic`）、新加坡、欧洲集群。
- **按量计费 (Pay-as-you-go)**：端点为 `https://api.xiaomimimo.com/anthropic`。

| 项目 | 值 |
|------|-----|
| 官网 | [MIMO API](https://platform.xiaomimimo.com) |
| 主模型 | `mimo-v2.5-pro[1m]` |
| 轻量模型 | `mimo-v2.5[1m]` |
| 特点 | 支持套餐与按量双模式 |

### 3. 自定义 API (Custom API)

| 项目 | 值 |
|------|-----|
| 端点 | 由用户自定义输入（如 `https://api.example.com/anthropic`） |
| 密钥 | 由用户自定义输入（隐藏输入） |
| 模型 | 由用户自定义输入（如 `claude-3-5-sonnet-20241022`） |
| 特点 | 支持任意兼容 Anthropic 协议的第三方代理端点 |

## 系统要求

### Windows

- **操作系统**: Windows 10/11
- **PowerShell**: 5.1 或更高版本
- **Node.js**: 16.0 或更高版本（用于安装 Claude Code）
- **Claude Code**: 已通过 `npm install -g @anthropic-ai/claude-code` 安装

### Linux / macOS

- **操作系统**: 主流 Linux 发行版或 macOS
- **Bash**: 4.0 或更高版本
- **Node.js**: 16.0 或更高版本（用于安装 Claude Code）
- **Claude Code**: 已通过 `npm install -g @anthropic-ai/claude-code` 安装
- **curl**: 用于 API 密钥验证

## 安装方法

### 方式一：一键运行 (推荐)

如果您不想克隆仓库，可以直接运行以下命令。

#### Windows

**在 PowerShell 中运行：**

```powershell
iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')
```

**在 CMD 命令提示符中运行：**

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')"
```

#### Linux / macOS

**在终端中运行：**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.sh)
```

> **注意**: 以上命令会下载并直接执行配置脚本，请确保您的网络环境可以访问 GitHub。

### 方式二：下载发布版本

1. 前往 [Releases](https://github.com/dreamforthat/claude-code-api-config/releases) 页面
2. 下载最新版本的 `claude-code-api-config.zip`
3. 解压到任意目录
4. 运行配置脚本：
   - **Windows**: 双击运行 `setup-claude-api.bat`
   - **Linux / macOS**: 运行 `./setup-claude-api.sh`

### 方式三：克隆仓库

```bash
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
```

## 使用方法

### 快速开始

#### Windows

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

#### Linux / macOS

```bash
# 进入脚本目录
cd path/to/claude-code-api-config

# 运行脚本
./setup-claude-api.sh

# 或使用 bash 运行
bash setup-claude-api.sh

# 查看帮助
./setup-claude-api.sh --help
```

### 操作流程

```
1. 运行脚本
   ↓
2. 选择语言（中文/English，默认中文）
   ↓
3. 检测 Claude Code 安装状态
   ↓
4. 选择 API 提供商（1: DeepSeek / 2: MIMO 二级菜单 / 3: 自定义 API，默认1）
   ↓
5. 输入 API 密钥及相关参数（自定义 API 还需输入 Base URL 与模型名称）
   ↓
6. 自动验证密钥有效性
   ↓
7. 显示当前 Claude Code 相关环境变量
   ↓
8. 选择安装模式（清洁安装/常规安装，默认清洁安装）
   ↓
9. 配置环境变量
   ↓
10. 重启终端生效
```

> **提示**: 所有选择步骤直接按回车即可选择默认选项（选项1）。

### 配置验证

配置完成后，重启终端，运行以下命令验证：

#### Windows (PowerShell)

```powershell
# 查看 Anthropic 相关环境变量
Get-ChildItem Env:ANTHROPIC*

# 查看 Claude 相关环境变量
Get-ChildItem Env:CLAUDE*

# 测试 Claude Code 是否正常工作
claude --version
```

#### Linux / macOS

```bash
# 查看 Anthropic 相关环境变量
env | grep ANTHROPIC

# 查看 Claude 相关环境变量
env | grep CLAUDE

# 测试 Claude Code 是否正常工作
claude --version
```

## 安装模式

配置前，脚本会自动扫描系统中所有 Claude Code 相关的环境变量（匹配 `ANTHROPIC_*`、`CLAUDE_*`、`CLAUDE_CODE_*`、`DISABLE_PROMPT_CACHING` 前缀），并列出当前值。

### 清洁安装（默认）

清除所有检测到的相关环境变量后，再写入新配置。适用于：
- 首次配置
- 切换 API 提供商
- 遇到配置冲突或异常时

### 常规安装

仅覆盖写入脚本涉及的变量，不影响其他 Claude Code 相关变量。适用于：
- 仅更新 API 密钥
- 保留自定义配置的同时修改部分变量

## 环境变量说明

配置完成后，脚本将设置以下环境变量：

- **Windows**: 使用 `setx` 写入用户环境变量（永久生效）
- **Linux / macOS**: 写入 `~/.bashrc` 和 `~/.zshrc`（需重启终端生效）

| 环境变量 | 说明 | MIMO 示例值 | DeepSeek 示例值 |
|---------|------|--------|--------|
| `ANTHROPIC_BASE_URL` | API 代理地址 | `https://token-plan-cn.xiaomimimo.com/anthropic` | `https://api.deepseek.com/anthropic` |
| `ANTHROPIC_AUTH_TOKEN` | API 密钥 | `sk-xxxxxxxx` | `sk-xxxxxxxx` |
| `ANTHROPIC_MODEL` | 指定主模型 | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | 映射 Opus 模型 | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | 映射 Sonnet 模型 | `mimo-v2.5-pro` | `deepseek-v4-pro` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | 映射 Haiku 模型 (1M 上下文) | `mimo-v2.5[1m]` | `deepseek-v4-flash[1m]` |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Subagent 辅助模型 | `mimo-v2.5` | `deepseek-v4-flash` |
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
- 网络连接问题 / 虚拟机网络或 DNS 解析失败（例如提示 `Could not resolve host` 错误）

**解决方案：**
1. 检查密钥是否正确
2. 登录 API 提供商官网查看密钥状态
3. 检查网络连接。如果在虚拟机（如 VMware）中遇到 `Could not resolve host`：
   - 先检查虚拟机是否完全断网，运行 `ping -c 3 8.8.8.8`
   - 如果可以 ping 通外网 IP 但解析域名失败，临时修改 DNS 为公共 DNS：`echo "nameserver 223.5.5.5" > /etc/resolv.conf`
   - 如果完全断网，在虚拟机内重启网络服务：`systemctl restart NetworkManager` 或 `dhclient -r && dhclient`；或者在虚拟机软件中将网卡“断开连接”后再重新“连接”。

### Q3: 配置后不生效

**解决方案：**

**Windows:**
1. 确保已重启终端
2. 检查环境变量是否正确设置：`set ANTHROPIC`
3. 尝试注销并重新登录 Windows

**Linux / macOS:**
1. 确保已重启终端
2. 检查环境变量是否正确设置：`env | grep ANTHROPIC`
3. 确认 `~/.bashrc` 或 `~/.zshrc` 中有相关配置
4. 运行 `source ~/.bashrc` 或 `source ~/.zshrc` 手动加载

### Q4: 如何切换 API 提供商？

重新运行配置脚本，选择新的 API 提供商即可。新的配置会覆盖旧配置。

### Q5: 如何恢复默认配置？

**Windows (PowerShell):**

```powershell
# 删除所有相关环境变量
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $null, "User")
# ... 其他变量类似
```

**Linux / macOS:**

```bash
# 从 ~/.bashrc 和 ~/.zshrc 中删除相关配置
sed -i '/ANTHROPIC_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/CLAUDE_CODE_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/CLAUDE_CONTEXT_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/CLAUDE_AUTOCOMPACT_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/# Claude Code API Config/d' ~/.bashrc ~/.zshrc 2>/dev/null

# 重启终端或执行
source ~/.bashrc
```

## 安全说明

- API 密钥在输入时不会显示在屏幕上
- 密钥存储位置：
  - **Windows**: 用户环境变量（仅当前用户可见）
  - **Linux / macOS**: `~/.bashrc` 和 `~/.zshrc`（仅当前用户可读）
- 脚本不会上传或存储任何敏感信息
- 建议定期更换 API 密钥

## 开发说明

### 项目结构

```
claude-code-api-config/
├── setup-claude-api.ps1    # Windows PowerShell 主脚本
├── setup-claude-api.bat    # Windows 批处理启动文件
├── setup-claude-api.sh     # Linux / macOS Bash 主脚本
└── README.md               # 本文件
```

### 本地开发

**Windows:**

```powershell
# 克隆仓库
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config

# 运行测试
.\setup-claude-api.ps1 -Help
```

**Linux / macOS:**

```bash
# 克隆仓库
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config

# 运行测试
./setup-claude-api.sh --help
```

### 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 提交 Pull Request

## 更新日志

### v1.2.0 (2026-08-14)

- 重构主菜单层级：`[1] DeepSeek API`、`[2] MIMO API`、`[3] 自定义 API`
- 新增 MIMO 二级子菜单：支持在二级菜单中切换选择套餐计费 (Plan) 与按量计费 (Pay-as-you-go)
- 新增自定义 API 功能：支持自定义输入 Base URL、API Key 与模型名称，自动完成映射配置
- 完善 Windows 脚本 UTF-8 BOM 编码支持，彻底解决中文 Windows 终端解析与运行报错

### v1.1.0 (2026-05-08)

- 新增 Linux / macOS 跨平台支持（Bash 脚本 `setup-claude-api.sh`）
- 新增环境变量扫描：配置前自动检测系统中所有 Claude Code 相关环境变量
- 新增清洁安装模式：清除所有相关旧变量后重新配置（默认）
- 新增常规安装模式：仅覆盖写入脚本涉及的变量
- 所有选择菜单支持直接按回车选择默认选项（选项1）

### v1.0.0 (2025-05-22)

- 初始发布
- 支持 MIMO API（套餐计费 / 按量计费）
- 支持 DeepSeek API
- 自动验证 API 密钥有效性
- 自动检测 Claude Code 安装状态
- 内置中英双语支持

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

> A one-click automation script to configure Claude Code for third-party APIs (MIMO, DeepSeek) on Windows, Linux, and macOS.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue.svg)](https://github.com/dreamforthat/claude-code-api-config)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)](https://www.gnu.org/software/bash/)

## Introduction

This tool helps Windows and Linux/macOS users quickly configure Claude Code to use third-party API services without manually setting environment variables. With an interactive interface, you can easily switch between different API providers. The script has built-in bilingual support (English and Simplified Chinese) without relying on any external tools.

## Features

- **Cross-Platform** - Supports Windows (PowerShell) and Linux/macOS (Bash)
- **Interactive Menu** - Simple and intuitive interface
- **Bilingual** - Built-in Chinese and English output
- **Multi-API Support** - Supports DeepSeek, MIMO (Plan/Pay-as-you-go), and Custom API
- **Secure Key Input** - Characters are hidden during input to protect API keys
- **Auto Validation** - Automatically verifies API key validity before applying config
- **Environment Detection** - Detects if Claude Code is installed
- **Persistent Config** - Uses `setx` to permanently save environment variables
- **Colorful Output** - Clear status prompts and error messages

## Supported API Providers

### 1. DeepSeek API

| Item | Value |
|------|-----|
| Website | [DeepSeek API](https://platform.deepseek.com/usage) |
| Endpoint | `https://api.deepseek.com/anthropic` |
| Main Model | `deepseek-v4-pro[1m]` |
| Light Model | `deepseek-v4-flash[1m]` |
| Features | Cost-effective Chinese LLM |

### 2. MIMO API

Contains two sub-options:
- **Plan**: Supports China (`https://token-plan-cn.xiaomimimo.com/anthropic`), Singapore, and Europe clusters.
- **Pay-as-you-go**: Endpoint `https://api.xiaomimimo.com/anthropic`.

| Item | Value |
|------|-----|
| Website | [MIMO API](https://platform.xiaomimimo.com) |
| Main Model | `mimo-v2.5-pro[1m]` |
| Light Model | `mimo-v2.5[1m]` |
| Features | Supports both subscription plan and pay-as-you-go modes |

### 3. Custom API

| Item | Value |
|------|-----|
| Endpoint | User-defined (e.g. `https://api.example.com/anthropic`) |
| API Key | User-defined (secure hidden input) |
| Model | User-defined (e.g. `claude-3-5-sonnet-20241022`) |
| Features | Supports any third-party Anthropic-compatible API endpoint |

## System Requirements

### Windows

- **OS**: Windows 10/11
- **PowerShell**: 5.1 or higher
- **Node.js**: 16.0 or higher (for installing Claude Code)
- **Claude Code**: Installed via `npm install -g @anthropic-ai/claude-code`

### Linux / macOS

- **OS**: Major Linux distributions or macOS
- **Bash**: 4.0 or higher
- **Node.js**: 16.0 or higher (for installing Claude Code)
- **Claude Code**: Installed via `npm install -g @anthropic-ai/claude-code`
- **curl**: For API key validation

## Installation

### Method 1: One-click run (Recommended)

If you don't want to clone the repository, you can run the following command directly.

#### Windows

**Run in PowerShell:**

```powershell
iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')
```

**Run in CMD Prompt:**

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((irm https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1) -replace '^\uFEFF', '')"
```

#### Linux / macOS

**Run in terminal:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.sh)
```

> **Note**: The above commands will download and execute the configuration script directly. Please ensure your network can access GitHub.

### Method 2: Download Release

1. Go to the [Releases](https://github.com/dreamforthat/claude-code-api-config/releases) page
2. Download the latest `claude-code-api-config.zip`
3. Extract to any directory
4. Run the configuration script:
   - **Windows**: Double-click `setup-claude-api.bat`
   - **Linux / macOS**: Run `./setup-claude-api.sh`

### Method 3: Clone Repository

```bash
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
```

## Usage

### Quick Start

#### Windows

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

#### Linux / macOS

```bash
# Enter script directory
cd path/to/claude-code-api-config

# Run script
./setup-claude-api.sh

# Or run with bash
bash setup-claude-api.sh

# View help
./setup-claude-api.sh --help
```

### Operation Flow

```
1. Run script
   ↓
2. Select Language (CN/EN, default: CN)
   ↓
3. Detect Claude Code installation
   ↓
4. Select API provider (1: DeepSeek / 2: MIMO sub-menu / 3: Custom API, default: 1)
   ↓
5. Input API Key and parameters (Custom API will also prompt for Base URL & Model Name)
   ↓
6. Auto validate key
   ↓
7. Show current Claude Code environment variables
   ↓
8. Select install mode (Clean/Normal, default: Clean)
   ↓
9. Configure environment variables
   ↓
10. Restart terminal to take effect
```

> **Tip**: In all selection steps, simply press Enter to choose the default option (option 1).

### Configuration Validation

After configuration, restart your terminal and run the following commands to verify:

#### Windows (PowerShell)

```powershell
# Check Anthropic related variables
Get-ChildItem Env:ANTHROPIC*

# Check Claude related variables
Get-ChildItem Env:CLAUDE*

# Test if Claude Code works properly
claude --version
```

#### Linux / macOS

```bash
# Check Anthropic related variables
env | grep ANTHROPIC

# Check Claude related variables
env | grep CLAUDE

# Test if Claude Code works properly
claude --version
```

## Install Modes

Before configuration, the script automatically scans all Claude Code related environment variables (matching `ANTHROPIC_*`, `CLAUDE_*`, `CLAUDE_CODE_*`, `DISABLE_PROMPT_CACHING` prefixes) and displays their current values.

### Clean Install (Default)

Clears all detected related environment variables, then writes the new configuration. Recommended for:
- First-time setup
- Switching API providers
- Resolving configuration conflicts or issues

### Normal Install

Only overwrites the variables managed by this script, leaving other Claude Code related variables intact. Suitable for:
- Updating only the API key
- Modifying specific variables while preserving custom configurations

## Environment Variables Reference

The script sets the following environment variables:

- **Windows**: Uses `setx` to write to user environment variables (persistent)
- **Linux / macOS**: Writes to `~/.bashrc` and `~/.zshrc` (restart terminal to take effect)

| Variable | Description | MIMO Example | DeepSeek Example |
|---------|------|--------|--------|
| `ANTHROPIC_BASE_URL` | API proxy URL | `https://token-plan-cn.xiaomimimo.com/anthropic` | `https://api.deepseek.com/anthropic` |
| `ANTHROPIC_AUTH_TOKEN` | API Key | `sk-xxxxxxxx` | `sk-xxxxxxxx` |
| `ANTHROPIC_MODEL` | Main model | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Mapped Opus model | `mimo-v2.5-pro[1m]` | `deepseek-v4-pro[1m]` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Mapped Sonnet model | `mimo-v2.5-pro` | `deepseek-v4-pro` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Mapped Haiku model (1M context) | `mimo-v2.5[1m]` | `deepseek-v4-flash[1m]` |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Subagent model | `mimo-v2.5` | `deepseek-v4-flash` |
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
- Network connection issues / Virtual machine network or DNS resolution failure (e.g., `Could not resolve host` error)

**Solutions:**
1. Check if the key is correct
2. Login to the provider's website to check key status
3. Check your network connection. If running in a virtual machine (e.g., VMware) and encountering `Could not resolve host`:
   - Verify VM connectivity by pinging an IP: `ping -c 3 8.8.8.8`
   - If pinging IP succeeds but DNS fails, temporarily add a public DNS to `/etc/resolv.conf`: `echo "nameserver 223.5.5.5" > /etc/resolv.conf`
   - If completely disconnected, restart the network manager in the VM (`systemctl restart NetworkManager` or `dhclient -r && dhclient`), or disconnect and reconnect the virtual network adapter.

### Q3: Configuration does not take effect

**Solutions:**

**Windows:**
1. Make sure you have restarted the terminal
2. Check variables: `set ANTHROPIC`
3. Try logging out and logging back into Windows

**Linux / macOS:**
1. Make sure you have restarted the terminal
2. Check variables: `env | grep ANTHROPIC`
3. Verify `~/.bashrc` or `~/.zshrc` contains the configuration
4. Run `source ~/.bashrc` or `source ~/.zshrc` to reload manually

### Q4: How to switch API provider?

Simply run the script again and select a new provider. The new config will overwrite the old one.

### Q5: How to restore default configuration?

**Windows (PowerShell):**

```powershell
# Remove all related environment variables
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $null, "User")
# ... Similar for other variables
```

**Linux / macOS:**

```bash
# Remove related configuration from ~/.bashrc and ~/.zshrc
sed -i '/ANTHROPIC_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/CLAUDE_CODE_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/CLAUDE_CONTEXT_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/CLAUDE_AUTOCOMPACT_/d' ~/.bashrc ~/.zshrc 2>/dev/null
sed -i '/# Claude Code API Config/d' ~/.bashrc ~/.zshrc 2>/dev/null

# Restart terminal or run
source ~/.bashrc
```

## Security Notes

- API Keys are hidden during input
- Key storage locations:
  - **Windows**: User environment variables (visible only to the current user)
  - **Linux / macOS**: `~/.bashrc` and `~/.zshrc` (readable only by current user)
- The script does NOT upload or store any sensitive information
- It is recommended to rotate API keys periodically

## Development

### Project Structure

```
claude-code-api-config/
├── setup-claude-api.ps1    # Windows PowerShell script
├── setup-claude-api.bat    # Windows batch launcher
├── setup-claude-api.sh     # Linux / macOS Bash script
└── README.md               # This file
```

### Local Development

**Windows:**

```powershell
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
.\setup-claude-api.ps1 -Help
```

**Linux / macOS:**

```bash
git clone https://github.com/dreamforthat/claude-code-api-config.git
cd claude-code-api-config
./setup-claude-api.sh --help
```

### Contributing

Issues and Pull Requests are welcome!

1. Fork the repo
2. Create feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m 'Add some feature'`
4. Push branch: `git push origin feature/your-feature`
5. Submit Pull Request

## Changelog

### v1.2.0 (2026-08-14)

- Restructured main menu: `[1] DeepSeek API`, `[2] MIMO API`, `[3] Custom API`
- Added MIMO sub-menu: easily switch between Plan and Pay-as-you-go modes
- Added Custom API support: allows custom Base URL, API Key, and Model Name with automatic mapping
- Fixed UTF-8 BOM encoding for Windows script to resolve Chinese terminal parsing errors

### v1.1.0 (2026-05-08)

- Added Linux / macOS cross-platform support via Bash script (`setup-claude-api.sh`)
- Added environment variable scanner: detects existing Claude Code env vars before setup
- Added Clean Install mode: clears existing Claude Code vars before writing new ones (default)
- Added Normal Install mode: only overwrites managed variables
- All interactive menus support pressing Enter to select default option (Option 1)

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
