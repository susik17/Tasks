#!/bin/bash

# ==============================
# System Baseline & Process Analysis Script
# ==============================

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
HOSTNAME="$(hostname)"
REPORT_DIR="./baseline_reports"
REPORT_FILE="$REPORT_DIR/baseline_$(date +%F_%H-%M-%S).log"

mkdir -p "$REPORT_DIR"

{
echo "============================================================"
echo "SYSTEM BASELINE REPORT"
echo "Generated At : $TIMESTAMP"
echo "Hostname     : $HOSTNAME"
echo "============================================================"
echo

# ------------------------------------------------------------
echo "===== CPU LOAD SUMMARY ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo
uptime
echo
echo "--- Top 5 CPU Consuming Processes ---"
ps -eo pid,ppid,user,cmd,%cpu,%mem --sort=-%cpu | head -n 6
echo

# ------------------------------------------------------------
echo "===== MEMORY USAGE SUMMARY ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo
free -h
echo
echo "--- Key Memory Metrics (/proc/meminfo) ---"
grep -E 'MemTotal|MemFree|MemAvailable|Buffers|Cached|SwapTotal|SwapFree' /proc/meminfo
echo

# ------------------------------------------------------------
echo "===== DISK USAGE SUMMARY ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo
df -hT
echo
echo "--- Top 5 Disk Consumers in /var ---"
du -xh /var 2>/dev/null | sort -rh | head -n 5
echo

# ------------------------------------------------------------
echo "===== PROCESS SUMMARY ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo
echo "Total Processes:"
ps -e --no-headers | wc -l
echo
echo "--- Process State Distribution ---"
ps -eo state | sort | uniq -c
echo

# ------------------------------------------------------------
echo "===== LONGEST RUNNING PROCESSES ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo
ps -eo pid,ppid,user,etime --sort=-etime | head -n 10
echo

# ------------------------------------------------------------
echo "===== PROCESS CLASSIFICATION ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo

echo "--- System-Related Processes (UID < 1000) ---"
ps -eo pid,user | awk '$2 == "root" || $2 == "systemd-network" || $2 == "daemon" {print}'| head
echo

echo
echo "--- User-Initiated Processes (UID >= 1000) ---"
ps -eo pid,user | awk '$2 != "root" {print}'| head
echo

echo "============================================================"

} > "$REPORT_FILE"

echo "Baseline report generated at: $REPORT_FILE"
