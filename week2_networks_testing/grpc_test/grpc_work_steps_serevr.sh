# 1.create -> server -> ec2 -> ssh -> one machine  2.client -> another machine
#!/bin/bash

echo "===== STEP 1: Install Node.js ====="
# gRPC server run => runtime need
sudo apt update -y
sudo apt install -y nodejs npm

echo "===== STEP 2: Create project ====="
# for clean workspace create 
mkdir -p ~/grpc-demo
cd ~/grpc-demo
npm init -y

echo "===== STEP 3: Install gRPC libs ====="
# gRPC server build => required packages
npm install @grpc/grpc-js @grpc/proto-loader

echo "===== STEP 4: Create proto file ====="
# client-server contract => defines grpc behaviour 
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

echo "===== STEP 5: Create server ====="
cat <<EOF > server.js
const grpc = require("@grpc/grpc-js");
const protoLoader = require("@grpc/proto-loader");

const pkg = protoLoader.loadSync("hello.proto");
const grpcObj = grpc.loadPackageDefinition(pkg);

const server = new grpc.Server();

server.addService(grpcObj.HelloService.service, {
  SayHello: (call, callback) => {
    console.log("Request:", call.request);
    callback(null, { message: "Hello " + call.request.name });
  }
});

server.bindAsync("0.0.0.0:50051",
  grpc.ServerCredentials.createInsecure(),
  () => {
    console.log("gRPC Server running on port 50051");
    server.start();
  }
);
EOF

echo "===== STEP 6: Start server ====="
node server.js