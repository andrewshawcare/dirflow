#!/bin/bash
#
# Test: Verify 01-basic-pipeline example runs correctly
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 01-basic-pipeline example..."

cd "$PROJECT_ROOT"

# Test 1: Self-contained execution (run the pipeline)
echo "Testing self-contained execution..."
EXPECTED_SELF="Number | Square
-------|-------
1      | 1
2      | 4
3      | 9
4      | 16
5      | 25
6      | 36
7      | 49
8      | 64
9      | 81
10     | 100"
ACTUAL_SELF="$(./dirflow.sh examples/01-basic-pipeline)"

if [ "$ACTUAL_SELF" = "$EXPECTED_SELF" ]; then
    echo "PASS: Self-contained execution output matches expected"
else
    echo "FAIL: Self-contained execution output mismatch"
    echo "Expected:"
    echo "$EXPECTED_SELF"
    echo "Actual:"
    echo "$ACTUAL_SELF"
    exit 1
fi

# Test 2: With input
echo "Testing with input..."
EXPECTED_INPUT="Number | Square
-------|-------
1      | 1
2      | 4
3      | 9
4      | 16
5      | 25"
ACTUAL_INPUT="$(echo "5" | ./dirflow.sh examples/01-basic-pipeline)"

if [ "$ACTUAL_INPUT" = "$EXPECTED_INPUT" ]; then
    echo "PASS: Input-dependent execution output matches expected"
else
    echo "FAIL: Input-dependent execution output mismatch"
    echo "Expected:"
    echo "$EXPECTED_INPUT"
    echo "Actual:"
    echo "$ACTUAL_INPUT"
    exit 1
fi

echo "PASS: All 01-basic-pipeline tests passed"