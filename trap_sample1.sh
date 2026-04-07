#!/bin/bash


#cleanup function
cleanup(){
    echo "cleaning temporary files..."
    rm -f /tmp/my_temp_file1 /tmp/my_temp_file2
    echo "temporary files removed"
    echo "cleanup done"
}

#trap the EXIT signal to call cleanup function
#Exit -> script ends in any way (normal exit, error, Ctrl+C) call this(cleanup) function 

trap cleanup EXIT

#main script logic
echo "This trap_sample1.sh script is running..."
echo "Creating a temporary file..."
touch /tmp/my_temp_file1 /tmp/my_temp_file2
echo "Temporary files 1&2 created successfully"


sleep 20

echo "Work done!"