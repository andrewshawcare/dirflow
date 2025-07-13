#!/bin/bash
#
# Test: Verify 04-loop-conditional example sub-workflows run correctly
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 04-loop-conditional example..."

cd "$PROJECT_ROOT"

# Test 1: while loop
echo "Testing while loop..."
EXPECTED_WHILE="160"
ACTUAL_WHILE="$(echo "5" | ./dirflow.sh examples/04-loop-conditional/while)"

if [ "$ACTUAL_WHILE" = "$EXPECTED_WHILE" ]; then
    echo "PASS: While loop output matches expected"
else
    echo "FAIL: While loop output mismatch"
    echo "Expected: '$EXPECTED_WHILE'"
    echo "Actual: '$ACTUAL_WHILE'"
    exit 1
fi

# Test 2: until loop
echo "Testing until loop..."
EXPECTED_UNTIL="10"
ACTUAL_UNTIL="$(echo "3" | ./dirflow.sh examples/04-loop-conditional/until)"

if [ "$ACTUAL_UNTIL" = "$EXPECTED_UNTIL" ]; then
    echo "PASS: Until loop output matches expected"
else
    echo "FAIL: Until loop output mismatch"
    echo "Expected: '$EXPECTED_UNTIL'"
    echo "Actual: '$ACTUAL_UNTIL'"
    exit 1
fi

# Test 3: do-while loop
echo "Testing do-while loop..."
EXPECTED_DO_WHILE="0"
ACTUAL_DO_WHILE="$(echo "8" | ./dirflow.sh examples/04-loop-conditional/do-while)"

if [ "$ACTUAL_DO_WHILE" = "$EXPECTED_DO_WHILE" ]; then
    echo "PASS: Do-while loop output matches expected"
else
    echo "FAIL: Do-while loop output mismatch"
    echo "Expected: '$EXPECTED_DO_WHILE'"
    echo "Actual: '$ACTUAL_DO_WHILE'"
    exit 1
fi

echo "PASS: All 04-loop-conditional tests passed"