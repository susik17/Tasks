#!/bin/bash

echo "USER | FILE_COUNT | MAX_FILE_SIZE | FILE_PATH"
echo "------------------------------------------------"


# cut -d: -f1 =>  -d: => delimiter is ":" | -f1 => get the first field (username) from /etc/passwd
for user in $(cut -d: -f1 /etc/passwd)
do
    #find files => created by that user => -type f => only files | 2>/dev/null => suppress error messages(/dev/null => black hole => discard  any comes inside -> cant comeback)
    files=$(find /home -type f -user $user 2>/dev/null)

    count=$(echo "$files" | wc -l)
    max_file=$(find /home -type f -user $user -printf "%s %p\n" 2>/dev/null | sort -nr | head -1)

    size=$(echo $max_file | awk '{print $1}')
    path=$(echo $max_file | cut -d' ' -f2-)

    if [ "$count" -gt 0 ]; then
        echo "$user | $count | $size | $path"
    fi

done

#Max size/path empty → -permission fail or no files for that user