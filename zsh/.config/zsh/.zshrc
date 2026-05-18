# ── 环境变量 ──────────────────────────────────────────────
source "$ZDOTDIR/config.zsh"

# ── 插件 ──────────────────────────────────────────────────
# 必须在下方工具加载前，因为 zsh-defer 在此定义
if [[ -f "$XDG_CACHE_HOME/zsh/sheldon-source.zsh" ]]; then
  source "$XDG_CACHE_HOME/zsh/sheldon-source.zsh"
elif command -v sheldon &>/dev/null; then
  eval "$(sheldon source 2>/dev/null)"
fi

# ── Shell 选项 ────────────────────────────────────────────
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
[[ -d "$XDG_DATA_HOME/zsh" ]] || mkdir -p "$XDG_DATA_HOME/zsh"

stty stop undef
setopt interactive_comments no_nomatch
setopt hist_ignore_all_dups hist_save_nodups hist_expire_dups_first
setopt hist_ignore_space hist_reduce_blanks inc_append_history
setopt autocd complete_in_word

# ── 补全 ──────────────────────────────────────────────────
DISABLE_MAGIC_FUNCTIONS=true
autoload -Uz compinit
local _compdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
if [[ -n "${_compdump}(#qN.mh+24)" ]]; then
  compinit -d "$_compdump"
else
  compinit -C -d "$_compdump"
fi

# ── Prompt ────────────────────────────────────────────────
if [[ -f "$XDG_CACHE_HOME/zsh/starship-init.zsh" ]]; then
  source "$XDG_CACHE_HOME/zsh/starship-init.zsh"
else
  eval "$(starship init zsh)"
fi

# ── 工具 ──────────────────────────────────────────────────
# mise: 交互 shell defer 加速启动，非交互同步保证工具可用
if [[ -o interactive ]]; then
  if [[ -f "$XDG_CACHE_HOME/zsh/mise-activate.zsh" ]]; then
    zsh-defer source "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
  else
    zsh-defer eval "$(mise activate zsh 2>/dev/null)"
  fi
else
  if [[ -f "$XDG_CACHE_HOME/zsh/mise-activate.zsh" ]]; then
    source "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
  else
    eval "$(mise activate zsh 2>/dev/null)"
  fi
fi

# ── 快捷键 & 别名 ────────────────────────────────────────
source "$ZDOTDIR/bindkey.zsh"
source "$ZDOTDIR/vimode.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/lazy.zsh"

# ── 工具函数 ──────────────────────────────────────────────
_zsh_zcompile() {
  autoload -Uz zrecompile
  local f
  for f in "$XDG_CACHE_HOME/zsh"/**/*.zsh(N); do
    zrecompile -pq "$f"
  done
}

zsh-reload-cache() {
  echo "Regenerating zsh caches..."
  mkdir -p "$XDG_CACHE_HOME/zsh"
  command -v sheldon &>/dev/null && sheldon source 2>/dev/null > "$XDG_CACHE_HOME/zsh/sheldon-source.zsh"
  command -v starship &>/dev/null && starship init zsh > "$XDG_CACHE_HOME/zsh/starship-init.zsh"
  command -v mise &>/dev/null && mise activate zsh 2>/dev/null > "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
  _zsh_zcompile
  echo "Done. Restart zsh to apply."
}
