#!/bin/bash

# Pass through data for first-n sampling
input=$(cat)
echo "First-n sampling activated"
echo "Input data:"
echo "$input"
echo "Line count: $(echo "$input" | wc -l)"