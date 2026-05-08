source "$ZDOTDIR/init.zsh"
source "$ZDOTDIR/config.zsh"

# sheldon 插件加载
if command -v sheldon &>/dev/null; then
  eval "$(sheldon source 2>/dev/null)"
fi

source "$ZDOTDIR/vimode.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/bindkey.zsh"
