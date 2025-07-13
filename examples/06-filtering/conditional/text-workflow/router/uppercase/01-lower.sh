#!/bin/bash

# Convert uppercase text to lowercase
while read -r line; do
    echo "Converted to lowercase: $(echo "$line" | tr '[:upper:]' '[:lower:]')"
done