#!/bin/sh
# tuigreet 的 --greeting 不支持变量；它把上次登录的用户名存在
# /var/cache/tuigreet/lastuser-name（由 --remember 写入）。
# 这里读出来生成动态问候语，首次登录时回退到通用提示。
set -eu

cache_dir="${TUIGREET_CACHE_DIR:-/var/cache/tuigreet}"
last_user=""

if [ -r "$cache_dir/lastuser-name" ]; then
    IFS= read -r last_user <"$cache_dir/lastuser-name" || true
fi

if [ -n "$last_user" ]; then
    greeting="Hello, $last_user!"
else
    greeting="Welcome back!"
fi

exec tuigreet \
    --cmd sway \
    --sessions /usr/share/wayland-sessions \
    --kb-command 2 --kb-sessions 3 --kb-power 12 \
    --time --time-format '%Y-%m-%d %H:%M:%S' \
    --remember \
    --user-menu --user-menu-min-uid 1000 --user-menu-max-uid 60000 \
    --width 48 --window-padding 1 \
    --greeting "$greeting" --greet-align center \
    --asterisks \
    --theme 'border=blue;text=white;time=lightblue;container=black;title=lightblue;greet=green;prompt=cyan;input=white;action=lightgreen;button=yellow'
