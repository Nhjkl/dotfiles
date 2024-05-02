# install starship
if ! hash "starship" &>/dev/null; then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi
eval "$(starship init zsh)"

# Cargo
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"
export RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup

# GEM
if hash "ruby" &>/dev/null; then
  PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

# Tmux
if ! hash "tmux" &>/dev/null; then
  echo "install tmux..."
  yay -S tmux
fi

# oh-my-tmux
OH_MY_TMUX="$XDG_DATA_HOME/oh-my-tmux"
if [ ! -d "$OH_MY_TMUX" ]; then
  mkdir -p "$OH_MY_TMUX";
  git clone --depth=1 https://github.com/gpakosz/.tmux.git "$OH_MY_TMUX"
  ln -s -f "$OH_MY_TMUX/.tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
fi

# nvm
# nvm() {
#   # install nvm
#   if [ ! -d "$NVM_DIR" ]; then
#     mkdir -p "$NVM_DIR";
#     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
#   fi
#   . "$NVM_DIR/nvm.sh" ; nvm $@ ;
# }
#
# export PATH=$NVM_DIR/versions/node/v20.9.0/bin/:$PATH

export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
export FNM_NODE_DIST_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
# fnm
FNM_DIR="$XDG_DATA_HOME/fnm"
if [ ! -d "$FNM_DIR" ]; then
  sh -c "$(curl -fsSL https://fnm.vercel.app/install)"
fi
export PATH="$FNM_DIR:$PATH"
eval "`fnm env`"

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# atuin
if hash "atuin" &>/dev/null; then
  eval "$(atuin init zsh)"
fi
