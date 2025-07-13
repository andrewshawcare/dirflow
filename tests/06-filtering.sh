#!/bin/bash
#
# Test: Verify 06-filtering example workflows run and produce expected output
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 06-filtering workflows..."

cd "$PROJECT_ROOT"

# Test 1: valid-data workflow
echo "Testing valid-data workflow..."
EXPECTED_VALID="Processed: 123 -> 246
Processed: 456 -> 912
Processed: 789 -> 1578
Processed: 42 -> 84"
ACTUAL_VALID="$(./dirflow.sh examples/06-filtering/filter/valid-data)"

if [ "$ACTUAL_VALID" = "$EXPECTED_VALID" ]; then
    echo "PASS: Valid-data workflow output matches expected"
else
    echo "FAIL: Valid-data workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_VALID"
    echo "Actual:"
    echo "$ACTUAL_VALID"
    exit 1
fi

# Test 2: number-workflow
echo "Testing number-workflow..."
EXPECTED_NUMBER="Positive 15 squared = 225
Positive 42 squared = 1764
Positive 7 squared = 49
Positive 100 squared = 10000"
ACTUAL_NUMBER="$(./dirflow.sh examples/06-filtering/conditional/number-workflow)"

if [ "$ACTUAL_NUMBER" = "$EXPECTED_NUMBER" ]; then
    echo "PASS: Number-workflow output matches expected"
else
    echo "FAIL: Number-workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_NUMBER"
    echo "Actual:"
    echo "$ACTUAL_NUMBER"
    exit 1
fi

# Test 3: text-workflow
echo "Testing text-workflow..."
EXPECTED_TEXT="Converted to lowercase: hello world
Converted to lowercase: this is sample text
Converted to lowercase: with mixed case letters
Converted to lowercase: for demonstration purposes"
ACTUAL_TEXT="$(./dirflow.sh examples/06-filtering/conditional/text-workflow)"

if [ "$ACTUAL_TEXT" = "$EXPECTED_TEXT" ]; then
    echo "PASS: Text-workflow output matches expected"
else
    echo "FAIL: Text-workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_TEXT"
    echo "Actual:"
    echo "$ACTUAL_TEXT"
    exit 1
fi

# Test 4: skip-empty-workflow
echo "Testing skip-empty-workflow..."
EXPECTED_SKIP="Non-empty content detected: 'First line of content

Second line after empty


Third line after multiple empties
Final line'"
ACTUAL_SKIP="$(./dirflow.sh examples/06-filtering/filter/skip-empty-workflow)"

if [ "$ACTUAL_SKIP" = "$EXPECTED_SKIP" ]; then
    echo "PASS: Skip-empty-workflow output matches expected"
else
    echo "FAIL: Skip-empty-workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_SKIP"
    echo "Actual:"
    echo "$ACTUAL_SKIP"
    exit 1
fi

echo "PASS: All 06-filtering workflows tests passed"