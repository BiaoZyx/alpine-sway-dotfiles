#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-10-03 22:23:17

# ~/.config/waybar/scripts/layout_watcher.sh
set -u

# 只订阅会真正改变布局指示器的事件：
# 不再订阅 "binding"，避免每次按键都同步触发 waybar 的脚本执行。
# 每个事件立即刷新，不做时间节流，保证切换工作区时字母即时更新。
swaymsg -t subscribe -m '["window", "workspace"]' | while IFS= read -r event; do
    pkill -SIGRTMIN+8 -x waybar 2>/dev/null || true
done
