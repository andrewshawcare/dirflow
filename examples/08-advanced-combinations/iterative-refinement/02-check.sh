#!/bin/bash

# Check current quality and potentially increment
input=$(cat)
current_score=$(echo "$input" | grep -o '[0-9]\+' | tail -1)

if [ -z "$current_score" ]; then
    current_score=5
fi

# Increment score by 15-25 each iteration
increment=$((15 + RANDOM % 11))
new_score=$((current_score + increment))

# Output just the score for loop condition
echo "$new_score"