#!/bin/bash
#
# Test: Verify 09-debugging example workflows run correctly
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 09-debugging example..."

cd "$PROJECT_ROOT"

# Test 1: basic debugging workflow
echo "Testing basic debugging workflow..."
EXPECTED_BASIC="Processing: test -> processed -> completed"
ACTUAL_BASIC="$(echo "test" | ./dirflow.sh examples/09-debugging/basic)"

if [ "$ACTUAL_BASIC" = "$EXPECTED_BASIC" ]; then
    echo "PASS: Basic debugging workflow output matches expected"
else
    echo "FAIL: Basic debugging workflow output mismatch"
    echo "Expected: '$EXPECTED_BASIC'"
    echo "Actual: '$ACTUAL_BASIC'"
    exit 1
fi

# Test 2: advanced debugging workflow
echo "Testing advanced debugging workflow..."
EXPECTED_ADVANCED="Text data: test | uppercase"
ACTUAL_ADVANCED="$(echo "test" | ./dirflow.sh examples/09-debugging/advanced)"

if [ "$ACTUAL_ADVANCED" = "$EXPECTED_ADVANCED" ]; then
    echo "PASS: Advanced debugging workflow output matches expected"
else
    echo "FAIL: Advanced debugging workflow output mismatch"
    echo "Expected: '$EXPECTED_ADVANCED'"
    echo "Actual: '$ACTUAL_ADVANCED'"
    exit 1
fi

echo "PASS: All 09-debugging tests passed"