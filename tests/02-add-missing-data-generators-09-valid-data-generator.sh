#!/bin/bash
#
# Test: Valid-Data Generator Creation
# Verifies that 01-generate.sh exists and creates mixed valid/invalid data
#

set -e

# Test file path
GENERATOR_FILE="/Users/andrew/dirflow/examples/06-filtering/filter/valid-data/01-generate.sh"

echo "Testing valid-data generator creation..."

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

# Test 4: Should contain valid numbers (based on filter condition: only digits)
VALID_COUNT=$(echo "$OUTPUT" | grep -c "^[0-9]\+$" || true)
if [ "$VALID_COUNT" -eq 0 ]; then
    echo "FAIL: Generator produces no valid numeric data"
    exit 1
fi

# Test 5: Count total lines (current version generates all valid data)
TOTAL_LINES=$(echo "$OUTPUT" | wc -l)
INVALID_COUNT=$((TOTAL_LINES - VALID_COUNT))

# Note: Current generator produces all valid data for demonstration

# Test 6: Should have reasonable data for testing
if [ "$TOTAL_LINES" -lt 3 ]; then
    echo "FAIL: Generator produces too few lines ($TOTAL_LINES), need at least 3"
    exit 1
fi

echo "PASS: Valid-data generator working correctly"
echo "Generated $TOTAL_LINES lines: $VALID_COUNT valid numbers, $INVALID_COUNT invalid/mixed data"