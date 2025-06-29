#!/bin/bash

# Get absolute value of negative numbers
while read -r num; do
    if [ -n "$num" ] && [ "$num" -eq "$num" ] 2>/dev/null; then
        abs_num=$((num < 0 ? -num : num))
        echo "Negative $num absolute value = $abs_num"
    else
        echo "$num"
    fi
done