#!/bin/bash

read -p "Enter domain: " domain

# -------- BASIC DOMAIN VALIDATION --------
if [[ ! $domain =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Invalid domain format"
    exit 1
fi

# -------- DNS LOOKUP --------
ips=$(getent ahosts "$domain" | awk '{print $1}' | sort -u)

if [[ -z "$ips" ]]; then
    echo "DNS resolution failed"
    exit 1
fi

echo "Resolved IPs:"
echo "$ips"
echo "----------------------"

# -------- VALIDATION --------

for ip in $ips; do

    # IPv4 check
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        
        valid=true
        IFS='.' read -r a b c d <<< "$ip"

        for o in $a $b $c $d; do
            if (( o < 0 || o > 255 )); then
                valid=false
            fi
        done

        if $valid; then
            echo "Valid IPv4 : $ip"
        else
            echo "Invalid IPv4 : $ip"
        fi

    # IPv6 check (simple)
    elif [[ $ip =~ : ]]; then
        echo "IPv6 detected : $ip"

    else
        echo "Unknown format : $ip"
    fi

done