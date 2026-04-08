autoload -Uz compinit

if [[ -n "${ZDOTDIR}/.zcompdump(#qN.mh+24)" ]]; then
  compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
else
  compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
fi

eval "$(mise activate zsh 2>/dev/null)"

eval "$(starship init zsh)"

source "$ZDOTDIR/lang/opencode.zsh"
source "$ZDOTDIR/lang/go.zsh"

[[ -d "$XDG_DATA_HOME/pnpm/bin" ]] && path=("$XDG_DATA_HOME/pnpm/bin" $path)
