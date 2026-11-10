#!/bin/bash
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-10-03 22:23:17

# ~/.config/waybar/scripts/layout_watcher.sh

swaymsg -t subscribe -m '["window", "workspace", "binding"]' | while IFS= read -r event; do
    pkill -SIGRTMIN+8 waybar
done
