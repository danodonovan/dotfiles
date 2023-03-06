## This file is sourced before zshrc
## Edit this file for settings in non-interactive shells
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
