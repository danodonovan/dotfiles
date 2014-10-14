#!/bin/bash

# register inputrc file
export INPUTRC=~/.inputrc

# Borrowed from Ben
if [ $shortname ]; then
  PS1='\[\e[1m\][\t] $shortname \e[1m\][$opsys] \[\e[32m\]\w\[\e[m\]\n \[\e[1;33m\]\#\$ \[\e[m\]'
else
  PS1='\[\e[1m\][\t] [\e[1m\]$HOSTNAME] \[\e[32m\][\w]\[\e[m\]\n \[\e[1;33m\]\#\$ \[\e[m\]'
fi

if [ `whoami` = root ]; then
  PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '
fi

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

# enable color support of ls and also add handy aliases
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

## SVN Stuff
export SVN_EDITOR=vim
export EDITOR=vim

## include B4D in python path
export PYTHONPATH=$PYTHONPATH
