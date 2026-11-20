#!/bin/sh

# dependencies: pipewire (pw-dump), jq, fuser, gdbus (dbus)
set -eu

# 固定使用系统命令：不要用 JQ/PW_DUMP 环境变量覆盖命令名，
# 否则攻击者若能控制 waybar 的环境即可注入任意命令（如 "jq | curl ..."）。

mic=0
cam=0
loc=0
scr=0
rec=0
mic_muted=0

mic_app=""
cam_app=""
loc_app=""
scr_app=""

# mic & camera
if command -v pw-dump >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  # pw-dump 在 PipeWire 不稳定时可能挂住，加超时避免 waybar 的定时执行被拖死。
  dump="$(timeout 3 pw-dump 2>/dev/null || true)"

  mic="$(
    printf '%s' "$dump" \
    | jq -r '
      [ .[]
        | select(.type=="PipeWire:Interface:Node")
        | select((.info.props."media.class"=="Audio/Source" or .info.props."media.class"=="Audio/Source/Virtual"))
        | select((.info.state=="running") or (.state=="running"))
      ] | (if length>0 then 1 else 0 end)
    ' 2>/dev/null || echo 0
  )"
  # pw-dump 连不上 PipeWire 时会输出空内容；jq 对空输入返回成功但无输出，
  # 所以必须在这里兜底，否则 [ "$mic" -eq 1 ] 会在 ash 下报 "out of range"。
  case "$mic" in
    0|1) ;;
    *)   mic=0 ;;
  esac

  if [ "$mic" -eq 1 ]; then
    mic_app="$(
      printf '%s' "$dump" \
      | jq -r '
        [ .[]
          | select(.type=="PipeWire:Interface:Node")
          | select((.info.props."media.class"=="Stream/Input/Audio"))
          | select((.info.state=="running") or (.state=="running"))
          | .info.props["node.name"]
        ] | unique | join(", ")
      ' 2>/dev/null || echo ""
    )"
  fi

  if command -v fuser >/dev/null 2>&1; then
      cam=0
      for dev in /dev/video*; do
          if [ -e "$dev" ] && timeout 1 fuser "$dev" >/dev/null 2>&1; then
              cam=1
              break
          fi
      done
  else
      cam=0
  fi

  if command -v fuser >/dev/null 2>&1; then
      for dev in /dev/video*; do
          if [ -e "$dev" ] && timeout 1 fuser "$dev" >/dev/null 2>&1; then
              # fuser 的 PID 后面可能附带访问类型字母（如 1234c），
              # 过滤掉非数字字符，避免 ps -p "1234c" 取不到进程名。
              pids=$(timeout 1 fuser "$dev" 2>/dev/null | tr -cd '[:digit:][:space:]' || true)
              for pid in $pids; do
                  pname=$(ps -p "$pid" -o comm=)
                  if [ -n "$pname" ]; then
                      cam_app="${cam_app}$pname, "
                  fi
              done
          fi
      done
      cam_app="${cam_app%, }"
  fi
fi

# location
# 不使用 `ps aux | grep [g]eoclue`：它会把命令行里恰好含 "geoclue" 的
# 无关进程误判为定位服务。这里用 pgrep -x 精确匹配进程名。
# 定位服务检测只依赖 pgrep/ps，不需要 gdbus；以前的 gdbus 判断会让
# 未安装 gdbus 的系统永远检测不到 geoclue。
if pids=$(pgrep -x geoclue); then
    loc=1
    for pid in $pids; do
        pname=$(ps -p "$pid" -o comm=)
        [ -n "$pname" ] && loc_app="${loc_app}$pname, "
    done
    loc_app="${loc_app%, }"
else
    loc=0
fi

# screen sharing
if command -v pw-dump >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  if [ -z "${dump:-}" ]; then
    dump="$(timeout 3 pw-dump 2>/dev/null || true)"
  fi

  scr="$(
      printf '%s' "$dump" \
      | jq -e '
          [ .[]
            | select(.info?.props?)
            | select(
                (.info.props["media.name"]? // "")
                | test("^(xdph-streaming|gsr-default|game capture)")
            )
          ]
          | (if length > 0 then true else false end)
        ' >/dev/null && echo 1 || echo 0
    )"
  # 同样处理空 dump 导致 jq 无输出的情况
  case "$scr" in
    0|1) ;;
    *)   scr=0 ;;
  esac
fi

if [ "$scr" -eq 1 ]; then
    scr_app="$(
    printf '%s' "$dump" \
    |   jq -r '
        [ .[]
          | select(.type=="PipeWire:Interface:Node")
          | select((.info.props."media.class"=="Stream/Input/Video") or (.info.props."media.name"=="gsr-default_output") or (.info.props."media.name"=="game capture"))
          | select((.info.state=="running") or (.state=="running"))
          | .info.props["media.name"]
        ] | unique | join(", ")
      ' 2>/dev/null || echo ""
    )"
fi

# 录屏状态（与麦克风/摄像头同属 privacy 模块）
if pgrep -x wf-recorder >/dev/null 2>&1; then
  rec=1
fi

# 麦克风静音状态：静音时显示独立的静音图标，这样按静音键有可见反馈
if command -v wpctl >/dev/null 2>&1; then
  if wpctl get-volume @DEFAULT_SOURCE@ 2>/dev/null | grep -q '\[MUTED\]'; then
    mic_muted=1
  fi
fi

# output
red="#FF728F"
green="#30D158"
orange="#FF9F0A"
blue="#0A84FF"
purple="#9B32FA"

dot() {
  dot_on="$1" dot_color="$2"
  if [ "$dot_on" -eq 1 ]; then
    printf '<span foreground="%s">●</span>' "$dot_color"
  else
    printf ''
  fi
}

text=""
if [ "$mic_muted" -eq 1 ]; then
  text="${text}<span foreground=\"$red\"></span> "
elif [ "$mic" -eq 1 ]; then
  text="${text}<span foreground=\"$green\"></span> "
fi
[ "$cam" -eq 1 ] && text="${text}<span foreground=\"$orange\"></span> "
[ "$loc" -eq 1 ] && text="${text}<span foreground=\"$blue\">󰌀</span> "
[ "$scr" -eq 1 ] && text="${text}<span foreground=\"$purple\"></span> "
[ "$rec" -eq 1 ] && text="${text}<span foreground=\"$red\">●</span> "
text="${text% }"

if [ "$mic_muted" -eq 1 ]; then
  mic_status="Mic: muted"
elif [ -n "$mic_app" ]; then
  mic_status="Mic: $mic_app"
else
  mic_status="Mic: off"
fi

if [ -n "$cam_app" ]; then
  cam_status="Cam: $cam_app"
else
  cam_status="Cam: off"
fi

if [ -n "$loc_app" ]; then
  loc_status="Location: $loc_app"
else
  loc_status="Location: off"
fi

if [ -n "$scr_app" ]; then
  scr_status="Screen sharing: $scr_app"
else
  scr_status="Screen sharing: off"
fi

if [ "$rec" -eq 1 ]; then
  rec_status="Recording: wf-recorder (click to stop)"
else
  rec_status="Recording: off"
fi

tooltip="$mic_status  |  $cam_status  |  $loc_status  |  $scr_status  |  $rec_status"

classes="privacydot"
[ "$mic" -eq 1 ] && classes="$classes mic-on" || classes="$classes mic-off"
[ "$mic_muted" -eq 1 ] && classes="$classes mic-muted"
[ "$cam" -eq 1 ] && classes="$classes cam-on" || classes="$classes cam-off"
[ "$loc" -eq 1 ] && classes="$classes loc-on" || classes="$classes loc-off"
[ "$scr" -eq 1 ] && classes="$classes scr-on" || classes="$classes scr-off"
[ "$rec" -eq 1 ] && classes="$classes rec-on" || classes="$classes rec-off"

jq -c -n --arg text "$text" --arg tooltip "$tooltip" --arg class "$classes" \
  '{text:$text, tooltip:$tooltip, class:$class}'
