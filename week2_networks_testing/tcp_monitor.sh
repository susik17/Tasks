#!/bin/bash

LOG_FILE="tcp_log.txt"
PREV_FILE="/tmp/prev_conn.txt"
CURR_FILE="/tmp/curr_conn.txt"

LOCAL_IPS=$(hostname -I)


while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Capture current connections
    ss -tn state established -o | awk 'NR>1 {print $4, $5, $6}' > $CURR_FILE

    # Compare with previous → new connections => avoid add dupicates of same connections
    # grep -Fxv  =>-F Fixed strings, x->full-line match, v-inverted (exclude)=> unique
    if [ -f "$PREV_FILE" ]; then
        new_conn=$(grep -Fxv -f $PREV_FILE $CURR_FILE)
    else
        new_conn=$(cat $CURR_FILE)
    fi


    #Extract src&dest 
    #ip=> dst == local → IN
    #src == local → OUT
    echo "$new_conn" | while read src dst timer; do
        src_ip=${src%:*}
        #If src="192.168.1.5:8080", then src_ip becomes 192.168.1.5=> removes after ':'
        dst_ip=${dst%:*}
        

        if echo "$LOCAL_IPS" | grep -qw "$dst_ip"; then
            direction="IN"
            peer_ip=$src_ip
        else
            direction="OUT"
            peer_ip=$dst_ip
        fi
    

        echo "$timestamp | $direction | $src -> $dst | $timer" >> $LOG_FILE
    done

    # Save snapshot
    cp $CURR_FILE $PREV_FILE
     
    sleep 180 #3mins
done