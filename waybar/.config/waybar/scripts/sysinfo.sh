#!/usr/bin/env bash
# Outputs a JSON object with text + tooltip for waybar custom module

TEXT="󰍹"

KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/up //')
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)
MEM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
DISK=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
TEMP=$(sensors 2>/dev/null | grep -m1 'Package id 0' | awk '{print $4}' || echo "N/A")
LOAD=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')
PROCS=$(ps -e --no-headers | wc -l)
IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')

TOOLTIP="<b>System Info</b>\n"
TOOLTIP+="Kernel:  $KERNEL\n"
TOOLTIP+="Uptime:  $UPTIME\n"
TOOLTIP+="CPU:     ${CPU}%\n"
TOOLTIP+="Load:    $LOAD\n"
TOOLTIP+="RAM:     $MEM\n"
TOOLTIP+="Disk /:  $DISK\n"
TOOLTIP+="Temp:    $TEMP\n"
TOOLTIP+="Procs:   $PROCS\n"
TOOLTIP+="IP:      $IP"

printf '{"text":"%s","tooltip":"%s"}\n' "$TEXT" "$TOOLTIP"
