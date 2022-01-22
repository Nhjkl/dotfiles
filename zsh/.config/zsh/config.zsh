HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_CACHE_HOME/zsh/history"

setopt no_nomatch
setopt hist_ignore_all_dups hist_save_nodups # 忽略重复的历史记录
DISABLE_MAGIC_FUNCTIONS=true # 解决安装 fast-syntax-highlighting 插件后粘贴内容慢的问题
