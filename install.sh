#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Dotfiles Interactive Installer
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

pkg_install_cask() {
  if [[ "$OS" == "macos" ]]; then
    local pkg="$1"
    if ! brew list --cask "$pkg" &>/dev/null; then
      info "安装 $pkg (brew cask)..."
      brew install --cask "$pkg"
    fi
  fi
}

cmd_exists() { command -v "$1" &>/dev/null; }

# ============================================================
# 安装系统依赖
# ============================================================
install_deps() {
  info "检查系统依赖..."

  # stow 必须先装
  pkg_install "stow"

  # 基础工具
  pkg_install "git"
  pkg_install "tmux"
  pkg_install "fzf"

  # macOS 自带 zsh 但可能版本旧
  if [[ "$OS" == "macos" ]]; then
    pkg_install "zsh"
  else
    pkg_install "zsh"
  fi

  # wget 用于 checkNvim 下载
  pkg_install "wget"
}

# ============================================================
# 安装第三方工具（官方 installer）
# ============================================================
install_sheldon() {
  if cmd_exists sheldon; then
    ok "sheldon 已安装"
    return
  fi
  info "安装 sheldon..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi sheldon &>/dev/null || sudo pacman -S --noconfirm sheldon 2>/dev/null || {
      info "  使用官方 installer..."
      curl --proto '=https' --tlsv1.2 -sSf https://sheldon.cli.rs/install | sh
    }
  else
    curl --proto '=https' --tlsv1.2 -sSf https://sheldon.cli.rs/install | sh
  fi
}

install_starship() {
  if cmd_exists starship; then
    ok "starship 已安装"
    return
  fi
  info "安装 starship..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi starship &>/dev/null || sudo pacman -S --noconfirm starship 2>/dev/null || {
      info "  使用官方 installer..."
      curl -sS https://starship.rs/install.sh | sh -s -- -y
    }
  else
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi
}

install_mise() {
  if cmd_exists mise; then
    ok "mise 已安装"
    return
  fi
  info "安装 mise..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi mise &>/dev/null || sudo pacman -S --noconfirm mise 2>/dev/null || {
      info "  使用官方 installer..."
      curl https://mise.run | sh
    }
  else
    curl https://mise.run | sh
  fi
}

install_lazygit() {
  if cmd_exists lazygit; then
    ok "lazygit 已安装"
    return
  fi
  info "安装 lazygit..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi lazygit &>/dev/null || sudo pacman -S --noconfirm lazygit
  else
    brew install lazygit
  fi
}

install_yazi() {
  if cmd_exists yazi; then
    ok "yazi 已安装"
    return
  fi
  info "安装 yazi..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi yazi &>/dev/null || sudo pacman -S --noconfirm yazi
  else
    brew install yazi
  fi
}

install_btop() {
  if cmd_exists btop; then
    ok "btop 已安装"
    return
  fi
  info "安装 btop..."
  if [[ "$OS" == "linux" ]]; then
    pacman -Qi btop &>/dev/null || sudo pacman -S --noconfirm btop
  else
    brew install btop
  fi
}

install_terminal() {
  local term="$1"
  case "$term" in
  kitty)
    if cmd_exists kitty; then
      ok "kitty 已安装"
      return
    fi
    info "安装 kitty..."
    [[ "$OS" == "linux" ]] && sudo pacman -S --noconfirm kitty || brew install --cask kitty
    ;;
  alacritty)
    if cmd_exists alacritty; then
      ok "alacritty 已安装"
      return
    fi
    info "安装 alacritty..."
    [[ "$OS" == "linux" ]] && sudo pacman -S --noconfirm alacritty || brew install --cask alacritty
    ;;
  wezterm)
    if cmd_exists wezterm; then
      ok "wezterm 已安装"
      return
    fi
    info "安装 wezterm..."
    [[ "$OS" == "linux" ]] && sudo pacman -S --noconfirm wezterm || brew install --cask wezterm
    ;;
  esac
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

  # 尝试 stow，处理冲突
  local stow_output
  stow_output=$(stow -d "$DOTFILES_DIR" "$pkg" 2>&1)
  if [[ $? -eq 0 ]]; then
    ok "stow $pkg 完成"
    return 0
  fi

  # 检查是否已链接（无错误 = 成功）
  if echo "$stow_output" | grep -q "Already stowed"; then
    ok "$pkg 已链接"
    return 0
  fi

  # 处理冲突：备份冲突文件
  if echo "$stow_output" | grep -q "CONFLICT\|existing target"; then
    warn "$pkg 有冲突文件，备份到 $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"

    # 从 stow 输出提取冲突目标路径
    echo "$stow_output" | while IFS= read -r line; do
      # 匹配冲突文件路径
      if [[ "$line" =~ existing\ target\ is.*:[[:space:]]*(.*) ]]; then
        local relpath="${BASH_REMATCH[1]}"
        local target="$HOME/$relpath"
        if [[ -e "$target" && ! -L "$target" ]]; then
          mkdir -p "$(dirname "$BACKUP_DIR/$relpath")"
          mv "$target" "$BACKUP_DIR/$relpath"
          info "  备份: $relpath"
        fi
      fi
    done

    # 重试 stow
    stow -d "$DOTFILES_DIR" "$pkg" 2>&1
    ok "stow $pkg 完成"
  else
    warn "stow $pkg 遇到问题: $stow_output"
    return 1
  fi
}

unstow_pkg() {
  local pkg="$1"
  stow -D -d "$DOTFILES_DIR" "$pkg" 2>/dev/null || true
}

# ============================================================
# 交互式菜单
# ============================================================
show_menu() {
  echo ""
  printf "${BOLD}=== Dotfiles Installer ===${NC}\n"
  echo ""

  if [[ "$OS" == "linux" ]]; then
    printf "Detected: ${GREEN}Arch Linux${NC}\n"
  else
    printf "Detected: ${GREEN}macOS${NC}\n"
  fi
  echo ""

  printf "${BOLD}--- Core (推荐全选) ---${NC}\n"
  echo "  [1]  linux-profile - XDG 环境变量 + .zshenv"
  echo "  [2]  linux-bin     - 自定义脚本 (checkNvim, tmux-sessionizer...)"
  echo "  [3]  zsh           - Zsh + Sheldon + Starship prompt"
  echo "  [4]  git           - Git 配置"
  echo "  [5]  tmux          - Tmux + TPM + Catppuccin"
  echo "  [6]  nvim          - Neovim (checkNvim) + 配置"
  echo ""

  printf "${BOLD}--- Enhancement (可选) ---${NC}\n"
  echo "  [7]  vim        - Vim 基础配置"
  echo "  [8]  lazygit    - Lazygit TUI"
  echo "  [9]  yazi       - 文件管理器"
  echo "  [10] btop       - 系统监控"
  echo ""

  printf "${BOLD}--- Terminal (可选) ---${NC}\n"
  echo "  [11] kitty      - Kitty 终端"
  echo "  [12] alacritty  - Alacritty 终端"
  echo "  [13] wezterm    - WezTerm 终端"
  echo ""

  printf "${BOLD}--- Other (可选) ---${NC}\n"
  echo "  [14] npm        - npm/pnpm 配置"
  echo "  [15] wget       - wget 配置"
  if [[ "$OS" == "linux" ]]; then
    echo "  [16] fontconfig - 字体配置"
    echo "  [17] dwm        - dwm 状态栏脚本"
  else
    echo "  [16] yabai      - yabai + skhd 窗口管理"
  fi
  echo ""

  printf "输入编号 (如 ${GREEN}1-6${NC} 或 ${GREEN}a${NC} 全选): "
  read -r selection
  echo ""

  SELECTED=()
  case "$selection" in
  a | A | all)
    SELECTED=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
    [[ "$OS" == "linux" ]] && SELECTED+=(17)
    ;;
  *)
    # 支持 "1-6" 范围和 "1 3 5" 列表
    IFS=' ,' read -ra parts <<<"$selection"
    for part in "${parts[@]}"; do
      if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
        for i in $(seq "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"); do
          SELECTED+=("$i")
        done
      else
        SELECTED+=("$part")
      fi
    done
    ;;
  esac
}

# ============================================================
# 安装选中包
# ============================================================
install_selected() {
  # 映射: 编号 → (stow包名, 需要安装的工具)
  local want_profile=false
  local want_bin=false
  local want_zsh=false
  local want_git=false
  local want_tmux=false
  local want_nvim=false
  local want_vim=false
  local want_lazygit=false
  local want_yazi=false
  local want_btop=false
  local want_kitty=false
  local want_alacritty=false
  local want_wezterm=false
  local want_npm=false
  local want_wget=false
  local want_fontconfig=false
  local want_dwm=false
  local want_yabai=false

  for num in "${SELECTED[@]}"; do
    case "$num" in
    1) want_profile=true ;;
    2) want_bin=true ;;
    3) want_zsh=true ;;
    4) want_git=true ;;
    5) want_tmux=true ;;
    6) want_nvim=true ;;
    7) want_vim=true ;;
    8) want_lazygit=true ;;
    9) want_yazi=true ;;
    10) want_btop=true ;;
    11) want_kitty=true ;;
    12) want_alacritty=true ;;
    13) want_wezterm=true ;;
    14) want_npm=true ;;
    15) want_wget=true ;;
    16)
      if [[ "$OS" == "linux" ]]; then want_fontconfig=true; else want_yabai=true; fi
      ;;
    17)
      if [[ "$OS" == "linux" ]]; then want_dwm=true; fi
      ;;
    *) warn "无效编号: $num" ;;
    esac
  done

  # --- 1. 系统依赖 ---
  info "=== 安装系统依赖 ==="
  install_deps

  # --- 2. 第三方工具 ---
  info "=== 安装第三方工具 ==="

  if $want_zsh || $want_nvim; then
    install_sheldon
    install_starship
    install_mise
  fi
  $want_lazygit && install_lazygit
  $want_yazi && install_yazi
  $want_btop && install_btop
  $want_kitty && install_terminal kitty
  $want_alacritty && install_terminal alacritty
  $want_wezterm && install_terminal wezterm

  # --- 3. Stow 按依赖顺序 ---
  info "=== Stow 链接配置 ==="

  # 顺序: linux-profile → linux-bin → git → starship → tmux → nvim → zsh → 其余
  $want_profile && stow_pkg "linux-profile"
  $want_bin && stow_pkg "linux-bin"
  $want_git && stow_pkg "git"
  $want_wget && stow_pkg "wget"
  $want_vim && stow_pkg "vim"
  stow_pkg "starship" # starship config 始终链接（zsh 依赖）

  if $want_tmux; then
    stow_pkg "tmux"
    # 安装 TPM
    if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
      info "安装 TPM (tmux plugin manager)..."
      git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    fi
    # 在 tmux session 中安装插件（TPM 需要 tmux 环境运行）
    if [[ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]]; then
      info "安装 tmux 插件..."
      tmux new-session -d -s dotfiles-init 2>/dev/null || true
      "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || true
      tmux kill-session -t dotfiles-init 2>/dev/null || true
      ok "tmux 插件安装完成"
    fi
  fi

  if $want_nvim; then
    stow_pkg "nvim"
    # 运行 checkNvim 安装 nvim
    if ! cmd_exists nvim; then
      local check_nvim=""
      for p in "$HOME/.local/bin/common/checkNvim" "$HOME/.local/bin/checkNvim"; do
        if [[ -x "$p" ]]; then
          check_nvim="$p"
          break
        fi
      done
      if [[ -n "$check_nvim" ]]; then
        info "使用 checkNvim 安装 Neovim..."
        # 非交互模式：自动确认
        echo "y" | "$check_nvim"
      else
        warn "checkNvim 未找到，跳过 nvim 安装"
      fi
    else
      ok "nvim 已安装: $(nvim -v 2>/dev/null | head -1)"
    fi
  fi

  if $want_zsh; then
    stow_pkg "zsh-sheldon"
    # sheldon 初始化 — 下载插件并生成 lock 文件
    if cmd_exists sheldon; then
      info "初始化 sheldon 插件（可能需要几分钟下载）..."
      if ! timeout 120 sheldon lock --update 2>&1; then
        warn "sheldon lock 超时或失败，首次启动 zsh 时会自动重试"
      fi
    fi
  fi

  # 可选包
  $want_lazygit && stow_pkg "lazygit"
  $want_yazi && stow_pkg "yazi"
  $want_btop && stow_pkg "btop"
  $want_kitty && stow_pkg "kitty"
  $want_alacritty && stow_pkg "alacritty"
  $want_wezterm && stow_pkg "wezterm"
  $want_npm && stow_pkg "npm"
  $want_fontconfig && stow_pkg "fontconfig"
  $want_dwm && stow_pkg "dwm"
  $want_yabai && stow_pkg "yabai"

  # --- 4. 提示设置默认 shell ---
  if $want_zsh; then
    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ "$SHELL" != "$zsh_path" ]]; then
      warn "请手动设置默认 shell: chsh -s $zsh_path, sudo chsh -s $zsh_path testuser"
    fi
  fi
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
  check_cmd "tmux" "tmux $(tmux -V 2>/dev/null)"
  # nvim 可能安装在 ~/.local/bin，不在默认 PATH 中
  local nvim_path
  nvim_path="$(command -v nvim 2>/dev/null || echo "$HOME/.local/bin/nvim")"
  if [[ -x "$nvim_path" ]]; then
    ok "$("$nvim_path" --version 2>/dev/null | head -1)"
  else
    error "nvim 未安装"
  fi
  check_cmd "sheldon" "sheldon"
  check_cmd "starship" "starship"
  check_cmd "mise" "mise"
  check_cmd "fzf" "fzf"

  echo ""
  printf "${BOLD}--- 符号链接检查 ---${NC}\n"
  check_link "$HOME/.zshenv"
  check_link "$HOME/.config/zsh"
  check_link "$HOME/.config/git"
  check_link "$HOME/.config/nvim"
  check_link "$HOME/.config/tmux"
  check_link "$HOME/.config/starship.toml"

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
  show_menu

  if [[ ${#SELECTED[@]} -eq 0 ]]; then
    warn "未选择任何包"
    exit 0
  fi

  info "将安装 ${#SELECTED[@]} 个包"
  echo ""

  install_selected
  verify
}

main "$@"
