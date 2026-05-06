# Claude Code API 配置脚本
# 用于自动化设置 Claude Code 的 API 环境变量

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

param(
    [switch]$Help
)

if ($Help) {
    Write-Host 'Claude Code API 配置脚本'
    Write-Host ''
    Write-Host '用法: .\setup-claude-api.ps1'
    Write-Host ''
    Write-Host '功能:'
    Write-Host '  - 检测 Claude Code 是否已安装'
    Write-Host '  - 交互式选择 API 提供商 (MIMO 套餐/按量计费，或 DeepSeek)'
    Write-Host '  - 发送测试请求验证 API 密钥'
    Write-Host '  - 安全输入 API 密钥'
    Write-Host '  - 自动设置环境变量'
    Write-Host ''
    Write-Host '注意: 设置完成后需要重启终端才能生效'
    exit 0
}

function Check-ClaudeCode {
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
        Write-Host '=================================' -ForegroundColor Red
        Write-Host '警告: 未检测到 Claude Code (claude)' -ForegroundColor Yellow
        Write-Host '请确保已通过以下命令安装:' -ForegroundColor White
        Write-Host 'npm install -g @anthropic-ai/claude-code' -ForegroundColor Cyan
        Write-Host '=================================' -ForegroundColor Red
        Write-Host ''
        $continue = Read-Host '是否仍要继续配置环境变量? (Y/N)'
        if ($continue -notmatch '^[Yy]$') {
            Write-Host '操作已取消。' -ForegroundColor Cyan
            exit 1
        }
    } else {
        $version = claude --version
        Write-Host "检测到 Claude Code: $version" -ForegroundColor Green
        Write-Host ''
    }
}

function Show-Menu {
    Clear-Host
    Check-ClaudeCode
    
    Write-Host '=================================' -ForegroundColor Cyan
    Write-Host '  Claude Code API 配置工具' -ForegroundColor Cyan
    Write-Host '=================================' -ForegroundColor Cyan
    Write-Host ''
    Write-Host '请选择 API 提供商:' -ForegroundColor Yellow
    Write-Host ''
    Write-Host '  [1] MIMO API (套餐计费 - Plan)' -ForegroundColor Green
    Write-Host '  [2] MIMO API (按量计费 - Pay-as-you-go)' -ForegroundColor Green
    Write-Host '  [3] DeepSeek API' -ForegroundColor Green
    Write-Host '  [Q] 退出' -ForegroundColor Red
    Write-Host ''
}

function Get-SecureApiKey {
    param([string]$ProviderName)

    Write-Host ''
    Write-Host "请输入 $ProviderName API 密钥:" -ForegroundColor Yellow
    Write-Host '(输入时不会显示字符，按回车确认)' -ForegroundColor Gray

    $secureKey = Read-Host -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
    $apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

    return $apiKey
}

function Test-ApiKey {
    param([string]$BaseUrl, [string]$ApiKey, [string]$Model)
    
    Write-Host ''
    Write-Host '正在验证 API 密钥，请稍候...' -ForegroundColor Cyan
    $endpoint = "$BaseUrl/v1/messages"
    $headers = @{
        "x-api-key" = $ApiKey
        "anthropic-version" = "2023-06-01"
        "Content-Type" = "application/json"
    }
    
    $body = @{
        model = $Model
        max_tokens = 10
        messages = @(
            @{ role = "user"; content = "hello" }
        )
    } | ConvertTo-Json -Depth 5 -Compress
    
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Post -Headers $headers -Body $body -ErrorAction Stop
        Write-Host 'API 密钥验证成功！' -ForegroundColor Green
        return $true
    } catch {
        Write-Host 'API 密钥验证失败！' -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host "详细信息: $($_.ErrorDetails.Message)" -ForegroundColor Red
        } else {
            Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}

function Set-ApiConfig {
    param(
        [string]$ProviderName,
        [string]$BaseUrl,
        [string]$Model,
        [string]$HaikuModel,
        [string]$ApiKey
    )

    Write-Host ''
    Write-Host "正在配置 $ProviderName API..." -ForegroundColor Cyan

    $envVars = @{
        'ANTHROPIC_BASE_URL' = $BaseUrl
        'ANTHROPIC_AUTH_TOKEN' = $ApiKey
        'ANTHROPIC_MODEL' = $Model
        'ANTHROPIC_DEFAULT_OPUS_MODEL' = $Model
        'ANTHROPIC_DEFAULT_SONNET_MODEL' = $Model
        'ANTHROPIC_DEFAULT_HAIKU_MODEL' = $HaikuModel
        'CLAUDE_CODE_SUBAGENT_MODEL' = $HaikuModel
        'CLAUDE_CODE_EFFORT_LEVEL' = 'max'
    }
    
    if ($ProviderName -match 'MIMO') {
        $envVars['CLAUDE_CONTEXT_CAPACITY_OVERRIDE'] = '1000000'
        $envVars['CLAUDE_AUTOCOMPACT_PCT_OVERRIDE'] = '100'
    }

    foreach ($var in $envVars.GetEnumerator()) {
        $result = setx $var.Key $var.Value 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK] $($var.Key)" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] $($var.Key)" -ForegroundColor Red
        }
    }

    return $true
}

function Handle-MimoConfig {
    param([string]$Type)
    
    if ($Type -eq 'Plan') {
        $baseUrl = 'https://token-plan-cn.xiaomimimo.com/anthropic'
        $providerName = 'MIMO 套餐计费'
    } else {
        $baseUrl = 'https://api.xiaomimimo.com/anthropic'
        $providerName = 'MIMO 按量计费'
    }
    
    $apiKey = Get-SecureApiKey -ProviderName $providerName

    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Host ''
        Write-Host '错误: API 密钥不能为空' -ForegroundColor Red
        return $false
    }

    $isValid = Test-ApiKey -BaseUrl $baseUrl -ApiKey $apiKey -Model 'mimo-v2.5-pro'
    if (-not $isValid) {
        $force = Read-Host '验证失败。是否强制应用配置? (Y/N)'
        if ($force -notmatch '^[Yy]$') {
            return $false
        }
    }

    return Set-ApiConfig -ProviderName $providerName -BaseUrl $baseUrl -Model 'mimo-v2.5-pro' -HaikuModel 'mimo-v2.5' -ApiKey $apiKey
}

function Handle-DeepSeekConfig {
    $providerName = 'DeepSeek'
    $baseUrl = 'https://api.deepseek.com/anthropic'
    
    $apiKey = Get-SecureApiKey -ProviderName $providerName

    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Host ''
        Write-Host '错误: API 密钥不能为空' -ForegroundColor Red
        return $false
    }

    $isValid = Test-ApiKey -BaseUrl $baseUrl -ApiKey $apiKey -Model 'deepseek-v4-pro[1m]'
    if (-not $isValid) {
        $force = Read-Host '验证失败。是否强制应用配置? (Y/N)'
        if ($force -notmatch '^[Yy]$') {
            return $false
        }
    }

    return Set-ApiConfig -ProviderName $providerName -BaseUrl $baseUrl -Model 'deepseek-v4-pro[1m]' -HaikuModel 'deepseek-v4-flash' -ApiKey $apiKey
}

function Show-Result {
    param([bool]$Success, [string]$ProviderName)

    Write-Host ''
    Write-Host '=================================' -ForegroundColor Cyan

    if ($Success) {
        Write-Host '  配置完成!' -ForegroundColor Green
        Write-Host '=================================' -ForegroundColor Cyan
        Write-Host ''
        Write-Host "已配置 $ProviderName 环境变量" -ForegroundColor Yellow
        Write-Host ''
        Write-Host '重要提示:' -ForegroundColor Red
        Write-Host '  1. 需要重启终端才能生效' -ForegroundColor White
        Write-Host '  2. 验证命令: Get-ChildItem Env:ANTHROPIC*' -ForegroundColor White
        Write-Host ''
    } else {
        Write-Host '  配置未完成' -ForegroundColor Red
        Write-Host '=================================' -ForegroundColor Cyan
        Write-Host ''
    }
}

# 主程序
do {
    Show-Menu
    $choice = Read-Host '请输入选项 (1, 2, 3, Q)'

    switch ($choice) {
        '1' {
            $success = Handle-MimoConfig -Type 'Plan'
            Show-Result -Success $success -ProviderName "MIMO 套餐计费 API"
            break
        }
        '2' {
            $success = Handle-MimoConfig -Type 'Pay'
            Show-Result -Success $success -ProviderName "MIMO 按量计费 API"
            break
        }
        '3' {
            $success = Handle-DeepSeekConfig
            Show-Result -Success $success -ProviderName "DeepSeek API"
            break
        }
        'Q' {
            Write-Host ''
            Write-Host '退出配置工具' -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Host ''
            Write-Host '无效选项，请重新选择' -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }

    if ($choice -match '^[123]$') {
        Write-Host ''
        $continue = Read-Host '按 Enter 返回主菜单，输入 Q 退出'
        if ($continue -eq 'Q') {
            Write-Host ''
            Write-Host '退出配置工具' -ForegroundColor Cyan
            exit 0
        }
    }

} while ($true)