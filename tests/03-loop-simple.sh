#!/bin/bash
#
# Test: Verify 03-loop-simple example runs correctly
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 03-loop-simple example..."

cd "$PROJECT_ROOT"

# Test 1: Default starting value (0)
echo "Testing with default starting value..."
EXPECTED_DEFAULT="3"
ACTUAL_DEFAULT="$(./dirflow.sh examples/03-loop-simple)"

if [ "$ACTUAL_DEFAULT" = "$EXPECTED_DEFAULT" ]; then
    echo "PASS: Default execution output matches expected"
else
    echo "FAIL: Default execution output mismatch"
    echo "Expected: '$EXPECTED_DEFAULT'"
    echo "Actual: '$ACTUAL_DEFAULT'"
    exit 1
fi

# Test 2: Custom starting value
echo "Testing with custom starting value..."
EXPECTED_CUSTOM="13"
ACTUAL_CUSTOM="$(echo "10" | ./dirflow.sh examples/03-loop-simple)"

if [ "$ACTUAL_CUSTOM" = "$EXPECTED_CUSTOM" ]; then
    echo "PASS: Custom input execution output matches expected"
else
    echo "FAIL: Custom input execution output mismatch"
    echo "Expected: '$EXPECTED_CUSTOM'"
    echo "Actual: '$ACTUAL_CUSTOM'"
    exit 1
fi

echo "PASS: All 03-loop-simple tests passed"