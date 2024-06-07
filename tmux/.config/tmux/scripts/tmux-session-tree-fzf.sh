#!/bin/bash
# tmux session/window/pane tree manager with preview and kill support

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER_SCRIPT="$SCRIPT_DIR/tmux-generate-tree-with-mode.sh"
STATE_FILE="/tmp/tmux-fzf-color-mode"
current_session=$(tmux display-message -p '#S')

# Initialize state file
[ ! -f "$STATE_FILE" ] && echo "on" > "$STATE_FILE"

selected=$("$WRAPPER_SCRIPT" | fzf --ansi --reverse --with-nth=1 --delimiter=$'\t' \
  --height=100% \
  --border=rounded \
  --prompt='Pane > ' \
  --pointer='►' \
  --bind 'ctrl-/:toggle-preview' \
  --bind 'ctrl-c:execute-silent([ -f '$STATE_FILE' ] && current=$(cat '$STATE_FILE') || current=off; [ "$current" = "off" ] && echo on > '$STATE_FILE' || echo off > '$STATE_FILE')+reload('$WRAPPER_SCRIPT')' \
  --bind 'ctrl-s:execute-silent(session=$(echo {2} | sed "s/\x1b\[[0-9;]*m//g" | cut -d: -f1); if [ "$session" != "'"$current_session"'" ]; then tmux kill-session -t "$session"; else tmux display-message "Cannot kill current session"; fi)+reload('$WRAPPER_SCRIPT')' \
  --bind 'ctrl-w:execute-silent(session=$(echo {2} | sed "s/\x1b\[[0-9;]*m//g" | cut -d: -f1); window=$(echo {2} | sed "s/\x1b\[[0-9;]*m//g" | cut -d: -f2); if [ "$session" = "'"$current_session"'" ]; then window_count=$(tmux display-message -t "$session" -p "#{window_count}"); if [ "$window_count" -le 1 ]; then tmux display-message "Cannot kill last window"; exit; fi; fi; tmux kill-window -t "$session:$window")+reload('$WRAPPER_SCRIPT')' \
  --bind 'ctrl-x:execute-silent(target=$(echo {2} | sed "s/\x1b\[[0-9;]*m//g"); session=$(echo "$target" | cut -d: -f1); window=$(echo "$target" | cut -d: -f2); if [ "$session" = "'"$current_session"'" ]; then pane_count=$(tmux display-message -t "$session:$window" -p "#{window_panes}"); if [ "$pane_count" -le 1 ]; then tmux display-message "Cannot kill last pane"; exit; fi; fi; tmux kill-pane -t "$target")+reload('$WRAPPER_SCRIPT')' \
  --bind 'ctrl-a:execute-silent(target=$(echo {2} | sed "s/\x1b\[[0-9;]*m//g"); tmux kill-pane -t "$target")+reload('$WRAPPER_SCRIPT')' \
  --color='header:italic,prompt:cyan,pointer:green' \
  --preview 'target=$(echo {2} | sed "s/\x1b\[[0-9;]*m//g"); tmux capture-pane -ep -t "$target"' \
  --preview-window=right:55%:border-left:noborder:hidden)

# Strip ANSI codes from selected
selected=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g' | awk -F$'\t' '{print $2}')

if [[ -n "$selected" ]]; then
  if [[ "$selected" =~ \.[0-9]+$ ]]; then
    tmux switch-client -t "$selected" 2>/dev/null || true
    tmux select-window -t "$selected" 2>/dev/null || true
    tmux select-pane -t "$selected"
  elif [[ "$selected" =~ :[0-9]+$ ]]; then
    tmux switch-client -t "$selected" 2>/dev/null || true
    tmux select-window -t "$selected"
  else
    tmux switch-client -t "$selected"
  fi
fi
