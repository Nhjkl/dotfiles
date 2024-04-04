#!/bin/zsh
# ~/ Clean-up:
[ -f "$HOME/.config/xdg-dirs/xdgdirs" ] && source "$HOME/.config/xdg-dirs/xdgdirs"

# Adds `~/.local/bin` to $PATH
[ -s "$HOME/.local/bin/" ] && export PATH="$(echo $PATH:$(du -L $HOME/.local/bin | cut -f2) | sed -e "s/ /:/g")"

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
# export TERMINAL="alacritty"
export TERMINAL="kitty"
# export TERMINAL="wezterm"
# export BROWSER="firefox-developer-edition"
export BROWSER="brave"
export READER="zathura"
export TERM=xterm-256color
# export MANPAGER="nvim -c 'set ft=man' -"
export LESSHISTFILE="-"

# Other program settings:
[ -f "$XDG_CONFIG_HOME/rofi/scripts/askpass-rofi" ] && export SUDO_ASKPASS="$XDG_CONFIG_HOME/rofi/scripts/askpass-rofi"
# export FZF_DEFAULT_OPTS='--layout=reverse --height 50%'
# export FZF_DEFAULT_OPTS='--layout=reverse --height 50% --color=fg:#f8f8f2,bg:#282a36,hl:#82aaff --color=fg+:#f8f8f2,bg+:#44475a,hl+:#82aaff --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
export FZF_DEFAULT_OPTS="
  --layout=reverse --height 50%
	--color=fg:#908caa,bg:#232136,hl:#ea9a97
	--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
	--color=border:#44415a,header:#3e8fb0,gutter:#232136
	--color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export QT_QPA_PLATFORMTHEME="gtk2"        # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"                # Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D" # May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1      # Fix for Java applications in dwm

[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC"
