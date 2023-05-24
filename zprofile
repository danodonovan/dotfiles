## This file is sourced before zshrc
## Edit this file for settings in non-interactive shells
export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/.local/bin:$PATH
if [ -d "/opt/homebrew" ]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

export HOSTNAME="$(networksetup -getcomputername)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

if [ -f ~/.aliases ]; then
    source ~/.aliases
else
    print "404: ~/.aliases not found."
fi

export AWS_PROFILE=prod-read-only

# set homebrew cache to external drive
if [ -d "/Volumes/Data-02" ]; then
    export HOMEBREW_CACHE=/Volumes/Data-02/Caches/Homebrew
fi
