#!/bin/sh
# @file    restart_waybar.sh
# @author  BiaoZyx
# @email   BiaoZyx@outlook.com
# @date    2026-11-20
# @brief   睡眠唤醒后重启 waybar，避免 pulseaudio/tray 模块在恢复时卡住主线程
#          先等旧进程真正退出，否则新 waybar 可能因为抢不到 layer surface 而启动失败
pkill -TERM -x waybar 2>/dev/null || true

i=0
while pgrep -x waybar >/dev/null 2>&1 && [ "$i" -lt 20 ]; do
    sleep 0.1
    i=$((i + 1))
done

waybar &
