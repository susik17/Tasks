#!/bin/bash

#CPU Steal => (wait) Time when VM wants CPU but hypervisor gives CPU to another VM.
#cpu steal => VM level metric, not host/process level metric.

LOG_FILE="cpu_steal_log.txt"
THRESHOLD=5  #  above 5 percent -> warning 

while true
do
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    STEAL=$(mpstat 1 1 | awk '/Average/ {print $8}')
    #check => steal empty
    if [ -z "$STEAL" ]; then
        STEAL=0
    fi

    #check steal crosses threshold
    if (( $(echo "$STEAL > $THRESHOLD" | bc -l) ))
    then
        STATUS="HIGH STEAL"
    else
        STATUS="NORMAL"
    fi

    echo "$TIME | CPU Steal: $STEAL% | Status: $STATUS" >> $LOG_FILE
    #Top processes => identify which processes are consuming CPU resources
    echo "Top 10 CPU Processes:" >> $LOG_FILE
    ps -eo pid,comm,%cpu --sort=-%cpu | head -11 >> $LOG_FILE

    sleep 10 # 300s -> 5 minutes
done