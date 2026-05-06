@echo off
:: 将执行重定向到 PowerShell 脚本，解决编码和复杂逻辑问题
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-claude-api.ps1"
