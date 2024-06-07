#!/bin/bash
# fzf interface to run project commands in a new tmux window
# Supports: Node.js (package.json), Rust (Cargo.toml)

CURRENT_PATH="$(tmux display-message -p '#{pane_current_path}')"

# Detect project type
if [[ -f "$CURRENT_PATH/package.json" ]]; then
  PROJECT_TYPE="node"
  PACKAGE_JSON="$CURRENT_PATH/package.json"

  # Extract scripts using node
  scripts=$(node -e "
    const pkg = require('$PACKAGE_JSON');
    if (pkg.scripts) {
      Object.entries(pkg.scripts).forEach(([name, cmd]) => {
        console.log(name + '\t' + cmd);
      });
    }
  " 2>/dev/null)

  # Add fixed command
  scripts="claude"$'\n'"$scripts"

  if [[ -z "$scripts" ]]; then
    echo "No scripts found in package.json" | fzf --ansi --reverse \
      --height=20% \
      --border=rounded \
      --prompt='Press ESC to exit > ' \
      --pointer='►' \
      --color='header:italic,prompt:red,pointer:green'
    exit 1
  fi

  selected=$(echo "$scripts" | fzf --ansi --reverse \
    --with-nth=1 \
    --delimiter=$'\t' \
    --height=100% \
    --border=rounded \
    --prompt='npm > ' \
    --pointer='►' \
    --bind 'ctrl-/:toggle-preview' \
    --color='header:italic,prompt:cyan,pointer:green' \
    --preview-window=down:30%:border-top:noborder \
    --preview="echo -e '{2}'" |
    awk -F$'\t' '{print $1}')

  if [[ -n "$selected" ]]; then
    if [[ "$selected" == "claude" ]]; then
      tmux new-window -n "claude" -c "$CURRENT_PATH" "claude --dangerously-skip-permissions; exec $SHELL"
    else
      tmux new-window -n "npm run $selected" -c "$CURRENT_PATH" "npm run $selected; exec $SHELL"
    fi
  fi

elif [[ -f "$CURRENT_PATH/Cargo.toml" ]]; then
  PROJECT_TYPE="rust"

  # Common cargo commands
  scripts="claude
build
run
test
check
clean
doc
run --release
build --release"

  selected=$(echo "$scripts" | fzf --ansi --reverse \
    --height=100% \
    --border=rounded \
    --prompt='cargo > ' \
    --pointer='►' \
    --color='header:italic,prompt:cyan,pointer:green')

  if [[ -n "$selected" ]]; then
    if [[ "$selected" == "claude" ]]; then
      tmux new-window -n "claude" -c "$CURRENT_PATH" "claude --dangerously-skip-permissions; exec $SHELL"
    else
      tmux new-window -n "cargo $selected" -c "$CURRENT_PATH" "cargo $selected; exec $SHELL"
    fi
  fi

else
  # No project detected, still offer claude
  scripts="claude"

  selected=$(echo "$scripts" | fzf --ansi --reverse \
    --height=100% \
    --border=rounded \
    --prompt='commands > ' \
    --pointer='►' \
    --color='header:italic,prompt:cyan,pointer:green')

  if [[ -n "$selected" ]]; then
    tmux new-window -n "claude" -c "$CURRENT_PATH" "claude --dangerously-skip-permissions; exec $SHELL"
  fi
fi
