#!/bin/bash
#
# Test: Verify REGISTRY_EVALUATION.md exists and contains required evaluation
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing tool recommender registry evaluation..."

REGISTRY_EVAL_PATH="$PROJECT_ROOT/tasks/01-tool-recommender/REGISTRY_EVALUATION.md"

# Test 1: File exists
if [ ! -f "$REGISTRY_EVAL_PATH" ]; then
    echo "FAIL: REGISTRY_EVALUATION.md does not exist"
    exit 1
fi

echo "PASS: REGISTRY_EVALUATION.md file exists"

# Test 2: Contains evaluation of multiple registries
if ! grep -i "registr" "$REGISTRY_EVAL_PATH" > /dev/null; then
    echo "FAIL: REGISTRY_EVALUATION.md does not contain registry evaluation"
    exit 1
fi

echo "PASS: Contains registry evaluation content"

# Test 3: Contains selection rationale
if ! grep -i "rationale\|reason\|selected\|chosen" "$REGISTRY_EVAL_PATH" > /dev/null; then
    echo "FAIL: REGISTRY_EVALUATION.md does not contain selection rationale"
    exit 1
fi

echo "PASS: Contains selection rationale"

# Test 4: Contains API information
if ! grep -i "api\|endpoint\|url" "$REGISTRY_EVAL_PATH" > /dev/null; then
    echo "FAIL: REGISTRY_EVALUATION.md does not contain API information"
    exit 1
fi

echo "PASS: Contains API information"

echo "PASS: All registry evaluation tests passed"