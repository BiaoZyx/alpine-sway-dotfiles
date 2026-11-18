#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-10-03 22:23:17

# ~/.config/waybar/scripts/layout_watcher.sh
set -u

# 只订阅真正会影响布局指示器的事件。
# 原订阅包含 "binding"，导致每次按键（尤其是长按重复）都会给 waybar 发信号，
# waybar 会同步执行 layout_indicator.sh，频繁时能把主线程堵住。
# 另外加 1 秒节流：布局指示器只是一个字母，没必要每次事件都刷新。
last_signal=0
swaymsg -t subscribe -m '["window", "workspace"]' | while IFS= read -r event; do
    now=$(date +%s)
    if [ "$now" -gt "$last_signal" ]; then
        pkill -SIGRTMIN+8 -x waybar 2>/dev/null || true
        last_signal=$now
    fi
done
