用中文回答
# Claude Code API Configuration Tool

This project provides a simple way to configure Claude Code to use third-party API providers like MIMO and DeepSeek on Windows, Linux, and macOS.

## Core Files
- `setup-claude-api.ps1`: The main PowerShell script for Windows interactive configuration.
- `setup-claude-api.bat`: A batch wrapper for easy execution by double-clicking on Windows.
- `setup-claude-api.sh`: The main Bash script for Linux/macOS interactive configuration.
- `README.md`: Human-readable documentation.

## Development Commands

### Windows
- Run configuration: `.\setup-claude-api.ps1`
- View help: `.\setup-claude-api.ps1 -Help`

### Linux / macOS
- Run configuration: `./setup-claude-api.sh`
- View help: `./setup-claude-api.sh --help`

## Configuration Details
Before setting variables, the script scans all existing Claude Code related environment variables (`ANTHROPIC_*`, `CLAUDE_*`, `CLAUDE_CODE_*`, `DISABLE_PROMPT_CACHING`) and offers two install modes:
- **Clean Install (default)**: Clears all related variables, then sets the ones below.
- **Normal Install**: Only overwrites the variables below, leaving others intact.

The script sets the following environment variables:
- `ANTHROPIC_BASE_URL`
- `ANTHROPIC_AUTH_TOKEN`
- `ANTHROPIC_MODEL`
- `ANTHROPIC_DEFAULT_OPUS_MODEL`
- `ANTHROPIC_DEFAULT_SONNET_MODEL`
- `ANTHROPIC_DEFAULT_HAIKU_MODEL`
- `CLAUDE_CODE_SUBAGENT_MODEL`

### Storage Locations
- **Windows**: User environment variables via `setx`
- **Linux / macOS**: `~/.bashrc` and `~/.zshrc`
