#!/bin/bash

echo "=======================User with maximum processes======================="
echo "===User============Total Processes===========Highest State==========="
grep total process_log.txt | awk '{print $1,$2,$8}' | sort -k2 -t= -nr | head -n 1