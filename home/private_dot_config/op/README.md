# 1Password CLI Environment Management

This directory contains scripts for securely managing environment variables using 1Password CLI.

## Setup

1. **Install 1Password CLI**:
   ```bash
   brew install --cask 1password-cli
   ```

2. **Sign in to 1Password**:
   ```bash
   op signin
   ```

3. **Store your secrets in 1Password**:
   - Create items in your vault (e.g., "OpenAI API Key", "Gemini API Key")
   - Use the "Password" or "Credential" field for the secret value
   - Note the vault name and item name for reference

## Usage

The `env_loader.sh` script is automatically sourced by your shell profile and will:
- Check if 1Password CLI is available and authenticated
- Load environment variables from your vault
- Gracefully handle missing or inaccessible secrets

## Adding New Secrets

1. **Store in 1Password**:
   ```bash
   # Interactive creation
   op item create --category=login --title="My App Secret" \
     --vault="Private" credential="your-secret-value"
   
   # Or use the 1Password app GUI
   ```

2. **Add to env_loader.sh**:
   ```bash
   export MY_SECRET=$(op read "op://Private/My App Secret/credential" 2>/dev/null)
   [[ -z "$MY_SECRET" ]] && unset MY_SECRET
   ```

## Reference Format

1Password CLI uses this format for item references:
```
op://VaultName/ItemName/FieldName
```

Examples:
- `op://Private/OpenAI API Key/credential`
- `op://Work/Database/username`
- `op://Work/Database/password`

## Security Benefits

✅ **No secrets in git history**
✅ **Centralized secret management**
✅ **Easy rotation and sharing**
✅ **Audit trail in 1Password**
✅ **Graceful degradation if unavailable**

## Troubleshooting

- **Not authenticated**: Run `op signin` 
- **Item not found**: Check vault name and item title
- **Permission denied**: Ensure you have access to the vault
- **Slow shell startup**: Consider caching or lazy loading for many secrets