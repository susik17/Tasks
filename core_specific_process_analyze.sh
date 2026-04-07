# ps -eo pid,psr,cmd => psr - processor number  => last CPU core the process ran on

#!/bin/bash

# npoc => no of processors/cores
#ps -eo pid,psr,state,pcpu,cmd | grep " R "
cores=$(nproc)

for ((i=0;i<cores;i++))
do
    echo "==============================================="
    echo "Processes currently running on CORE $i"
    echo "=============================================="

    ps -eo pid,psr,state,pcpu,cmd --no-headers | while read pid psr state cpu cmd
    do
        if [ "$psr" -eq "$i" ] && [ "$state" = "R" ]; then
            echo "PID=$pid CPU=${cpu}% CMD=$cmd"
        fi
    done

    echo
done

echo "=============================================================="
echo "Top CPU consuming processes with their last CPU core(real time)"
echo "=============================================================="

watch -n1 "ps -eo pid,psr,pcpu,comm --sort=-pcpu | head" #=> every 1 second, show top CPU consuming processes with their last CPU core
# Running => core-> positive value, Ready => core-> -1, Waiting => core-> -2 sleep => core-> -3, Stopped => core-> -4, Zombie => core-> -5