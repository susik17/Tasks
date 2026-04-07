# file config 

IP_FILE="/home/susi-pt8230/Tasks/logs/process_stats.log"

echo "------------------ANALYSE REPORT----------------------"

echo "-----------------------------------------------------"
#1.Total Records
echo "Total Records(logfile):$(wc -l < "IP_FILE")"

echo "-------------------------------------------------------"
#2. User wise count
echo "User-wise Process Count:"
echo "-------------------------------------------------------"
awk  -F',' '{print $2}' "IP_FILE" | sort | uniq -c | sort -nr
#3.state wise
echo "State-wise Process Count"
echo "-----------------------------------------------------"
awk -F',' '{print $3}' "IP_FILE" |sort | uniq -c| sort -nr
#4.top user 
echo "Top User(Highest Count) :"
echo "-----------------------------------------------------"
awk  -F',' '{print $2}' "IP_FILE" | sort | uniq -c | sort -nr| head -1
 
#5.states count per User 
echo "===========USER-WISE STATE ANALYSIS=============="

users=$(awk -F',''{print $2}' "IP_FILE" | sort -u)

for user in users;do
	echo "User:$user"
	#awk -v var=value   assigns value to program variable var.
	states=$(awk -F',' -v u="$user" u==$3
