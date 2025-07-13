#!/bin/bash

# Normalize text: convert to lowercase and remove punctuation
while IFS= read -r line; do
    # Convert to lowercase and remove punctuation, then split into words
    echo "$line" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | tr -s ' '
done