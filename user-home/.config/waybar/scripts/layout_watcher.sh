#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-10-03 22:23:17

# ~/.config/waybar/scripts/layout_watcher.sh
set -u

# -x 精确匹配进程名，避免 pkill 的正则匹配到名字里含 "waybar" 的其它进程。
swaymsg -t subscribe -m '["window", "workspace", "binding"]' | while IFS= read -r event; do
    pkill -SIGRTMIN+8 -x waybar
done
