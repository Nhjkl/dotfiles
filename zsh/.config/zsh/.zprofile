#!/bin/zsh

unsetopt PROMPT_SP

# [ -s "$HOME/.local/bin/" ] && export PATH="$(echo $PATH:$(du -L $HOME/.local/bin | cut -f2) | sed -e 's/ /:/g')"
[[ -d "$HOME/.local/bin" ]] && path=($HOME/.local/bin/*(N-/) $HOME/.local/bin $path)
[[ -z "$TERM" ]] && export TERM=xterm-256color

export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="brave"
export READER="zathura"
export DESKTOP_SESSION="dwm"
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
