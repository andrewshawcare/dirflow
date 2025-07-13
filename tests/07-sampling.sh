#!/bin/bash
#
# Test: Verify 07-sampling example first-n workflow (deterministic behavior)
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 07-sampling/first-n example..."

# Test 1: First-n with few lines (should pass through)
echo "Testing first-n with few lines..."
cd "$PROJECT_ROOT"
EXPECTED_FEW="line1
line2"
ACTUAL_FEW="$(echo -e "line1\nline2" | ./dirflow.sh examples/07-sampling/first-n)"

if [ "$ACTUAL_FEW" = "$EXPECTED_FEW" ]; then
    echo "PASS: First-n with few lines passes through correctly"
else
    echo "FAIL: First-n with few lines output mismatch"
    echo "Expected:"
    echo "$EXPECTED_FEW"
    echo "Actual:"
    echo "$ACTUAL_FEW"
    exit 1
fi

# Test 2: First-n with many lines (should process)
echo "Testing first-n with many lines..."
EXPECTED_MANY="=== FIRST-N CRITERIA MET ===
Processing: First-n sampling activated
Processing: Input data:
Processing: line1
Processing: line2
Processing: line3
Processing: line4
Processing: line5
Processing: Line count:        5
=== PROCESSING COMPLETE ==="
ACTUAL_MANY="$(echo -e "line1\nline2\nline3\nline4\nline5" | ./dirflow.sh examples/07-sampling/first-n)"

if [ "$ACTUAL_MANY" = "$EXPECTED_MANY" ]; then
    echo "PASS: First-n with many lines processes correctly"
else
    echo "FAIL: First-n with many lines output mismatch"
    echo "Expected:"
    echo "$EXPECTED_MANY"
    echo "Actual:"
    echo "$ACTUAL_MANY"
    exit 1
fi

echo "PASS: All 07-sampling/first-n tests passed"