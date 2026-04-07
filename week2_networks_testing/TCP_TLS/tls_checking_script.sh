
# openssl s_client .. => TCP connection establish + clientHEllo send-TLS handshake start
# openssl s_server ..=> decision point => accept/deny connection => based on version,cipher,heve certificate

# Generate Self-signed certificate
#2048 - key size => bits
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes

#key.pem -> key cert.pem -> certificate
#2.TLS server start on port 8443
openssl s_server -key key.pem -cert cert.pem -accept 8443 #simple TLS server 

#TLS Client connect 
openssl s_client -connect localhost:8443 

#FLOW : TCP connect -> TLS clientHello send -> SeverHello receive -> Certificate verify(self-signed => warning) -> TLS establish
#SUCCESS => OP: SSL-Session: Protocol: TLSv1.3 

#DENY => 1.TLS version deny 2.cipher mismatch 3.certificate reject(client side) 4.port open but no TLS
 
#1.TLS version deny
openssl s_server -accept 8443 -tls1_2 -cert cert.pem -key key.pem
openssl s_client -connect localhost:8443 -tls1_3 
#Result => HAndshake failure
#2.cipher mismatch 
openssl s_server -accept 8443 -cipher AES128-SHA -cert cert.pem -key key.pem
openssl s_client -connect localhost:8443 -cipher ECDHE-RSA-AES256-GCM-SHA384
#Result => no shared cipher
#3.No TLS server(only TCP)
nc -l 8443 #server
openssl s_client -connect localhost:8443
#Result => wrong version num
#4.Deny from client => strict verify 
openssl s_server -accept 8443 -cert cert.pem -key key.pem
openssl s_client -connect localhost:8443 -verify_return_error