#!/bin/bash
#
# Test: Verify 05-parallel-execution example workflows run correctly
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 05-parallel-execution example..."

cd "$PROJECT_ROOT"

# Test 1: concatenate workflow
echo "Testing concatenate workflow..."
EXPECTED_CONCATENATE="Fast: Processing 'test'
Fast: Result ready!
Medium: Processing 'test'
Medium: Result after brief delay
Slow: Processing 'test'
Slow: Result after longer delay"
ACTUAL_CONCATENATE="$(echo "test" | ./dirflow.sh examples/05-parallel-execution/concatenate)"

if [ "$ACTUAL_CONCATENATE" = "$EXPECTED_CONCATENATE" ]; then
    echo "PASS: Concatenate workflow output matches expected"
else
    echo "FAIL: Concatenate workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_CONCATENATE"
    echo "Actual:"
    echo "$ACTUAL_CONCATENATE"
    exit 1
fi

# Test 2: merge workflow
echo "Testing merge workflow..."
EXPECTED_MERGE="A-test
1-test
!-test
B-test
2-test
@-test
C-test
3-test
#-test"
ACTUAL_MERGE="$(echo "test" | ./dirflow.sh examples/05-parallel-execution/merge)"

if [ "$ACTUAL_MERGE" = "$EXPECTED_MERGE" ]; then
    echo "PASS: Merge workflow output matches expected"
else
    echo "FAIL: Merge workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_MERGE"
    echo "Actual:"
    echo "$ACTUAL_MERGE"
    exit 1
fi

# Test 3: first-last workflow
echo "Testing first-last workflow..."
EXPECTED_FIRST_LAST="Gamma: Last processor handling 'Alpha: First processor handling 'test'
Alpha: This output will be used'
Gamma: This output will be used"
ACTUAL_FIRST_LAST="$(echo "test" | ./dirflow.sh examples/05-parallel-execution/first-last)"

if [ "$ACTUAL_FIRST_LAST" = "$EXPECTED_FIRST_LAST" ]; then
    echo "PASS: First-last workflow output matches expected"
else
    echo "FAIL: First-last workflow output mismatch"
    echo "Expected:"
    echo "$EXPECTED_FIRST_LAST"
    echo "Actual:"
    echo "$ACTUAL_FIRST_LAST"
    exit 1
fi

echo "PASS: All 05-parallel-execution tests passed"