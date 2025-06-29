#!/bin/bash

# Convert lowercase text to uppercase
while read -r line; do
    echo "Converted to uppercase: $(echo "$line" | tr '[:lower:]' '[:upper:]')"
done