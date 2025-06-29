#!/bin/bash

# Read input data or generate starting value
input=$(cat)

if [ -n "$input" ]; then
    # Use provided input
    echo "$input"
else
    # Generate starting value of 0
    echo "0"
fi