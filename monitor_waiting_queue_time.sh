#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <PID>"
    exit 1
fi
PID=$1
echo "Monitoring Wait Time for PID: $PID "
while true; do
    if [ -f /proc/$PID/schedstat ]; then
        wait_ns=$(awk '{print $1}' /proc/$PID/schedstat)
        wait_sec=$(echo "scale=3; $wait_ns / 1000000000" | bc)
        clear
        echo "=== Run Queue Wait Monitor ==="
        echo "PID: $PID"
        echo "Total Wait Time: $wait_sec Seconds"
        echo "=============================="
    else
        echo "Process not found or no permissions"
        exit 1
    fi
    sleep 2
done