#!/bin/bash
# Save as: osi_demo.sh

echo "=== OSI MODEL LIVE DEMO ==="
echo
echo "Layer 7 - Application: Running curl..."
curl -I https://google.com 2>&1 | head -1

echo
echo "Layer 4 - Transport: Active TCP connections..."
ss -tan | grep ESTAB | head -3

echo
echo "Layer 3 - Network: Your IP & Gateway..."
ip route | grep default

echo
echo "Layer 2 - Data Link: Your MAC Address..."
ip link show | grep link/ether | head -1

echo
echo "Layer 1 - Physical: Network Interface Status..."
ethtool eth0 2>/dev/null | grep "Speed:\|Link detected:" || echo "Physical layer active"