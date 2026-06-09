#!/bin/bash
# Claude Code API 配置脚本 / Config Script
# 用于自动化设置 Claude Code 的 API 环境变量 / For automating Claude Code API environment variables


# 颜色定义 / Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 语言设置 / Language setting
LANG_CODE='zh'

# 国际化函数 / Internationalization function
L() {
    local zh="$1"
    local en="$2"
    if [[ "$LANG_CODE" == "en" && -n "$en" ]]; then
        echo "$en"
    else
        echo "$zh"
    fi
}

# 显示帮助 / Show help
show_help() {
    echo "$(L 'Claude Code API 配置脚本' 'Claude Code API Config Script')"
    echo ""
    echo "$(L '用法: ./setup-claude-api.sh' 'Usage: ./setup-claude-api.sh')"
    echo ""
    echo "$(L '功能:' 'Features:')"
    echo "$(L '  - 检测 Claude Code 是否已安装' '  - Detect if Claude Code is installed')"
    echo "$(L '  - 交互式选择 API 提供商 (MIMO 套餐/按量计费，或 DeepSeek)' '  - Interactive API provider selection (MIMO Plan/Pay-as-you-go, or DeepSeek)')"
    echo "$(L '  - 发送测试请求验证 API 密钥' '  - Send test request to verify API key')"
    echo "$(L '  - 安全输入 API 密钥' '  - Secure API key input')"
    echo "$(L '  - 自动设置环境变量' '  - Automatically set environment variables')"
    echo ""
    echo "$(L '注意: 设置完成后需要重启终端才能生效' 'Note: You must restart the terminal after configuration to take effect')"
    exit 0
}

# 检查参数 / Check arguments
if [[ "$1" == "-h" || "$1" == "--help" || "$1" == "help" ]]; then
    show_help
fi

# 语言选择 / Language selection
echo -e "${CYAN}Please select language / 请选择语言:${NC}"
echo -e "${GREEN}  [1] 简体中文 (默认/Default)${NC}"
echo -e "${GREEN}  [2] English${NC}"
read -p "Input option / 请输入选项 (1/2, 默认1): " lang_choice
if [[ -z "$lang_choice" ]]; then
    lang_choice="1"
fi
if [[ "$lang_choice" == "2" ]]; then
    LANG_CODE='en'
fi

# 检测 Claude Code / Check Claude Code
check_claude_code() {
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}=================================${NC}"
        echo -e "${YELLOW}$(L '提示: 未检测到 Claude Code (claude)' 'Hint: Claude Code (claude) not detected')${NC}"
        echo -e "${RED}=================================${NC}"
        echo ""
        read -p "$(L '是否现在自动安装 Claude Code? (Y/N) ' 'Automatically install Claude Code now? (Y/N) ')" install
        if [[ "$install" =~ ^[Yy]$ ]]; then
            # 检查 npm / Check npm
            if ! command -v npm &> /dev/null; then
                echo ""
                echo -e "${RED}$(L '错误: 未检测到 npm，无法安装 Claude Code。' 'Error: npm not detected, cannot install Claude Code.')${NC}"
                read -p "$(L '是否现在自动安装 Node.js (包含 npm)? (Y/N) ' 'Automatically install Node.js (with npm) now? (Y/N) ')" install_node
                if [[ "$install_node" =~ ^[Yy]$ ]]; then
                    echo ""
                    echo -e "${CYAN}$(L '正在尝试安装 Node.js...' 'Attempting to install Node.js...')${NC}"
                    # 尝试使用不同的包管理器 / Try different package managers
                    if command -v apt-get &> /dev/null; then
                        sudo apt-get update && sudo apt-get install -y nodejs npm
                    elif command -v yum &> /dev/null; then
                        sudo yum install -y nodejs npm
                    elif command -v dnf &> /dev/null; then
                        sudo dnf install -y nodejs npm
                    elif command -v pacman &> /dev/null; then
                        sudo pacman -S --noconfirm nodejs npm
                    elif command -v brew &> /dev/null; then
                        brew install node
                    else
                        echo -e "${RED}$(L '无法自动安装 Node.js，请手动安装。' 'Cannot auto-install Node.js, please install manually.')${NC}"
                        echo -e "${YELLOW}$(L '请访问 https://nodejs.org 下载安装' 'Please visit https://nodejs.org to download')${NC}"
                        exit 1
                    fi
                    if [[ $? -eq 0 ]]; then
                        echo ""
                        echo -e "${GREEN}$(L 'Node.js 安装成功！' 'Node.js installed successfully!')${NC}"
                        echo -e "${YELLOW}$(L '重要: 请重启终端，然后重新运行此脚本。' 'IMPORTANT: Please restart terminal, then run this script again.')${NC}"
                        read -p "$(L '按回车键退出...' 'Press Enter to exit...')"
                        exit 0
                    else
                        echo -e "${RED}$(L '安装失败，请手动安装 Node.js。' 'Installation failed, please install Node.js manually.')${NC}"
                    fi
                fi
                exit 1
            fi

            echo ""
            echo -e "${CYAN}$(L '正在通过 npm 安装 @anthropic-ai/claude-code...' 'Installing @anthropic-ai/claude-code via npm...')${NC}"
            echo -e "${GRAY}$(L '这可能需要一两分钟，请稍候...' 'This may take a minute or two, please wait...')${NC}"

            npm install -g @anthropic-ai/claude-code

            if [[ $? -eq 0 ]]; then
                echo ""
                echo -e "${GREEN}$(L 'Claude Code 安装成功！' 'Claude Code installed successfully!')${NC}"
                sleep 1
            else
                echo ""
                echo -e "${RED}$(L '安装失败，请尝试使用 sudo 运行，或检查网络连接。' 'Installation failed. Try running with sudo, or check network.')${NC}"
                read -p "$(L '是否仍要继续配置环境变量? (Y/N) ' 'Continue configuring environment variables anyway? (Y/N) ')" choice_continue
                if [[ ! "$choice_continue" =~ ^[Yy]$ ]]; then
                    exit 1
                fi
            fi
        else
            read -p "$(L '是否仍要继续配置环境变量? (Y/N) ' 'Continue configuring environment variables anyway? (Y/N) ')" choice_continue
            if [[ ! "$choice_continue" =~ ^[Yy]$ ]]; then
                echo -e "${CYAN}$(L '操作已取消。' 'Operation cancelled.')${NC}"
                exit 1
            fi
        fi
    else
        version=$(claude --version 2>/dev/null || echo "unknown")
        echo -e "${GREEN}$(L "检测到 Claude Code: $version" "Detected Claude Code: $version")${NC}"
        echo ""
    fi
}

# 显示菜单 / Show menu
show_menu() {
    clear
    check_claude_code

    echo -e "${CYAN}=================================${NC}"
    echo -e "${CYAN}  $(L 'Claude Code API 配置工具' 'Claude Code API Config Tool')${NC}"
    echo -e "${CYAN}=================================${NC}"
    echo ""
    echo -e "${YELLOW}$(L '请选择 API 提供商:' 'Please select API provider:')${NC}"
    echo ""
    echo -e "${GREEN}  [1] MIMO API ($(L '套餐计费' 'Plan'))${NC}"
    echo -e "${GREEN}  [2] MIMO API ($(L '按量计费' 'Pay-as-you-go'))${NC}"
    echo -e "${GREEN}  [3] DeepSeek API${NC}"
    echo -e "${RED}  [Q] $(L '退出' 'Exit')${NC}"
    echo ""
}

# 安全输入 API 密钥 / Secure API key input
get_secure_api_key() {
    local provider_name="$1"
    local var_name="$2"
    echo ""
    echo -e "${YELLOW}$(L "请输入 $provider_name API 密钥:" "Please enter $provider_name API Key:")${NC}"
    echo -e "${GRAY}$(L '(注意：输入或粘贴时屏幕上【不会显示任何字符或星号】，直接输入并按回车确认即可)' '(Note: Nothing will be displayed on screen, including asterisks. Type/paste and press Enter to confirm)')${NC}"
    read -s "$var_name"
    echo ""
}

# 验证 API 密钥 / Validate API key
test_api_key() {
    local base_url="$1"
    local api_key="$2"
    local model="$3"
    local provider_name="$4"

    if ! command -v curl &> /dev/null; then
        echo -e "${RED}$(L '错误: 未检测到 curl 命令，无法进行 API 密钥验证。' 'Error: curl command not detected, cannot verify API key.')${NC}"
        return 1
    fi

    echo ""
    echo -e "${CYAN}$(L '正在验证 API 密钥，请稍候...' 'Verifying API Key, please wait...')${NC}"
    local endpoint="$base_url/v1/messages"
    local body=$(cat <<EOF
{
    "model": "$model",
    "max_tokens": 10,
    "messages": [
        {"role": "user", "content": "hello"}
    ]
}
EOF
)

    local response
    local http_code
    if [[ "$provider_name" =~ MIMO ]]; then
        response=$(curl -s -w "\n%{http_code}" -X POST "$endpoint" \
            -H "api-key: $api_key" \
            -H "Content-Type: application/json" \
            -d "$body" 2>&1)
    else
        response=$(curl -s -w "\n%{http_code}" -X POST "$endpoint" \
            -H "x-api-key: $api_key" \
            -H "anthropic-version: 2023-06-01" \
            -H "Content-Type: application/json" \
            -d "$body" 2>&1)
    fi

    http_code=$(echo "$response" | tail -n1)
    local body_response=$(echo "$response" | sed '$d')

    if [[ "$http_code" == "200" ]] || [[ "$http_code" == "201" ]]; then
        echo -e "${GREEN}$(L 'API 密钥验证成功！' 'API Key verification successful!')${NC}"
        return 0
    else
        echo -e "${RED}$(L 'API 密钥验证失败！' 'API Key verification failed!')${NC}"
        # 尝试提取错误信息 / Try to extract error message
        local error_msg=$(echo "$body_response" | grep -o '"message":"[^"]*"' | head -1 | cut -d'"' -f4)
        if [[ -n "$error_msg" ]]; then
            echo -e "${RED}$(L "详细信息: $error_msg" "Details: $error_msg")${NC}"
        else
            case "$http_code" in
                [0-9][0-9][0-9])
                    echo -e "${RED}$(L "HTTP 状态码: $http_code" "HTTP Status: $http_code")${NC}"
                    ;;
                *)
                    echo -e "${RED}$(L "连接失败: $http_code" "Connection failed: $http_code")${NC}"
                    ;;
            esac
        fi
        return 1
    fi
}

# 写入环境变量到配置文件 / Write env vars to config files
write_env_to_file() {
    local file="$1"
    local var_name="$2"
    local var_value="$3"

    # 删除已有的同名变量 / Remove existing variable
    if [[ -f "$file" ]]; then
        local temp_file
        temp_file=$(mktemp)
        grep -v "^export ${var_name}=" "$file" > "$temp_file" || true
        cat "$temp_file" > "$file"
        rm -f "$temp_file"
    fi

    # 追加新变量 / Append new variable
    echo "export ${var_name}=\"${var_value}\"" >> "$file"
}

# 获取系统中相关的环境变量 / Get related env vars in current session and files
get_claude_env_vars() {
    local config_files=()
    [[ -f "$HOME/.bashrc" ]] && config_files+=("$HOME/.bashrc")
    [[ -f "$HOME/.zshrc" ]] && config_files+=("$HOME/.zshrc")
    
    local file_vars=""
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            local lines
            lines=$(grep -oE '^export [A-Za-z0-9_]+' "$config_file" 2>/dev/null | cut -d' ' -f2 || true)
            file_vars="${file_vars}${lines}"$'\n'
        fi
    done

    local env_vars
    env_vars=$(env | cut -d'=' -f1 || true)
    
    local combined
    combined=$(echo -e "${file_vars}\n${env_vars}" | sort -u)
    
    for v in $combined; do
        if [[ "$v" =~ ^(ANTHROPIC_|CLAUDE_|CLAUDE_CODE_|DISABLE_PROMPT_CACHING) ]]; then
            echo "$v"
        fi
    done
}

# 显示系统中相关的环境变量 / Show related env vars in current session and files
show_claude_env_vars() {
    local vars
    vars=$(get_claude_env_vars)
    echo ""
    echo -e "${CYAN}$(L '当前系统中 Claude Code 相关的环境变量:' 'Current Claude Code related environment variables:')${NC}"
    echo -e "${GRAY}-------------------------------------------${NC}"
    if [[ -z "$vars" ]]; then
        echo -e "  $(L '(未检测到)' '  (None detected)')"
    else
        for v in $vars; do
            # 从当前环境变量获取值，若为空则尝试从配置文件读取
            local val="${!v}"
            if [[ -z "$val" ]]; then
                for config_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
                    if [[ -f "$config_file" ]]; then
                        local extracted
                        extracted=$(grep -h "^export $v=" "$config_file" 2>/dev/null | head -1 | cut -d'"' -f2 | cut -d"'" -f2 || true)
                        if [[ -n "$extracted" ]]; then
                            val="$extracted"
                            break
                        fi
                    fi
                done
            fi
            # 缩短显示超长变量值
            local display="$val"
            if [[ ${#val} -gt 50 ]]; then
                display="${val:0:47}..."
            fi
            echo -e "  ${YELLOW}$v${NC} = $display"
        done
    fi
    echo -e "${GRAY}-------------------------------------------${NC}"
    local total_count=0
    if [[ -n "$vars" ]]; then
        total_count=$(echo "$vars" | wc -l | tr -d ' ')
    fi
    echo -e "${CYAN}$(L "共 $total_count 个相关变量" "Total: $total_count related variable(s)")${NC}"
}

# 清除系统中相关的环境变量 / Clear related env vars in current session and files
clear_claude_env_vars() {
    local vars
    vars=$(get_claude_env_vars)
    if [[ -z "$vars" ]]; then
        echo -e "  ${GRAY}$(L '没有需要清除的变量' 'No variables to clear')${NC}"
        return 0
    fi
    
    local count=0
    for v in $vars; do
        # 从当前会话中清除
        unset "$v"
        # 从配置文件中删除
        for config_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
            if [[ -f "$config_file" ]]; then
                local temp_file
                temp_file=$(mktemp)
                grep -v "^export $v=" "$config_file" > "$temp_file" || true
                cat "$temp_file" > "$config_file"
                rm -f "$temp_file"
            fi
        done
        echo -e "  ${GREEN}[OK]${NC} $v"
        count=$((count + 1))
    done
    echo -e "${GREEN}$(L "已清除 $count 个变量" "Cleared $count variable(s)")${NC}"
}

set_api_config() {
    local provider_name="$1"
    local base_url="$2"
    local opus_model="$3"
    local sonnet_model="$4"
    local haiku_model="$5"
    local subagent_model="$6"
    local api_key="$7"
    local is_mimo="$8"

    echo ""
    echo -e "${CYAN}$(L "正在配置 $provider_name API..." "Configuring $provider_name API...")${NC}"

    # 显示当前变量
    show_claude_env_vars

    # 选择安装模式
    echo ""
    echo -e "${YELLOW}$(L '请选择安装模式:' 'Please select install mode:')${NC}"
    echo -e "${GREEN}  [1] $(L '清洁安装（默认）- 清除所有相关变量后重新配置' 'Clean Install (Default) - Clear all related vars then configure')${NC}"
    echo -e "${GREEN}  [2] $(L '常规安装 - 仅覆盖写入以下变量' 'Normal Install - Only overwrite the following vars')${NC}"
    read -p "$(L '请输入选项 (1/2，默认1): ' 'Enter option (1/2, default 1): ')" install_mode
    if [[ -z "$install_mode" ]]; then
        install_mode="1"
    fi

    if [[ "$install_mode" == "2" ]]; then
        echo ""
        echo -e "${CYAN}$(L '常规安装模式：仅覆盖写入变量' 'Normal mode: only overwriting variables')${NC}"
    else
        echo ""
        echo -e "${CYAN}$(L '清洁安装模式：清除所有 Claude Code 相关变量' 'Clean mode: clearing all Claude Code related variables')${NC}"
        clear_claude_env_vars
    fi

    # 确定要写入的配置文件 / Determine config files to write
    local config_files=()
    [[ -f "$HOME/.bashrc" ]] && config_files+=("$HOME/.bashrc")
    [[ -f "$HOME/.zshrc" ]] && config_files+=("$HOME/.zshrc")

    # 如果都不存在，创建 .bashrc / If neither exists, create .bashrc
    if [[ ${#config_files[@]} -eq 0 ]]; then
        config_files+=("$HOME/.bashrc")
    fi

    # 确保文件存在并添加注释 / Ensure files exist and add comment
    for config_file in "${config_files[@]}"; do
        touch "$config_file"
        if ! grep -q "# Claude Code API Config" "$config_file" 2>/dev/null; then
            echo "" >> "$config_file"
            echo "# Claude Code API Config - Added by setup script" >> "$config_file"
        fi
    done

    # 辅助写入函数 / Helper function to apply variables
    apply_var() {
        local var_name="$1"
        local var_value="$2"
        for config_file in "${config_files[@]}"; do
            write_env_to_file "$config_file" "$var_name" "$var_value"
            echo -e "  ${GREEN}[OK]${NC} $var_name -> $config_file"
        done
        export "$var_name"="$var_value"
    }

    # 写入环境变量 / Apply environment variables
    apply_var "ANTHROPIC_BASE_URL" "$base_url"
    apply_var "ANTHROPIC_AUTH_TOKEN" "$api_key"
    apply_var "ANTHROPIC_MODEL" "$opus_model"
    apply_var "ANTHROPIC_DEFAULT_OPUS_MODEL" "$opus_model"
    apply_var "ANTHROPIC_DEFAULT_SONNET_MODEL" "$sonnet_model"
    apply_var "ANTHROPIC_DEFAULT_HAIKU_MODEL" "$haiku_model"
    apply_var "CLAUDE_CODE_SUBAGENT_MODEL" "$subagent_model"

    if [[ "$is_mimo" == "true" ]]; then
        apply_var "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE" "80"
    fi

    return 0
}

# 处理 MIMO 配置 / Handle MIMO config
handle_mimo_config() {
    local type="$1"

    if [[ "$type" == "Plan" ]]; then
        echo ""
        echo -e "${YELLOW}$(L '请选择 MIMO 套餐计费集群地区:' 'Please select MIMO Plan cluster region:')${NC}"
        echo -e "${GREEN}  [1] $(L '中国集群 (默认)' 'China Cluster (Default)')${NC}"
        echo -e "${GREEN}  [2] $(L '新加坡集群' 'Singapore Cluster')${NC}"
        echo -e "${GREEN}  [3] $(L '欧洲集群' 'Europe Cluster')${NC}"

        read -p "$(L '请输入选项 (1, 2, 3，默认1) ' 'Enter option (1, 2, 3, default 1) ')" region_choice
        if [[ -z "$region_choice" ]]; then
            region_choice="1"
        fi
        case "$region_choice" in
            2)
                base_url="https://token-plan-sgp.xiaomimimo.com/anthropic"
                provider_name="$(L 'MIMO 套餐计费 (新加坡)' 'MIMO Plan (Singapore)')"
                ;;
            3)
                base_url="https://token-plan-ams.xiaomimimo.com/anthropic"
                provider_name="$(L 'MIMO 套餐计费 (欧洲)' 'MIMO Plan (Europe)')"
                ;;
            *)
                base_url="https://token-plan-cn.xiaomimimo.com/anthropic"
                provider_name="$(L 'MIMO 套餐计费 (中国)' 'MIMO Plan (China)')"
                ;;
        esac
    else
        base_url="https://api.xiaomimimo.com/anthropic"
        provider_name="$(L 'MIMO 按量计费' 'MIMO Pay-as-you-go')"
    fi

    local api_key
    get_secure_api_key "$provider_name" api_key

    if [[ -z "$api_key" ]]; then
        echo ""
        echo -e "${RED}$(L '错误: API 密钥不能为空' 'Error: API Key cannot be empty')${NC}"
        return 1
    fi

    if ! test_api_key "$base_url" "$api_key" "mimo-v2.5-pro" "$provider_name"; then
        read -p "$(L '验证失败。是否强制应用配置? (Y/N) ' 'Verification failed. Force apply configuration? (Y/N) ')" force
        if [[ ! "$force" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi

    set_api_config "$provider_name" "$base_url" "mimo-v2.5-pro[1m]" "mimo-v2.5-pro" "mimo-v2.5[1m]" "mimo-v2.5" "$api_key" "true"
    return $?
}

# 处理 DeepSeek 配置 / Handle DeepSeek config
handle_deepseek_config() {
    provider_name="DeepSeek"
    base_url="https://api.deepseek.com/anthropic"

    local api_key
    get_secure_api_key "$provider_name" api_key

    if [[ -z "$api_key" ]]; then
        echo ""
        echo -e "${RED}$(L '错误: API 密钥不能为空' 'Error: API Key cannot be empty')${NC}"
        return 1
    fi

    if ! test_api_key "$base_url" "$api_key" "deepseek-v4-pro" "$provider_name"; then
        read -p "$(L '验证失败。是否强制应用配置? (Y/N) ' 'Verification failed. Force apply configuration? (Y/N) ')" force
        if [[ ! "$force" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi

    set_api_config "$provider_name" "$base_url" "deepseek-v4-pro[1m]" "deepseek-v4-pro" "deepseek-v4-flash[1m]" "deepseek-v4-flash" "$api_key" "false"
    return $?
}

# 显示结果 / Show result
show_result() {
    local success="$1"
    local provider_name="$2"

    echo ""
    echo -e "${CYAN}=================================${NC}"

    if [[ "$success" == "0" ]]; then
        echo -e "${GREEN}  $(L '配置完成!' 'Configuration Complete!')${NC}"
        echo -e "${CYAN}=================================${NC}"
        echo ""
        echo -e "${YELLOW}$(L "已配置 $provider_name 环境变量" "Configured environment variables for $provider_name")${NC}"
        echo ""
        echo -e "${RED}$(L '重要提示:' 'IMPORTANT:')${NC}"
        echo -e "${WHITE}  1. $(L '需要重启终端才能生效' 'You must restart the terminal for changes to take effect')${NC}"
        echo -e "${WHITE}  2. $(L '验证命令: env | grep ANTHROPIC' 'Verification command: env | grep ANTHROPIC')${NC}"
        echo ""
        echo -e "${GRAY}$(L '已写入配置文件:' 'Written to config files:')${NC}"
        [[ -f "$HOME/.bashrc" ]] && echo -e "${GRAY}  - ~/.bashrc${NC}"
        [[ -f "$HOME/.zshrc" ]] && echo -e "${GRAY}  - ~/.zshrc${NC}"
        echo ""
    else
        echo -e "${RED}  $(L '配置未完成' 'Configuration Incomplete')${NC}"
        echo -e "${CYAN}=================================${NC}"
        echo ""
    fi
}

# 主程序 / Main program
while true; do
    show_menu
    read -p "$(L '请输入选项 (1, 2, 3, Q，默认1) ' 'Enter option (1, 2, 3, Q, default 1) ')" choice
    if [[ -z "$choice" ]]; then
        choice="1"
    fi

    case "$choice" in
        1)
            handle_mimo_config "Plan"
            show_result "$?" "$(L 'MIMO 套餐计费 API' 'MIMO Plan API')"
            ;;
        2)
            handle_mimo_config "Pay"
            show_result "$?" "$(L 'MIMO 按量计费 API' 'MIMO Pay-as-you-go API')"
            ;;
        3)
            handle_deepseek_config
            show_result "$?" "DeepSeek API"
            ;;
        [Qq])
            echo ""
            echo -e "${CYAN}$(L '退出配置工具' 'Exiting config tool')${NC}"
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}$(L '无效选项，请重新选择' 'Invalid option, please try again')${NC}"
            sleep 1
            ;;
    esac

    if [[ "$choice" =~ ^[123]$ ]]; then
        echo ""
        read -p "$(L '按 Enter 返回主菜单，输入 Q 退出 ' 'Press Enter to return to main menu, or Q to exit ')" choice_continue
        if [[ "$choice_continue" =~ ^[Qq]$ ]]; then
            echo ""
            echo -e "${CYAN}$(L '退出配置工具' 'Exiting config tool')${NC}"
            exit 0
        fi
    fi
done
