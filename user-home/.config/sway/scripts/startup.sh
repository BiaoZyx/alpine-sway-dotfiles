#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-08-26 19:26:20

# 清理旧进程
killall -9 dbus-daemon pipewire pipewire-pulse wireplumber wayland-pipewire-idle-inhibit 2>/dev/null

# 固定 DBus 地址
dbus-daemon --session --address=unix:path=/run/user/1000/bus --nofork &
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

# ------------------------------
# 启动服务
# ------------------------------
# 音频服务
rtkitctl --start
pipewire &
pipewire-pulse &
wireplumber &
wayland-pipewire-idle-inhibit &

# 输入法
fcitx5 -d &

# 剪切板
wl-paste --watch cliphist store &

# Waybar
waybar &

# 通知服务
fnott &
