#!/bin/bash

# ============================
# System Health Check Script
# Author: Okello Elijah
# ============================

LOG_FILE="/var/log/sysmonitor/system_health.log"

DISK_THRESHOLD=80
MEM_THRESHOLD=75

log_message() {
    local MESSAGE="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $MESSAGE" >> "$LOG_FILE"
}

check_disk() {
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
    echo "$DISK_USAGE"
}

check_memory() {
    MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
    echo "$MEM_USAGE"
}

check_cpu() {
    CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
    echo "$CPU_LOAD"
}

main() {
    DISK=$(check_disk)
    MEM=$(check_memory)
    CPU=$(check_cpu)

    STATUS="OK"

    if [ "$DISK" -ge "$DISK_THRESHOLD" ] || [ "$MEM" -ge "$MEM_THRESHOLD" ]; then
        STATUS="WARNING"
    fi

    OUTPUT="Status: $STATUS | Disk: ${DISK}% | Memory: ${MEM}% | CPU Load: $CPU"

    echo "$OUTPUT"
    log_message "$OUTPUT"
}

main

