#!/bin/bash
#
# Test: Verify tool recommender can analyze tasks and match relevant tools
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing tool recommender task analysis..."

# Test 1: Analysis script processes JSON input and produces analysis output
echo "Testing task analysis logic..."

# Create sample input that matches the output format from query script
SAMPLE_INPUT='{
    "task_input": "I want to find a flight from Toronto to Denmark",
    "tools": [
        {
            "id": "brave-search",
            "name": "brave-search",
            "url": "https://github.com/modelcontextprotocol/servers/tree/main/brave-search",
            "description": "MCP server: brave-search",
            "type": "mcp-server"
        },
        {
            "id": "filesystem",
            "name": "filesystem",
            "url": "https://github.com/modelcontextprotocol/servers/tree/main/filesystem",
            "description": "MCP server: filesystem",
            "type": "mcp-server"
        }
    ]
}'

cd "$PROJECT_ROOT"
ANALYSIS_OUTPUT=$(echo "$SAMPLE_INPUT" | bash examples/10-tool-recommender/02-analyze-task.sh)

# Test that we get valid JSON output
if ! echo "$ANALYSIS_OUTPUT" | jq . >/dev/null 2>&1; then
    echo "FAIL: Analysis script does not produce valid JSON"
    exit 1
fi

echo "PASS: Analysis script produces valid JSON"

# Test 2: Analysis output contains matched tools with relevance scores
if echo "$ANALYSIS_OUTPUT" | grep -q "placeholder"; then
    echo "FAIL: Analysis script still returning placeholder data - need real analysis"
    exit 1
fi

echo "PASS: Analysis returns real data (not placeholder)"

# Test 3: Analysis identifies relevant tools for the task
if ! echo "$ANALYSIS_OUTPUT" | jq -e '.matched_tools[]?' >/dev/null 2>&1; then
    echo "FAIL: Analysis output does not contain matched_tools array"
    exit 1
fi

echo "PASS: Analysis output contains matched tools"

# Test 4: Matched tools have necessity classification
MATCHED_COUNT=$(echo "$ANALYSIS_OUTPUT" | jq -r '.matched_tools | length' 2>/dev/null || echo "0")
if [ "$MATCHED_COUNT" -lt 1 ]; then
    echo "FAIL: No tools matched for the flight booking task"
    exit 1
fi

echo "PASS: Found $MATCHED_COUNT matched tools for flight booking task"

# Test 5: Tools have necessity and rationale
FIRST_TOOL=$(echo "$ANALYSIS_OUTPUT" | jq -r '.matched_tools[0]' 2>/dev/null)
if ! echo "$FIRST_TOOL" | jq -e '.necessity' >/dev/null 2>&1; then
    echo "FAIL: Matched tools missing necessity classification"
    exit 1
fi

if ! echo "$FIRST_TOOL" | jq -e '.rationale' >/dev/null 2>&1; then
    echo "FAIL: Matched tools missing rationale"
    exit 1
fi

echo "PASS: Matched tools have necessity and rationale"

echo "PASS: All task analysis tests passed"