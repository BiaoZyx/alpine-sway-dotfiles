#!/bin/sh
# Author: BiaoZyx
# Email: BiaoZyx@outlook.com
# Date: 2026-10-03 22:23:17

# ~/.config/waybar/scripts/layout_watcher.sh
set -u

# 用 fifo 让主进程直接 read 订阅流（而不是把 while 放进管道子 shell）：
#   1) 主进程收到 TERM 时能立刻执行 trap，不会卡在 wait 上；
#   2) swaymsg 断开后外层循环能自动重连，避免布局指示从此失效。
fifo="${TMPDIR:-/tmp}/waybar-layout-$$.fifo"
rm -f "$fifo"
mkfifo "$fifo"
msgpid=""

cleanup() {
    [ -n "$msgpid" ] && kill -TERM "$msgpid" 2>/dev/null || true
    rm -f "$fifo"
    exit 0
}
trap cleanup TERM INT HUP

# sway 不会因为容器 layout 改变而发 workspace 事件；用快捷键改布局时
# 发出的是 binding 事件，所以必须订阅 binding，否则顶栏字母不会刷新。
# 为避免普通按键刷屏，binding 事件只在命令确实是布局相关时才刷新。
while :; do
    swaymsg -t subscribe -m '["window", "workspace", "binding"]' >"$fifo" 2>/dev/null &
    msgpid=$!

    while IFS= read -r event; do
        # 用 jq 解析 change 字段，不依赖 JSON 里冒号后是否有空格。
        change=$(printf '%s' "$event" | jq -r '.change // ""' 2>/dev/null || printf '')
        if [ "$change" = "run" ]; then
            cmd=$(printf '%s' "$event" | jq -r '.binding.command // ""' 2>/dev/null || printf '')
            case "$cmd" in
                splith|splitv|layout*|fullscreen*) ;;
                *) continue ;;
            esac
        fi
        pkill -SIGRTMIN+8 -x waybar 2>/dev/null || true
    done <"$fifo"

    # 订阅断开（sway 重启/睡眠恢复）：清理后短暂等待再重连。
    kill -TERM "$msgpid" 2>/dev/null || true
    wait "$msgpid" 2>/dev/null || true
    msgpid=""
    sleep 1
done
