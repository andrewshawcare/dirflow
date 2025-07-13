#!/bin/bash

# Count characters in the content
while read -r line; do
    if [[ "$line" =~ ^Non-empty.*\'(.*)\'$ ]]; then
        content="${BASH_REMATCH[1]}"
        count=${#content}
        echo "Character count: $count characters in '$content'"
    else
        echo "$line"
    fi
done