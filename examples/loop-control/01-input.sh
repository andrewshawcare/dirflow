#!/bin/bash
input=$(cat)
if [ -z "$input" ]; then
    echo 1
else
    echo "$input"
fi
