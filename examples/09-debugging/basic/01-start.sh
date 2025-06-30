#!/bin/bash

# Starting script - generates initial data
input=$(cat)

if [ -n "$input" ]; then
    echo "Processing: $input"
else
    echo "Starting with: initial-data"
fi