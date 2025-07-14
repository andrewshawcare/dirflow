# Tool recommender - Implementation Plan

## Task Overview
Create a dirflow pipeline example that queries an MCP registry API to recommend tools based on task descriptions. The pipeline should accept task descriptions via stdin and output CSV-formatted tool recommendations with necessity categorization. Implementation includes registry evaluation documentation and follows dirflow conventions for pipeline structure.

## Test-Driven Development Plan

### Red-Green-Refactor Cycles

**Cycle 1: Registry Research and Documentation**
- RED: Write test to verify REGISTRY_EVALUATION.md exists and contains required evaluation
- GREEN: Research MCP registries and create evaluation documentation
- REFACTOR: Ensure documentation is comprehensive and well-structured

**Cycle 2: Pipeline Structure and Basic Functionality**
- RED: Write test to verify pipeline directory exists and accepts stdin input
- GREEN: Create basic pipeline structure in examples/ directory
- REFACTOR: Ensure pipeline follows dirflow conventions

**Cycle 3: Registry API Integration**
- RED: Write test to verify pipeline can query chosen MCP registry API
- GREEN: Implement API query functionality to fetch available tools
- REFACTOR: Handle API errors and optimize data retrieval

**Cycle 4: Task Analysis and Tool Matching**
- RED: Write test to verify pipeline analyzes task descriptions and matches relevant tools
- GREEN: Implement task analysis logic and tool matching algorithm
- REFACTOR: Improve matching accuracy and logic

**Cycle 5: Output Formatting**
- RED: Write test to verify CSV output format matches specification
- GREEN: Implement output formatting with required fields and structure
- REFACTOR: Ensure proper escaping and formatting of CSV data

**Cycle 6: Example Validation**
- RED: Write test using provided example ("flight from Toronto to Denmark...")
- GREEN: Ensure pipeline works correctly with the specific example
- REFACTOR: Handle edge cases and improve reliability

## Implementation Progress

### Completed Tasks
- [x] Plan created and reviewed
- [x] Test framework set up

### Task-Specific Implementation Steps

**Phase 1: Research and Documentation**
- [x] Research available MCP registries (GitHub, official directories, etc.)
- [x] Evaluate registry APIs for ease of access, tool coverage, and data quality
- [x] Create REGISTRY_EVALUATION.md with evaluation findings and selection rationale
- [x] Verify registry evaluation test passes

**Phase 2: Pipeline Foundation**
- [x] Create pipeline directory structure (e.g., examples/10-tool-recommender/)
- [x] Implement basic stdin input handling
- [x] Create pipeline README.md with usage documentation
- [x] Verify basic pipeline structure test passes

**Phase 3: API Integration**
- [x] Implement registry API query script (01-query-registry.sh)
- [x] Handle API responses and error conditions
- [x] Parse and structure tool data from registry
- [x] Verify API integration test passes

**Phase 4: Analysis Engine**
- [x] Implement task analysis script (02-analyze-task.sh)
- [x] Create tool matching algorithm based on keywords, categories, descriptions
- [x] Implement necessity classification logic (essential vs optional)
- [x] Verify task analysis test passes

**Phase 5: Output Generation**
- [x] Implement output formatting script (03-format-output.sh)
- [x] Ensure CSV format: {ID},{NAME},{URL},{DESCRIPTION},{SELECTION_NECESSITY},{SELECTION_RATIONALE}
- [x] Handle cases with no suitable tools (empty output)
- [x] Verify output formatting test passes

**Phase 6: Integration Testing**
- [x] Test complete pipeline with flight booking example
- [x] Test edge cases (no matches, malformed input, API failures)
- [x] Verify all integration tests pass

### Final Verification
- [x] All tests passing (`tests/run-tests.sh`)
- [x] Code reviewed and refactored
- [x] Implementation complete

## Notes

**Implementation Strategy:**
- Start with registry research to understand available APIs and data formats
- Build pipeline incrementally following TDD cycles
- Focus on practical tool matching based on keywords and descriptions
- Handle real-world API constraints (rate limits, authentication, data quality)

**Key Technical Considerations:**
- Use curl and jq for API interactions and JSON parsing
- Implement robust error handling for network and API failures
- Design flexible matching algorithm that can work with various registry schemas
- Ensure CSV output properly escapes commas and quotes in data fields

**Success Metrics:**
- Pipeline correctly identifies relevant tools for the flight booking example
- Registry evaluation provides clear rationale for chosen API
- All scripts follow dirflow conventions and execute reliably
- Output format exactly matches specification

## Test Naming
Test files should be named to describe what they test: `tool-recommender-registry-evaluation.sh` or `tool-recommender-pipeline.sh`