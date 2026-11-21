#!/bin/sh
# @file    screenshot.sh
# @author  BiaoZyx
# @email   BiaoZyx@outlook.com
# @date    2026-11-20
# @brief   截图：统一处理目录、时间戳和 grimshot 参数
set -eu

mode=${1:-anything}
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$mode" in
    anything|screen|active|area) exec grimshot savecopy "$mode" "$file" --notify ;;
    *)
        printf 'usage: %s <anything|screen|active|area>\n' "$0" >&2
        exit 1
        ;;
esac
