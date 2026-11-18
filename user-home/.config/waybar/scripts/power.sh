#!/bin/sh
#choice=$(printf "Lock\nLogout\nSleep\nReboot\nShutdown" | rofi -dmenu -p "Power")
choice=$(printf "Lock\nLogout\nSleep\nReboot\nShutdown" | fuzzel --dmenu -p "Power" --width 16 --lines 5 --minimal-lines)

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
