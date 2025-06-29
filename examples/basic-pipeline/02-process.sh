#!/bin/bash
# Sort and double each number
sort -n | awk '{print $1 * 2}'