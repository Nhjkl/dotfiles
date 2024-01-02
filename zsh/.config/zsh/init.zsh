[ -f $XDG_CONFIG_HOME/lf/LF_ICONS ] && {
  export LC_ALL=en_US.UTF-8
  LF_ICONS="$(tr '\n' ':' < $XDG_CONFIG_HOME/lf/LF_ICONS)"\
  && export LF_ICONS
}

# install starship
if ! hash "starship" &>/dev/null; then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi
eval "$(starship init zsh)"

# Cargo
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# GEM
if hash "ruby" &>/dev/null; then
  PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

# Tmux
if ! hash "tmux" &>/dev/null; then
  echo "install tmux..."
  yay -S tmux
fi

CODE_DIR="$HOME/.local/src"
if [ ! -d "$CODE_DIR" ]; then
  mkdir -p "$CODE_DIR";
fi

if [ ! -d "$CODE_DIR/oh-my-tmux" ]; then
  git clone --depth=1 https://github.com/gpakosz/.tmux.git "$CODE_DIR/oh-my-tmux"
  ln -s -f "$CODE_DIR/oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# nvm
nvm() {
  # install nvm
  if [ ! -d "$NVM_DIR" ]; then
    mkdir -p "$NVM_DIR";
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
  fi
  . "$NVM_DIR/nvm.sh" ; nvm $@ ;
}

export PATH=$NVM_DIR/versions/node/v20.9.0/bin/:$PATH
export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
