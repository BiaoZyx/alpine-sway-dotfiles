#!/bin/sh
# 睡眠唤醒后重启 waybar，避免 pulseaudio/tray 模块在恢复时卡住主线程。
pkill -TERM -x waybar 2>/dev/null || true
waybar &
