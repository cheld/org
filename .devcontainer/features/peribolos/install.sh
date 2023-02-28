#!/bin/sh

git clone https://github.com/kubernetes/test-infra.git
cd test-infra
git reset --hard f4414f57345035fbf7c93a734c9e9980eaab9c02

go build -o peribolos ./prow/cmd/peribolos/main.go
cp ./peribolos /usr/local/bin

go build -o proxy ./ghproxy/ghproxy.go
cp ./proxy /usr/local/bin

echo "done"