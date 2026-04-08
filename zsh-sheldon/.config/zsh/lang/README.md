# mise 环境管理指南

## 全局配置文件

`~/.config/mise/config.toml`

```toml
[tools]
go     = "latest"
node   = "lts"
python = "latest"
rust   = "stable"

[settings]
node.mirror_url  = "https://npmmirror.com/mirrors/node/"
node.gpg_verify  = false
```

## 各语言路径一览

| 语言       | 安装路径                                         | 包/依赖路径                                                                    | 备注                                               |
| ---------- | ------------------------------------------------ | ------------------------------------------------------------------------------ | -------------------------------------------------- |
| **Go**     | `~/.local/share/mise/installs/go/<version>/`     | `$GOPATH` → `~/.local/share/go`                                                | `GOPATH` 和 `GOPROXY` 仍需在 shell 中配置          |
| **Node**   | `~/.local/share/mise/installs/node/<version>/`   | `~/.local/share/mise/installs/node/<version>/lib/node_modules/`                | npm 全局包随 node 版本走                           |
| **Python** | `~/.local/share/mise/installs/python/<version>/` | `~/.local/share/mise/installs/python/<version>/lib/python<ver>/site-packages/` | pip 包随 python 版本走                             |
| **Rust**   | `~/.local/share/mise/installs/rust/stable/`      | `$CARGO_HOME` → `~/.local/share/cargo/`                                        | mise 底层调用 rustup，cargo 全局包在 `$CARGO_HOME` |

## Shell 配置

mise 通过 `eval "$(mise activate zsh)"` 自动将各语言的 bin 目录加入 PATH，无需手动配置。

### 仍需手动配置的内容

**go.zsh** — GOPATH 和 GOPROXY mise 不自动管理：

```zsh
export GOPATH="$HOME/.local/share/go"
export GOBIN="$GOPATH/bin"
export GOPROXY=https://goproxy.cn,direct
[[ -d "$GOPATH/bin" ]] && path=("$GOPATH/bin" $path)
```

## 常用命令

```bash
# 安装/切换版本
mise use <tool>@<version>        # 项目级（写入 .mise.toml）
mise use -g <tool>@<version>     # 全局级

# 查看已安装
mise ls

# 更新所有工具
mise upgrade

# 安装项目依赖（读取 .mise.toml）
mise install

# 卸载
mise uninstall <tool>@<version>
```

## 项目级配置

在项目根目录创建 `.mise.toml`：

```toml
[tools]
python = "3.12"
node = "20"
```

## 国内镜像

| 工具   | 配置项                      | 镜像地址                              |
| ------ | --------------------------- | ------------------------------------- |
| Node   | `settings.node.mirror_url`  | `https://npmmirror.com/mirrors/node/` |
| Go     | `GOPROXY`（shell 环境变量） | `https://goproxy.cn,direct`           |
| Python | 暂不支持 mirror_url         | 使用华为镜像等需手动下载              |
| Rust   | 暂不支持 mirror_url         | 使用中科大镜像需手动配置 rustup       |

## npm/pip/cargo 全局包位置

| 包管理器      | 全局安装路径                                                               | 配置方式                      |
| ------------- | -------------------------------------------------------------------------- | ----------------------------- |
| npm           | `~/.local/share/mise/installs/node/<ver>/bin/` 和 `lib/node_modules/`      | npm 默认随 node               |
| pip           | `~/.local/share/mise/installs/python/<ver>/lib/python<ver>/site-packages/` | pip 默认随 python             |
| cargo install | `$CARGO_HOME/bin/` 即 `~/.local/share/cargo/bin/`                          | `CARGO_HOME` 由 mise 自动设置 |
| go install    | `$GOPATH/bin/` 即 `~/.local/share/go/bin/`                                 | 需在 shell 中配置 `GOPATH`    |
