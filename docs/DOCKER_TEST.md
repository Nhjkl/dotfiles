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

## Step 3: 一键安装（curl 方式）

```bash
curl -fsSL https://raw.githubusercontent.com/Nhjkl/dotfiles/refs/heads/main/install.sh | bash
```
