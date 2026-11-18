#!/bin/sh
# waybar 录屏状态指示：wf-recorder 运行时显示红点，点击停止录制
set -eu

if pgrep -x wf-recorder >/dev/null 2>&1; then
  jq -c -n \
    --arg text "●" \
    --arg class "recording-on" \
    --arg tooltip "录屏中（点击停止并保存）" \
    '{text:$text, class:$class, tooltip:$tooltip}'
else
  jq -c -n \
    --arg text "○" \
    --arg class "recording-off" \
    --arg tooltip "未在录屏" \
    '{text:$text, class:$class, tooltip:$tooltip}'
fi
