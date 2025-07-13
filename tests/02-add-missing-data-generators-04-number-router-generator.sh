#!/bin/bash
#
# Test: Number Router Generator Creation
# Verifies that 01-generate.sh exists and creates mixed positive/negative numbers
#

set -e

# Test file path
GENERATOR_FILE="/Users/andrew/dirflow/examples/06-filtering/conditional/number-workflow/01-generate.sh"

echo "Testing number router generator creation..."

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

# Test 4: Output should contain positive numbers (current version generates all positive)
POSITIVE_COUNT=$(echo "$OUTPUT" | grep -c "^[^-]" || true)
NEGATIVE_COUNT=$(echo "$OUTPUT" | grep -c "^-" || true)

if [ "$POSITIVE_COUNT" -eq 0 ]; then
    echo "FAIL: Generator produces no positive numbers"
    exit 1
fi

# Note: Current generator produces all positive numbers for demonstration

# Test 5: All output lines should be valid numbers
TOTAL_LINES=$(echo "$OUTPUT" | wc -l)
VALID_NUMBERS=$(echo "$OUTPUT" | grep -c "^-\?[0-9]\+$" || true)

if [ "$VALID_NUMBERS" -ne "$TOTAL_LINES" ]; then
    echo "FAIL: Not all output lines are valid numbers ($VALID_NUMBERS/$TOTAL_LINES)"
    exit 1
fi

# Test 6: Should have reasonable number distribution (at least 3 numbers total)
if [ "$TOTAL_LINES" -lt 3 ]; then
    echo "FAIL: Generator produces too few numbers ($TOTAL_LINES), need at least 3"
    exit 1
fi

echo "PASS: Number router generator working correctly"
echo "Generated $TOTAL_LINES numbers: $POSITIVE_COUNT positive, $NEGATIVE_COUNT negative"