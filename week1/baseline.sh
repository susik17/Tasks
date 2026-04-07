#!/bin/bash

mkdir -p logs
OUTPUT_FILE="logs/baseline_$(date +%F_%H-%M-%S).log"

{
echo "========================================"
echo "SYSTEM BASELINE REPORT"
echo "Generated at: $(date)"
echo "========================================"
echo

echo "----- CPU LOAD SUMMARY -----"
date
uptime
echo

echo "----- MEMORY USAGE SUMMARY -----"
date
free -h
echo

echo "----- DISK USAGE SUMMARY -----"
date
df -h
echo

echo "----- RUNNING PROCESS COUNT -----"
date
ps -e --no-headers | wc -l
echo

} > "$OUTPUT_FILE"
