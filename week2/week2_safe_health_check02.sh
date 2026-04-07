#!/bin/bash
# ==============================================================================
# Script Name: safe_health_check.sh
# Description: Safe System Health Check Utility
# ==============================================================================

# --- 1. SCRIPT REFINEMENT & ERROR HANDLING ---
set -euo pipefail

# Exit Codes
EXIT_OK=0
EXIT_WARNING=1
EXIT_CRITICAL=2
EXIT_ERROR=3

# --- 2. LOGGING SETUP (File La Save Aagum) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/health_check.log"

# Create log folder automatically
mkdir -p "$LOG_DIR"

# Logging Function (Signal vs Noise)
log() {
    local level="$1"      # First word: INFO, ERROR, etc.
    local message="$2"    # Second word: Full message
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    
    echo "$timestamp [$level] $message" >> "$LOG_FILE"
    
    #  Error/Warning => Important messages (Signal) => Terminal show 
    if [[ "$level" == "ERROR" || "$level" == "CRITICAL" || "$level" == "WARNING" ]]; then
        echo "$timestamp [$level] $message" >&2
    fi
}

# --- 3. INPUT HANDLING & VALIDATION ---
# Default Thresholds
DEF_CPU_WARN=70; DEF_CPU_CRIT=90
DEF_MEM_WARN=70; DEF_MEM_CRIT=90
DEF_DISK_WARN=80; DEF_DISK_CRIT=95

# Use Arguments passed by user or  use Defaults
CPU_WARN=${1:-$DEF_CPU_WARN}
CPU_CRIT=${2:-$DEF_CPU_CRIT}
MEM_WARN=${3:-$DEF_MEM_WARN}
MEM_CRIT=${4:-$DEF_MEM_CRIT}
DISK_WARN=${5:-$DEF_DISK_WARN}
DISK_CRIT=${6:-$DEF_DISK_CRIT}

# Validate Function (Number & Range Check)
validate_input() {
    local value="$1"
    local name="$2"
    
    # Check 1: Empty or Not a Number
    if [[ -z "$value" || ! "$value" =~ ^[0-9]+$ ]]; then
        log "ERROR" "Invalid input for $name: '$value'. Must be a number."
        exit $EXIT_ERROR
    fi
    
    # Check 2: Range 0-100
    if [[ "$value" -lt 0 || "$value" -gt 100 ]]; then
        log "ERROR" "Invalid range for $name: '$value'. Must be 0-100."
        exit $EXIT_ERROR
    fi
}

# Run Validation for all inputs
validate_input "$CPU_WARN" "CPU Warning"
validate_input "$CPU_CRIT" "CPU Critical"
validate_input "$MEM_WARN" "MEM Warning"
validate_input "$MEM_CRIT" "MEM Critical"
validate_input "$DISK_WARN" "DISK Warning"
validate_input "$DISK_CRIT" "DISK Critical"

# Check Logic: Warning should be less than Critical
if [[ "$CPU_WARN" -ge "$CPU_CRIT" || "$MEM_WARN" -ge "$MEM_CRIT" || "$DISK_WARN" -ge "$DISK_CRIT" ]]; then
    log "ERROR" "Logic Error: Warning threshold cannot be >= Critical threshold."
    exit $EXIT_ERROR
fi

# --- 4. RESOURCE MEASUREMENT (Normalized Output) ---
get_cpu_usage() {
    # vmstat => 15th column = Idle % => 100 - Idle = CPU Usage
    vmstat 1 2 | tail -1 | awk '{print 100 - $15}'
}

get_memory_usage() {
    # Free command => Memory% 
    free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

get_disk_usage() {
    # DF command => Disk% 
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

# --- 5. HEALTH CLASSIFICATION ---
check_health() {
    local metric="$1"
    local current="$2"
    local warn="$3"
    local crit="$4"
    local status=$EXIT_OK

    if [[ "$current" -ge "$crit" ]]; then
        log "CRITICAL" "$metric is ${current}% (Limit: ${crit}%)"
        status=$EXIT_CRITICAL
    elif [[ "$current" -ge "$warn" ]]; then
        log "WARNING" "$metric is ${current}% (Limit: ${warn}%)"
        status=$EXIT_WARNING
    else
        log "OK" "$metric is ${current}% (Normal)"
        status=$EXIT_OK
    fi
    return $status
}

# --- MAIN LOGIC ---
main() {
    log "INFO" "Health Check Started"
    log "INFO" "Thresholds: CPU(${CPU_WARN}/${CPU_CRIT}), MEM(${MEM_WARN}/${MEM_CRIT}), DISK(${DISK_WARN}/${DISK_CRIT})"
    
    local overall_status=$EXIT_OK
    local temp_status=0

    # Check CPU
    cpu_val=$(get_cpu_usage)
    check_health "CPU" "$cpu_val" "$CPU_WARN" "$CPU_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # Check Memory
    mem_val=$(get_memory_usage)
    check_health "Memory" "$mem_val" "$MEM_WARN" "$MEM_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # Check Disk
    disk_val=$(get_disk_usage)
    check_health "Disk" "$disk_val" "$DISK_WARN" "$DISK_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # Final Summary
    if [[ "$overall_status" -eq $EXIT_OK ]]; then
        log "INFO" "System Health: HEALTHY"
    elif [[ "$overall_status" -eq $EXIT_WARNING ]]; then
        log "WARNING" "System Health: DEGRADED"
    else
        log "CRITICAL" "System Health: UNHEALTHY"
    fi
    
    log "INFO" "Health Check Completed"
    exit $overall_status
}

main