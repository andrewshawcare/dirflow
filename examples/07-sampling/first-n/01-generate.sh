#!/bin/bash

# Pass through data for first-n sampling
input=$(cat)
echo "First-n sampling activated"
echo "Input data:"
echo "$input"
line_count=$(echo "$input" | wc -l)
printf "Line count:%9s\n" "$line_count"