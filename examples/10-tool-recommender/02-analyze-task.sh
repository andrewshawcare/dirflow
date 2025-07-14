#!/bin/bash
#
# Analyze Task Description and Match Tools
# Uses Claude Code SDK to intelligently match tools to task requirements
#

set -e

# Read the combined input from previous stage
INPUT=$(cat)

# Extract task input and tools from JSON
TASK_TEXT=$(echo "$INPUT" | jq -r '.task_input // ""')
TOOLS_ARRAY=$(echo "$INPUT" | jq -c '.tools // []')

# Format tools in a more readable way for Claude
TOOLS_LIST=""
while read -r tool; do
    if [ -n "$tool" ] && [ "$tool" != "null" ]; then
        TOOL_ID=$(echo "$tool" | jq -r '.id // ""')
        TOOL_NAME=$(echo "$tool" | jq -r '.name // ""')
        TOOL_URL=$(echo "$tool" | jq -r '.url // ""')
        TOOL_DESC=$(echo "$tool" | jq -r '.description // ""')
        TOOLS_LIST="$TOOLS_LIST
- ID: $TOOL_ID, Name: $TOOL_NAME, Description: $TOOL_DESC, URL: $TOOL_URL"
    fi
done < <(echo "$TOOLS_ARRAY" | jq -c '.[]?' 2>/dev/null || echo "")

# Create prompt for Claude to analyze task and match tools
CLAUDE_PROMPT="You are an expert at analyzing tasks and recommending relevant MCP tools.

Task to complete: \"$TASK_TEXT\"

Available MCP tools:$TOOLS_LIST

Please analyze the task and identify which MCP tools would be DIRECTLY relevant and necessary. Only include tools that are specifically needed for the core task, not general-purpose tools that could theoretically help with any task.

Consider that:
- \"fetch\" tool can make HTTP requests and web searches
- \"filesystem\" tool can read/write files 
- \"memory\" tool can store and retrieve information
- \"time\" tool provides date/time functions
- \"git\" tool provides version control operations

Respond with JSON in this exact format (do NOT use markdown formatting):
{
  \"matched_tools\": [
    {
      \"id\": \"tool-id\",
      \"name\": \"tool-name\", 
      \"url\": \"tool-url\",
      \"description\": \"tool-description\",
      \"necessity\": \"essential\",
      \"rationale\": \"specific reason why this tool is directly required for the task\"
    }
  ]
}

IMPORTANT: Only include tools that are directly required for the specific task. For tasks unrelated to web searches, file operations, or technical computing, return an empty matched_tools array. For example, physical cooking tasks should return empty results since MCP tools are for digital/computational tasks.

If no tools are relevant, return: {\"matched_tools\": []}"

# Use Claude Code SDK to analyze the task and tools
CLAUDE_RAW_RESPONSE=$(echo "$CLAUDE_PROMPT" | /Users/andrew/.claude/local/claude --print --output-format json)

# Extract the result field from Claude's JSON response
CLAUDE_RESPONSE=$(echo "$CLAUDE_RAW_RESPONSE" | jq -r '.result')

# Extract matched tools from Claude's response
MATCHED_TOOLS=$(echo "$CLAUDE_RESPONSE" | jq -c '.matched_tools // []' 2>/dev/null || echo '[]')
MATCH_COUNT=$(echo "$MATCHED_TOOLS" | jq 'length' 2>/dev/null || echo '0')

# Ensure we have valid JSON values
if [ -z "$MATCHED_TOOLS" ]; then
    MATCHED_TOOLS='[]'
fi
if [ -z "$MATCH_COUNT" ]; then
    MATCH_COUNT='0'
fi

# Output analysis results in expected format
echo "{
    \"task_input\": \"$TASK_TEXT\",
    \"analysis\": \"claude_analysis\",
    \"matched_tools\": $MATCHED_TOOLS,
    \"total_matches\": $MATCH_COUNT
}"