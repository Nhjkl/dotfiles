if [ ! -f "$HOME/.local/share/zap/zap.zsh" ] ; then
  echo "install zap..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh)"
fi

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Example install plugins
zapplug "zap-zsh/supercharge"
zapplug "zsh-users/zsh-autosuggestions"
zapplug "zsh-users/zsh-syntax-highlighting"
zapplug "hlissner/zsh-autopair"
zapplug "zap-zsh/vim"

# Example theme
# zapplug "zap-zsh/zap-prompt"
# Example install completion
zapplug "esc/conda-zsh-completion"
