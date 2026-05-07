# Docker 交互式测试教程

模拟一台全新的 Arch Linux 机器，测试 dotfiles 一键安装脚本。

## 前置条件

```bash
docker --version
```

## Step 1: 构建测试镜像

```bash
cd ~/dotfiles
docker build -f Dockerfile.interactive -t dotfiles-interactive .
```

构建一个最小化 Arch Linux 环境，预装 `sudo`、`git`、`curl`，代理默认 `127.0.0.1:7890`。

## Step 2: 进入容器

使用 `--network host` 共享宿主机网络，代理直接可用：

```bash
docker run -it --rm --network host dotfiles-interactive
```

进入容器后验证代理：

```bash
curl -I https://github.com 2>/dev/null | head -3
# 看到 HTTP/2 200 就说明代理通了
```

> **覆盖代理地址**（如果代理不在 7890 端口）：
>
> ```bash
> docker run -it --rm --network host \
>   -e http_proxy=http://127.0.0.1:9090 \
>   -e https_proxy=http://127.0.0.1:9090 \
>   -e all_proxy=socks5://127.0.0.1:9090 \
>   dotfiles-interactive
> ```

> **桥接模式**（`--network host` 不可用时）：
>
> ```bash
> docker run -it --rm \
>   --add-host=host.docker.internal:host-gateway \
>   -e http_proxy=http://host.docker.internal:7890 \
>   -e https_proxy=http://host.docker.internal:7890 \
>   -e all_proxy=socks5://host.docker.internal:7890 \
>   dotfiles-interactive
> ```
>
> 注意：桥接模式需要代理客户端开启「允许局域网连接」。

## Step 3: 确认初始状态

```bash
command -v stow    # 应该找不到
command -v zsh     # 应该找不到
command -v tmux    # 应该找不到
ls ~/dotfiles      # 应该不存在
```

## Step 4: 一键安装（curl 方式）

```bash
curl -fsSL https://raw.githubusercontent.com/Nhjkl/dotfiles/refs/heads/main/install.sh | bash
```

脚本会自动：
1. 克隆 `https://github.com/Nhjkl/dotfiles.git` 到 `~/.dotfiles`
2. 重新执行仓库内的 `install.sh`
3. 显示交互式菜单

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

> 如果想修改脚本后再测试（本地开发），可以直接运行：
> ```bash
> bash ~/.dotfiles/install.sh
> ```

## Step 5: 验证安装

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
zsh

# 在 zsh 中测试
alias
,cc            # 测试 claude CLI 别名
,t             # 测试 tmux-sessionizer

exit
```

## Step 7: 测试单独安装某个包

退出容器，重新进入干净环境：

```bash
# 宿主机执行
docker run -it --rm --network host dotfiles-interactive

# 容器内 — curl 安装后只选某个包
curl -fsSL https://raw.githubusercontent.com/Nhjkl/dotfiles/refs/heads/main/install.sh | bash
# 输入: 5  (只安装 tmux)
```

## Step 8: 测试全选

```bash
docker run -it --rm --network host dotfiles-interactive

# 容器内
curl -fsSL https://raw.githubusercontent.com/Nhjkl/dotfiles/refs/heads/main/install.sh | bash
# 输入: a
```

## Step 9: 测试重复运行

```bash
# 第一次安装后，再次运行
bash ~/.dotfiles/install.sh
# 再次输入 1-6
# 应该看到 "已安装" 或 "已链接"，不会重复安装
```

## 快速命令参考

```bash
# 构建镜像
docker build -f Dockerfile.interactive -t dotfiles-interactive .

# 进入容器（最简方式）
docker run -it --rm --network host dotfiles-interactive

# 后台运行容器（可反复进入）
docker run -itd --name dotfiles-test --network host dotfiles-interactive
docker exec -it dotfiles-test bash
docker stop dotfiles-test && docker rm dotfiles-test

# 一键安装命令
curl -fsSL https://raw.githubusercontent.com/Nhjkl/dotfiles/refs/heads/main/install.sh | bash
```
