#!/bin/bash
#
# Test: Complete Data Processing Pipeline
# Verifies the entire pipeline works end-to-end without external input
#

set -e

PIPELINE_DIR="/Users/andrew/dirflow/examples/02-data-processing"
DIRFLOW_SCRIPT="/Users/andrew/dirflow/dirflow.sh"

echo "Testing complete data processing pipeline..."

# Test 1: Pipeline should run without errors
if ! OUTPUT=$("$DIRFLOW_SCRIPT" "$PIPELINE_DIR" 2>&1); then
    echo "FAIL: Pipeline execution failed"
    echo "Error output: $OUTPUT"
    exit 1
fi

# Test 2: Should produce output
if [ -z "$OUTPUT" ]; then
    echo "FAIL: Pipeline produces no output"
    exit 1
fi

# Test 3: Output should contain word frequency analysis (from count step)
if ! echo "$OUTPUT" | grep -q "Word frequency analysis:"; then
    echo "FAIL: Output doesn't contain expected word frequency analysis header"
    exit 1
fi

# Test 4: Should show word counts in expected format (word: count)
if ! echo "$OUTPUT" | grep -q "[a-z]*: [0-9]*"; then
    echo "FAIL: Output doesn't contain expected word count format"
    exit 1
fi

# Test 5: Should contain some actual word counts (at least 3 different words)
WORD_COUNT_LINES=$(echo "$OUTPUT" | grep -c "[a-z]*: [0-9]*" || true)
if [ "$WORD_COUNT_LINES" -lt 3 ]; then
    echo "FAIL: Output contains fewer than 3 word counts ($WORD_COUNT_LINES found)"
    exit 1
fi

# Test 6: Verify processing happened - word counts should be normalized (lowercase only)
WORD_LINES=$(echo "$OUTPUT" | grep "[a-z]*: [0-9]*")
if echo "$WORD_LINES" | grep -q "[A-Z]"; then
    echo "FAIL: Word counts still contain uppercase letters (normalization may have failed)"
    exit 1
fi

echo "PASS: Complete data processing pipeline working correctly"
echo "Pipeline processed text through all stages: generate → clean → normalize → count"
echo "Found $WORD_COUNT_LINES different words in frequency analysis"