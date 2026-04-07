#!/bin/bash
# ==========================================
# Defensive Scripting Example: Log Rotator
# ==========================================

# 1. Strict Mode
set -euo pipefail

# 2. Constants
LOG_DIR="/var/log/myapp"
MAX_SIZE=10485760 # 10MB
TIMESTAMP=$(date +%F_%H-%M-%S)

# 3. Logging Functions
log_info() { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

# 4. Cleanup Trap
TEMP_FILE=""
cleanup() {
    if [ -n "$TEMP_FILE" ] && [ -f "$TEMP_FILE" ]; then
        rm -f "$TEMP_FILE"
        log_info "Temp file cleaned up."
    fi
}
trap cleanup EXIT INT TERM

# 5. Input Validation & Checks
if [ ! -d "$LOG_DIR" ]; then
    log_error "Log directory $LOG_DIR does not exist!"
    exit 1
fi

# Check if running as root (since /var/log needs permission)
if [ "$EUID" -ne 0 ]; then 
    log_error "Please run as root"
    exit 1
fi

log_info "Starting log rotation..."

# 6. Safe File Operations
for logfile in "$LOG_DIR"/*.log; do
    if [ -f "$logfile" ]; then
        size=$(stat -c%s "$logfile")
        
        if [ "$size" -gt "$MAX_SIZE" ]; then
            log_info "Rotating $logfile (Size: $size)"
            
            # Create safe temp file
            TEMP_FILE=$(mktemp)
            
            # Compress logic (Simulated)
            gzip -c "$logfile" > "$TEMP_FILE"
            
            # Move atomically
            mv "$TEMP_FILE" "${logfile}.${TIMESTAMP}.gz"
            
            # Truncate original file safely
            : > "$logfile" 
            
            # Reset temp file var so cleanup doesn't delete new backup
            TEMP_FILE=""
            
            log_info "Rotated successfully: ${logfile}.${TIMESTAMP}.gz"
        fi
    fi
done

log_info "Log rotation completed."
exit 0