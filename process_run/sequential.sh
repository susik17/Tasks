#!/bin/bash 
# Sequential execution of tasks -> one by one -> one waits for the previous to finish
echo "----------------------------------------------------------"
echo "Script pid : $$"
echo "Start Time $(date +%T)"
echo "Task 1 starting..."
sleep 3
echo "Task 1 Done"
echo "Task 2 starting..."
sleep 3
echo "Task 2 Done"
echo "Task 3 starting..."
sleep 3
echo "Task 3 Done"
echo "End Time: $(date +%T)"
echo "-----------------------------------------------------------"
