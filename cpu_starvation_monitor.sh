#!/bin/bash

#CPU Starvation => A process keeps waiting for resources because other processes continuously get priority.

LOG_FILE="cpu_starvation_log.txt"
CORES=$(nproc)
THRESHOLD=$CORES  # Load > cores => cpu_starvation 

echo "=== CPU Starvation Monitor Started ===" >> $LOG_FILE
echo "CPU Cores: $CORES" >> $LOG_FILE
echo "Monitoring every 5 mins..." >> $LOG_FILE
echo "--------------------------------------" >> $LOG_FILE

while true
do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # Load average -> R(wait cpu)+D(wait i/o) state
    LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)
    #xargs  => trim spaces

    #cpu idle(cpu freetime) => low (cpu busy) && run queue(process waiting for cpu) => high  ====> cpu starvation
    RUN_QUEUE=$(vmstat 1 1 | tail -1 | awk '{print $1}')
    CPU_IDLE=$(vmstat 1 1 | tail -1 | awk '{print $15}')

    # Top CPU processes
    TOP_PROCESSES=$(ps aux --sort=-%cpu | head -6 | tail -5)

    STATUS="NORMAL"

    if (( $(echo "$LOAD > $THRESHOLD" | bc -l) ))
    then
        STATUS="STARVATION DETECTED"
    fi

    echo "Time: $TIMESTAMP" >> $LOG_FILE
    echo "Status: $STATUS" >> $LOG_FILE
    echo "Load Average: $LOAD | CPU Cores: $CORES" >> $LOG_FILE
    echo "Run Queue: $RUN_QUEUE | CPU Idle: $CPU_IDLE%" >> $LOG_FILE
    echo "Top CPU Processes:" >> $LOG_FILE
    echo "$TOP_PROCESSES" >> $LOG_FILE
    echo "--------------------------------------" >> $LOG_FILE

    sleep 10 
done