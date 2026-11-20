#!/bin/sh
# 录屏：统一处理目录、时间戳、区域选择与停止信号
set -eu

dir="$HOME/Videos/Screenrecord"
file="$dir/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

case "${1:-}" in
    start)
        mkdir -p "$dir"
        notify-send "开始录屏" "wf-recorder"
        exec wf-recorder -f "$file"
        ;;
    area)
        mkdir -p "$dir"
        notify-send "开始录屏" "wf-recorder"
        geometry=$(slurp)
        exec wf-recorder -g "$geometry" -f "$file"
        ;;
    stop)
        notify-send "录屏结束" "已保存到 ~/Videos/Screenrecord"
        pkill -SIGINT -x wf-recorder
        ;;
    *)
        printf 'usage: %s <start|area|stop>\n' "$0" >&2
        exit 1
        ;;
esac
