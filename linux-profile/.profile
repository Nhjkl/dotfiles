#!/bin/zsh
# ~/ Clean-up:
[ -f "$HOME/.config/xdg-dirs/xdgdirs" ] && source "$HOME/.config/xdg-dirs/xdgdirs"

# Adds `~/.local/bin` to $PATH
[ -s "$HOME/.local/bin/" ] && export PATH="$(echo $PATH:$(du -L $HOME/.local/bin | cut -f2) | sed -e "s/ /:/g")"

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox-developer-edition"
export READER="zathura"
export TERM=xterm-256color
export MANPAGER="nvim -c 'set ft=man' -"
export LESSHISTFILE="-"

# Other program settings:
[ -f "$XDG_CONFIG_HOME/rofi/scripts/askpass-rofi" ] && export SUDO_ASKPASS="$XDG_CONFIG_HOME/rofi/scripts/askpass-rofi"
# export FZF_DEFAULT_OPTS='--layout=reverse --height 50%'
export FZF_DEFAULT_OPTS='--layout=reverse --height 50% --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export QT_QPA_PLATFORMTHEME="gtk2"        # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"                # Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D" # May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1      # Fix for Java applications in dwm

[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC"
