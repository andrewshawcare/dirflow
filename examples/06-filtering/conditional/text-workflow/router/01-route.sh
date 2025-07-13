#!/bin/bash
#
# Route text based on case - this is handled by .conditional file
# This script just passes through the input for conditional processing
#

while read -r line; do
    echo "$line"
done