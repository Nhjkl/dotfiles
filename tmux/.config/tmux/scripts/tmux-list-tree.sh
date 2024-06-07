#!/bin/bash
# List tmux sessions/windows/panes in tree format

current_session=$(tmux display-message -p '#S')
current_window=$(tmux display-message -p '#I')
current_pane=$(tmux display-message -p '#P')

# List all sessions
tmux list-sessions -F '#{session_name}' | while read -r session; do
  # Session header
  if [ "$session" = "$current_session" ]; then
    printf "\033[1;32m┌─ \033[1;36m%s\033[0m\n" "$session"
  else
    printf "┌─ \033[1;36m%s\033[0m\n" "$session"
  fi

  # List windows in this session
  tmux list-windows -t "$session" -F '#{window_index}:#{window_name}:#{window_panes}' | while IFS=: read -r win_idx win_name win_panes; do
    win_prefix="│  └─"

    # Check if this is the current window
    if [ "$session" = "$current_session" ] && [ "$win_idx" = "$current_window" ]; then
      printf "\033[1;32m%s [%s] %s\033[0m\n" "$win_prefix" "$win_idx" "$win_name"
    else
      printf "%s [%s] %s\n" "$win_prefix" "$win_idx" "$win_name"
    fi

    # List panes in this window (if more than 1 pane or show all)
    tmux list-panes -t "$session:$win_idx" -F '#{pane_index}:#{pane_current_command}:#{pane_current_path}' | while IFS=: read -r pane_idx pane_cmd pane_path; do
      pane_prefix="│     └─"

      # Format pane path (shorten)
      pane_path_short=$(basename "$pane_path")

      # Check if this is the current pane
      if [ "$session" = "$current_session" ] && [ "$win_idx" = "$current_window" ] && [ "$pane_idx" = "$current_pane" ]; then
        printf "\033[1;32m%s [%s] %s @ %s\033[0m\n" "$pane_prefix" "$pane_idx" "$pane_cmd" "$pane_path_short"
      else
        printf "%s [%s] %s @ %s\n" "$pane_prefix" "$pane_idx" "$pane_cmd" "$pane_path_short"
      fi
    done
  done

  # Empty line between sessions
  echo ""
done
