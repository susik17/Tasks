#!/bin/bash 

echo "Enter a number:"
read NUMBER
if [ $NUMBER -gt 0 ]; then
    echo "The number is positive."
elif [ $NUMBER -lt 0 ]; then
    echo "The number is negative."
else
    echo "The number is zero."
fi

# -lt => less than
# -gt => greater than
# -eq => equal to
# -ne => not equal to
# -le => less than or equal to
# -ge => greater than or equal to
# -z => string is empty
# -n => string is not empty
# && => logical AND
# || => logical OR
# ! => logical NOT
# [ ] => test command
# (( )) => arithmetic evaluation
# [[ ]] => extended test command
#============================================================================================
# if [ condition ]; then
#     # code to execute if condition is true
# elif [ condition ]; then
#     # code to execute if condition is true
# else
#     # code to execute if all conditions are false
# fi
#============================================================================================
# -file / -f=> check if file exists and is a regular file
# -d => check if directory exists
# -e => check if file or directory exists
# -r => check if file is readable
# -w => check if file is writable
# -x => check if file is executable     
# -s => check if file is not empty
# -L => check if file is a symbolic link
