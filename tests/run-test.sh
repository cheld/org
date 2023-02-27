#!/bin/bash
cd "$(dirname "$0")"/..

# No approved members. Must fail
./scripts/lint_org.sh ./tests/test-org.yaml ./tests/test-members-empty.yaml ./tests/test-repos-ok.yaml
 if [ $? -eq 0 ]; then
    echo "Test without approved members should have failed"
    exit 1
 fi

# No approved repos. Must fail
./scripts/lint_org.sh ./tests/test-org.yaml ./tests/test-members-ok.yaml ./tests/test-repos-empty.yaml
 if [ $? -eq 0 ]; then
    echo "Test without approved repos should have failed"
    exit 1
 fi

# Org configuration matches approved members and repos. Must pass
./scripts/lint_org.sh ./tests/test-org.yaml ./tests/test-members-ok.yaml ./tests/test-repos-ok.yaml
 if [ $? -eq 1 ]; then
    echo "Test should have passed"
    exit 1
 fi

 echo "All tests passed."
