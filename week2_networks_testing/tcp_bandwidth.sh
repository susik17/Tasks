#!/bin/bash


#bandwidth => Data  transfer rate => bytes 
echo "Checking bandwidth..."


# -t -> tcp i-> internal details n-> numeric => tells about bytes send&received 
# capture start 
ss -tin state established | grep -E "ESTAB|bytes_" > /tmp/start.txt

sleep 5

# capture end
ss -tin state established | grep -E "ESTAB|bytes_" > /tmp/end.txt

echo "Top bandwidth IP (approx):"


# s1,s2 => send r1,r2 => receive 
#combine both [start] [end]
paste /tmp/start.txt /tmp/end.txt | awk '    
/ESTAB/ {
    src=$4
    dst=$5
}
/bytes_sent/ {
    for(i=1;i<=NF;i++){
        if($i ~ /bytes_sent:/){
            split($i,a,":"); s1=a[2]
        }
        if($i ~ /bytes_received:/){
            split($i,b,":"); r1=b[2]
        }
    }

    getline
    for(i=1;i<=NF;i++){
        if($i ~ /bytes_sent:/){
            split($i,a,":"); s2=a[2]
        }
        if($i ~ /bytes_received:/){
            split($i,b,":"); r2=b[2]
        }
    }

    diff = (s2 - s1) + (r2 - r1)

    split(dst,d,":")
    ip=d[1]

    usage[ip]+=diff
}

END {
    for(i in usage){
        print i, usage[i]
    }
}'

#Example
#start(s1,s2): 1000 + 2000
#end:   4000 + 6000

#diff = 7000 bytes

#---------------------------------------------------
#1. Take snapshot1 (bytes_sent, bytes_received)
#2. Wait (5 sec)
#3. Take snapshot2
#4. For each connection:
#     diff = (bytes2 - bytes1)
#5. Extract IP (remove port)
#6. Group by IP (sum all diffs)
#7. Print IP with data usage