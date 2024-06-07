#!/bin/bash
# Generate list of tmux sessions/windows for fzf

current_session=$(tmux display-message -p '#S')
current_window=$(tmux display-message -p '#I')

tmux list-windows -a -F '#{window_activity}:#{session_name}:#{window_index}:#{window_name}#{?#{>:#{window_panes},1}, [#{window_panes}p],}' |
  sort -rn |
  cut -d: -f2- |
  awk -v cs="$current_session" -v cw="$current_window" -F: '
    {
      display = $1":"$3;
      value = $1":"$2;
      if ($1 == cs && $2 == cw)
        print "\033[1;32m" display "\033[0m\t" value;
      else
        print display "\t" value;
    }'
