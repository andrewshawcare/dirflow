#!/bin/bash

# Clean input data: remove empty lines and trim whitespace
while IFS= read -r line || [ -n "$line" ]; do
    # Trim leading and trailing whitespace
    trimmed=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    # Only output non-empty lines
    if [ -n "$trimmed" ]; then
        echo "$trimmed"
    fi
done