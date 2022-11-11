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

# yarn
plugins=(git npm pip vi-mode)
source $ZSH/oh-my-zsh.sh
