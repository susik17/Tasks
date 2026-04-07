#!/bin/bash

echo " dummy app is running with PID $$"
# Simulate some work (infinite loop)
while true; do
    i=$((i+1)) 
    #echo "Working... Iteration $i"
    sleep 10
done