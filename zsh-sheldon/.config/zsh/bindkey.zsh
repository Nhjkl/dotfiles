# Ctrl+F: 打开 tmux-sessionizer
bindkey -s ^f "tmux-sessionizer\n"
# Ctrl+P: 上一条历史命令
bindkey '^P' up-history
# Ctrl+N: 下一条历史命令
bindkey '^N' down-history
# Ctrl+E: 光标移到行尾
bindkey '^E' end-of-line
# Ctrl+A: 光标移到行首
bindkey '^A' beginning-of-line
# Ctrl+W: 删除光标前一个单词
bindkey '^W' backward-kill-word
# 上箭头: 搜索历史命令（向前）
bindkey '^[[A' history-search-backward
# 下箭头: 搜索历史命令（向后）
bindkey '^[[B' history-search-forward
# Backspace: 删除光标前一个字符
bindkey '^?' backward-delete-char
# Delete: 删除光标后一个字符
bindkey '^[[3~' delete-char
# Ctrl+H: 删除光标前一个字符
bindkey '^H' backward-delete-char
