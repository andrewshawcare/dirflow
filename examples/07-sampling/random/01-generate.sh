#!/bin/bash

# Generate or pass through test data
input=$(cat)
if [ -n "$input" ]; then
    echo "Input: $input"
    echo "Timestamp: $(date)"
    echo "Random value: $RANDOM"
else
    echo "Generated data"
    echo "Timestamp: $(date)"
    echo "Random value: $RANDOM"
fi