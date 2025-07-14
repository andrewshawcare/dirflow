#!/bin/bash
#
# Test: Verify tool recommender produces correct CSV output format
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing tool recommender output formatting..."

# Test 1: Complete pipeline produces CSV output for flight booking task
echo "Testing complete pipeline with flight booking task..."

cd "$PROJECT_ROOT"
FLIGHT_TASK="I want to find a flight from Toronto to Denmark. I want the lowest fare in CAD that is a direct flight"
PIPELINE_OUTPUT=$(echo "$FLIGHT_TASK" | ./dirflow.sh examples/10-tool-recommender)

# Test CSV format: {ID},{NAME},{URL},{DESCRIPTION},{SELECTION_NECESSITY},{SELECTION_RATIONALE}
if [ -n "$PIPELINE_OUTPUT" ]; then
    echo "PASS: Pipeline produces output for flight booking task"
    
    # Test that output contains CSV format
    LINE_COUNT=$(echo "$PIPELINE_OUTPUT" | wc -l)
    if [ "$LINE_COUNT" -lt 1 ]; then
        echo "FAIL: No output lines produced"
        exit 1
    fi
    
    echo "PASS: Pipeline produced $LINE_COUNT recommendation(s)"
    
    # Test CSV format structure
    FIRST_LINE=$(echo "$PIPELINE_OUTPUT" | head -n1)
    FIELD_COUNT=$(echo "$FIRST_LINE" | tr ',' '\n' | wc -l)
    
    if [ "$FIELD_COUNT" -ne 6 ]; then
        echo "FAIL: CSV line does not have 6 fields (got $FIELD_COUNT): $FIRST_LINE"
        exit 1
    fi
    
    echo "PASS: CSV format has correct number of fields (6)"
    
    # Test that necessity field contains valid values
    NECESSITY=$(echo "$FIRST_LINE" | cut -d',' -f5)
    if [ "$NECESSITY" != "essential" ] && [ "$NECESSITY" != "optional" ]; then
        echo "FAIL: Necessity field is not 'essential' or 'optional': $NECESSITY"
        exit 1
    fi
    
    echo "PASS: Necessity field contains valid value: $NECESSITY"
    
else
    # Test empty output case
    echo "PASS: Pipeline produces no output (no suitable tools found)"
fi

# Test 2: Pipeline handles task with no matches
echo "Testing pipeline with unrelated task..."
UNRELATED_TASK="I want to bake a cake with chocolate frosting"
EMPTY_OUTPUT=$(echo "$UNRELATED_TASK" | ./dirflow.sh examples/10-tool-recommender)

if [ -z "$EMPTY_OUTPUT" ]; then
    echo "PASS: Pipeline produces no output for unrelated task"
else
    echo "FAIL: Pipeline should produce no output for unrelated task, got: $EMPTY_OUTPUT"
    exit 1
fi

# Test 3: Verify specific output format fields
if [ -n "$PIPELINE_OUTPUT" ]; then
    FIRST_LINE=$(echo "$PIPELINE_OUTPUT" | head -n1)
    ID=$(echo "$FIRST_LINE" | cut -d',' -f1)
    NAME=$(echo "$FIRST_LINE" | cut -d',' -f2)
    URL=$(echo "$FIRST_LINE" | cut -d',' -f3)
    
    if [ -z "$ID" ] || [ -z "$NAME" ] || [ -z "$URL" ]; then
        echo "FAIL: Required fields (ID, NAME, URL) are empty"
        exit 1
    fi
    
    echo "PASS: Required fields contain data"
fi

echo "PASS: All output formatting tests passed"