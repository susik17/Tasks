#!/bin/bash

LOGFILE="cpu_starvation.log"

echo "==== CPU Starvation Monitor Started $(date) ====" >> $LOGFILE

while true
do
    echo "---- $(date) ----" >> $LOGFILE

    ps -eo pid,stat,etimes,pcpu,comm --no-headers | awk '
    $2 ~ /^R/ && $3 > 60 && $4 < 1 {
        printf "STARVATION: PID=%s CMD=%s TIME=%ss CPU=%s%%\n",$1,$5,$3,$4
    }' >> $LOGFILE

    sleep 10
done