#!/bin/zsh
# ~/ Clean-up:
[ -f "$HOME/.config/xdg-dirs/xdgdirs" ] && source "$HOME/.config/xdg-dirs/xdgdirs"

# Adds `~/.local/bin` to $PATH
[ -s "$HOME/.local/bin/" ] && export PATH="$(echo $PATH:$(du -L $HOME/.local/bin | cut -f2) | sed -e "s/ /:/g")"

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export TERM=xterm-256color
export MANPAGER="nvim -c 'set ft=man' -"
export LESSHISTFILE="-"
