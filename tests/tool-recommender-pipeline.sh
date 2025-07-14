#!/bin/bash
#
# Test: Verify tool recommender pipeline structure and basic functionality
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing tool recommender pipeline structure..."

PIPELINE_DIR="$PROJECT_ROOT/examples/10-tool-recommender"

# Test 1: Pipeline directory exists
if [ ! -d "$PIPELINE_DIR" ]; then
    echo "FAIL: Pipeline directory does not exist at $PIPELINE_DIR"
    exit 1
fi

echo "PASS: Pipeline directory exists"

# Test 2: Pipeline contains executable scripts
SCRIPT_COUNT=$(find "$PIPELINE_DIR" -name "*.sh" -perm +111 | wc -l)
if [ "$SCRIPT_COUNT" -lt 1 ]; then
    echo "FAIL: Pipeline directory contains no executable scripts"
    exit 1
fi

echo "PASS: Pipeline contains executable scripts ($SCRIPT_COUNT found)"

# Test 3: Pipeline can accept stdin input and produce output
echo "Testing pipeline with stdin input..."
TEST_INPUT="I want to find a flight from Toronto to Denmark"
cd "$PROJECT_ROOT"

# Test that pipeline accepts input without crashing
if ! echo "$TEST_INPUT" | timeout 30s ./dirflow.sh examples/10-tool-recommender >/dev/null 2>&1; then
    echo "FAIL: Pipeline crashed or timed out with stdin input"
    exit 1
fi

echo "PASS: Pipeline accepts stdin input without crashing"

# Test 4: Pipeline README exists
if [ ! -f "$PIPELINE_DIR/README.md" ]; then
    echo "FAIL: Pipeline README.md does not exist"
    exit 1
fi

echo "PASS: Pipeline README.md exists"

echo "PASS: All pipeline structure tests passed"