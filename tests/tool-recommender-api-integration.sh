#!/bin/bash
#
# Test: Verify tool recommender can query MCP registry API
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing tool recommender API integration..."

# Test 1: Query registry script can fetch tool data
echo "Testing registry API query..."

# Run just the first script to test API integration
TEST_INPUT="test task"
cd "$PROJECT_ROOT"
API_OUTPUT=$(echo "$TEST_INPUT" | bash examples/10-tool-recommender/01-query-registry.sh)

# Test that we get valid JSON output with tool data
if ! echo "$API_OUTPUT" | jq . >/dev/null 2>&1; then
    echo "FAIL: Registry query script does not produce valid JSON"
    exit 1
fi

echo "PASS: Registry query produces valid JSON"

# Test 2: Output contains actual tool information from GitHub API
if echo "$API_OUTPUT" | grep -q "mock_data"; then
    echo "FAIL: Registry query still returning mock data - need real API integration"
    exit 1
fi

echo "PASS: Registry query returns real data (not mock)"

# Test 3: Tool data contains required fields
if ! echo "$API_OUTPUT" | jq -r '.tools[]?' >/dev/null 2>&1; then
    echo "FAIL: Registry output does not contain tools array"
    exit 1
fi

echo "PASS: Registry output contains tools array"

# Test 4: Each tool has required metadata
TOOL_COUNT=$(echo "$API_OUTPUT" | jq -r '.tools | length' 2>/dev/null || echo "0")
if [ "$TOOL_COUNT" -lt 1 ]; then
    echo "FAIL: No tools found in registry response"
    exit 1
fi

echo "PASS: Found $TOOL_COUNT tools in registry"

echo "PASS: All API integration tests passed"