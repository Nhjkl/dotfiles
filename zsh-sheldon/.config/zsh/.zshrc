source "$ZDOTDIR/config.zsh"
source "$ZDOTDIR/init.zsh"

# sheldon 插件加载（lock 文件存在时才加载，避免首次启动卡住）
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/lock.toml" ]]; then
  eval "$(sheldon source 2>/dev/null)"
fi

source "$ZDOTDIR/vimode.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/bindkey.zsh"
