# Security Policy

## Supported Versions

Only the latest version of this tool is supported. Please ensure you are using the most recent release.

## Reporting a Vulnerability

If you discover a security vulnerability within this project, please report it by opening an issue. Since this is a local configuration tool and does not run a server or handle remote data, most security concerns would likely involve local environment variable management.

### Note on API Keys
This script handles API keys. It uses `Read-Host -AsSecureString` to prevent keys from being echoed to the console during input. However, once set, these keys are stored in your Windows User Environment Variables. Anyone with access to your local user account can read these variables.
