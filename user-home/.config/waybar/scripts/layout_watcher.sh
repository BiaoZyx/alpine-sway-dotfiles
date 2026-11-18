#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-10-03 22:23:17

# ~/.config/waybar/scripts/layout_watcher.sh
set -u

# sway 不会因为容器 layout 改变而发 workspace 事件；用快捷键改布局时
# 发出的是 binding 事件，所以必须订阅 binding，否则顶栏字母不会刷新。
# 为避免普通按键刷屏，binding 事件只在命令确实是布局相关时才刷新。
swaymsg -t subscribe -m '["window", "workspace", "binding"]' | while IFS= read -r event; do
    case "$event" in
        *'"change": "run"'*|*'"change":"run"'*)
            cmd=$(printf '%s' "$event" | jq -r '.binding.command // ""' 2>/dev/null || printf '')
            case "$cmd" in
                splith|splitv|layout*|fullscreen*) ;;
                *) continue ;;
            esac
            ;;
    esac
    pkill -SIGRTMIN+8 -x waybar 2>/dev/null || true
done
