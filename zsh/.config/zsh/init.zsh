# ============================================
# opencode
# ============================================
if [ -d "$HOME/.opencode/bin" ]; then
  export PATH="$HOME/.opencode/bin:$PATH"
fi

# ============================================
# npm
# ============================================
if [ -d "$HOME/.local/share/npm/bin" ]; then
  export PATH="$HOME/.local/share/npm/bin:$PATH"
fi

# ============================================
# bun
# ============================================
if [ -d "$HOME/.local/share/bun" ]; then
  export PATH="$HOME/.local/share/bun/bin:$PATH"
  [ -s "$HOME/.local/share/bun/_bun" ] && source "$HOME/.local/share/bun/_bun"
fi

# ============================================
# starship
# ============================================
if ! hash "starship" &>/dev/null; then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi
eval "$(starship init zsh)"

# ============================================
# cargo / rust
# ============================================
if [ -d "$CARGO_HOME" ]; then
  [ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"
  export RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static
  export RUSTUP_UPDATE_ROOT=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup
  export PATH="$CARGO_HOME/bin:$PATH"
fi

# ============================================
# fnm
# ============================================
# if [ -d "$HOME/.local/share/fnm" ]; then
#   export PATH="$HOME/.local/share/fnm:$PATH"
#   eval "`fnm env`"
# fi

# ============================================
# tmux
# ============================================
if ! hash "tmux" &>/dev/null; then
  echo "install tmux..."
  yay -S tmux
fi

# oh-my-tmux
OH_MY_TMUX="$XDG_DATA_HOME/oh-my-tmux"
if [ ! -d "$OH_MY_TMUX" ]; then
  mkdir -p "$OH_MY_TMUX"
  git clone --depth=1 https://github.com/gpakosz/.tmux.git "$OH_MY_TMUX"
  ln -s -f "$OH_MY_TMUX/.tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
fi


# OpenClaw Completion
source "$HOME/.openclaw/completions/openclaw.zsh"

export GOPATH="$HOME/.local/share/go";
export GOROOT="$HOME/.go";
export GOBIN="$GOPATH/bin";
export PATH="$GOBIN:$PATH";
export CGO_ENABLED=1

# password-store
export PASSWORD_STORE_DIR="$HOME/.local/src/password-store"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

unset NPM_CONFIG_TMP

# pyenv configuration
export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"

# Add pyenv to PATH
if [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Initialize pyenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
