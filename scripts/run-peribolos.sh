#!/bin/bash

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Variable GITHUB_TOKEN not set"
    exit 1
fi
ORG="test-user-org"

ramtmp="$(mktemp -p /dev/shm/)"
echo $GITHUB_TOKEN > $ramtmp

peribolos --dump $ORG --github-token-path $ramtmp | tee ~/current.yaml