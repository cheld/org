#!/bin/bash
cd "$(dirname "$0")"/..

echo "run tests"

# No approved members. Must fail
echo "Run tests with no approved members..."
result=`./scripts/lint_org.sh ./tests/test-org.yaml ./tests/test-members-empty.yaml ./tests/test-repos-ok.yaml`
 if [ $? -eq 0 ]; then
    echo $result
    echo "Test with no approved members should have failed"
    exit 1
 fi

# No approved repos. Must fail
echo "Run tests with no approved repos..."
result=`./scripts/lint_org.sh ./tests/test-org.yaml ./tests/test-members-ok.yaml ./tests/test-repos-empty.yaml`
 if [ $? -eq 0 ]; then
    echo $result
    echo "Test with no approved repos should have failed"
    exit 1
 fi

# Org configuration matches approved members and repos. Must pass
echo "Run tests with approved members and approved repos..."
result=`./scripts/lint_org.sh ./tests/test-org.yaml ./tests/test-members-ok.yaml ./tests/test-repos-ok.yaml`
 if [ $? -eq 1 ]; then
    echo $result
    echo "Test with approved members and approved reposshould have passed"
    exit 1
 fi

 echo "All tests passed."
