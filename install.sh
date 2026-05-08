#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Dotfiles Minimal Installer
# 仅安装核心依赖，其余工具通过 lazy.zsh 按需安装
# Supports: Arch Linux, macOS
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info() { printf "${BLUE}[INFO]${NC}  %s\n" "$1"; }
ok() { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$1"; }

# ============================================================
# OS 检测
# ============================================================
detect_os() {
  case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux) OS="linux" ;;
  *)
    error "不支持的系统: $(uname -s)"
    exit 1
    ;;
  esac
  info "检测到系统: $OS"
}

# ============================================================
# 包管理器封装
# ============================================================
pkg_install() {
  local pkg="$1"
  if [[ "$OS" == "linux" ]]; then
    if ! pacman -Qi "$pkg" &>/dev/null; then
      info "安装 $pkg (pacman)..."
      sudo pacman -S --noconfirm "$pkg"
    fi
  else
    if ! brew list "$pkg" &>/dev/null; then
      info "安装 $pkg (brew)..."
      brew install "$pkg"
    fi
  fi
}

cmd_exists() { command -v "$1" &>/dev/null; }

# ============================================================
# 安装系统依赖（仅核心）
# ============================================================
install_deps() {
  info "检查系统依赖..."
  pkg_install "stow"
  pkg_install "git"
  pkg_install "zsh"
  pkg_install "fzf"
  pkg_install "wget"
}

# ============================================================
# 安装第三方工具（zsh 启动必需）
# ============================================================
install_with_fallback() {
  local name="$1" cmd="$2" pkg="$3" url="$4"
  shift 4
  if cmd_exists "$cmd"; then
    ok "$name 已安装"
    return
  fi
  info "安装 $name..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi "$pkg" &>/dev/null || sudo pacman -S --noconfirm "$pkg" 2>/dev/null || {
      info "  使用官方 installer..."
      curl -sSf "$url" | sh "$@"
    }
  else
    curl -sSf "$url" | sh "$@"
  fi
}

install_sheldon() { install_with_fallback "sheldon" "sheldon" "sheldon" "https://sheldon.cli.rs/install"; }
install_starship() { install_with_fallback "starship" "starship" "starship" "https://starship.rs/install.sh" -s -- -y; }
install_mise() {
  stow_pkg "mise"
  if ! cmd_exists mise; then
    info "安装 mise..."
    curl -sSf https://mise.run | sh
  fi
  # 初始化 gnupg（避免 gpg keyblock 报错）
  local gnupg_dir="$HOME/.local/share/gnupg"
  if [[ ! -d "$gnupg_dir" ]]; then
    mkdir -p "$gnupg_dir"
    chmod 700 "$gnupg_dir"
  fi
}

# ============================================================
# Stow 管理
# ============================================================
stow_pkg() {
  local pkg="$1"
  if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
    warn "包 '$pkg' 不存在，跳过"
    return 1
  fi

  local stow_output
  stow_output=$(stow -d "$DOTFILES_DIR" "$pkg" 2>&1)
  if [[ $? -eq 0 ]]; then
    ok "stow $pkg 完成"
    return 0
  fi

  if echo "$stow_output" | grep -q "Already stowed"; then
    ok "$pkg 已链接"
    return 0
  fi

  if echo "$stow_output" | grep -q "CONFLICT\|existing target"; then
    warn "$pkg 有冲突文件，备份到 $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"

    while IFS= read -r line; do
      if [[ "$line" =~ existing\ target\ is.*:[[:space:]]*(.*) ]]; then
        local relpath="${BASH_REMATCH[1]}"
        local target="$HOME/$relpath"
        if [[ -e "$target" && ! -L "$target" ]]; then
          mkdir -p "$(dirname "$BACKUP_DIR/$relpath")"
          mv "$target" "$BACKUP_DIR/$relpath"
          info "  备份: $relpath"
        fi
      fi
    done <<<"$stow_output"

    stow -d "$DOTFILES_DIR" "$pkg" 2>&1
    ok "stow $pkg 完成"
  else
    warn "stow $pkg 遇到问题: $stow_output"
    return 1
  fi
}

# ============================================================
# linux-bin 专用安装
# ============================================================
LOCAL_DIRS=(bin src share lib state backup)

init_local() {
  info "初始化 ~/.local 目录结构..."
  for dir in "${LOCAL_DIRS[@]}"; do
    mkdir -p "$HOME/.local/$dir"
  done
  ok "~/.local 目录就绪"
}

bin_install() {
  init_local

  local src_dir="$DOTFILES_DIR/linux-bin/.local/bin"
  if [[ ! -d "$src_dir" ]]; then
    warn "linux-bin/.local/bin 不存在，跳过"
    return 1
  fi

  info "链接自定义脚本..."
  for item in "$src_dir"/*; do
    [[ -e "$item" ]] || continue
    local name
    name="$(basename "$item")"
    local target="$HOME/.local/bin/$name"

    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
      warn "  跳过 $name (已存在非链接文件)"
      continue
    fi

    ln -sfn "$item" "$target"
    ok "  链接 $name"
  done
}

# ============================================================
# 验证
# ============================================================
verify() {
  echo ""
  printf "${BOLD}=== 安装验证 ===${NC}\n"

  check_cmd() {
    if cmd_exists "$1"; then
      ok "$2"
    else
      error "$2 未安装"
    fi
  }

  check_link() {
    if [[ -L "$1" ]]; then
      ok "$1 → $(readlink "$1")"
    elif [[ -e "$1" ]]; then
      warn "$1 存在但不是符号链接"
    else
      error "$1 不存在"
    fi
  }

  check_cmd "zsh" "zsh $(zsh --version 2>/dev/null | head -1)"
  check_cmd "git" "git $(git --version 2>/dev/null)"
  check_cmd "sheldon" "sheldon"
  check_cmd "starship" "starship"
  check_cmd "mise" "mise"
  check_cmd "fzf" "fzf"

  echo ""
  printf "${BOLD}--- 符号链接检查 ---${NC}\n"
  check_link "$HOME/.zshenv"
  check_link "$HOME/.config/zsh"
  check_link "$HOME/.config/git"
  check_link "$HOME/.config/starship.toml"

  echo ""
  printf "${BOLD}--- lazy.zsh 已接管按需安装 ---${NC}\n"
  printf "首次使用 tmux / lazygit / yazi / btop 等工具时会自动安装并配置\n"

  echo ""
  if [[ -d "$BACKUP_DIR" ]]; then
    printf "${YELLOW}备份文件位于: $BACKUP_DIR${NC}\n"
  fi
  printf "${GREEN}安装完成! 请运行: exec zsh -l${NC}\n"
}

# ============================================================
# Main
# ============================================================
main() {
  detect_os

  if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    local target="$HOME/.dotfiles"
    if [[ -d "$target" ]]; then
      warn "$target 已存在，跳过克隆"
    else
      info "克隆 dotfiles 仓库..."
      git clone https://github.com/Nhjkl/dotfiles.git "$target"
    fi
    cd "$target"
    exec "$target/install.sh" "$@"
  fi

  # --- 1. 系统依赖 ---
  info "=== 安装系统依赖 ==="
  install_deps

  # --- 2. Stow wget 配置（后续下载依赖 wgetrc） ---
  info "=== Stow wget 配置 ==="
  stow_pkg "wget"

  # --- 3. zsh 启动必需工具 ---
  info "=== 安装 zsh 核心工具 ==="
  install_sheldon
  install_starship
  install_mise

  # --- 4. Stow 核心配置 ---
  info "=== Stow 链接配置 ==="
  stow_pkg "linux-profile"
  stow_pkg "zsh"
  bin_install
  stow_pkg "git"
  stow_pkg "npm"
  stow_pkg "starship"

  # --- 5. sheldon 初始化 ---
  if cmd_exists sheldon; then
    info "初始化 sheldon 插件..."
    if ! timeout 120 sheldon lock --update 2>&1; then
      warn "sheldon lock 超时或失败，首次启动 zsh 时会自动重试"
    fi
  fi

  # --- 6. 提示设置默认 shell ---
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "$SHELL" != "$zsh_path" ]]; then
    warn "请手动设置默认 shell: chsh -s $zsh_path"
  fi

  verify
}

main "$@"
