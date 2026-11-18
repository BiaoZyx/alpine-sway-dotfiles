#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-08-26 19:26:20
# Revised: 不再用 SIGKILL 强杀 dbus-daemon，改用 XDG_RUNTIME_DIR，
#          并避免 sway reload 时重复启动后台服务。

set -u

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
# 绝不 killall -9 dbus-daemon：那会杀死其他应用正在使用的总线，
# 且 SIGKILL 无法让守护进程正常清理，反而容易造成 DBus 异常。
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
# 启动服务（带存在性检查，防止 sway reload 后出现重复实例）
# ------------------------------
if command -v rtkitctl >/dev/null 2>&1; then
    rtkitctl --start >/dev/null 2>&1 || true
fi

pgrep -x pipewire >/dev/null 2>&1 || pipewire &
pgrep -x pipewire-pulse >/dev/null 2>&1 || pipewire-pulse &
pgrep -x wireplumber >/dev/null 2>&1 || wireplumber &
# 注意：wayland-pipewire-idle-inhibit 已由 config.d/idle.sway 启动，此处不重复启动。

# Waybar 布局监听脚本（wayland 工作区状态）
pgrep -f 'layout_watcher.sh' >/dev/null 2>&1 || ~/.config/waybar/scripts/layout_watcher.sh &

# 输入法
pgrep -x fcitx5 >/dev/null 2>&1 || fcitx5 -d &

# 剪切板
pgrep -f 'wl-paste --watch cliphist store' >/dev/null 2>&1 || wl-paste --watch cliphist store &

# Waybar
pgrep -x waybar >/dev/null 2>&1 || waybar &

# 通知服务
pgrep -x fnott >/dev/null 2>&1 || fnott &
