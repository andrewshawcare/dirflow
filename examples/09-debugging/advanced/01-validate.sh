#!/bin/bash

# Validation script with complex processing
input=$(cat)

if [[ "$input" =~ ^[0-9]+$ ]]; then
    echo "Valid number: $input"
else
    echo "Text data: $input"
fi