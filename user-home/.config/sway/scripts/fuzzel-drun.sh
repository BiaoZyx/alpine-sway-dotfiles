#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-08-26 19:56:05

set -eu

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# 优先使用会话继承下来的 DBUS_SESSION_BUS_ADDRESS；
# 仅当缺失时才回退到当前用户的标准 bus，绝不硬编码 /run/user/1000。
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && [ -S "$RUNTIME_DIR/bus" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$RUNTIME_DIR/bus"
fi

# 追加 Flatpak 的导出目录，而不是覆盖 XDG_DATA_DIRS，
# 否则 ~/.local/share/applications 里用户自己的 .desktop 项会消失。
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
case ":$XDG_DATA_DIRS:" in
    *:/var/lib/flatpak/exports/share:*) ;;
    *) XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS" ;;
esac
export XDG_DATA_DIRS

# LC_ALL 只接受单一 locale，不是冒号分隔的列表。
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh

exec fuzzel
