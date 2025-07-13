#!/bin/bash
#
# Test Runner for TDD Implementation
# Runs all test scripts in lexicographic order (dirflow pattern)
#

set -e

# Get directory of this script
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all test scripts except this runner (using dirflow pattern)
TEST_SCRIPTS="$(ls "$TEST_DIR" | grep '\.sh$' | grep -v 'run-tests.sh' | sort)"

# Track test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo "Running tests in $TEST_DIR..."
echo "================================"

# Run each test script
for script in $TEST_SCRIPTS; do
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -n "Running $script... "
    
    if cd "$TEST_DIR" && ./"$script" >/dev/null 2>&1; then
        echo "PASS"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo "FAIL"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        echo "  Error in $script:"
        ./"$script" 2>&1 | sed 's/^/    /'
    fi
done

echo "================================"
echo "Tests: $TOTAL_TESTS, Passed: $PASSED_TESTS, Failed: $FAILED_TESTS"

if [ $FAILED_TESTS -eq 0 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "Some tests failed."
    exit 1
fi