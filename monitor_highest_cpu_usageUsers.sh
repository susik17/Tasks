#!/bin/bash

# ================= CONFIGURATION =================
LOG_FILE="cpu_user_monitor.log"
INTERVAL=10  # 5 Minutes (300 seconds)
# =================================================

# Clear old log file
echo "" > $LOG_FILE

# Variables to track OVERALL Highest CPU User
MAX_CPU=0
MAX_USER="N/A"
MAX_PID="N/A"
MAX_COMM="N/A"
MAX_TIME="N/A"

# Function to write Final Summary when script stops
finish() {
    echo "" 
    echo "=========================================="
    echo "FINAL SUMMARY - TOP CPU USER"
    echo "==========================================" 
    echo "User with Highest CPU Overall: $MAX_USER" 
    echo "Process ID (PID): $MAX_PID" 
    echo "Process Name: $MAX_COMM" 
    echo "Max CPU Recorded: ${MAX_CPU}%" 
    echo "Peak Time: $MAX_TIME" 
    echo "==========================================" 
    echo "MONITORING STOPPED"
    echo "End Time: $(date)" 
    echo "==========================================" 
    echo ""
    exit 0
}

# Trap Ctrl+C to run the finish function
trap finish EXIT

# main start point 
# Start Message
echo "Starting User CPU Monitor (Every 5 mins)..."
echo "Logging to: $LOG_FILE"

# Write Header to Log
echo "==========================================" >> $LOG_FILE
echo " USER CPU MONITORING REPORT" >> $LOG_FILE
echo "Start Time: $(date)" >> $LOG_FILE
echo "==========================================" >> $LOG_FILE
echo "" >> $LOG_FILE

# Main Loop
while true
do
    # 1. Get Current Time
    CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

    # 2. Find Top CPU Process (All Users)
    # Format: user pid cpu% command
    TOP_LINE=$(ps -eo user,pid,pcpu,comm --sort=-pcpu | head -2 | tail -1)
    
    # Extract individual fields
    TOP_USER=$(echo "$TOP_LINE" | awk '{print $1}')
    TOP_PID=$(echo "$TOP_LINE" | awk '{print $2}')
    TOP_CPU=$(echo "$TOP_LINE" | awk '{print $3}')
    TOP_COMM=$(echo "$TOP_LINE" | awk '{print $4}')

    # 3. Check if this is the NEW HIGHEST ever recorded
    # Using awk for float comparison (bash can't compare floats directly)
    IS_HIGHER=$(awk -v new="$TOP_CPU" -v old="$MAX_CPU_EVER" 'BEGIN {print (new > old) ? 1 : 0}')
    
    if [ "$IS_HIGHER" -eq 1 ]; then
        MAX_CPU_EVER="$TOP_CPU"
        MAX_USER_EVER="$TOP_USER"
        MAX_PID_EVER="$TOP_PID"
        MAX_COMM_EVER="$TOP_COMM"
        MAX_TIME_EVER="$CURRENT_TIME"
    fi

    # 4. Write to Log File (Every 5 mins)
    echo "Time: $CURRENT_TIME" >> $LOG_FILE
    echo "Top: $TOP_USER | PID: $TOP_PID | CPU: ${TOP_CPU}% | Proc: $TOP_COMM" >> $LOG_FILE
    echo "----------------------------------------" >> $LOG_FILE


    # 6. Wait for 5 Minutes
    sleep $INTERVAL
done