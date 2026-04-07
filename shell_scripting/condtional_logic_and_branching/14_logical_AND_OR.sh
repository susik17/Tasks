# && -> 1st one success only then execute the 2nd one
# || -> 1st one fail/success then execute the 2nd one

#!/bin/bash
read -p "Enter a number: " num
if [ $num -gt 0 ] && [ $num -lt 100 ]; then
    echo "Number is between 1 and 99"
else
    echo "Number is out of range"
fi

read -p "Enter a number: " num
if [ $num -lt 0 ] || [ $num -gt 100 ]; then
    echo "Number is out of range"
else
    echo "Number is between 0 and 100"
fi


# mkdir /tmp/backup && cd /tmp/backup
# ping google.com || echo "Internet Connection Failed"

