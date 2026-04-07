#!/bin/bash 

LOG_FILE="/home/susi-pt8230/Tasks/logs/process_stats.log"

#infinite loop 
while true; do
	#variable used to store time  
	TIMESTAMP=$(date '+%y-%m-%d %H:%M:%S')
	#get date & append to log
	#while read USER STATE - each line -> user,state segregate
	ps -eo user,state --no-headers | while read USER STATE; do 
		echo "$TIMESTAMP,$USER,$STATE" >> $LOG_FILE 
        done 
	
	echo "Logged  at : $TIMESTAMP"
	#for 2 mins -> sleep 120 sleep 10 -> 10s 
 	sleep 10 
done

