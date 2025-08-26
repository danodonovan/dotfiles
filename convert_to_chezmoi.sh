#!/usr/bin/env bash
set -euo pipefail

REPO_URL="git@github.com:danodonovan/dotfiles.git"
BACKUP_DIR="$HOME/dotfiles-backup"
CHEZMOI_SOURCE="$HOME/.local/share/chezmoi"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "🔍 Running in dry-run mode (no push or apply)"
fi

echo "🔧 Converting dotfiles repo to chezmoi source layout"
echo "================================================"

# Check for chezmoi
if ! command -v chezmoi &> /dev/null; then
    echo "❌ chezmoi not found. Please install it first:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "   brew install chezmoi"
    else
        echo "   sudo snap install chezmoi"
        echo "   # or use your package manager"
    fi
    exit 1
fi

# Check if chezmoi source already exists and is not our repo
if [[ -d "$CHEZMOI_SOURCE" ]]; then
    if [[ -d "$CHEZMOI_SOURCE/.git" ]]; then
        cd "$CHEZMOI_SOURCE"
        CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
        if [[ "$CURRENT_REMOTE" != "$REPO_URL" ]]; then
            echo "❌ $CHEZMOI_SOURCE already exists with different remote: $CURRENT_REMOTE"
            echo "   Please backup and remove it first, or use a different repo."
            exit 1
        fi
        echo "✅ Using existing chezmoi source directory"
    else
        echo "❌ $CHEZMOI_SOURCE exists but is not a git repository"
        echo "   Please backup and remove it first."
        exit 1
    fi
else
    echo "📥 Cloning repo to chezmoi source directory..."
    git clone "$REPO_URL" "$CHEZMOI_SOURCE"
fi

# Create backup
echo "💾 Creating backup at $BACKUP_DIR..."
rm -rf "$BACKUP_DIR"
git clone "$REPO_URL" "$BACKUP_DIR"

# Work in chezmoi source directory
cd "$CHEZMOI_SOURCE"

echo "🏗️  Setting up chezmoi structure..."

# Create .chezmoiroot
echo "home" > .chezmoiroot

# Create home directory
mkdir -p home

# Function to safely move files with git
git_move_if_exists() {
    local src="$1"
    local dest="$2"
    
    if [[ -e "$src" ]]; then
        echo "  Moving $src → $dest"
        mkdir -p "$(dirname "$dest")"
        git mv "$src" "$dest"
    fi
}

echo "📁 Moving and renaming files to chezmoi conventions..."

# Move dotfiles with dot_ prefix
git_move_if_exists "ackrc" "home/dot_ackrc"
git_move_if_exists "aliases" "home/dot_aliases"
git_move_if_exists "bash_profile" "home/dot_bash_profile"
git_move_if_exists "gitconfig" "home/dot_gitconfig"
git_move_if_exists "hgrc" "home/dot_hgrc"
git_move_if_exists "tmux.conf" "home/dot_tmux.conf"
git_move_if_exists "vimrc" "home/dot_vimrc"
git_move_if_exists "zprofile" "home/dot_zprofile"
git_move_if_exists "zshrc" "home/dot_zshrc"

# Move config directory
git_move_if_exists "config" "home/dot_config"

# Special case: ipython_config.py
if [[ -f "ipython_config.py" ]]; then
    echo "  Moving ipython_config.py → home/dot_ipython/profile_default/ipython_config.py"
    mkdir -p "home/dot_ipython/profile_default"
    git mv "ipython_config.py" "home/dot_ipython/profile_default/ipython_config.py"
fi

echo "🚫 Creating .chezmoiignore for non-home assets..."

# Create or update .chezmoiignore
IGNORE_FILE="home/.chezmoiignore"
IGNORE_ENTRIES=(
    "/.github/"
    "/git-templates/"
    "/UHK/"
    "/PyCharm/"
    "/Brewfile"
    "/iterm_default_profile.json"
    "/convert_to_chezmoi.sh"
)

# Read existing ignore file if it exists
if [[ -f "$IGNORE_FILE" ]]; then
    EXISTING_IGNORES=$(cat "$IGNORE_FILE")
else
    EXISTING_IGNORES=""
    touch "$IGNORE_FILE"
fi

# Add missing entries
for entry in "${IGNORE_ENTRIES[@]}"; do
    if ! echo "$EXISTING_IGNORES" | grep -Fxq "$entry"; then
        echo "$entry" >> "$IGNORE_FILE"
    fi
done

echo "🩺 Running chezmoi doctor..."
chezmoi doctor

echo ""
echo "🔍 Showing what chezmoi will apply..."
chezmoi diff

if [[ "$DRY_RUN" == "true" ]]; then
    echo ""
    echo "🏁 Dry-run complete. Changes prepared but not applied or pushed."
    echo "   Remove --dry-run flag to execute for real."
    exit 0
fi

echo ""
echo "⚠️  Ready to apply changes to your home directory."
read -p "Continue? (type 'yes' to confirm): " -r
if [[ "$REPLY" != "yes" ]]; then
    echo "❌ Aborted by user"
    exit 1
fi

echo "✅ Applying chezmoi changes..."
chezmoi apply

echo "💾 Committing changes to chezmoi source..."
git add .
if git diff --cached --quiet; then
    echo "ℹ️  No changes to commit"
else
    git commit --no-gpg-sign -m "Convert repo to chezmoi source layout (home/ via .chezmoiroot; dot_* renames)"
fi

echo ""
echo "🚀 Ready to push changes to remote repository."
read -p "Push to $REPO_URL? (type 'yes' to confirm): " -r
if [[ "$REPLY" != "yes" ]]; then
    echo "⚠️  Changes committed locally but not pushed"
    echo "   Run 'git push' from $CHEZMOI_SOURCE when ready"
else
    echo "📤 Pushing to remote..."
    git push origin main
    echo "✅ Successfully pushed!"
fi

echo ""
echo "🎉 Conversion complete!"
echo ""
echo "NEXT STEPS:"
echo "==========="
echo "• Bootstrap a new machine:"
echo "    chezmoi init --apply danodonovan/dotfiles"
echo ""
echo "• Add new files:"
echo "    chezmoi add <path>"
echo "    chezmoi apply"
echo "    cd $CHEZMOI_SOURCE && git add . && git commit -m 'Add <file>' && git push"
echo ""
echo "• Backup location: $BACKUP_DIR"
echo ""
echo "ROLLBACK (if needed):"
echo "===================="
echo "    cd $CHEZMOI_SOURCE"
echo "    git reset --hard HEAD~1  # undo the conversion commit"
echo "    # then restore from backup if necessary"
