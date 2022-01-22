# install nvm
if [ ! -d "$NVM_DIR" ]; then
  mkdir -p "$NVM_DIR";
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
fi

# install ohmyzsh
if [ ! -f "$ZSH/oh-my-zsh.sh" ] ; then
  echo "install ohmyzsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d $ZSH/plugins/fast-syntax-highlighting ] ; then
  cd $ZSH/plugins;
  git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git;
  cd $HOME;
fi
if [ ! -d $ZSH/plugins/zsh-autosuggestions ] ; then
  cd $ZSH/plugins;
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git;
  cd $HOME;
fi
# Load syntax highlighting; should be last.
source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# install starship
if ! hash "starship" &>/dev/null; then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi
eval "$(starship init zsh)"

# Cargo
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# GEM
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# nvm
nvm() {
  . "$NVM_DIR/nvm.sh" ; nvm $@ ;
}
export PATH=$NVM_DIR/versions/node/v16.13.2/bin/:$PATH
export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
