# dotfiles

使用 GNU Stow 管理的个人配置文件，支持 Arch Linux 和 macOS。

## 快速安装

```bash
git clone git@github.com:Nhjkl/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

交互式菜单选择要安装的组件，推荐选择 `1-6` 安装核心环境。

## 手动安装

```bash
# 安装 stow
# macOS:
brew install stow
# Arch Linux:
sudo pacman -S stow

# 链接单个包
cd ~/dotfiles
stow <package>
```

## Stow 包列表

### Core

| 包              | 说明                                        |
| --------------- | ------------------------------------------- |
| `linux-profile` | XDG 环境变量 + `.zshenv`                    |
| `linux-bin`     | 自定义脚本 (checkNvim, tmux-sessionizer...) |
| `zsh-sheldon`   | Zsh + Sheldon + Starship                    |
| `git`           | Git 配置                                    |
| `tmux`          | Tmux + TPM + Catppuccin                     |
| `nvim`          | Neovim (LazyVim) 配置                       |

### Enhancement

| 包         | 说明         |
| ---------- | ------------ |
| `vim`      | Vim 基础配置 |
| `lazygit`  | Lazygit TUI  |
| `yazi`     | 文件管理器   |
| `btop`     | 系统监控     |
| `starship` | Prompt 主题  |

### Terminal

| 包          | 说明           |
| ----------- | -------------- |
| `kitty`     | Kitty 终端     |
| `alacritty` | Alacritty 终端 |
| `wezterm`   | WezTerm 终端   |

### Other

| 包           | 说明                   |
| ------------ | ---------------------- |
| `npm`        | npm/pnpm 配置          |
| `wget`       | wget 配置              |
| `fontconfig` | 字体配置 (Linux)       |
| `dwm`        | dwm 状态栏脚本 (Linux) |
| `yabai`      | yabai + skhd (macOS)   |

## root 用户 zsh

```bash
sudo stow zsh-sheldon -t /root
```
