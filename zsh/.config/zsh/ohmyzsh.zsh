# install ohmyzsh
if [ ! -f "$ZSH/oh-my-zsh.sh" ] ; then
  echo "install ohmyzsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSHPLUGIN=$ZSH/custom/plugins

cd $ZSHPLUGIN;
if [ ! -d $ZSHPLUGIN/fast-syntax-highlighting ] ; then
  git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git;
fi
if [ ! -d $ZSHPLUGIN/zsh-autosuggestions ] ; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git;
fi
if [ ! -d $ZSHPLUGIN/fzf-tab ] ; then
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab.git;
fi
cd $HOME;

# Load syntax highlighting; should be last.
# source $ZSHPLUGIN/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
# source $ZSHPLUGIN/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
# source $ZSHPLUGIN/fzf-tab/fzf-tab.plugin.zsh 2>/dev/null

# yarn
plugins=(git npm pip vi-mode fzf-tab fast-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
