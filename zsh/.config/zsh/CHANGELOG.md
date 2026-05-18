# Zsh 启动速度优化记录

日期: 2026-05-18

## 基准数据

| 指标   | 初始    | 第一轮（缓存） | 第二轮（defer mise） |
| ------ | ------- | -------------- | -------------------- |
| 平均   | 398ms   | ~130ms         | **~17ms**            |
| 最快   | 338ms   | 127ms          | **17ms**             |
| 最慢   | 562ms   | 161ms          | **19ms**             |
| 中位数 | ~378ms  | ~135ms         | **17ms**             |

---

## 改动清单

### 1. `.zshrc` — sheldon 加载改为缓存

```diff
- if command -v sheldon &>/dev/null; then
-   eval "$(sheldon source 2>/dev/null)"
- fi
+ if [[ -f "$XDG_CACHE_HOME/zsh/sheldon-source.zsh" ]]; then
+   source "$XDG_CACHE_HOME/zsh/sheldon-source.zsh"
+ elif command -v sheldon &>/dev/null; then
+   eval "$(sheldon source 2>/dev/null)"
+ fi
```

预估收益: 15-40ms

### 2. `init.zsh` — starship/mise 加载改为缓存

```diff
- eval "$(starship init zsh)"
- eval "$(mise activate zsh 2>/dev/null)"
+ if [[ -f "$XDG_CACHE_HOME/zsh/starship-init.zsh" ]]; then
+   source "$XDG_CACHE_HOME/zsh/starship-init.zsh"
+ else
+   eval "$(starship init zsh)"
+ fi
+
+ if [[ -f "$XDG_CACHE_HOME/zsh/mise-activate.zsh" ]]; then
+   source "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
+ else
+   eval "$(mise activate zsh 2>/dev/null)"
+ fi
```

预估收益: 25-80ms

### 3. `.zprofile` — 清除与 config.zsh 的重复

原文件包含与 `config.zsh` 完全重复的环境变量和 PATH 设置，已清空：

```diff
- unsetopt PROMPT_SP
- [[ -d "$HOME/.local/bin" ]] && path=(...)
- [[ -z "$TERM" ]] && export TERM=xterm-256color
- export EDITOR="nvim"
- ...
+ # login shell 仅执行一次的操作
+ # 环境变量和 PATH 由 config.zsh 统一管理，此处不再重复
```

预估收益: 1-3ms（主要是消除重复执行）

### 4. `config.zsh:90` — 简化 PATH glob

```diff
- [[ -d "$HOME/.local/bin" ]] && path=($HOME/.local/bin/*(N-/) $HOME/.local/bin $path)
+ [[ -d "$HOME/.local/bin" ]] && path=($HOME/.local/bin $path)
```

去掉不必要的 glob 展开 `*(N-/)`，它会把 `~/.local/bin/` 下所有子目录加入 PATH。

预估收益: 1-5ms

### 5. `plugins.toml` — zsh-completions 启用 defer

```diff
  [plugins.zsh-completions]
  github = "zsh-users/zsh-completions"
+ apply = ["defer"]
```

预估收益: 5-15ms

### 6. `.zshrc` — 新增 zcompile 和缓存刷新命令

在 `.zshrc` 末尾添加了两个函数：

- `_zsh_zcompile` — 编译 `~/.cache/zsh/` 下的 .zsh 文件为 .zwc（符合 XDG 规范）
- `zsh-reload-cache` — 一键重新生成所有缓存（sheldon/starship/mise/zcompile）

预估收益: 5-20ms

### 7. `init.zsh` — mise 延迟加载（交互 shell defer，非交互同步）

```diff
- # mise（使用缓存）
- if [[ -f "$XDG_CACHE_HOME/zsh/mise-activate.zsh" ]]; then
-   source "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
- else
-   eval "$(mise activate zsh 2>/dev/null)"
- fi
+ # mise（交互 shell defer，非交互同步加载）
+ if [[ -o interactive ]]; then
+   if [[ -f "$XDG_CACHE_HOME/zsh/mise-activate.zsh" ]]; then
+     zsh-defer source "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
+   else
+     zsh-defer eval "$(mise activate zsh 2>/dev/null)"
+   fi
+ else
+   if [[ -f "$XDG_CACHE_HOME/zsh/mise-activate.zsh" ]]; then
+     source "$XDG_CACHE_HOME/zsh/mise-activate.zsh"
+   else
+     eval "$(mise activate zsh 2>/dev/null)"
+   fi
+ fi
```

交互 shell 将 mise 延迟到提示符显示后加载（~130ms → ~17ms），
非交互 shell（`zsh -c 'node --version'`）同步加载保证工具可用。

预估收益: ~110ms

### 8. `.zshrc` — 调整加载顺序

```diff
  source "$ZDOTDIR/config.zsh"
- source "$ZDOTDIR/init.zsh"
-
- # sheldon 插件加载
- ...
+ # sheldon 插件加载（必须在 init.zsh 之前，因为 zsh-defer 在这里定义）
+ ...
+
+ source "$ZDOTDIR/init.zsh"
```

sheldon（包含 zsh-defer）必须在 init.zsh 之前加载，
否则 init.zsh 中 `zsh-defer source mise` 会找不到 zsh-defer。

所有缓存文件位于 `$XDG_CACHE_HOME/zsh/`（即 `~/.cache/zsh/`）：

| 文件                   | 来源                | 大小    |
| ---------------------- | ------------------- | ------- |
| sheldon-source.zsh     | `sheldon source`    | ~200B   |
| starship-init.zsh      | `starship init zsh` | ~3KB    |
| mise-activate.zsh      | `mise activate zsh` | ~4KB    |
| sheldon-source.zsh.zwc | zcompile 编译       | ~1.6KB  |
| starship-init.zsh.zwc  | zcompile 编译       | ~6.3KB  |
| mise-activate.zsh.zwc  | zcompile 编译       | ~10.4KB |
| zcompdump-$ZSH_VERSION | compinit 缓存       | ~43KB   |

## 缓存刷新

升级以下工具后需要运行 `zsh-reload-cache`：

- sheldon 插件变更（添加/删除插件）
- starship 版本升级
- mise 版本升级

```bash
zsh-reload-cache  # 重新生成所有缓存并 zcompile
```

## 设计决策

- **为什么不对 `~/.config/zsh/*.zsh` 做 zcompile**: zsh 的 `source` 只查找源文件同目录下的 `.zwc`，无法重定向到其他目录。将编译产物放在 `~/.config/` 不符合 XDG 规范（config 应只存放用户编辑的配置），而 ZDOTDIR 下的文件体量小，编译收益可忽略。因此只编译 `~/.cache/zsh/` 下的大文件。
- **为什么不保留 `.zprofile` 的环境变量**: `.zprofile` 只在 login shell 时加载，而 `config.zsh` 在每次交互 shell 都加载。环境变量设在两处会导致维护负担和不一致风险，统一由 `config.zsh` 管理更清晰。
