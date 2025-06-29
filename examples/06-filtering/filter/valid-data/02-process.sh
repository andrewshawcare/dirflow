#!/bin/bash

# Process the validated numeric data
while read -r line; do
    if [[ "$line" =~ ^Valid\ number:\ ([0-9]+)$ ]]; then
        num="${BASH_REMATCH[1]}"
        echo "Processed: $num -> $((num * 2))"
    else
        echo "$line"
    fi
done