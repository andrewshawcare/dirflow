# Tool Recommender Pipeline

This pipeline recommends MCP tools based on task descriptions provided via stdin.

## Prerequisites

You need a Smithery API key to use this pipeline:

1. Create an account at https://smithery.ai/
2. Get your API key at https://smithery.ai/account/api-keys
3. Set the environment variable:
   ```bash
   export SMITHERY_API_KEY=your_api_key_here
   ```

## Structure
```
10-tool-recommender/
├── 01-query-registry.sh   # Queries MCP registry API for available tools
├── 02-analyze-task.sh     # Analyzes task description and matches tools
├── 03-format-output.sh    # Formats recommendations in CSV format
└── README.md
```

## How it works
1. **01-query-registry.sh** - Fetches available tools from the selected MCP registry
2. **02-analyze-task.sh** - Analyzes the input task description and matches relevant tools
3. **03-format-output.sh** - Formats the matched tools in the required CSV format

## Examples
```bash
# Recommend tools for flight booking
echo "I want to find a flight from Toronto to Denmark. I want the lowest fare in CAD that is a direct flight" | ./dirflow.sh examples/10-tool-recommender

# Recommend tools for general task
echo "I need to analyze customer data and create a report" | ./dirflow.sh examples/10-tool-recommender
```

## Expected Output Format
Each recommended tool is output as a CSV line:
```
{ID},{NAME},{URL},{DESCRIPTION},{SELECTION_NECESSITY},{SELECTION_RATIONALE}
```

Where:
- **ID**: Tool identifier
- **NAME**: Tool name
- **URL**: Tool repository/documentation URL
- **DESCRIPTION**: Brief description of tool capabilities
- **SELECTION_NECESSITY**: "essential" or "optional"
- **SELECTION_RATIONALE**: Explanation of why this tool was recommended

If no suitable tools are found, no output is produced.