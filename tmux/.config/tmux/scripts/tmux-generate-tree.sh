#!/bin/bash
# Generate tmux pane list for fzf (with TAB delimiter)
# Format: session > window > pane

COLOR_MODE="${1:-off}"

# Two alternating colors for sessions
COLORS=(
  "\033[38;5;75m"  # light blue
  "\033[38;5;215m" # orange
)

get_session_color() {
  local index="$1"
  if [ "$COLOR_MODE" = "on" ]; then
    echo -e "${COLORS[$((index % ${#COLORS[@]}))]}"
  else
    echo ""
  fi
}

current_session=$(tmux display-message -p '#S')
current_window=$(tmux display-message -p '#I')
current_pane=$(tmux display-message -p '#P')

session_idx=0
while read -r session; do
  session_color=$(get_session_color "$session_idx")
  reset="\033[0m"

  # Windows
  while IFS=: read -r win_idx win_name; do
    [ -z "$win_name" ] && win_name="<no name>"

    # Panes
    while IFS=: read -r pane_idx pane_cmd; do
      target="${session}:${win_idx}.${pane_idx}"
      display="$session > [$win_idx] $win_name > [$pane_idx] $pane_cmd"

      if [ "$session" = "$current_session" ] && [ "$win_idx" = "$current_window" ] && [ "$pane_idx" = "$current_pane" ]; then
        # Current pane: bold + color
        if [ -n "$session_color" ]; then
          printf "\033[1;32m●${reset} \033[1m${session_color}%s${reset}\t%s\n" "$display" "$target"
        else
          printf "\033[1;32m●\033[0m \033[1;32m%s\033[0m\t%s\n" "$display" "$target"
        fi
      else
        # Other panes: normal color
        if [ -n "$session_color" ]; then
          printf "  ${session_color}%s${reset}\t%s\n" "$display" "$target"
        else
          printf "  %s\t%s\n" "$display" "$target"
        fi
      fi
    done < <(tmux list-panes -t "$session:$win_idx" -F '#{pane_index}:#{pane_current_command}')
  done < <(tmux list-windows -t "$session" -F '#{window_index}:#{window_name}')
  session_idx=$((session_idx + 1))
done < <(tmux list-sessions -F '#{session_name}')
