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
setopt share_history
setopt autocd
setopt complete_in_word
DISABLE_MAGIC_FUNCTIONS=true
