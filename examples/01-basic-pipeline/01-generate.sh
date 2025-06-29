#!/bin/bash

# Generate sample data - numbers 1 through 10
# If input is provided, use it as the upper limit
input=$(cat)
if [ -n "$input" ] && [ "$input" -gt 0 ] 2>/dev/null; then
    seq 1 "$input"
else
    seq 1 10
fi