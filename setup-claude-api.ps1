# Claude Code API 配置脚本 / Config Script
# 用于自动化设置 Claude Code 的 API 环境变量 / For automating Claude Code API environment variables

param(
    [switch]$Help
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$global:Lang = 'zh'

function L {
    param([string]$zh, [string]$en)
    if ($global:Lang -eq 'en' -and -not [string]::IsNullOrWhiteSpace($en)) { return $en }
    return $zh
}

if ($Help) {
    Write-Host (L 'Claude Code API 配置脚本' 'Claude Code API Config Script')
    Write-Host ''
    Write-Host (L '用法: .\setup-claude-api.ps1' 'Usage: .\setup-claude-api.ps1')
    Write-Host ''
    Write-Host (L '功能:' 'Features:')
    Write-Host (L '  - 检测 Claude Code 是否已安装' '  - Detect if Claude Code is installed')
    Write-Host (L '  - 交互式选择 API 提供商 (MIMO 套餐/按量计费，或 DeepSeek)' '  - Interactive API provider selection (MIMO Plan/Pay-as-you-go, or DeepSeek)')
    Write-Host (L '  - 发送测试请求验证 API 密钥' '  - Send test request to verify API key')
    Write-Host (L '  - 安全输入 API 密钥' '  - Secure API key input')
    Write-Host (L '  - 自动设置环境变量' '  - Automatically set environment variables')
    Write-Host ''
    Write-Host (L '注意: 设置完成后需要重启终端才能生效' 'Note: You must restart the terminal after configuration to take effect')
    exit 0
}

Write-Host "Please select language / 请选择语言:" -ForegroundColor Cyan
Write-Host "  [1] 简体中文 (默认/Default)" -ForegroundColor Green
Write-Host "  [2] English" -ForegroundColor Green
$langChoice = Read-Host "Input option / 请输入选项 (1/2)"
if ($langChoice -eq '2') {
    $global:Lang = 'en'
}

function Check-ClaudeCode {
    if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
        Write-Host '=================================' -ForegroundColor Red
        Write-Host (L '提示: 未检测到 Claude Code (claude)' 'Hint: Claude Code (claude) not detected') -ForegroundColor Yellow
        Write-Host '=================================' -ForegroundColor Red
        Write-Host ''
        $install = Read-Host (L '是否现在自动安装 Claude Code? (Y/N)' 'Automatically install Claude Code now? (Y/N)')
        if ($install -match '^[Yy]$') {
            # 检查 npm 是否存在
            if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
                Write-Host ''
                Write-Host (L '错误: 未检测到 npm，无法安装 Claude Code。' 'Error: npm not detected, cannot install Claude Code.') -ForegroundColor Red
                $installNode = Read-Host (L '是否现在通过 winget 自动安装 Node.js (包含 npm)? (Y/N)' 'Automatically install Node.js (with npm) via winget now? (Y/N)')
                if ($installNode -match '^[Yy]$') {
                    Write-Host ''
                    Write-Host (L '正在启动 winget 安装 Node.js...' 'Starting winget to install Node.js...') -ForegroundColor Cyan
                    winget install OpenJS.NodeJS
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host ''
                        Write-Host (L 'Node.js 安装请求已发送。' 'Node.js installation request sent.') -ForegroundColor Green
                        Write-Host (L '重要: 请在安装完成后【重启终端】, 然后重新运行此脚本。' 'IMPORTANT: After installation completes, [RESTART TERMINAL], then run this script again.') -ForegroundColor Yellow
                        Read-Host (L '按回车键退出...' 'Press Enter to exit...')
                        exit 0
                    } else {
                        Write-Host (L 'winget 安装失败。请手动前往 https://nodejs.org 安装。' 'winget installation failed. Please manually install from https://nodejs.org.') -ForegroundColor Red
                    }
                }
                exit 1
            }

            Write-Host ''
            Write-Host (L '正在通过 npm 安装 @anthropic-ai/claude-code...' 'Installing @anthropic-ai/claude-code via npm...') -ForegroundColor Cyan
            Write-Host (L '这可能需要一两分钟，请稍候...' 'This may take a minute or two, please wait...') -ForegroundColor Gray
            
            npm install -g @anthropic-ai/claude-code
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host ''
                Write-Host (L 'Claude Code 安装成功！' 'Claude Code successfully installed!') -ForegroundColor Green
                Start-Sleep -Seconds 1
            } else {
                Write-Host ''
                Write-Host (L '安装失败，请尝试以管理员权限运行终端，或检查网络连接。' 'Installation failed. Try running terminal as Administrator, or check network.') -ForegroundColor Red
                $continue = Read-Host (L '是否仍要继续配置环境变量? (Y/N)' 'Continue configuring environment variables anyway? (Y/N)')
                if ($continue -notmatch '^[Yy]$') {
                    exit 1
                }
            }
        } else {
            $continue = Read-Host (L '是否仍要继续配置环境变量? (Y/N)' 'Continue configuring environment variables anyway? (Y/N)')
            if ($continue -notmatch '^[Yy]$') {
                Write-Host (L '操作已取消。' 'Operation cancelled.') -ForegroundColor Cyan
                exit 1
            }
        }
    } else {
        $version = claude --version
        Write-Host (L "检测到 Claude Code: $version" "Detected Claude Code: $version") -ForegroundColor Green
        Write-Host ''
    }
}

function Show-Menu {
    Clear-Host
    Check-ClaudeCode
    
    Write-Host '=================================' -ForegroundColor Cyan
    Write-Host (L '  Claude Code API 配置工具' '  Claude Code API Config Tool') -ForegroundColor Cyan
    Write-Host '=================================' -ForegroundColor Cyan
    Write-Host ''
    Write-Host (L '请选择 API 提供商:' 'Please select API provider:') -ForegroundColor Yellow
    Write-Host ''
    Write-Host (L '  [1] MIMO API (套餐计费 - Plan)' '  [1] MIMO API (Plan)') -ForegroundColor Green
    Write-Host (L '  [2] MIMO API (按量计费 - Pay-as-you-go)' '  [2] MIMO API (Pay-as-you-go)') -ForegroundColor Green
    Write-Host (L '  [3] DeepSeek API' '  [3] DeepSeek API') -ForegroundColor Green
    Write-Host (L '  [Q] 退出' '  [Q] Exit') -ForegroundColor Red
    Write-Host ''
}

function Get-SecureApiKey {
    param([string]$ProviderName)

    Write-Host ''
    Write-Host (L "请输入 $ProviderName API 密钥:" "Please enter $ProviderName API Key:") -ForegroundColor Yellow
    Write-Host (L '(输入时不会显示字符，按回车确认)' '(Characters will be hidden during input, press Enter to confirm)') -ForegroundColor Gray

    $secureKey = Read-Host -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
    $apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

    return $apiKey
}

function Test-ApiKey {
    param([string]$BaseUrl, [string]$ApiKey, [string]$Model)
    
    Write-Host ''
    Write-Host (L '正在验证 API 密钥，请稍候...' 'Verifying API Key, please wait...') -ForegroundColor Cyan
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
        Write-Host (L 'API 密钥验证成功！' 'API Key verification successful!') -ForegroundColor Green
        return $true
    } catch {
        Write-Host (L 'API 密钥验证失败！' 'API Key verification failed!') -ForegroundColor Red
        if ($_.ErrorDetails) {
            Write-Host (L "详细信息: $($_.ErrorDetails.Message)" "Details: $($_.ErrorDetails.Message)") -ForegroundColor Red
        } else {
            Write-Host (L "错误: $($_.Exception.Message)" "Error: $($_.Exception.Message)") -ForegroundColor Red
        }
        return $false
    }
}

function Set-ApiConfig {
    param(
        [string]$ProviderName,
        [string]$BaseUrl,
        [string]$OpusModel,
        [string]$SonnetModel,
        [string]$HaikuModel,
        [string]$SubagentModel,
        [string]$ApiKey
    )

    Write-Host ''
    Write-Host (L "正在配置 $ProviderName API..." "Configuring $ProviderName API...") -ForegroundColor Cyan

    $envVars = @{
        'ANTHROPIC_BASE_URL' = $BaseUrl
        'ANTHROPIC_AUTH_TOKEN' = $ApiKey
        'ANTHROPIC_MODEL' = $OpusModel
        'ANTHROPIC_DEFAULT_OPUS_MODEL' = $OpusModel
        'ANTHROPIC_DEFAULT_SONNET_MODEL' = $SonnetModel
        'ANTHROPIC_DEFAULT_HAIKU_MODEL' = $HaikuModel
        'CLAUDE_CODE_SUBAGENT_MODEL' = $SubagentModel
        'CLAUDE_CODE_EFFORT_LEVEL' = 'max'
    }
    
    if ($ProviderName -match 'MIMO') {
        $envVars['CLAUDE_AUTOCOMPACT_PCT_OVERRIDE'] = '80'
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
        Write-Host ''
        Write-Host (L '请选择 MIMO 套餐计费集群地区:' 'Please select MIMO Plan cluster region:') -ForegroundColor Yellow
        Write-Host (L '  [1] 中国集群 (默认)' '  [1] China Cluster (Default)') -ForegroundColor Green
        Write-Host (L '  [2] 新加坡集群' '  [2] Singapore Cluster') -ForegroundColor Green
        Write-Host (L '  [3] 欧洲集群' '  [3] Europe Cluster') -ForegroundColor Green
        
        $regionChoice = Read-Host (L '请输入选项 (1, 2, 3)' 'Enter option (1, 2, 3)')
        switch ($regionChoice) {
            '2' { $baseUrl = 'https://token-plan-sgp.xiaomimimo.com/anthropic'; $providerName = (L 'MIMO 套餐计费 (新加坡)' 'MIMO Plan (Singapore)') }
            '3' { $baseUrl = 'https://token-plan-ams.xiaomimimo.com/anthropic'; $providerName = (L 'MIMO 套餐计费 (欧洲)' 'MIMO Plan (Europe)') }
            default { $baseUrl = 'https://token-plan-cn.xiaomimimo.com/anthropic'; $providerName = (L 'MIMO 套餐计费 (中国)' 'MIMO Plan (China)') }
        }
    } else {
        $baseUrl = 'https://api.xiaomimimo.com/anthropic'
        $providerName = (L 'MIMO 按量计费' 'MIMO Pay-as-you-go')
    }
    
    $apiKey = Get-SecureApiKey -ProviderName $providerName

    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Host ''
        Write-Host (L '错误: API 密钥不能为空' 'Error: API Key cannot be empty') -ForegroundColor Red
        return $false
    }

    $isValid = Test-ApiKey -BaseUrl $baseUrl -ApiKey $apiKey -Model 'mimo-v2.5-pro'
    if (-not $isValid) {
        $force = Read-Host (L '验证失败。是否强制应用配置? (Y/N)' 'Verification failed. Force apply configuration? (Y/N)')
        if ($force -notmatch '^[Yy]$') {
            return $false
        }
    }

    return Set-ApiConfig -ProviderName $providerName -BaseUrl $baseUrl -OpusModel 'mimo-v2.5-pro[1m]' -SonnetModel 'mimo-v2.5-pro' -HaikuModel 'mimo-v2.5[1m]' -SubagentModel 'mimo-v2.5' -ApiKey $apiKey
}

function Handle-DeepSeekConfig {
    $providerName = 'DeepSeek'
    $baseUrl = 'https://api.deepseek.com/anthropic'
    
    $apiKey = Get-SecureApiKey -ProviderName $providerName

    if ([string]::IsNullOrWhiteSpace($apiKey)) {
        Write-Host ''
        Write-Host (L '错误: API 密钥不能为空' 'Error: API Key cannot be empty') -ForegroundColor Red
        return $false
    }

    $isValid = Test-ApiKey -BaseUrl $baseUrl -ApiKey $apiKey -Model 'deepseek-v4-pro'
    if (-not $isValid) {
        $force = Read-Host (L '验证失败。是否强制应用配置? (Y/N)' 'Verification failed. Force apply configuration? (Y/N)')
        if ($force -notmatch '^[Yy]$') {
            return $false
        }
    }

    return Set-ApiConfig -ProviderName $providerName -BaseUrl $baseUrl -OpusModel 'deepseek-v4-pro[1m]' -SonnetModel 'deepseek-v4-pro' -HaikuModel 'deepseek-v4-flash[1m]' -SubagentModel 'deepseek-v4-flash' -ApiKey $apiKey
}

function Show-Result {
    param([bool]$Success, [string]$ProviderName)

    Write-Host ''
    Write-Host '=================================' -ForegroundColor Cyan

    if ($Success) {
        Write-Host (L '  配置完成!' '  Configuration Complete!') -ForegroundColor Green
        Write-Host '=================================' -ForegroundColor Cyan
        Write-Host ''
        Write-Host (L "已配置 $ProviderName 环境变量" "Configured environment variables for $ProviderName") -ForegroundColor Yellow
        Write-Host ''
        Write-Host (L '重要提示:' 'IMPORTANT:') -ForegroundColor Red
        Write-Host (L '  1. 需要重启终端才能生效' '  1. You must restart the terminal for changes to take effect') -ForegroundColor White
        Write-Host (L '  2. 验证命令: Get-ChildItem Env:ANTHROPIC*' '  2. Verification command: Get-ChildItem Env:ANTHROPIC*') -ForegroundColor White
        Write-Host ''
    } else {
        Write-Host (L '  配置未完成' '  Configuration Incomplete') -ForegroundColor Red
        Write-Host '=================================' -ForegroundColor Cyan
        Write-Host ''
    }
}

# 主程序
do {
    Show-Menu
    $choice = Read-Host (L '请输入选项 (1, 2, 3, Q)' 'Enter option (1, 2, 3, Q)')

    switch ($choice) {
        '1' {
            $success = Handle-MimoConfig -Type 'Plan'
            Show-Result -Success $success -ProviderName (L "MIMO 套餐计费 API" "MIMO Plan API")
            break
        }
        '2' {
            $success = Handle-MimoConfig -Type 'Pay'
            Show-Result -Success $success -ProviderName (L "MIMO 按量计费 API" "MIMO Pay-as-you-go API")
            break
        }
        '3' {
            $success = Handle-DeepSeekConfig
            Show-Result -Success $success -ProviderName "DeepSeek API"
            break
        }
        { $_ -match '^[Qq]$' } {
            Write-Host ''
            Write-Host (L '退出配置工具' 'Exiting config tool') -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Host ''
            Write-Host (L '无效选项，请重新选择' 'Invalid option, please try again') -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }

    if ($choice -match '^[123]$') {
        Write-Host ''
        $continue = Read-Host (L '按 Enter 返回主菜单，输入 Q 退出' 'Press Enter to return to main menu, or Q to exit')
        if ($continue -match '^[Qq]$') {
            Write-Host ''
            Write-Host (L '退出配置工具' 'Exiting config tool') -ForegroundColor Cyan
            exit 0
        }
    }

} while ($true)