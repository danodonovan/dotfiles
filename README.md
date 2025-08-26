# Dan's Dotfiles

A comprehensive dotfiles setup managed by [chezmoi](https://chezmoi.io) with secure secret management via 1Password CLI.

## 🚀 Quick Start

### Bootstrap on a new machine

```bash
# Install chezmoi and apply dotfiles in one command
chezmoi init --apply danodonovan/dotfiles
```

### Or step by step

```bash
# Install chezmoi first
brew install chezmoi  # macOS
# sudo snap install chezmoi  # Linux

# Initialize and apply
chezmoi init danodonovan/dotfiles
chezmoi apply
```

## 📁 What's Included

### Shell Configuration
- **zsh**: Oh My Zsh with Spaceship theme, custom aliases, and plugins
- **bash**: Backup bash configuration
- **aliases**: Comprehensive aliases for development tools

### Development Tools
- **git**: Advanced git configuration with SSH signing via 1Password
- **vim/nvim**: Neovim configuration with plugins and themes
- **tmux**: Terminal multiplexer configuration
- **python**: pyenv integration and IPython customization

### Security & Secrets
- **1Password CLI**: Secure environment variable management
- **SSH**: Git signing with 1Password SSH agent
- **GPG**: SSH-based signing configuration

### Additional Tools
- **ack**: Search configuration
- **awesome**: Window manager configuration (Linux)
- **hg**: Mercurial configuration

## 🔐 Secret Management

This setup uses 1Password CLI for secure secret management:

### Setup 1Password CLI

```bash
# Install 1Password CLI
brew install --cask 1password-cli

# Sign in
op signin

# Create your API keys in 1Password
op item create --category=password --title="OpenAI API Key" --vault="Private"
op item create --category=password --title="Gemini API Key" --vault="Private"
```

### How it works

- Secrets are loaded from 1Password using `~/.config/op/env_loader.sh`
- No secrets are stored in git
- Graceful fallback if 1Password CLI is unavailable
- See `~/.config/op/README.md` for detailed setup

## 🛠️ Managing Dotfiles

### Adding new files

```bash
# Add a file to be managed by chezmoi
chezmoi add ~/.newconfig

# Edit the file through chezmoi
chezmoi edit ~/.newconfig

# Apply changes
chezmoi apply
```

### Making changes

```bash
# Edit files directly in the chezmoi source directory
chezmoi cd
# ... make changes ...
git add .
git commit -m "Update configuration"
git push

# Or edit through chezmoi and apply
chezmoi edit ~/.zshrc
chezmoi apply
```

### Syncing changes

```bash
# Pull and apply updates from the repository
chezmoi update

# Or step by step
chezmoi git pull
chezmoi apply
```

## 🏗️ Repository Structure

This repository uses chezmoi's directory structure:

```
dotfiles/
├── .chezmoiroot          # Points to home/ as the source root
├── home/                 # Source directory for home files
│   ├── dot_zshrc        # → ~/.zshrc
│   ├── dot_vimrc        # → ~/.vimrc
│   ├── dot_config/      # → ~/.config/
│   │   ├── nvim/        # → ~/.config/nvim/
│   │   └── op/          # → ~/.config/op/ (1Password setup)
│   └── dot_ipython/     # → ~/.ipython/
├── Brewfile             # Homebrew dependencies (ignored by chezmoi)
├── git-templates/       # Git hooks (ignored by chezmoi)
└── README.md           # This file
```

Files prefixed with `dot_` become hidden dotfiles in your home directory.

## 🖥️ Platform-Specific Notes

### macOS
- Uses Homebrew for package management
- Includes macOS-specific aliases and configurations
- iTerm2 profile included (but ignored by chezmoi)

### Linux
- Includes Awesome WM configuration
- Snap/apt package alternatives documented

## 📋 Prerequisites

### Required
- Git
- A supported shell (zsh/bash)

### Recommended
- [Homebrew](https://brew.sh) (macOS) or your distribution's package manager
- [1Password CLI](https://developer.1password.com/docs/cli/) for secret management
- [Oh My Zsh](https://ohmyzsh.sh/) (auto-installed by configuration)

### Optional Tools
Many aliases and functions expect these tools:
- `bat` - Better cat with syntax highlighting
- `lsd` - Modern ls replacement  
- `dust` - Modern du replacement
- `nvim` - Neovim editor
- `atuin` - Shell history search
- `direnv` - Environment variable management

## 🔧 Customization

### Local Customization

Create machine-specific configurations that won't be synced:

```bash
# Add to ~/.zshrc.local for zsh-specific local config
echo "export LOCAL_VAR=value" >> ~/.zshrc.local

# Add to ~/.config/git/local for git-specific local config
git config --file ~/.config/git/local user.email "work@company.com"
```

### Templating

Chezmoi supports templating for different machines:

```bash
# Edit templates
chezmoi edit ~/.gitconfig
# Add template logic like {{ if eq .hostname "work-laptop" }}
```

## 🆘 Troubleshooting

### Common Issues

**Chezmoi not applying changes:**
```bash
chezmoi doctor  # Check for issues
chezmoi diff    # See what would change
```

**1Password CLI not working:**
```bash
op signin       # Re-authenticate
op account get  # Verify authentication
```

**Git signing issues:**
```bash
# Ensure 1Password SSH agent is running
# Check Git configuration
git config --global --list | grep gpg
```

**Shell not loading configs:**
```bash
# Check if files exist
ls -la ~/.zshrc ~/.zprofile

# Manually source to test
source ~/.zshrc
```

## 📚 Useful Commands

```bash
# chezmoi status and operations
chezmoi status                    # Show status
chezmoi diff                      # Show differences  
chezmoi apply --dry-run          # Preview changes
chezmoi update                   # Pull and apply updates
chezmoi cd                       # Go to chezmoi source directory
chezmoi doctor                   # Check for common issues

# Managing ignored files
chezmoi unmanaged                # Show unmanaged files in home
chezmoi add --template ~/.file   # Add file as template
```

## 🤝 Contributing

1. Fork this repository
2. Make your changes in the `home/` directory
3. Test with `chezmoi apply --dry-run`
4. Submit a pull request

## 📄 License

MIT License - feel free to use and modify as needed.

---

For more information about chezmoi, visit [chezmoi.io](https://chezmoi.io).