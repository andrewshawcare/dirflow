#!/bin/bash
#
# Test: Complete Text Routing Functionality
# Verifies the entire text router pipeline works end-to-end
#

set -e

ROUTER_DIR="/Users/andrew/dirflow/examples/06-filtering/conditional/text-workflow"
DIRFLOW_SCRIPT="/Users/andrew/dirflow/dirflow.sh"

echo "Testing complete text routing functionality..."

# Test 1: Pipeline should run without errors
if ! OUTPUT=$("$DIRFLOW_SCRIPT" "$ROUTER_DIR" 2>&1); then
    echo "FAIL: Text router pipeline execution failed"
    echo "Error output: $OUTPUT"
    exit 1
fi

# Test 2: Should produce output
if [ -z "$OUTPUT" ]; then
    echo "FAIL: Text router pipeline produces no output"
    exit 1
fi

# Test 3: Should contain conversion output (either to uppercase or lowercase)
CONVERSION_COUNT=$(echo "$OUTPUT" | grep -c "Converted to" || true)
if [ "$CONVERSION_COUNT" -eq 0 ]; then
    echo "FAIL: Output doesn't contain any text conversion results"
    exit 1
fi

# Test 4: Based on our generator (starts with "Hello WORLD"), should route to uppercase path
if ! echo "$OUTPUT" | grep -q "Converted to lowercase:"; then
    echo "FAIL: Expected uppercase-to-lowercase conversion not found"
    exit 1
fi

# Test 5: Verify specific expected results (based on our generator)
if ! echo "$OUTPUT" | grep -q "Converted to lowercase: hello world"; then
    echo "FAIL: Expected conversion of first line not found"
    exit 1
fi

if ! echo "$OUTPUT" | grep -q "Converted to lowercase: this is sample text"; then
    echo "FAIL: Expected conversion of second line not found"
    exit 1
fi

# Test 6: Should have processed all generated lines
EXPECTED_LINES=4  # We generate 4 lines of text
PROCESSED_LINES=$(echo "$OUTPUT" | grep -c "Converted to lowercase:" || true)

if [ "$PROCESSED_LINES" -ne "$EXPECTED_LINES" ]; then
    echo "FAIL: Expected $EXPECTED_LINES processed lines, but found $PROCESSED_LINES"
    exit 1
fi

echo "PASS: Text routing functionality working correctly"
echo "Processed $PROCESSED_LINES lines of text through uppercase-to-lowercase conversion"