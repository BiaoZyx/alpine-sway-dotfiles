#!/bin/sh

set -eu

# get_tree 的根节点是 output，不是 workspace；原来从 .nodes[] 取 focused
# 工作区的方式永远取不到值，字母一直是默认的 H。get_workspaces 直接提供
# focused / representation / layout，更快也更可靠。
WORKSPACES=$(timeout 2 swaymsg -t get_workspaces 2>/dev/null || printf '[]')

REPRESENTATION=$(printf '%s' "$WORKSPACES" \
  | jq -r '[.[] | select(.focused == true)][0].representation // ""')

LAYOUT=$(printf '%s' "$REPRESENTATION" | cut -c 1)
LAYOUT=${LAYOUT:-H}

# representation 为 null（单窗口）时回退到工作区自身的 layout
if [ -z "$REPRESENTATION" ] || [ "$REPRESENTATION" = "null" ]; then
  LAYOUT=$(printf '%s' "$WORKSPACES" \
    | jq -r '[.[] | select(.focused == true)][0].layout // "splith"')
fi

case "$LAYOUT" in
  H|splith)  icon="H"; class="layout-H" ;;
  V|splitv)  icon="V"; class="layout-V" ;;
  T|tabbed)  icon="T"; class="layout-T" ;;
  S|stacked) icon="S"; class="layout-S" ;;
  *)         icon="$LAYOUT"; class="" ;;
esac

jq -c -n --arg text "$icon" --arg class "$class" '{text:$text, class:$class}'
