HISTSIZE=10000
SAVEHIST=10000
if [ ! -f "$XDG_CACHE_HOME/zsh/history" ] ; then
  mkdir -p "$XDG_CACHE_HOME/zsh"
  cd $XDG_CACHE_HOME/zsh
  touch history
fi
HISTFILE="$XDG_CACHE_HOME/zsh/history"

stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

setopt no_nomatch
setopt hist_ignore_all_dups hist_save_nodups # 忽略重复的历史记录
DISABLE_MAGIC_FUNCTIONS=true # 解决安装 fast-syntax-highlighting 插件后粘贴内容慢的问题
