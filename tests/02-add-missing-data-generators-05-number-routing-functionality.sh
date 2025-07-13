#!/bin/bash
#
# Test: Complete Number Routing Functionality
# Verifies the entire number router pipeline works end-to-end
#

set -e

ROUTER_DIR="/Users/andrew/dirflow/examples/06-filtering/conditional/number-workflow"
DIRFLOW_SCRIPT="/Users/andrew/dirflow/dirflow.sh"

echo "Testing complete number routing functionality..."

# Test 1: Pipeline should run without errors
if ! OUTPUT=$("$DIRFLOW_SCRIPT" "$ROUTER_DIR" 2>&1); then
    echo "FAIL: Number router pipeline execution failed"
    echo "Error output: $OUTPUT"
    exit 1
fi

# Test 2: Should produce output
if [ -z "$OUTPUT" ]; then
    echo "FAIL: Number router pipeline produces no output"
    exit 1
fi

# Test 3: Should contain squared positive numbers
SQUARED_COUNT=$(echo "$OUTPUT" | grep -c "squared" || true)
if [ "$SQUARED_COUNT" -eq 0 ]; then
    echo "FAIL: Output doesn't contain any squared positive numbers"
    exit 1
fi

# Test 4: Should process positive numbers (current generator produces all positive)
POSITIVE_PROCESSED=$(echo "$OUTPUT" | grep -c "Positive.*squared" || true)

if [ "$POSITIVE_PROCESSED" -eq 0 ]; then
    echo "FAIL: No positive numbers were processed through positive path"
    exit 1
fi

# Test 5: Verify all numbers were processed as positive (based on current generator)
EXPECTED_COUNT=4  # We generate 4 positive numbers
if [ "$POSITIVE_PROCESSED" -ne "$EXPECTED_COUNT" ]; then
    echo "FAIL: Expected $EXPECTED_COUNT positive numbers, but processed $POSITIVE_PROCESSED"
    exit 1
fi

# Test 6: Verify expected results (all positive numbers based on our generator)
if ! echo "$OUTPUT" | grep -q "Positive 15 squared = 225"; then
    echo "FAIL: Expected positive number processing result not found"
    exit 1
fi

if ! echo "$OUTPUT" | grep -q "Positive 42 squared = 1764"; then
    echo "FAIL: Expected second positive number processing result not found"
    exit 1
fi

echo "PASS: Number routing functionality working correctly"
echo "Processed $POSITIVE_PROCESSED positive numbers (squared) as expected"