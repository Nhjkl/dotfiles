HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
[[ -d "$XDG_DATA_HOME/zsh" ]] || mkdir -p "$XDG_DATA_HOME/zsh"

stty stop undef
setopt interactive_comments
setopt no_nomatch
setopt hist_ignore_all_dups hist_save_nodups hist_expire_dups_first
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt autocd
setopt complete_in_word

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
