#!/bin/bash

# monitor script => continuos log collection 

mkdir -p logs
LOG="logs/system_monitor.log"

echo "Monitoring started at $(date)"

while true
do
echo "=================================" >> $LOG
echo "Timestamp: $(date)" >> $LOG

CPU=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1)
MEM=$(free | awk '/Mem:/ {print $3}')
DISK=$(df / | awk 'NR==2 {print $5}')
PROC=$(ps -e --no-headers | wc -l)

echo "CPU_LOAD=$CPU" >> $LOG
echo "MEM_USED=$MEM" >> $LOG
echo "DISK_USED=$DISK" >> $LOG
echo "PROCESS_COUNT=$PROC" >> $LOG
echo "" >> $LOG

sleep 30
done