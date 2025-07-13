#!/bin/bash
#
# Test: Data Processing Generator Creation
# Verifies that 01-generate.sh exists and creates sample text data
#

set -e

# Test file path
GENERATOR_FILE="/Users/andrew/dirflow/examples/02-data-processing/01-generate.sh"

echo "Testing data processing generator creation..."

# Test 1: File should exist
if [ ! -f "$GENERATOR_FILE" ]; then
    echo "FAIL: Generator file does not exist at $GENERATOR_FILE"
    exit 1
fi

# Test 2: File should be executable
if [ ! -x "$GENERATOR_FILE" ]; then
    echo "FAIL: Generator file is not executable"
    exit 1
fi

# Test 3: Should produce output when run
OUTPUT=$("$GENERATOR_FILE")
if [ -z "$OUTPUT" ]; then
    echo "FAIL: Generator produces no output"
    exit 1
fi

# Test 4: Output should contain varied text (at least some words)
WORD_COUNT=$(echo "$OUTPUT" | wc -w)
if [ "$WORD_COUNT" -lt 5 ]; then
    echo "FAIL: Generator output too short (less than 5 words)"
    exit 1
fi

echo "PASS: Data processing generator working correctly"
echo "Generated $WORD_COUNT words of sample text"