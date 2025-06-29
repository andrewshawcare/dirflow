#!/bin/bash

# Square positive numbers
while read -r num; do
    if [ -n "$num" ] && [ "$num" -eq "$num" ] 2>/dev/null; then
        echo "Positive $num squared = $((num * num))"
    else
        echo "$num"
    fi
done