#!/bin/bash
cd "$(dirname "$0")"/..

if [ "$1" != "--confirm" ]; then
    echo "In most cases this script is not required to be executed. Exiting..."
    exit 1
fi
ORG=${2:-"test-user-org"} 

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Variable GITHUB_TOKEN not set"
    exit 1
fi

echo "Dumping current Github state to org.yaml..."
ramtmp="$(mktemp -p /dev/shm/)"
echo $GITHUB_TOKEN > $ramtmp

peribolos --github-token-path $ramtmp --dump $ORG --dump-full | tee org.yaml
