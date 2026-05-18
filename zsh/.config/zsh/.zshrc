source "$ZDOTDIR/config.zsh"
source "$ZDOTDIR/init.zsh"

# sheldon 插件加载（使用缓存，zsh-reload-cache 可重新生成）
if [[ -f "$XDG_CACHE_HOME/zsh/sheldon-source.zsh" ]]; then
  source "$XDG_CACHE_HOME/zsh/sheldon-source.zsh"
elif command -v sheldon &>/dev/null; then
  eval "$(sheldon source 2>/dev/null)"
fi

source "$ZDOTDIR/vimode.zsh"
source "$ZDOTDIR/lazy.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/bindkey.zsh"

# zcompile 加速（仅编译 cache 目录下的文件，符合 XDG 规范）
_zsh_zcompile() {
  autoload -Uz zrecompile
  local f
  for f in "$XDG_CACHE_HOME/zsh"/**/*.zsh(N); do
    zrecompile -pq "$f"
  done
}

# 重新生成所有缓存（sheldon/starship/mise/zcompile）
zsh-reload-cache() {
  echo "Regenerating zsh caches..."
  mkdir -p "$XDG_CACHE_HOME/zsh"
  command -v sheldon &>/dev/null && sheldon source 2>/dev/null > "$XDG_CACHE_HOME/zsh/sheldon-source.zsh"
  command -v starship &>/dev/null && starship init zsh > "$XDG_CACHE_HOME/zsh/starship-init.zsh"
  command -v mise &>/dev/null && mise activate zsh 2>/dev/null > "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
  _zsh_zcompile
  echo "Done. Restart zsh to apply."
}
