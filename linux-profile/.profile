#!/bin/zsh
# ~/ Clean-up:
[ -f "$HOME/.config/xdg-dirs/xdgdirs" ] && source "$HOME/.config/xdg-dirs/xdgdirs"

# Adds `~/.local/bin` to $PATH
[ -s "$HOME/.local/bin/" ] && export PATH="$(echo $PATH:$(du -L $HOME/.local/bin | cut -f2) | sed -e "s/ /:/g")"

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export TERMINAL="kitty"
export BROWSER="brave"
export READER="zathura"
export TERM=xterm-256color
# export MANPAGER="nvim -c 'set ft=man' -"
export LESSHISTFILE="-"
export DESKTOP_SESSION="dwm"
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

export FZF_DEFAULT_OPTS="
  --layout=reverse --height 50%
	--color=fg:#908caa,bg:#232136,hl:#ea9a97
	--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
	--color=border:#44415a,header:#3e8fb0,gutter:#232136
	--color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
