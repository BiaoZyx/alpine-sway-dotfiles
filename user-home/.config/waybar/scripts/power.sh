#!/bin/sh
#choice=$(printf "Lock\nLogout\nSleep\nReboot\nShutdown" | rofi -dmenu -p "Power")
# 从 waybar 的 power 按钮点击时，把菜单锚定到右上角、waybar 下方；
# 用快捷键 $mod+x 启动时仍保持默认居中。
anchor=""
for arg in "$@"; do
    case "$arg" in
        --from-waybar) anchor="--anchor=top-right --x-margin=8 --y-margin=34" ;;
    esac
done

choice=$(printf "Lock\nLogout\nSleep\nReboot\nShutdown" | fuzzel --dmenu -p "Power·" --width 16 --lines 5 --minimal-lines $anchor)

if [ -z "$choice" ]; then
    exit 0
fi

case "$choice" in
    Lock) playerctl pause; swaylock ;;
    Logout) swaymsg exit ;;
    Sleep) playerctl pause; swaylock & loginctl suspend ;;
    Reboot) dbus-run-session loginctl reboot ;;
    Shutdown) dbus-run-session loginctl poweroff ;;
    # fuzzel 允许自由输入；未知选项不应触发任何操作。
    *) exit 0 ;;
esac
