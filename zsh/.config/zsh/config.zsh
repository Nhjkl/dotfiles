#!/bin/zsh

# ── XDG Base ──────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/run/user/$UID"
export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons

# ── Shell ─────────────────────────────────────────────────
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion"

# ── Editors & Tools ───────────────────────────────────────
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export LESSHISTFILE="-"

# ── Languages & Runtimes ──────────────────────────────────
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export BUN_INSTALL="$XDG_DATA_HOME/bun"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
export MAVEN_ARGS="--settings $XDG_CONFIG_HOME/maven/settings.xml"

# ── Applications ──────────────────────────────────────────
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export KODI_DATA="$XDG_DATA_HOME/kodi"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export UNISON="$XDG_DATA_HOME/unison"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export MINIKUBE_HOME="$XDG_DATA_HOME"
export CLAUDE_PACKAGE_MANAGER=pnpm

# ── GUI / Desktop (Linux) ────────────────────────────────
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

# ── PATH ──────────────────────────────────────────────────
unsetopt PROMPT_SP

[[ -d "$HOME/.local/bin" ]] && path=($HOME/.local/bin/*(N-/) $HOME/.local/bin $path)
[[ -z "$TERM" ]] && export TERM=xterm-256color

# ── Defaults ──────────────────────────────────────────────
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="brave"
export READER="zathura"
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
