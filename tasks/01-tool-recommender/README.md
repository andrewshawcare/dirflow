# Tool recommender

## Problem

The tool recommender should query an MCP registry via an API based on the task it needs to complete. It should review the available tools and suggest a set that would be most useful in completing the task; This should be implemented as an example in the examples folder, where the steps required to recommend a tool are implemented as a pipeline; it should take the task description as stdin and it should produce a list of line-delimited tool suggestions from the registry. The current situation that makes this necessary is that there are hundreds (if not thousands) of MCP tools available and it should not be the task of the user to query and select from this list, it should be automated; this solves the problem of researching and selecting the best possible tools to complete a given task.

## Examples

An example of task description input would be, "I want to find a flight from Toronto to Denmark. I want the lowest fare in CAD that is a direct flight". The expected output should be a list of MCP tools where each line is the following format: {ID},{NAME},{URL},{DESCRIPTION},{SELECTION_NECESSITY},{SELECTION_RATIONALE}. There should be a necessity listed of essential or optional; If no suitable tools are found, produce no output.

## Success Criteria

1. Pipeline exists in `examples/` directory that accepts task descriptions via stdin
2. Pipeline queries MCP registry API to fetch available tools
3. Pipeline analyzes task description against tool capabilities
4. Pipeline outputs recommendations in the specified CSV format: `{ID},{NAME},{URL},{DESCRIPTION},{SELECTION_NECESSITY},{SELECTION_RATIONALE}`
5. Pipeline correctly categorizes tools as "essential" or "optional"
6. Pipeline produces no output when no suitable tools are found
7. Pipeline works with the provided example input ("flight from Toronto to Denmark...")
8. All pipeline scripts follow dirflow conventions and execute properly
9. `REGISTRY_EVALUATION.md` file documents evaluation of MCP registries and selection rationale

## Subtasks

1. Research and evaluate available MCP registries
2. Create REGISTRY_EVALUATION.md documenting registry selection
3. Design tool recommendation algorithm/logic
4. Implement registry API query script
5. Implement task analysis and tool matching script
6. Implement output formatting script
7. Create example pipeline directory structure
8. Test with provided example and edge cases
9. Document pipeline usage and behavior

## Dependencies

Internet access to query MCP registry APIs, understanding of MCP tool schema/format, bash scripting capabilities for API requests (curl, jq, etc.), access to MCP registry documentation. If API keys or pricing details are relevant, they should be documented in the SELECTION_RATIONALE section of the output.