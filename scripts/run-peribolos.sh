#!/bin/bash

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Github token not set"
else 
    echo "Github token set"
fi