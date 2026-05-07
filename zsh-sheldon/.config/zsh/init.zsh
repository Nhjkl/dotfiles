DISABLE_MAGIC_FUNCTIONS=true
autoload -Uz compinit

local _compdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
if [[ -n "${_compdump}(#qN.mh+24)" ]]; then
  compinit -d "$_compdump"
else
  compinit -C -d "$_compdump"
fi

eval "$(mise activate zsh 2>/dev/null)"

eval "$(starship init zsh)"

source "$ZDOTDIR/lang/opencode.zsh"
source "$ZDOTDIR/lang/go.zsh"
source "$ZDOTDIR/lang/maven.zsh"

[[ -d "$XDG_DATA_HOME/pnpm/bin" ]] && path=("$XDG_DATA_HOME/pnpm/bin" $path)
