#!/bin/sh
# 系统信息只读面板：用 fuzzel 弹出内存/磁盘/温度/IP/电池
set -eu

MEM=$(free -h 2>/dev/null | awk '/^Mem:/ {printf "%s / %s", $3, $2}')
DISK=$(df -h / 2>/dev/null | awk 'NR==2 {printf "%s 已用, %s 可用", $5, $4}')

TEMP=""
for z in /sys/class/thermal/thermal_zone*/temp; do
  [ -r "$z" ] || continue
  t=$(cat "$z" 2>/dev/null) || continue
  TEMP="$((t / 1000))°C"
  break
done

IP=$(ip -4 -o addr show scope global 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | paste -sd ' ' -)

BAT=""
for b in /sys/class/power_supply/BAT*/capacity; do
  [ -r "$b" ] || continue
  BAT="$(cat "$b")%"
  break
done

info=$(printf '内存: %s\n磁盘: %s\nCPU 温度: %s\nIP: %s\n电池: %s\n' \
  "${MEM:-未知}" "${DISK:-未知}" "${TEMP:-未知}" "${IP:-无}" "${BAT:-无}")

# 用 --mesg 显示纯信息 + 空 stdin：没有输入栏、没有光标，按键不参与过滤。
printf '' | fuzzel --dmenu --hide-prompt --mesg "$info" --width 34 --minimal-lines >/dev/null
