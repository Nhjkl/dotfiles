#!/bin/bash
# 监听 tmux prefix 键并自动切换输入法到英文
# 当用户按下 prefix 键时，如果当前是中文输入法，自动切换到英文

POLL_INTERVAL=0.1 # 轮询间隔（秒），可根据需要调整
COOLDOWN_TIME=0.5 # 防抖动冷却时间（秒）
LOG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/tmux-prefix-monitor.log"

last_status=0
last_switch_time=0

mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >>"$LOG_FILE"
}

log "Monitor started with poll interval: ${POLL_INTERVAL}s"

while true; do
  current_status=$(tmux display-message -p "#{?client_prefix,1,0}" 2>/dev/null || echo "0")

  # 状态从 0 变为 1：prefix 刚被按下
  if [ "$current_status" = "1" ] && [ "$last_status" = "0" ]; then
    current_time=$(date +%s)

    # 防抖动：避免短时间内重复切换
    if [ $((current_time - last_switch_time)) -ge $(($(echo "$COOLDOWN_TIME" | awk '{print int($1)}'))) ]; then
      # 检查输入法状态
      im_status=$(fcitx5-remote 2>/dev/null || echo "0")

      # 如果是中文输入（状态 2），切换到英文
      if [ "$im_status" = "2" ]; then
        fcitx5-remote -c
        last_switch_time=$current_time
        log "Prefix pressed, switched input method from Chinese to English"
      else
        log "Prefix pressed, input method already English (status: $im_status)"
      fi
    fi
  fi

  last_status=$current_status
  sleep "$POLL_INTERVAL"
done
