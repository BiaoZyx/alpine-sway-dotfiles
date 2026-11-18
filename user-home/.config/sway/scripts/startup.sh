#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-08-26 19:26:20
# Revised: 使用 XDG_RUNTIME_DIR；不 SIGKILL dbus-daemon；按 socket 判断服务；
#          清理上一会话残留进程；提高 FD 上限避免 waybar 撞到 1024。

set -u

# waybar 的 pulseaudio 模块在 PulseAudio 不可达时会快速重试并泄漏 FD，
# 软上限 1024 很快耗尽。硬上限通常是 4096，这里尽可能提高。
ulimit -n 4096 2>/dev/null || true

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
BUS_SOCKET="$RUNTIME_DIR/bus"
BUS_ADDRESS="unix:path=$BUS_SOCKET"

# 检查一个 D-Bus 地址是否真的可用（而不只是 socket 文件存在）。
bus_ok() {
    if command -v dbus-send >/dev/null 2>&1; then
        DBUS_SESSION_BUS_ADDRESS="$1" dbus-send --session --print-reply \
            --dest=org.freedesktop.DBus / org.freedesktop.DBus.GetId >/dev/null 2>&1
    else
        case "$1" in
            unix:path=*) [ -S "${1#unix:path=}" ] ;;
            *) [ -n "$1" ] ;;
        esac
    fi
}

# ------------------------------
# D-Bus：复用已有的健康的会话总线；只有在没有可用总线时才新建。
# 绝不 killall -9 dbus-daemon：那会杀死其他应用正在使用的总线。
# ------------------------------
if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] && bus_ok "$DBUS_SESSION_BUS_ADDRESS"; then
    : # 继承到可用的会话总线，保持不变
elif bus_ok "$BUS_ADDRESS"; then
    export DBUS_SESSION_BUS_ADDRESS="$BUS_ADDRESS"
else
    # 仅当 socket 失效（无响应）时才移除残留文件并启动新的总线。
    [ -S "$BUS_SOCKET" ] && rm -f "$BUS_SOCKET"
    dbus-daemon --session --address="$BUS_ADDRESS" --nofork &
    _i=0
    while [ "$_i" -lt 30 ] && ! bus_ok "$BUS_ADDRESS"; do
        sleep 0.1
        _i=$((_i + 1))
    done
    export DBUS_SESSION_BUS_ADDRESS="$BUS_ADDRESS"
fi

# ------------------------------
# 清理上一个 sway 会话残留的服务。
# 这些进程若存活，会让下面基于 pgrep 的判断误以为服务已启动，
# 但它们并没有在当前 XDG_RUNTIME_DIR 中建立 socket（典型症状：
# pw-dump 报 "can't connect: Host is down"、waybar pulseaudio 模块刷屏）。
# 用 TERM 而非 KILL；不碰 dbus-daemon。
# ------------------------------
for _name in pipewire pipewire-pulse wireplumber waybar fnott fcitx5; do
    pkill -TERM -x "$_name" 2>/dev/null || true
done
pkill -TERM -f 'layout_watcher.sh' 2>/dev/null || true
pkill -TERM -f 'wl-paste --watch cliphist store' 2>/dev/null || true
sleep 1

# ------------------------------
# 启动服务
# ------------------------------
if command -v rtkitctl >/dev/null 2>&1; then
    rtkitctl --start >/dev/null 2>&1 || true
fi

# 音频：按 socket 判断，确保真正在当前会话可用
if [ ! -S "$RUNTIME_DIR/pipewire-0" ]; then
    pipewire &
    _i=0
    while [ "$_i" -lt 30 ] && [ ! -S "$RUNTIME_DIR/pipewire-0" ]; do
        sleep 0.2
        _i=$((_i + 1))
    done
fi
if [ ! -S "$RUNTIME_DIR/pulse/native" ]; then
    pipewire-pulse &
fi
if ! pgrep -x wireplumber >/dev/null 2>&1; then
    wireplumber &
fi
# wayland-pipewire-idle-inhibit 已由 config.d/idle.sway 启动，此处不重复启动。

# Waybar 布局监听脚本
~/.config/waybar/scripts/layout_watcher.sh &

# 输入法
fcitx5 -d &

# 剪切板
wl-paste --watch cliphist store &

# Waybar
waybar &

# 通知服务
fnott &
