#!/bin/bash

LOG_FILE="tcp_log.txt"

echo "Top Incoming IP:"
grep "IN" $LOG_FILE | awk -F'|' '{print $3}' | awk '{print $1}' | sort | uniq -c | sort -nr | head -1

echo "Longest Connection:"
awk -F'|' '{print $4}' $LOG_FILE | sort -r | head -1

echo "Shortest Connection:"
awk -F'|' '{print $4}' $LOG_FILE | sort | head -1