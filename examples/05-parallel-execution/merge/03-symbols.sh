#!/bin/bash

# Generate symbols based on input
input=$(cat)
echo "!-${input}"
echo "@-${input}"
echo "#-${input}"