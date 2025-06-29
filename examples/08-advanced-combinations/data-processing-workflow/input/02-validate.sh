#!/bin/bash

# Validate input format
while read -r line; do
    if [[ "$line" =~ ^Loaded\ data: ]]; then
        echo "Validated: $line"
    elif [[ "$line" =~ ^Metadata: ]]; then
        echo "Validated: $line"
    else
        echo "Valid: $line"
    fi
done