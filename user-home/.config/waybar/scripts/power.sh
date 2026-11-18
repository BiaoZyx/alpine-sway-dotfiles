#!/bin/sh
#choice=$(printf "Lock\nLogout\nSleep\nReboot\nShutdown" | rofi -dmenu -p "Power")
# 从 waybar 的 power 按钮点击时，把菜单锚定到右上角、waybar 下方；
# 用快捷键 $mod+x 启动时仍保持默认居中。
anchor=""
config_arg=""
cfg=""
for arg in "$@"; do
    case "$arg" in
        --from-waybar)
            anchor="--anchor=top-right --x-margin=2 --y-margin=2"
            # waybar 菜单按鼠标逻辑：失去键盘焦点就关闭。
            # fuzzel 没有正向的 CLI 开关，只有 --no-exit-on-keyboard-focus-loss，
            # 所以临时复制一份配置并覆盖该选项。
            cfg=$(mktemp "${TMPDIR:-/tmp}/power-fuzzel.XXXXXX")
            sed 's/^exit-on-keyboard-focus-loss=.*/exit-on-keyboard-focus-loss=yes/' \
                "${XDG_CONFIG_HOME:-$HOME/.config}/fuzzel/fuzzel.ini" >"$cfg"
            config_arg="--config=$cfg"
            trap 'rm -f "$cfg"' EXIT
            ;;
    esac
done

choice=$(printf "Lock\nLogout\nSleep\nReboot\nShutdown" | fuzzel --dmenu -p "Power·" --width 16 --lines 5 --minimal-lines $anchor $config_arg)

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
