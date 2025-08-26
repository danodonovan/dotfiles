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

# Load environment variables from 1Password
# Format: export VAR_NAME=$(op read "op://Vault/Item Name/field")

# API Keys
export OPENAI_API_KEY=$(op read "op://Private/OpenAI API Key/credential" 2>/dev/null)
export GEMINI_API_KEY=$(op read "op://Private/Gemini API Key/credential" 2>/dev/null)

# Database URLs (example)
# export DATABASE_URL=$(op read "op://Private/Database/url" 2>/dev/null)

# AWS/Cloud credentials (if not using SSO)
# export AWS_ACCESS_KEY_ID=$(op read "op://Private/AWS Personal/username" 2>/dev/null)
# export AWS_SECRET_ACCESS_KEY=$(op read "op://Private/AWS Personal/password" 2>/dev/null)

# GitHub/Git tokens
# export GITHUB_TOKEN=$(op read "op://Private/GitHub Personal Token/credential" 2>/dev/null)

# Slack/Discord webhooks
# export SLACK_WEBHOOK=$(op read "op://Private/Slack Webhook/url" 2>/dev/null)

# Custom application secrets
# export MY_APP_SECRET=$(op read "op://Private/My App/secret" 2>/dev/null)

# Only export variables that were successfully retrieved (not empty)
[[ -z "$OPENAI_API_KEY" ]] && unset OPENAI_API_KEY
[[ -z "$GEMINI_API_KEY" ]] && unset GEMINI_API_KEY