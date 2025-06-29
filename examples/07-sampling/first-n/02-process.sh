#!/bin/bash

# Process data that met the first-n criteria
echo "=== FIRST-N CRITERIA MET ==="
while read -r line; do
    echo "Processing: $line"
done
echo "=== PROCESSING COMPLETE ==="