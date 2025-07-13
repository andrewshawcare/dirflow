#!/bin/bash
#
# Test: Verify 02-data-processing example runs and produces expected output
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 02-data-processing example..."

# Expected output from README.md
EXPECTED_OUTPUT="Word frequency analysis:
processing: 4
words: 2
mixed: 2
for: 2
demonstration: 2
and: 2
with: 1
will: 1
varied: 1
too: 1
this: 1
text: 1
symbols: 1
some: 1
sample: 1
repeat: 1
purposes: 1
punctuation: 1
numbers: 1
more: 1
lines: 1
line: 1
like: 1
it: 1
is: 1
included: 1
in: 1
final: 1
empty: 1
content: 1
contains: 1
case: 1
be: 1
are: 1
123: 1"

# Test 1: Self-contained execution with generated data
echo "Testing self-contained execution..."
cd "$PROJECT_ROOT"
ACTUAL_OUTPUT="$(./dirflow.sh examples/02-data-processing)"

if [ "$ACTUAL_OUTPUT" = "$EXPECTED_OUTPUT" ]; then
    echo "PASS: Self-contained execution output matches expected"
else
    echo "FAIL: Self-contained execution output mismatch"
    echo "Expected:"
    echo "$EXPECTED_OUTPUT"
    echo "Actual:"
    echo "$ACTUAL_OUTPUT"
    exit 1
fi

echo "PASS: All 02-data-processing tests passed"