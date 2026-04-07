#!/bin/bash

echo "===== ENTER EC2 IP ====="
read -p "Enter EC2 Public IP: " EC2_IP

echo "===== STEP 1: Check IP reachable ====="
ping -c 2 $EC2_IP

echo "===== STEP 2: Check port open ====="
telnet $EC2_IP 50051

echo "===== STEP 3: Create proto ====="
cat <<EOF > hello.proto
syntax = "proto3";

service HelloService {
  rpc SayHello (HelloRequest) returns (HelloResponse);
}

message HelloRequest {
  string name = 1;
}

message HelloResponse {
  string message = 1;
}
EOF

echo "===== STEP 4: Install grpcurl (if not installed) ====="
command -v grpcurl >/dev/null 2>&1 || {
  echo "Installing grpcurl..."
  wget -q https://github.com/fullstorydev/grpcurl/releases/latest/download/grpcurl_linux_x86_64.tar.gz
  tar -xvf grpcurl_linux_x86_64.tar.gz
  sudo mv grpcurl /usr/local/bin/
}

echo "===== STEP 5: Actual gRPC call ====="
grpcurl -plaintext -proto hello.proto \
-d '{"name":"Susi"}' \
$EC2_IP:50051 \
HelloService/SayHello

echo "===== STEP 6: Debug mode ====="
grpcurl -v -plaintext -proto hello.proto \
-d '{"name":"Debug"}' \
$EC2_IP:50051 \
HelloService/SayHello