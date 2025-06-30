#!/bin/bash

echo "Number | Square"
echo "-------|-------"
while read -r num square; do
    if [ -n "$num" ] && [ -n "$square" ]; then
        printf "%-6s | %s\n" "$num" "$square"
    fi
done