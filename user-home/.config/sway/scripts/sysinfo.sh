#!/bin/sh
# 系统信息只读面板：用 fuzzel 弹出内存/磁盘/温度/IP/电池/可更新包
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

UPD=$(timeout 8 apk upgrade -s 2>/dev/null | grep -c '^Inst' || true)
[ "$UPD" = "0" ] && UPD="无"

printf '内存: %s\n磁盘: %s\nCPU 温度: %s\nIP: %s\n电池: %s\n可更新包: %s\n' \
  "${MEM:-未知}" "${DISK:-未知}" "${TEMP:-未知}" "${IP:-无}" "${BAT:-无}" "${UPD:-未知}" \
  | fuzzel --dmenu --hide-prompt --width 34 --lines 6 --minimal-lines >/dev/null
