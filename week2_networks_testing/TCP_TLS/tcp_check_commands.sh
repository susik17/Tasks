# step 1 => server start 
nc -l 8080 #port 8080 listen

# step 2 => Packet capture
sudo tcpdump -i any port 8080 -nn #handshake show  -nn => no name resolution
# -i => any interface => eth0 (LAN),lo (localhost),wlan0 (wifi) port=> any source/destination

#step 3 => client connect 
nc localhost 8080 

# S => SYN(client) S. => SYN+ACK (server) . => ACK (client) <=>  TCP connection establish
