#!/bin/bash

# Increment the input number by 1
while read -r num; do
    if [ -n "$num" ] && [ "$num" -eq "$num" ] 2>/dev/null; then
        echo $((num + 1))
    else
        echo "$num"
    fi
done