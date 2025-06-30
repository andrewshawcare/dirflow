#!/bin/bash

while read -r num; do
    if [ -n "$num" ] && [ "$num" -eq "$num" ] 2>/dev/null; then
        echo "$num $((num * num))"
    fi
done