# 1. Basic
dig domain.com

# 2. Trace full path
dig domain.com +trace

# 3. Check specific DNS
dig domain.com @8.8.8.8

# 4. Compare multiple => based on geolocation -ip change 
dig domain.com @1.1.1.1

# 5. Check cache
systemd-resolve --statistics

# 6. Packet level
tcpdump -i any port 53