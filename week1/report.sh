#!/bin/bash

LOG="logs/system_monitor.log"


#calculate thresholds from logs 
CPU_LIMIT=$(grep CPU_LOAD "$LOG" | cut -d= -f2 | sort -nr | head -1 | awk '{print $1 * 0.9}')
MEM_LIMIT=$(grep MEM_USED "$LOG" | cut -d= -f2 | sort -nr | head -1 | awk '{print $1 * 0.9}')
PROC_LIMIT=$(grep PROCESS_COUNT "$LOG" | cut -d= -f2 | sort -nr | head -1 | awk '{printf "%.0f", $1 * 0.9}')

echo "Auto-Calculated Thresholds (90% of Observed Max):"
echo "   CPU Limit: $CPU_LIMIT"
echo "   MEM Limit: $MEM_LIMIT KiB"
echo "   PROC Limit: $PROC_LIMIT"
echo "----------------------------------------"
echo
echo "================================"
echo "FINAL SYSTEM MONITOR REPORT"
echo "Generated at: $(date)"
echo "================================"
echo

echo "----- SUMMARY -----"

echo "Max CPU Load:"
grep CPU_LOAD $LOG | cut -d= -f2 | sort -nr | head -1

echo "Max Memory Usage:"
grep MEM_USED $LOG | cut -d= -f2 | sort -nr | head -1

echo "Max Process Count:"
grep PROCESS_COUNT $LOG | cut -d= -f2 | sort -nr | head -1

echo
echo "----- ANOMALY REPORT -----"

grep CPU_LOAD $LOG | awk -F= -v limit=$CPU_LIMIT '
{ if($2 > limit) print "High CPU Load:",$2 }'

grep MEM_USED $LOG | awk -F= -v limit=$MEM_LIMIT '
{ if($2 > limit) print "High Memory Usage:",$2 }'

grep PROCESS_COUNT $LOG | awk -F= -v limit=$PROC_LIMIT '
{ if($2 > limit) print "High Process Count:",$2 }'