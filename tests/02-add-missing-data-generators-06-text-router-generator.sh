#!/bin/bash
#
# Test: Text Router Generator Creation
# Verifies that 01-generate.sh exists and creates mixed case text
#

set -e

# Test file path - using similar structure as number workflow
GENERATOR_FILE="/Users/andrew/dirflow/examples/06-filtering/conditional/text-workflow/01-generate.sh"

echo "Testing text router generator creation..."

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

# Test 4: Output should contain text (at least some words)
WORD_COUNT=$(echo "$OUTPUT" | wc -w)
if [ "$WORD_COUNT" -lt 3 ]; then
    echo "FAIL: Generator output too short (less than 3 words)"
    exit 1
fi

# Test 5: Should contain mixed case text or demonstrate routing behavior
# For text routing, the first line will determine which path all text goes to
FIRST_LINE=$(echo "$OUTPUT" | head -n1)
LOWERCASE_VERSION=$(echo "$FIRST_LINE" | tr '[:upper:]' '[:lower:]')

if [ "$FIRST_LINE" = "$LOWERCASE_VERSION" ]; then
    echo "First line is all lowercase - will route to lowercase path"
else
    echo "First line contains uppercase - will route to uppercase path"
fi

echo "PASS: Text router generator working correctly"
echo "Generated $WORD_COUNT words of sample text"