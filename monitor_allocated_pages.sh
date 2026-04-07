#!/bin/bash
#get PID => argument
PID=$1
echo "=== Memory Page Monitor (PID: $PID) ==="
echo "Monitoring... "
echo "--------------------------------------"
while true; do

    # Read directly from statm -> memory status (pages)
    STATM=$(cat /proc/$PID/statm)
    RSS_PAGES=$(echo $STATM | awk '{print $2}')  # 2nd column => RSS Pages
    VIRT_PAGES=$(echo $STATM | awk '{print $1}') # 1st column => Virtual Pages
    
    echo "=== Memory Page Monitor (PID: $PID) ==="
    echo "Total virtual memory pages allocated: $VIRT_PAGES"
    echo "Total RSS memory pages allocated: $RSS_PAGES"
    echo "---------------------------------------"

    sleep 10
done