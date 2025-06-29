#!/bin/bash

# Load and prepare input data
input=$(cat)
echo "Loaded data: $input"
echo "Metadata: $(date) - size: ${#input} chars"