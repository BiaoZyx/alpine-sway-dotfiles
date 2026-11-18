#!/bin/sh

set -eu

# 当前布局应取“焦点窗口的父容器”的 layout：
# 工作区的 representation/layout 描述的是最外层容器（通常总是 H），
# 而真正决定窗口排列的是焦点所在的那一层，例如 H[V[foot]] 里的 V。
TREE=$(timeout 2 swaymsg -t get_tree 2>/dev/null || printf '{}')
WORKSPACES=$(timeout 2 swaymsg -t get_workspaces 2>/dev/null || printf '[]')

LAYOUT=$(printf '%s' "$TREE" | jq -r '
  [.. | objects | select(.focused == true and .app_id != null)][0] as $leaf
  | if $leaf == null then ""
    else
      [.. | objects | select(.nodes? and (.nodes | map(.id) | index($leaf.id)))] as $parents
      | if ($parents | length) > 0
        then ($parents | last | .layout // "")
        else ""
        end
    end
' 2>/dev/null || printf '')

# 没有焦点窗口（空工作区）时回退到工作区数据
if [ -z "$LAYOUT" ] || [ "$LAYOUT" = "null" ]; then
  LAYOUT=$(printf '%s' "$WORKSPACES" | jq -r '
    [.[] | select(.focused == true)][0]
    | (.representation // "" | .[0:1]) as $rep
    | if ($rep | test("^[HVTS]$")) then $rep else (.layout // "splith") end
  ' 2>/dev/null || printf 'splith')
fi

case "$LAYOUT" in
  H|splith)  icon="H"; class="layout-H" ;;
  V|splitv)  icon="V"; class="layout-V" ;;
  T|tabbed)  icon="T"; class="layout-T" ;;
  S|stacked) icon="S"; class="layout-S" ;;
  *)         icon="$LAYOUT"; class="" ;;
esac

jq -c -n --arg text "$icon" --arg class "$class" '{text:$text, class:$class}'
