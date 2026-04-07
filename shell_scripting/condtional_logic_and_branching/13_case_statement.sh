#!/bin/bash 

echo "1. start server"
echo "2. stop server"
echo "3. Exit "
read -p "Enter your choice: " choice

case $choice in 
    1)
        echo "server starting..."
        #;; -> used to terminate the current case block
        ;;
    2)
        echo "server stopping..."
        ;;
    3)
        echo "Exiting.."
        ;;
    # * -> default case, it will execute if none of the above cases match
    *)
        echo "Invalid choice"
        ;;
esac