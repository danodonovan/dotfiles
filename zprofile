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

eval "$(/opt/homebrew/bin/brew shellenv)"

# for tables
export HDF5_DIR=$(brew --prefix)/opt/hdf5
export BLOSC_DIR=$(brew --prefix)/opt/c-blosc


# for the shell theme
SPACESHIP_AWS_SHOW=false
SPACESHIP_GCLOUD_SHOW=false
SPACESHIP_PYTHON_SHOW=true
