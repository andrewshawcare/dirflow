#!/bin/bash
#
# Test: Verify 08-advanced-combinations example workflows run correctly
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing 08-advanced-combinations example..."

cd "$PROJECT_ROOT"

# Test 1: data-processing-workflow (check for key output patterns)
echo "Testing data-processing-workflow..."
ACTUAL_DATA_PROCESSING="$(echo "valid data" | ./dirflow.sh examples/08-advanced-combinations/data-processing-workflow)"

# Check for key patterns in the output
if echo "$ACTUAL_DATA_PROCESSING" | grep -q "=== CLEANING RESULTS ===" && \
   echo "$ACTUAL_DATA_PROCESSING" | grep -q "=== ANALYSIS RESULTS ===" && \
   echo "$ACTUAL_DATA_PROCESSING" | grep -q "=== ENRICHMENT RESULTS ==="; then
    echo "PASS: Data-processing-workflow contains expected sections"
else
    echo "FAIL: Data-processing-workflow missing expected sections"
    echo "Actual output:"
    echo "$ACTUAL_DATA_PROCESSING"
    exit 1
fi

# Test 2: iterative-refinement
echo "Testing iterative-refinement..."
EXPECTED_ITERATIVE="Improvement: Applied enhancement algorithms
Improvement: Quality boosted
Verification: Checking improvements
Verification: Standards met
Scoring: Calculating quality metrics
Scoring: Analysis complete"
ACTUAL_ITERATIVE="$(echo "quality_score=85" | ./dirflow.sh examples/08-advanced-combinations/iterative-refinement)"

if [ "$ACTUAL_ITERATIVE" = "$EXPECTED_ITERATIVE" ]; then
    echo "PASS: Iterative-refinement output matches expected"
else
    echo "FAIL: Iterative-refinement output mismatch"
    echo "Expected:"
    echo "$EXPECTED_ITERATIVE"
    echo "Actual:"
    echo "$ACTUAL_ITERATIVE"
    exit 1
fi

# Test 3: loop-parallel (check it runs and produces output containing key patterns)
echo "Testing loop-parallel..."
ACTUAL_LOOP_PARALLEL="$(./dirflow.sh examples/08-advanced-combinations/loop-parallel)"

# Check for key patterns in the complex output
if echo "$ACTUAL_LOOP_PARALLEL" | grep -q "Generator:" && \
   echo "$ACTUAL_LOOP_PARALLEL" | grep -q "Transformer:" && \
   echo "$ACTUAL_LOOP_PARALLEL" | grep -q "Collector:"; then
    echo "PASS: Loop-parallel contains expected processing stages"
else
    echo "FAIL: Loop-parallel missing expected processing stages"
    echo "Actual output:"
    echo "$ACTUAL_LOOP_PARALLEL"
    exit 1
fi

echo "PASS: All 08-advanced-combinations tests passed"