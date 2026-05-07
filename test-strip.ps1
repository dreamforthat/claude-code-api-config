$url = "https://raw.githubusercontent.com/dreamforthat/claude-code-api-config/main/setup-claude-api.ps1"
iex ((irm $url) -replace '^\uFEFF', '')