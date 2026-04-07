#!/bin/bash
# ==============================================================================
# Script Name: safe_health_check.sh
# Description: Safe System Health Check Utility with Input Validation & Classification
# ==============================================================================

# --- 1. SCRIPT REFINEMENT & ERROR HANDLING ---
# Fail Fast: Exit on error, unset variables, and pipe failures
set -euo pipefail

# Exit Codes Define
EXIT_OK=0
EXIT_WARNING=1
EXIT_CRITICAL=2
EXIT_ERROR=3

# Logging Function (Signal vs Noise)
# Signal => Important messages (Warning, Critical, Errors)
# Noise => Normal operational messages (OK status, process start/end)
LOG_FILE="health_check.log"
log() {
    local level="$1"
    #level = OK/WARNING/CRITICAL/ERROR
    #shift removes the first argument (level) and leaves the rest as message
    shift
    local message="$*"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOG_FILE"
    # Terminal-la Warning/Critical matum kaatu (Noise reduce)
    if [[ "$level" == "WARNING" || "$level" == "CRITICAL" || "$level" == "ERROR" ]]; then
        echo "[$level] $message" >&2
    fi
}

# --- 2. INPUT HANDLING & VALIDATION (Requirement 1) ---
# Default Thresholds (Defaults iruntha script run aagum, illana validation pannum)
DEFAULT_CPU_WARN=70
DEFAULT_CPU_CRIT=90
DEFAULT_MEM_WARN=70
DEFAULT_MEM_CRIT=90
DEFAULT_DISK_WARN=80
DEFAULT_DISK_CRIT=95

validate_number() {
    local value="$1"
    local name="$2"
    # Check 1: Empty or Non-Numeric
    if [[ -z "$value" || ! "$value" =~ ^[0-9]+$ ]]; then
        log "ERROR" "Invalid input for $name: '$value'. Must be a positive number."
        exit $EXIT_ERROR
    fi
    # Check 2: Range (0-100)
    if [[ "$value" -lt 0 || "$value" -gt 100 ]]; then
        log "ERROR" "Invalid range for $name: '$value'. Must be between 0-100."
        exit $EXIT_ERROR
    fi
}

# Parse Arguments (Example: ./script.sh 70 90 70 90 80 95)
# Illana defaults use aagum
CPU_WARN=${1:-$DEFAULT_CPU_WARN}
CPU_CRIT=${2:-$DEFAULT_CPU_CRIT}
MEM_WARN=${3:-$DEFAULT_MEM_WARN}
MEM_CRIT=${4:-$DEFAULT_MEM_CRIT}
DISK_WARN=${5:-$DEFAULT_DISK_WARN}
DISK_CRIT=${6:-$DEFAULT_DISK_CRIT}

# Run Validation
validate_number "$CPU_WARN" "CPU Warning"
validate_number "$CPU_CRIT" "CPU Critical"
validate_number "$MEM_WARN" "MEM Warning"
validate_number "$MEM_CRIT" "MEM Critical"
validate_number "$DISK_WARN" "DISK Warning"
validate_number "$DISK_CRIT" "DISK Critical"

# Logic Check: Warning should be less than Critical
if [[ "$CPU_WARN" -ge "$CPU_CRIT" || "$MEM_WARN" -ge "$MEM_CRIT" || "$DISK_WARN" -ge "$DISK_CRIT" ]]; then
    log "ERROR" "Logic Error: Warning threshold cannot be >= Critical threshold."
    exit $EXIT_ERROR
fi

# --- 3. RESOURCE MEASUREMENT (Requirement 2) ---
# Normalize Output (Raw command dumps avoid panni, just number edukkanum)
get_cpu_usage() {
    # top command la idle time eduthu, 100-la subtract pannom
    local idle
    idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1)
    # Handle float to int conversion roughly
    printf "%.0f" "$(echo "100 - $idle" | bc)"
}

get_memory_usage() {
    # free command la used/total percentage
    free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

get_disk_usage() {
    # df command la root partition usage
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

# --- 4. HEALTH CLASSIFICATION (Requirement 3) ---
check_health() {
    local metric_name="$1"
    local current_value="$2"
    local warn_thresh="$3"
    local crit_thresh="$4"
    local status=$EXIT_OK

    if [[ "$current_value" -ge "$crit_thresh" ]]; then
        log "CRITICAL" "$metric_name is ${current_value}% (Threshold: ${crit_thresh}%)"
        status=$EXIT_CRITICAL
    elif [[ "$current_value" -ge "$warn_thresh" ]]; then
        log "WARNING" "$metric_name is ${current_value}% (Threshold: ${warn_thresh}%)"
        status=$EXIT_WARNING
    else
        log "OK" "$metric_name is ${current_value}% (Normal)"
        status=$EXIT_OK
    fi
    return $status
}

# --- MAIN LOGIC ---
main() {
    log "OK" "Health Check Started with thresholds: CPU(${CPU_WARN}/${CPU_CRIT}), MEM(${MEM_WARN}/${MEM_CRIT}), DISK(${DISK_WARN}/${DISK_CRIT})"
    
    local overall_status=$EXIT_OK
    local temp_status=0

    # 1. Check CPU
    cpu_usage=$(get_cpu_usage)
    check_health "CPU" "$cpu_usage" "$CPU_WARN" "$CPU_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # 2. Check Memory
    mem_usage=$(get_memory_usage)
    check_health "Memory" "$mem_usage" "$MEM_WARN" "$MEM_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # 3. Check Disk
    disk_usage=$(get_disk_usage)
    check_health "Disk" "$disk_usage" "$DISK_WARN" "$DISK_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # Final Summary
    if [[ "$overall_status" -eq $EXIT_OK ]]; then
        log "OK" "System Health: HEALTHY"
    elif [[ "$overall_status" -eq $EXIT_WARNING ]]; then
        log "WARNING" "System Health: DEGRADED (Check Warnings)"
    else
        log "CRITICAL" "System Health: UNHEALTHY (Immediate Action Required)"
    fi

    log "OK" "Health Check Completed"
    exit $overall_status
}

main
# --- 2. INPUT HANDLING & VALIDATION (Requirement 1) ---
# Default Thresholds (Defaults iruntha script run aagum, illana validation pannum)
DEFAULT_CPU_WARN=70
DEFAULT_CPU_CRIT=90
DEFAULT_MEM_WARN=70
DEFAULT_MEM_CRIT=90
DEFAULT_DISK_WARN=80
DEFAULT_DISK_CRIT=95

validate_number() {
    local value="$1"
    local name="$2"
    # Check 1: Empty or Non-Numeric
    if [[ -z "$value" || ! "$value" =~ ^[0-9]+$ ]]; then
        log "ERROR" "Invalid input for $name: '$value'. Must be a positive number."
        exit $EXIT_ERROR
    fi
    # Check 2: Range (0-100)
    if [[ "$value" -lt 0 || "$value" -gt 100 ]]; then
        log "ERROR" "Invalid range for $name: '$value'. Must be between 0-100."
        exit $EXIT_ERROR
    fi
}

# Parse Arguments (Example: ./script.sh 70 90 70 90 80 95)
# Illana defaults use aagum
CPU_WARN=${1:-$DEFAULT_CPU_WARN}
CPU_CRIT=${2:-$DEFAULT_CPU_CRIT}
MEM_WARN=${3:-$DEFAULT_MEM_WARN}
MEM_CRIT=${4:-$DEFAULT_MEM_CRIT}
DISK_WARN=${5:-$DEFAULT_DISK_WARN}
DISK_CRIT=${6:-$DEFAULT_DISK_CRIT}

# Run Validation
validate_number "$CPU_WARN" "CPU Warning"
validate_number "$CPU_CRIT" "CPU Critical"
validate_number "$MEM_WARN" "MEM Warning"
validate_number "$MEM_CRIT" "MEM Critical"
validate_number "$DISK_WARN" "DISK Warning"
validate_number "$DISK_CRIT" "DISK Critical"

# Logic Check: Warning should be less than Critical
if [[ "$CPU_WARN" -ge "$CPU_CRIT" || "$MEM_WARN" -ge "$MEM_CRIT" || "$DISK_WARN" -ge "$DISK_CRIT" ]]; then
    log "ERROR" "Logic Error: Warning threshold cannot be >= Critical threshold."
    exit $EXIT_ERROR
fi

# --- 3. RESOURCE MEASUREMENT (Requirement 2) ---
# Normalize Output (Raw command dumps avoid panni, just number edukkanum)
get_cpu_usage() {
    # top command la idle time eduthu, 100-la subtract pannom
    local idle
    idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1)
    # Handle float to int conversion roughly
    printf "%.0f" "$(echo "100 - $idle" | bc)"
}

get_memory_usage() {
    # free command la used/total percentage
    free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

get_disk_usage() {
    # df command la root partition usage
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

# --- 4. HEALTH CLASSIFICATION (Requirement 3) ---
check_health() {
    local metric_name="$1"
    local current_value="$2"
    local warn_thresh="$3"
    local crit_thresh="$4"
    local status=$EXIT_OK

    if [[ "$current_value" -ge "$crit_thresh" ]]; then
        log "CRITICAL" "$metric_name is ${current_value}% (Threshold: ${crit_thresh}%)"
        status=$EXIT_CRITICAL
    elif [[ "$current_value" -ge "$warn_thresh" ]]; then
        log "WARNING" "$metric_name is ${current_value}% (Threshold: ${warn_thresh}%)"
        status=$EXIT_WARNING
    else
        log "OK" "$metric_name is ${current_value}% (Normal)"
        status=$EXIT_OK
    fi
    return $status
}

# --- MAIN LOGIC ---
main() {
    log "OK" "Health Check Started with thresholds: CPU(${CPU_WARN}/${CPU_CRIT}), MEM(${MEM_WARN}/${MEM_CRIT}), DISK(${DISK_WARN}/${DISK_CRIT})"
    
    local overall_status=$EXIT_OK
    local temp_status=0

    # 1. Check CPU
    cpu_usage=$(get_cpu_usage)
    check_health "CPU" "$cpu_usage" "$CPU_WARN" "$CPU_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # 2. Check Memory
    mem_usage=$(get_memory_usage)
    check_health "Memory" "$mem_usage" "$MEM_WARN" "$MEM_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # 3. Check Disk
    disk_usage=$(get_disk_usage)
    check_health "Disk" "$disk_usage" "$DISK_WARN" "$DISK_CRIT" || temp_status=$?
    [[ "$temp_status" -gt "$overall_status" ]] && overall_status=$temp_status

    # Final Summary
    if [[ "$overall_status" -eq $EXIT_OK ]]; then
        log "OK" "System Health: HEALTHY"
    elif [[ "$overall_status" -eq $EXIT_WARNING ]]; then
        log "WARNING" "System Health: DEGRADED (Check Warnings)"
    else
        log "CRITICAL" "System Health: UNHEALTHY (Immediate Action Required)"
    fi

    log "OK" "Health Check Completed"
    exit $overall_status
}

main