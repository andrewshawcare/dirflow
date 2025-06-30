#!/bin/bash

input=$(cat)

if [ -n "$input" ] && [ "$input" -gt 0 ] 2>/dev/null; then
    seq 1 "$input"
else
    seq 1 10
fi