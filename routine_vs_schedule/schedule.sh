#!/bin/bash

LOG_FILE="/home/susi-pt8230/Tasks/routine_vs_schedule/schedule_log.txt"

echo "===== Scheduled Task Started ====="

while true
do
    current_time=$(date +%H:%M)

    if [ "$current_time" = "16:27" ] || [ "$current_time" = "16:30" ]; then
        echo "Scheduled Task Executed at $(date)" >> "$LOG_FILE"
        sleep 60
    fi

    sleep 5
done