# ARP => IP -> MAC
#----------------------------------------
# default gateway -> same network 
ip route
#192.168.1.1
ping 192.168.1.1 
ip neigh #or arp -a 

#NAT => Public ip <-> private ip 
#----------------------------------------
curl ifconfig.me #public ip 
ip a #private ip 


#UDP => tcpdump => specifies udp 
#------------------------------------------
sudo tcpdump -i lo -n udp port 9999 -vv

#BGP => decides which path is short 
#-------------------------------------------
traceroute google.com  # inbetween hops
curl ipinfo.io  #shows ISP/ASN 





