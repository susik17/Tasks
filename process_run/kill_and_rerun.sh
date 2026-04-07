#kill -> pid remove forever 
#rerun -> using 'cmd' ->  rerun the same process again but with new pid

#check -> dummy_app run 

#!/bin/bash

#!/bin/bash
set -euo pipefail

# ================= CONFIGURATION =================
LOG_FILE="/home/susi-pt8230/Tasks/process_run/cpu_usage_log.log"
CHECK_INTERVAL=60  # Check every 60 seconds 
# =================================================

# --- Input Validation ---
if [ $# -lt 2 ]; then
    echo "Usage: $0 <PID> <CPU_THRESHOLD>"
    echo "Example: $0 1234 80.0"
    exit 1
fi

TARGET_PID=$1
THRESHOLD=$2

# --- Functions ---
log_message() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$msg" | tee -a "$LOG_FILE"
}

cleanup() {
    log_message "Script Stopped. (PID: $$)"
    exit 0
}

# Trap signals for graceful exit
trap cleanup EXIT INT TERM

# --- Initial Check ---
if ! kill -0 "$TARGET_PID" 2>/dev/null; then
    log_message "Error: PID $TARGET_PID does not exist or no permission!"
    exit 1
fi

# Capture Original Command & Working Directory (For Restart)
ORIGINAL_CMD=$(ps -p "$TARGET_PID" -o args= 2>/dev/null)
ORIGINAL_CWD=$(pwdx "$TARGET_PID" 2>/dev/null | awk -F: '{print $2}' | xargs)

if [ -z "$ORIGINAL_CMD" ]; then
    log_message "Error: Could not capture command for PID $TARGET_PID"
    exit 1
fi

log_message "MONITOR Started for PID: $TARGET_PID"
log_message "Threshold: ${THRESHOLD}%"
log_message "Command: $ORIGINAL_CMD"
log_message "Working Dir: ${ORIGINAL_CWD:-/}"
log_message "----------------------------------------"

# --- Main Loop (Scheduling Inside Script) ---
while true; do
    # 1. Check if Process Exists
    if ! kill -0 "$TARGET_PID" 2>/dev/null; then
        log_message "Process $TARGET_PID is DEAD. Restarting..."
        # Restart Logic
        (cd "${ORIGINAL_CWD:-/}" && nohup $ORIGINAL_CMD > /dev/null 2>&1 &)
        NEW_PID=$!
        TARGET_PID=$NEW_PID
        log_message "Restarted! New PID: $TARGET_PID"
        sleep 5
        continue
    fi

    # 2. Get CPU Usage
    # ps -p: Specific PID, -o %cpu=: Output only CPU value
    CPU_USAGE=$(ps -p "$TARGET_PID" -o %cpu= 2>/dev/null | awk '{print $1}')
    
    if [ -z "$CPU_USAGE" ]; then
        log_message "Could not fetch CPU for PID $TARGET_PID"
        sleep $CHECK_INTERVAL
        continue
    fi

    # 3. Compare CPU with Threshold (Float Comparison using awk)
    IS_HIGH=$(awk -v cpu="$CPU_USAGE" -v thresh="$THRESHOLD" 'BEGIN {print (cpu > thresh) ? 1 : 0}')

    if [ "$IS_HIGH" -eq 1 ]; then
        log_message "ALERT: CPU ${CPU_USAGE}% > Threshold ${THRESHOLD}%"
        log_message "Killing PID $TARGET_PID..."
        
        # Graceful Kill (SIGTERM)
        kill -15 "$TARGET_PID" 2>/dev/null || true
        sleep 5
        
        # Force Kill (SIGKILL) if still running
        if kill -0 "$TARGET_PID" 2>/dev/null; then
            log_message "Force Killing (SIGKILL)..."
            kill -9 "$TARGET_PID" 2>/dev/null || true
        fi

        # 4. Restart Process
        log_message "Restarting Process..."
        cd "${ORIGINAL_CWD:-/}" || cd /
        nohup $ORIGINAL_CMD > /dev/null 2>&1 &
        sleep 1
        NEW_PID=${!:-0}
        TARGET_PID=$NEW_PID
        log_message "Process Restarted! New PID: $TARGET_PID"
    else
        log_message "OK: PID $TARGET_PID CPU is ${CPU_USAGE}% (Limit: ${THRESHOLD}%)"
    fi

    # 5. Schedule Next Check
    sleep $CHECK_INTERVAL
done