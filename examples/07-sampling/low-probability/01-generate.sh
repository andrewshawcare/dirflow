#!/bin/bash

# Generate test data for low-probability sampling
input=$(cat)
echo "Low-probability sample triggered!"
echo "Input: ${input:-none}"
echo "Lucky run: $(date)"