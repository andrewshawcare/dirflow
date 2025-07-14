#!/bin/bash
#
# Query MCP Registry for Available Tools
# Uses Smithery registry API to fetch real MCP server data
#

set -e

# Get Smithery API key from environment variable
SMITHERY_API_KEY="${SMITHERY_API_KEY:-}"

if [ -z "$SMITHERY_API_KEY" ]; then
    echo "ERROR: SMITHERY_API_KEY environment variable not set" >&2
    echo "Please set your Smithery API key: export SMITHERY_API_KEY=your_key_here" >&2
    echo "Get your API key at: https://smithery.ai/account/api-keys" >&2
    exit 1
fi

# Store the input task for later use
TASK_INPUT=$(cat)

# Query Smithery MCP registry
echo "Querying Smithery MCP registry..." >&2

TOOLS_JSON=""
TOOL_COUNT=0

# Extract key terms from task for better search results
SEARCH_TERMS=""
if echo "$TASK_INPUT" | grep -qi "flight\|travel\|booking\|airline"; then
    SEARCH_TERMS="search web travel flight"
elif echo "$TASK_INPUT" | grep -qi "search\|find\|web"; then
    SEARCH_TERMS="search web"
elif echo "$TASK_INPUT" | grep -qi "file\|document\|pdf"; then
    SEARCH_TERMS="file document"
elif echo "$TASK_INPUT" | grep -qi "database\|sql\|data"; then
    SEARCH_TERMS="database sql"
elif echo "$TASK_INPUT" | grep -qi "terminal\|command\|shell"; then
    SEARCH_TERMS="terminal command"
else
    # Use first few words of task as search terms
    SEARCH_TERMS=$(echo "$TASK_INPUT" | cut -d' ' -f1-3)
fi

TASK_QUERY=$(echo "$SEARCH_TERMS" | jq -Rr @uri)

# Query Smithery API with task-specific search
SMITHERY_RESPONSE=$(curl -s -H "Authorization: Bearer $SMITHERY_API_KEY" \
    -H "Accept: application/json" \
    "https://registry.smithery.ai/servers?q=${TASK_QUERY}&pageSize=20" 2>/dev/null || echo "")

# Check if Smithery returned valid data
if echo "$SMITHERY_RESPONSE" | jq -e '.servers' >/dev/null 2>&1; then
    echo "Using Smithery registry data..." >&2
    
    # Parse Smithery response (servers array format)
    SERVERS=$(echo "$SMITHERY_RESPONSE" | jq -c '.servers[]?' 2>/dev/null)
    
    while read -r server; do
        if [ -n "$server" ] && [ "$server" != "null" ]; then
            QUALIFIED_NAME=$(echo "$server" | jq -r '.qualifiedName // "unknown"')
            DISPLAY_NAME=$(echo "$server" | jq -r '.displayName // .qualifiedName // "unknown"')
            DESCRIPTION=$(echo "$server" | jq -r '.description // "No description available"' | tr -d '\n\r\t' | tr -s ' ')
            HOMEPAGE=$(echo "$server" | jq -r '.homepage // ""')
            USE_COUNT=$(echo "$server" | jq -r '.useCount // 0')
            IS_REMOTE=$(echo "$server" | jq -r '.remote // false')
            
            # Include all servers from Smithery (since we're filtering for deployed ones)
            # Use jq to create proper JSON with escaping
            TOOL_ENTRY=$(jq -n \
                --arg id "$QUALIFIED_NAME" \
                --arg name "$DISPLAY_NAME" \
                --arg url "$HOMEPAGE" \
                --arg description "$DESCRIPTION" \
                --arg type "mcp-server" \
                --argjson useCount "$USE_COUNT" \
                --argjson remote "$IS_REMOTE" \
                '{
                    id: $id,
                    name: $name,
                    url: $url,
                    description: $description,
                    type: $type,
                    useCount: $useCount,
                    remote: $remote
                }')
            
            if [ $TOOL_COUNT -eq 0 ]; then
                TOOLS_JSON="$TOOL_ENTRY"
            else
                TOOLS_JSON="$TOOLS_JSON,$TOOL_ENTRY"
            fi
            
            TOOL_COUNT=$((TOOL_COUNT + 1))
        fi
    done < <(echo "$SERVERS")
else
    # No servers found - return empty tools array
    echo "No MCP servers found in registry" >&2
fi

# Output structured JSON with task input and discovered tools
echo "{
    \"task_input\": \"$TASK_INPUT\",
    \"tools\": [$TOOLS_JSON]
}"