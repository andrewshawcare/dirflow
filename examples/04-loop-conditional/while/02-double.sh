#!/bin/bash

# Double the input number
while read -r num; do
    if [ -n "$num" ] && [ "$num" -eq "$num" ] 2>/dev/null; then
        echo $((num * 2))
    else
        echo "$num"
    fi
done