#!/bin/bash

# Generate data in parallel with other processors
input=$(cat)
echo "Generator: Processing '$input'"
echo "Generator: Added timestamp $(date +%s)"