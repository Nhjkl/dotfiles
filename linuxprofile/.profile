#!/bin/zsh

# Adds `~/.local/bin` to $PATH
[ -s "$HOME/.local/bin/" ] && export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | paste -sd ':')"
[ -s "$HOME/.config/rofi/bin" ] && export PATH="$PATH:$(du "$HOME/.config/rofi/bin/" | cut -f2 | paste -sd ':')"
[ -s "$HOME/.local/share/cargo/bin/" ] && export PATH="$PATH:$(du "$HOME/.local/share/cargo/bin/" | cut -f2 | paste -sd ':')"
[ -s "$HOME/.yarn/bin/" ] && export PATH="$PATH:$(du "$HOME/.yarn/bin/" | cut -f2 | paste -sd ':')"

# Default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"

## "nvim" as manpager
export MANPAGER="nvim -c 'set ft=man' -"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
# export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"

#export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
#export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"

#develop
export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export NVM_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvm"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_TMP=$XDG_RUNTIME_DIR/npm
export TERM=xterm-256color

# Other program settings:
export SUDO_ASKPASS="$HOME/.config/rofi/scripts/askpass-rofi"
# export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

if pacman -Qs libxft-bgra >/dev/null 2>&1; then
	# Start graphical server on tty1 if not already running.
	[ "$(tty)" = "/dev/tty1" ] && ! pidof Xorg >/dev/null 2>&1  && exec startx
else
	echo "Note that \`libxft-bgra\` must be installed for this build of dwm. Please run: yay -S libxft-bgra-git and replace \`libxft\`"
fi

# Switch escape and caps if tty and no passwd required:
# sudo -n loadkeys ${XDG_DATA_HOME:-$HOME/.local/share}/larbs/ttymaps.kmap 2>/dev/null
# source "/home/lx/.local/share/cargo/env"
