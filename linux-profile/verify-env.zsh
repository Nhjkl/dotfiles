#!/bin/zsh
# Verify environment variables match configuration
# Usage: zsh verify-env.zsh

PASS=0
FAIL=0
TOTAL=0

check() {
  local name="$1" expected="$2"
  local actual="${(P)name}"
  TOTAL=$((TOTAL + 1))
  if [[ "$actual" == "$expected" ]]; then
    printf "  \033[32m✓\033[0m %s\n" "$name"
    PASS=$((PASS + 1))
  else
    printf "  \033[31m✗\033[0m %s\n" "$name"
    printf "    expected: %s\n" "$expected"
    printf "    actual:   %s\n" "$actual"
    FAIL=$((FAIL + 1))
  fi
}

H="$HOME"

printf "\n\033[1m── .zshenv ──\033[0m\n"
check ZDOTDIR "$H/.config/zsh"

printf "\n\033[1m── XDG Base ──\033[0m\n"
check XDG_CONFIG_HOME "$H/.config"
check XDG_CACHE_HOME "$H/.cache"
check XDG_DATA_HOME "$H/.local/share"
check XDG_STATE_HOME "$H/.local/state"
check XDG_RUNTIME_DIR "/run/user/$UID"

printf "\n\033[1m── Shell ──\033[0m\n"
check HISTFILE "$H/.local/share/zsh/history"
check INPUTRC "$H/.config/inputrc"
check BASH_COMPLETION_USER_FILE "$H/.config/bash-completion/bash_completion"

printf "\n\033[1m── Editors & Tools ──\033[0m\n"
check VIMINIT 'let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
check VSCODE_PORTABLE "$H/.local/share/vscode"
check WGETRC "$H/.config/wget/wgetrc"
check GNUPGHOME "$H/.local/share/gnupg"
check GTK2_RC_FILES "$H/.config/gtk-2.0/gtkrc-2.0"
check NOTMUCH_CONFIG "$H/.config/notmuch-config"
check ANSIBLE_CONFIG "$H/.config/ansible/ansible.cfg"
check LESSHISTFILE "-"

printf "\n\033[1m── Languages & Runtimes ──\033[0m\n"
check RUSTUP_HOME "$H/.local/share/rustup"
check CARGO_HOME "$H/.local/share/cargo"
check GOPATH "$H/.local/share/go"
check PYENV_ROOT "$H/.local/share/pyenv"
check BUN_INSTALL "$H/.local/share/bun"
check NVM_DIR "$H/.local/share/nvm"
check GEM_HOME "$H/.local/share/gem"
check GEM_SPEC_CACHE "$H/.cache/gem"
check NODE_REPL_HISTORY "$H/.local/share/node_repl_history"
check NPM_CONFIG_USERCONFIG "$H/.config/npm/npmrc"
check NPM_CONFIG_CACHE "$H/.cache/npm"
check NPM_CONFIG_TMP "/run/user/$UID/npm"

printf "\n\033[1m── Applications ──\033[0m\n"
check PASSWORD_STORE_DIR "$H/.local/share/password-store"
check WINEPREFIX "$H/.local/share/wineprefixes/default"
check KODI_DATA "$H/.local/share/kodi"
check ELECTRUMDIR "$H/.local/share/electrum"
check UNISON "$H/.local/share/unison"
check WEECHAT_HOME "$H/.config/weechat"
check MBSYNCRC "$H/.config/mbsync/config"
check ANDROID_SDK_HOME "$H/.config/android"
check MPLAYER_HOME "$H/.config/mplayer"

printf "\n\033[1m── GUI / Desktop ──\033[0m\n"
check XINITRC "$H/.config/x11/xinitrc"
check XSERVERRC "$H/.config/X11/xserverrc"

printf "\n\033[1m── .zprofile ──\033[0m\n"
check EDITOR "nvim"
check TERMINAL "kitty"
check BROWSER "brave"
check READER "zathura"
check TERM "xterm-256color"
check DESKTOP_SESSION "dwm"
check LANG "C.UTF-8"
check LC_ALL "C.UTF-8"
check FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"

printf "\n──────────────────────────\n"
printf "Total: %d  \033[32mPass: %d\033[0m  \033[31mFail: %d\033[0m\n\n" "$TOTAL" "$PASS" "$FAIL"

[[ $FAIL -eq 0 ]] && exit 0 || exit 1
