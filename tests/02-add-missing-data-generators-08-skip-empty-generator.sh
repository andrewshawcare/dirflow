#!/bin/bash
#
# Test: Skip-Empty Generator Creation
# Verifies that 01-generate.sh exists and creates data with some empty lines
#

set -e

# Test file path
GENERATOR_FILE="/Users/andrew/dirflow/examples/06-filtering/filter/skip-empty-workflow/01-generate.sh"

echo "Testing skip-empty generator creation..."

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

# Test 4: Should contain both empty and non-empty lines
TOTAL_LINES=$(echo "$OUTPUT" | wc -l)
NON_EMPTY_LINES=$(echo "$OUTPUT" | grep -c "." || true)
EMPTY_LINES=$((TOTAL_LINES - NON_EMPTY_LINES))

if [ "$NON_EMPTY_LINES" -eq 0 ]; then
    echo "FAIL: Generator produces no non-empty lines"
    exit 1
fi

if [ "$EMPTY_LINES" -eq 0 ]; then
    echo "FAIL: Generator produces no empty lines (needed for skip-empty demonstration)"
    exit 1
fi

# Test 5: Should have reasonable distribution
if [ "$TOTAL_LINES" -lt 3 ]; then
    echo "FAIL: Generator produces too few lines ($TOTAL_LINES), need at least 3"
    exit 1
fi

echo "PASS: Skip-empty generator working correctly"
echo "Generated $TOTAL_LINES lines: $NON_EMPTY_LINES non-empty, $EMPTY_LINES empty"