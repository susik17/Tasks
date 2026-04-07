
#!/bin/bash
echo "---------------------------------"
echo "Script PID: $$"
echo "Start Time: $(date +%T)"


#every Task -> background run -> one doesn't wait for the previous to finish -> all run in parallel
# Task 1 
( echo "Task 1 Starting..."; sleep 3; echo "Task 1 Done" ) &

# Task 2
( echo "Task 2 Starting..."; sleep 3; echo "Task 2 Done" ) &

# Task 3
( echo "Task 3 Starting..."; sleep 3; echo "Task 3 Done" ) &

wait # wait until all process runs 

echo "End Time: $(date +%T)"
echo "---------------------------------"
