#!/bin/bash

read -p "Enter IP/CIDR: " input

# -------- VALIDATION --------eg:192.168.1.1/23
# 1. Input validate
if [[ ! $input =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]; then
    echo "Invalid format"
    exit 1
fi

ip=${input%/*}
cidr=${input#*/}
# 2.validate cidr
if (( cidr < 0 || cidr > 32 )); then
    echo "Invalid CIDR"
    exit 1
fi

#IFS → tells shell how to split a string => default -> space, tab, newline
IFS='.' read -r o1 o2 o3 o4 <<< "$ip"

#3. validate ip 
for o in $o1 $o2 $o3 $o4; do
    if (( o < 0 || o > 255 )); then
        echo "Invalid IP"
        exit 1
    fi
done

# -------- FIND CHANGING OCTET --------
if (( cidr <= 8 )); then
    idx=1; bits=$cidr; max=255
elif (( cidr <= 16 )); then
    idx=2; bits=$((cidr-8)); max=255
elif (( cidr <= 24 )); then
    idx=3; bits=$((cidr-16)); max=255
else
    idx=4; bits=$((cidr-24)); max=255
fi

# -------- BLOCK SIZE --------
block=$((2**(8-bits)))

echo "Block size: $block"
echo "All subnet ranges:"

# -------- PRINT ALL RANGES --------
for ((i=0; i<=255; i+=block)); do
    start=$i
    end=$((i + block - 1))

    if (( idx == 3 )); then
        echo "$o1.$o2.$start.0  -  $o1.$o2.$end.255"
    elif (( idx == 4 )); then
        echo "$o1.$o2.$o3.$start  -  $o1.$o2.$o3.$end"
    elif (( idx == 2 )); then
        echo "$o1.$start.0.0  -  $o1.$end.255.255"
    else
        echo "$start.0.0.0  -  $end.255.255.255"
    fi
done