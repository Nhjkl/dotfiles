#!/bin/bash
# tmux session/window fzf manager with kill support

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
current_session=$(tmux display-message -p '#S')

selected=$("$SCRIPT_DIR/tmux-generate-list.sh" | fzf --ansi --reverse --with-nth=1 --delimiter=$'\t' \
  --height=100% \
  --border=rounded \
  --prompt='Session/Window > ' \
  --pointer='►' \
  --bind 'ctrl-/:toggle-preview' \
  --bind "ctrl-x:execute-silent(session=\$(echo {2} | cut -d: -f1); [ \"\$session\" != \"$current_session\" ] && tmux kill-session -t \"\$session\")+reload($SCRIPT_DIR/tmux-generate-list.sh)" \
  --color='header:italic,prompt:cyan,pointer:green' \
  --preview "target=\$(echo {2} | sed 's/\\x1b\\[[0-9;]*m//g'); tmux capture-pane -ep -t \"\$target\"" \
  --preview-window=down:60%:border-top:noborder |
  awk -F$'\t' '{print $2}')

if [[ -n "$selected" ]]; then
  tmux switch-client -t "$selected"
fi
