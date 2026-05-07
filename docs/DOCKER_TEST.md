# Docker 交互式测试教程

模拟一台全新的 Arch Linux 机器，逐步测试 dotfiles 安装脚本。

## 前置条件

```bash
# 确保 Docker 已安装并运行
docker --version
```

## Step 1: 构建测试镜像

```bash
cd ~/dotfiles
docker build -f Dockerfile.interactive -t dotfiles-interactive .
```

这会构建一个最小化的 Arch Linux 环境，只装了 `sudo`，模拟全新系统。

## Step 2: 进入容器（带代理）

容器内需要代理才能访问 GitHub（下载 nvim、sheldon 插件等）。

推荐使用 `--network host` 模式，容器直接共享宿主机网络，`127.0.0.1:7890` 直接可用：

```bash
docker run -it --rm \
  --network host \
  -e http_proxy=http://127.0.0.1:7890 \
  -e https_proxy=http://127.0.0.1:7890 \
  -e all_proxy=socks5://127.0.0.1:7890 \
  dotfiles-interactive
```

进入容器后验证代理是否生效：

```bash
curl -I https://github.com 2>/dev/null | head -3
# 看到 HTTP/2 200 就说明代理通了
```

> **如果 `--network host` 不可用**（某些环境限制），可以用桥接模式：
> ```bash
> docker run -it --rm \
>   --add-host=host.docker.internal:host-gateway \
>   -e http_proxy=http://host.docker.internal:7890 \
>   -e https_proxy=http://host.docker.internal:7890 \
>   -e all_proxy=socks5://host.docker.internal:7890 \
>   dotfiles-interactive
> ```
> 注意：桥接模式需要代理客户端开启「允许局域网连接」(Allow LAN)。
> FlClash 路径：**工具 → 覆写 → 基础 → 局域网共享**。

## Step 3: 确认初始状态

```bash
# 确认是干净环境
command -v stow    # 应该找不到
command -v zsh     # 应该找不到
command -v tmux    # 应该找不到
ls ~/dotfiles      # 确认 dotfiles 已复制
```

## Step 4: 运行安装脚本

```bash
cd ~/dotfiles
bash install.sh
```

你会看到交互式菜单：

```
=== Dotfiles Installer ===
Detected: Arch Linux

--- Core (推荐全选) ---
  [1]  linux-profile - XDG 环境变量 + .zshenv
  [2]  linux-bin     - 自定义脚本 (checkNvim, tmux-sessionizer...)
  [3]  zsh           - Zsh + Sheldon + Starship prompt
  [4]  git           - Git 配置
  [5]  tmux          - Tmux + TPM + Catppuccin
  [6]  nvim          - Neovim (checkNvim) + 配置

  ...

输入编号 (如 1-6 或 a 全选):
```

**第一次测试 — 输入 `1-6` 安装核心包。**

脚本会自动：

1. 通过 pacman 安装 stow、zsh、git、tmux、fzf、wget
2. 安装 sheldon、starship、mise
3. 按顺序 stow 各包
4. sheldon 下载插件并生成 lock 文件
5. checkNvim 下载安装 nvim（需要代理）
6. 安装 TPM 和 tmux 插件
7. 设置默认 shell

## Step 5: 验证安装

脚本会自动输出验证结果。你也可以手动检查：

```bash
# 符号链接
ls -la ~/.zshenv
ls -la ~/.config/zsh
ls -la ~/.config/git
ls -la ~/.config/tmux
ls -la ~/.config/nvim
ls -la ~/.config/starship.toml

# 命令版本
zsh --version
git --version
tmux -V
~/.local/bin/nvim --version | head -1
sheldon --version
starship --version
mise --version

# 尝试加载 zsh 配置
zsh -c 'source ~/.config/zsh/.zshrc && echo "zshrc loaded OK"'
```

## Step 6: 测试 zsh 环境

```bash
# 启动 zsh
zsh

# 在 zsh 中测试
alias          # 查看别名
,cc            # 测试 claude CLI 别名（会提示找不到，正常）
,t             # 测试 tmux-sessionizer（会提示找不到 tmux，正常 — 因为无终端）

# 退出 zsh
exit
```

## Step 7: 测试单独安装某个包

退出容器，重新进入干净环境测试单个包：

```bash
# 在宿主机执行
docker run -it --rm \
  --network host \
  -e http_proxy=http://127.0.0.1:7890 \
  -e https_proxy=http://127.0.0.1:7890 \
  -e all_proxy=socks5://127.0.0.1:7890 \
  dotfiles-interactive

# 在容器内 — 只安装 tmux
cd ~/dotfiles
bash install.sh
# 输入: 5
```

## Step 8: 测试全选

```bash
# 在宿主机执行
docker run -it --rm \
  --network host \
  -e http_proxy=http://127.0.0.1:7890 \
  -e https_proxy=http://127.0.0.1:7890 \
  -e all_proxy=socks5://127.0.0.1:7890 \
  dotfiles-interactive

# 在容器内
cd ~/dotfiles
bash install.sh
# 输入: a
```

## Step 9: 测试重复运行

```bash
# 第一次安装后，再次运行
bash install.sh
# 再次输入 1-6
# 应该看到所有包显示 "已安装" 或 "已链接"，不会重复安装
```

## 快速命令参考

```bash
# 构建镜像
docker build -f Dockerfile.interactive -t dotfiles-interactive .

# 进入容器（带代理，推荐）
docker run -it --rm \
  --network host \
  -e http_proxy=http://127.0.0.1:7890 \
  -e https_proxy=http://127.0.0.1:7890 \
  -e all_proxy=socks5://127.0.0.1:7890 \
  dotfiles-interactive

# 后台运行容器（可反复进入）
docker run -itd --name dotfiles-test \
  --network host \
  -e http_proxy=http://127.0.0.1:7890 \
  -e https_proxy=http://127.0.0.1:7890 \
  -e all_proxy=socks5://127.0.0.1:7890 \
  dotfiles-interactive
docker exec -it dotfiles-test bash
docker stop dotfiles-test && docker rm dotfiles-test

# 自动化测试（非交互，用于 CI）
docker build -f Dockerfile.test -t dotfiles-test .
docker run --rm dotfiles-test
```
