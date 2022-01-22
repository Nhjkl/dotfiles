#!/bin/zsh

# Adds `~/.local/bin` to $PATH
# export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 )"
[ -s "$HOME/.local/bin/" ] && export PATH="$PATH:${$(echo $(echo $(du -L $HOME/.local/bin | cut -f2)) | sed -e "s/ /:/g")}"
[ -s "$HOME/.local/scripts/" ] && export PATH="$PATH:${$(echo $(echo $(du -L $HOME/.local/scripts | cut -f2)) | sed -e "s/ /:/g")}"
unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"

# ~/ Clean-up:
[ -f "$HOME/.config/xdg-dirs/xdgdirs" ] && source "$HOME/.config/xdg-dirs/xdgdirs"
