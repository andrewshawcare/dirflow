#!/bin/bash

# Transformation script
input=$(cat)

if [[ "$input" == *"number"* ]]; then
    echo "$input | squared"
else
    echo "$input | uppercase"
fi