# Tmux Prefix 键输入法自动切换功能

## 功能说明

当您在 tmux 中按下 prefix 键（Ctrl+]）时，如果当前输入法是中文模式，系统会自动切换到英文输入法，确保快捷键输入不受影响。

## 安装状态

- ✅ 监控脚本：`~/.config/tmux/scripts/prefix-input-method-monitor.sh`
- ✅ 系统服务：`tmux-prefix-monitor.service`
- ✅ 服务状态：运行中

## 使用方法

### 自动启动
服务已设置为开机自启，无需手动干预。

### 手动管理

```bash
# 查看服务状态
systemctl --user status tmux-prefix-monitor.service

# 重启服务
systemctl --user restart tmux-prefix-monitor.service

# 停止服务
systemctl --user stop tmux-prefix-monitor.service

# 启动服务
systemctl --user start tmux-prefix-monitor.service

# 查看日志
journalctl --user -u tmux-prefix-monitor.service -f

# 查看监控器日志
tail -f ~/.local/share/tmux-prefix-monitor.log
```

## 工作原理

1. 后台监控进程每 100ms 轮询一次 tmux 的 `client_prefix` 状态
2. 当检测到 prefix 键被按下（状态 0→1）时：
   - 检查 fcitx5 输入法状态
   - 如果是中文输入（状态码 2），执行 `fcitx5-remote -c` 切换到英文
   - 记录操作日志

## 性能参数

- **轮询间隔**：100ms（响应速度快，CPU 使用率低）
- **内存占用**：约 3MB
- **CPU 占用**：< 0.1%（几乎不可感知）

## 防抖动机制

设置了 0.5 秒的冷却时间，避免快速连续按下 prefix 键时重复切换输入法。

## 日志位置

- **系统日志**：`journalctl --user -u tmux-prefix-monitor.service`
- **操作日志**：`~/.local/share/tmux-prefix-monitor.log`

## 故障排除

### 监控器未响应

1. 检查服务状态：
   ```bash
   systemctl --user status tmux-prefix-monitor.service
   ```

2. 重启服务：
   ```bash
   systemctl --user restart tmux-prefix-monitor.service
   ```

3. 查看错误日志：
   ```bash
   journalctl --user -u tmux-prefix-monitor.service -n 50
   ```

### 输入法切换不工作

1. 检查 fcitx5 是否正常运行：
   ```bash
   ps aux | grep fcitx5
   ```

2. 测试 fcitx5-remote 命令：
   ```bash
   fcitx5-remote  # 应返回 0, 1, 或 2
   fcitx5-remote -o  # 切换到中文
   fcitx5-remote -c  # 切换到英文
   ```

3. 查看 tmux prefix 状态：
   ```bash
   tmux display-message -p "#{?client_prefix,激活,未激活}"
   ```

### 高 CPU 占用

如果发现 CPU 占用过高，可以增加轮询间隔：

编辑脚本文件，修改 `POLL_INTERVAL` 参数：
```bash
# ~/.config/tmux/scripts/prefix-input-method-monitor.sh
POLL_INTERVAL=0.2  # 改为 200ms
```

然后重启服务：
```bash
systemctl --user restart tmux-prefix-monitor.service
```

## 卸载方法

```bash
# 停止并禁用服务
systemctl --user stop tmux-prefix-monitor.service
systemctl --user disable tmux-prefix-monitor.service

# 删除服务文件
rm ~/.config/systemd/user/tmux-prefix-monitor.service

# 重新加载 systemd
systemctl --user daemon-reload

# 删除脚本（可选）
rm ~/.config/tmux/scripts/prefix-input-method-monitor.sh

# 删除日志（可选）
rm ~/.local/share/tmux-prefix-monitor.log
```

## 版本信息

- 创建日期：2026-03-05
- Tmux 版本：3.6a
- 输入法框架：fcitx5

## 注意事项

- 此方案适用于所有使用 prefix 键的 tmux 快捷键
- 不影响 tmux 的其他功能
- 只在需要时切换输入法，不会干扰正常使用
- 支持 X11 和 Wayland 显示协议
