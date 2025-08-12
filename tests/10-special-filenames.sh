#!/bin/bash
#
# Test: Verify that dirflow handles filenames with spaces correctly.
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 10-special-filenames example..."

cd "$PROJECT_ROOT"

# Test 1: Sequential execution with spaces in filenames
echo "Testing sequential execution with spaces..."
EXPECTED_SEQ="start
seq1
seq2"
ACTUAL_SEQ="$(echo "start" | ./dirflow.sh "examples/10-special-filenames/sequential")"

if [ "$ACTUAL_SEQ" = "$EXPECTED_SEQ" ]; then
    echo "PASS: Sequential execution with spaces in filenames works"
else
    echo "FAIL: Sequential execution with spaces in filenames failed"
    echo "Expected:"
    echo "$EXPECTED_SEQ"
    echo "Actual:"
    echo "$ACTUAL_SEQ"
    exit 1
fi

# Test 2: Parallel execution with spaces in filenames
echo "Testing parallel execution with spaces..."
EXPECTED_PAR="start
start
par1
par2"
ACTUAL_PAR="$(echo "start" | ./dirflow.sh "examples/10-special-filenames/parallel")"

if [ "$ACTUAL_PAR" = "$EXPECTED_PAR" ]; then
    echo "PASS: Parallel execution with spaces in filenames works"
else
    echo "FAIL: Parallel execution with spaces in filenames failed"
    echo "Expected:"
    echo "$EXPECTED_PAR"
    echo "Actual:"
    echo "$ACTUAL_PAR"
    exit 1
fi

echo "PASS: All 10-special-filenames tests passed"
