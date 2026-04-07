#!/bin/bash

LOGFILE="/home/susi-pt8230/Tasks/userspecific_process_state/process_log.txt"

while true
do
echo "===== $(date) =====" >> $LOGFILE

ps -eo user=,stat= | awk '
{
user=$1
# Extarct -> 1st character of state 
state=substr($2,1,1)

# Total processes => user
total[user]++

#state count => user
if(state=="R") R[user]++
if(state=="S") S[user]++
if(state=="D") D[user]++
if(state=="T") T[user]++
if(state=="Z") Z[user]++
}


# END BLOCK => After processing all lines, print summary for each user
END {

for(u in total){

#STATE COUNT VARIABLES
r=R[u]+0
s=S[u]+0
d=D[u]+0
t=T[u]+0
z=Z[u]+0

#MAX/MIN STATE => CALCULATE MAX/MIN STATE 
#maxv -> state => count value 
max="R"; maxv=r
if(s>maxv){max="S"; maxv=s}
if(d>maxv){max="D"; maxv=d}
if(t>maxv){max="T"; maxv=t}
if(z>maxv){max="Z"; maxv=z}

min="R"; minv=r
if(s<minv){min="S"; minv=s}
if(d<minv){min="D"; minv=d}
if(t<minv){min="T"; minv=t}
if(z<minv){min="Z"; minv=z}

printf "%s total=%d R=%d S=%d D=%d T=%d Z=%d MAX=%s MIN=%s\n",
u,total[u],r,s,d,t,z,max,min
}
}
' >> $LOGFILE

echo "" >> $LOGFILE

sleep 20 #120 => 2 minutes

done