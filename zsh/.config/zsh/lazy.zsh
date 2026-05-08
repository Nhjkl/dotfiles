#!/bin/zsh

# ── Lazy Setup ───────────────────────────────────────────
# 命令找不到时自动安装并配置（仅白名单内的命令）

DOTFILES_DIR="${DOTFILES_DIR:-${0:A:h:h:h:h}}"

# ── 通用工具 ──────────────────────────────────────────────
_lazy_install() {
  local pkg="$1"
  echo "lazy: installing $pkg..."
  case "$(uname -s)" in
    Darwin) brew install "$pkg" ;;
    Linux)  sudo pacman -S --noconfirm "$pkg" ;;
  esac
}

_lazy_stow() {
  local pkg="$1"
  [[ -d "$DOTFILES_DIR/$pkg" ]] || return 0
  stow -d "$DOTFILES_DIR" "$pkg" 2>/dev/null
}

# ── 各工具 setup 函数（安装 + 配置）──────────────────────

setup_fastfetch() { _lazy_install fastfetch }

setup_btop()      { _lazy_stow btop;    _lazy_install btop }
setup_lazygit()   { _lazy_stow lazygit; _lazy_install lazygit }
setup_yazi()      { _lazy_stow yazi;    _lazy_install yazi }

setup_tmux() {
  _lazy_stow tmux
  _lazy_install tmux
  local tpm="$HOME/.local/share/tmux/plugins"
  [[ -d "$tpm" ]] || git clone https://github.com/tmux-plugins/tpm "$tpm" 2>/dev/null
  [[ -x "$tpm/bin/install_plugins" ]] && "$tpm/bin/install_plugins" 2>/dev/null
}

setup_mise() {
  _lazy_stow mise
  if ! command -v mise &>/dev/null; then
    curl -sSf https://mise.run | sh
    # 安装后 source zshrc 使 init.zsh 中的 mise activate 生效
    source "${ZDOTDIR:-$HOME/.config/zsh}/.zshrc"
    return 0
  fi
  local gnupg_dir="$HOME/.local/share/gnupg"
  if [[ ! -d "$gnupg_dir" ]]; then
    mkdir -p "$gnupg_dir"
    chmod 700 "$gnupg_dir"
  fi
}
setup_nvim() { _lazy_stow nvim; echo "y" | checkNvim }
setup_eza() { _lazy_install eza }
setup_bat() { _lazy_install bat }
setup_fd()  { _lazy_install fd }

# ── 命令 → setup 函数映射 ────────────────────────────────
typeset -gA _lazy_map=(
  fastfetch setup_fastfetch
  btop      setup_btop
  lazygit   setup_lazygit
  yazi      setup_yazi
  tmux      setup_tmux
  nvim      setup_nvim
  mise      setup_mise
  eza       setup_eza
  bat       setup_bat
  fd        setup_fd
)

# ── Handler ───────────────────────────────────────────────
command_not_found_handler() {
  local cmd="$1"; shift
  local fn="${_lazy_map[$cmd]:-}"
  [[ -z "$fn" ]] && { echo "zsh: command not found: $cmd" >&2; return 127 }
  "$fn" && command "$cmd" "$@"
}
