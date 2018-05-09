case $OSTYPE in
darwin*)
    echo I am osx

    # OSX iTerm only
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

    # aws-keychain
    export PATH=$PATH:${HOME}/code/aws-keychain

    # if using brew, add bash completion
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    # if coreutils have been installed with brew
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    ;;
linux-gnu)
    echo I am linux

    # linux brew
    if [ -d "$HOME/.linuxbrew" ]; then
        BREW_DIR=$HOME/.linuxbrew
        complete -C "$BREW_DIR/bin/aws_completer" aws
        export PATH="$BREW_DIR/bin:$PATH"
        export MANPATH="$BREW_DIR/share/man:$MANPATH"
        export INFOPATH="$BREW_DIR/share/info:$INFOPATH"
        export PATH="$BREW_DIR/sbin:$PATH"
    fi
esac

if [ -e "$HOME/.aliases" ]; then
    source $HOME/.aliases
fi

# Click complains if this isn't set
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

# set up ssh-agent
eval $(ssh-agent -s)

# if $HOME/local exists
if [ -d "$HOME/local" ]; then
    export PATH="$HOME/local/bin:$PATH"
fi

# rust
if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -x "$(command -v nvim)" ]; then
    export EDITOR='nvim'
else
    export EDITOR='vim'
fi

# AWS cli complete
complete -C aws_completer aws

# apt-vim
export PATH=$PATH:$HOME/.vimpkg/bin

## prompt
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n \$ \[\e[m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# bash (and so git) completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# some bash color
export CLICOLOR=1

# jenv
if [ -d "$HOME/.jenv" ]; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi

# less syntax highlighting
# $ brew install source-highlight
export LESSOPEN="| /usr/local/Cellar/source-highlight/3.1.8_7/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# if pyenv exists
if [ -d "$HOME/.pyenv" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# bash completion (if installed)
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
