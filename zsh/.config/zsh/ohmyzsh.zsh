# install ohmyzsh
if [ ! -f "$ZSH/oh-my-zsh.sh" ] ; then
  echo "install ohmyzsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSHPLUGIN=$ZSH/custom/plugins

if [ ! -d $ZSHPLUGIN/fast-syntax-highlighting ] ; then
  git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSHPLUGIN/fast-syntax-highlighting;
fi
if [ ! -d $ZSHPLUGIN/zsh-autosuggestions ] ; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSHPLUGIN/zsh-autosuggestions;
fi
if [ ! -d $ZSHPLUGIN/fzf-tab ] ; then
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git $ZSHPLUGIN/fzf-tab;
fi

plugins=(git npm pip vi-mode fzf-tab fast-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
