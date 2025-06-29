#!/bin/bash

# Count word frequency and sort by most common
echo "Word frequency analysis:"

# Split into words, count, and sort by frequency
tr ' ' '\n' | grep -v '^$' | sort | uniq -c | sort -rn | while read -r count word; do
    echo "$word: $count"
done