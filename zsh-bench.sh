#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
SHELDON_DIR="$DOTFILES/zsh-sheldon/.config/zsh"
OMZ_DIR="$DOTFILES/zsh-omz/.config/zsh"

if ! command -v hyperfine &>/dev/null; then
  echo "hyperfine not found. Install: cargo install hyperfine"
  exit 1
fi

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║       Zsh Startup Benchmark          ║"
echo "  ║   Sheldon (optimized) vs Oh-My-Zsh   ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

export SHELDON_DIR OMZ_DIR

hyperfine \
  --warmup 2 \
  --runs 10 \
  --style full \
  --shell=bash \
  'ZDOTDIR="$SHELDON_DIR" HOME="$HOME" zsh -i -c "exit"' \
  'ZDOTDIR="$OMZ_DIR" HOME="$HOME" zsh -i -c "exit"'
