#!/bin/bash
# ~/.bashrc - Main loader + common configuration
# Part of dotfiles repo - shared across all machines

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# =============================================================================
# Common configuration (all machines)
# =============================================================================

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Shell options
shopt -s checkwinsize

# Prompt (default, can be overridden by OS/host files)
PS1='\u@\h:\w\$ '

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# =============================================================================
# OS-specific loading
# =============================================================================

case "$(uname -s)" in
    Linux)   _os="linux" ;;
    Darwin)  _os="darwin" ;;
    MINGW*|MSYS*) _os="win" ;;
esac
[ -f ~/.bashrc.${_os} ] && . ~/.bashrc.${_os}

# WSL (sub-variant of linux)
if grep -qi microsoft /proc/version 2>/dev/null; then
    [ -f ~/.bashrc.wsl ] && . ~/.bashrc.wsl
fi

# =============================================================================
# Hostname-specific loading
# =============================================================================

[ -f ~/.bashrc.$(hostname) ] && . ~/.bashrc.$(hostname)

# =============================================================================
# Local overrides (never versioned, always last)
# =============================================================================

[ -f ~/.bashrc.local ] && . ~/.bashrc.local

unset _os
