HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_CACHE_HOME/zsh/history"
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

stty stop undef
setopt interactive_comments
setopt no_nomatch
setopt hist_ignore_all_dups hist_save_nodups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history
setopt autocd
setopt complete_in_word
DISABLE_MAGIC_FUNCTIONS=true
