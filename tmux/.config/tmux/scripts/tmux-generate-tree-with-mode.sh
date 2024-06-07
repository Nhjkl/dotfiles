#!/bin/bash
# Wrapper script to get list with current color mode
STATE_FILE="/tmp/tmux-fzf-color-mode"
MODE=$(cat "$STATE_FILE" 2>/dev/null || echo "on")
~/.config/tmux/scripts/tmux-generate-tree.sh "$MODE"
