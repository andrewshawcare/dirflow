#!/bin/bash

# Log errors
echo "✗ ERROR: Processing encountered issues"
echo "✗ Results logged for investigation"
while read -r line; do
    echo "✗ $line"
done