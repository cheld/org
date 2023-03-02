#!/bin/bash
cd "$(dirname "$0")"/..

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Variable GITHUB_TOKEN not set"
    exit 1
fi
ORG=${1:-"test-user-org"} 

ramtmp="$(mktemp -p /dev/shm/)"
echo $GITHUB_TOKEN > $ramtmp

#./scripts/lint_org.sh
# if [ $? -eq 1 ]; then
#    exit 1
# fi

peribolos --github-token-path $ramtmp --config-path org.yaml -fix-org -fix-org-members -fix-repos -fix-teams -allow-repo-publish -allow-repo-archival -min-admins 2 --confirm 