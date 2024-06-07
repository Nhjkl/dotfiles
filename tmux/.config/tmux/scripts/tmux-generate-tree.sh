#!/bin/bash
# Generate tmux pane list for fzf (with TAB delimiter)
# Format: session > window > pane

COLOR_MODE="${1:-off}"

# Color palette for sessions
COLORS=(
  "\033[38;5;39m"   # cyan
  "\033[38;5;213m"  # pink
  "\033[38;5;226m"  # yellow
  "\033[38;5;81m"   # blue
  "\033[38;5;228m"  # white/yellow
  "\033[38;5;120m"  # green
  "\033[38;5;213m"  # magenta
  "\033[38;5;215m"  # orange
)

get_session_color() {
  local session="$1"
  if [ "$COLOR_MODE" = "on" ]; then
    # Generate color index from session name hash
    local hash=0
    for ((i=0; i<${#session}; i++)); do
      hash=$(( (hash * 31 + $(printf "%d" "'${session:$i:1}") ) % 1000 ))
    done
    local index=$((hash % ${#COLORS[@]}))
    echo -e "${COLORS[$index]}"
  else
    echo ""  # no color
  fi
}

current_session=$(tmux display-message -p '#S')
current_window=$(tmux display-message -p '#I')
current_pane=$(tmux display-message -p '#P')

tmux list-sessions -F '#{session_name}' | while read -r session; do
  session_color=$(get_session_color "$session")
  reset="\033[0m"

  # Windows
  tmux list-windows -t "$session" -F '#{window_index}:#{window_name}' | while IFS=: read -r win_idx win_name; do
    [ -z "$win_name" ] && win_name="<no name>"

    # Panes
    tmux list-panes -t "$session:$win_idx" -F '#{pane_index}:#{pane_current_command}' | while IFS=: read -r pane_idx pane_cmd; do
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
    done
  done
done
