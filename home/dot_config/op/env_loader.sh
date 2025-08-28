#!/bin/bash
# 1Password CLI Environment Loader
# This script safely loads environment variables from 1Password

# Check if 1Password CLI is available and authenticated
if ! command -v op &> /dev/null; then
    echo "Warning: 1Password CLI (op) not found. Skipping secure env loading." >&2
    return 1
fi

# Check if authenticated
if ! op account get &> /dev/null; then
    echo "Warning: Not authenticated with 1Password CLI. Run 'op signin' first." >&2
    return 1
fi

# Load environment variables from 1Password using op inject
# This approach is more efficient than individual op read calls

# Create a template with environment variables
cat <<'EOF' | op inject --force 2>/dev/null | source /dev/stdin
# API Keys
export OPENAI_API_KEY='op://Private/OpenAI API Key/credential'
export GEMINI_API_KEY='op://Private/Gemini API Key/credential'

# Personal Information  
export GIT_USER_EMAIL='op://Private/Git Configuration/email'
export GIT_USER_NAME='op://Private/Git Configuration/name'
export GIT_SIGNING_KEY='op://Private/Git SSH Signing Key/public key'

# Database URLs (example)
# export DATABASE_URL='op://Private/Database/url'

# AWS/Cloud credentials (if not using SSO)
# export AWS_ACCESS_KEY_ID='op://Private/AWS Personal/username'
# export AWS_SECRET_ACCESS_KEY='op://Private/AWS Personal/password'

# GitHub/Git tokens
# export GITHUB_TOKEN='op://Private/GitHub Personal Token/credential'

# Slack/Discord webhooks
# export SLACK_WEBHOOK='op://Private/Slack Webhook/url'

# Custom application secrets
# export MY_APP_SECRET='op://Private/My App/secret'
EOF
