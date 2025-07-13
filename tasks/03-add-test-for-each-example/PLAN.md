# Add a test for each example - Implementation Plan

## Task Overview
Create comprehensive tests for all 9 example directories (01-basic-pipeline through 09-debugging). Each test file should align 1-to-1 with its example, ensuring the example runs as expected and documented in the README.md. Convert "Usage" sections to "Examples" sections in README files for consistency. Tests should verify stdout output matches documented expected output, with focus on behavior/outcomes rather than implementation details.

## Test-Driven Development Plan

### Red-Green-Refactor Cycles

**Cycle 1: Documentation Standardization Test**
- RED: Write test to verify all README.md files use "Examples" section instead of "Usage"
- GREEN: Update all README.md files to use "Examples" section with proper command/output format
- REFACTOR: Ensure consistent documentation structure across all examples

**Cycle 2: Basic Self-Contained Example Tests**
- RED: Write tests for self-contained examples (02-data-processing, 06-filtering workflows, 07-sampling)
- GREEN: Implement test functions that run examples and verify stdout output
- REFACTOR: Extract common test patterns and improve test reliability

**Cycle 3: Input-Dependent Example Tests**
- RED: Write tests for examples requiring specific input (01-basic-pipeline, 03-loop-simple)
- GREEN: Implement tests with proper input handling and output verification
- REFACTOR: Standardize input/output testing patterns

**Cycle 4: Complex Example Tests**
- RED: Write tests for complex examples (04-loop-conditional, 05-parallel-execution, 08-advanced-combinations)
- GREEN: Implement tests handling multiple scenarios and complex outputs
- REFACTOR: Optimize test execution and error handling

**Cycle 5: Debugging Example Tests**
- RED: Write tests for debugging examples (09-debugging) with special considerations
- GREEN: Implement tests that may need to handle error conditions
- REFACTOR: Ensure all edge cases are covered

## Implementation Progress

### Completed Tasks
- [x] Plan created and reviewed
- [x] Test framework set up

### Task-Specific Implementation Steps

**Phase 1: Documentation Standardization**
- [x] Create test for README.md standardization (readme-examples-standardization.sh)
- [x] Audit all 9 example README.md files
- [x] Convert "Usage" to "Examples" sections with command/output pairs
- [x] Verify documentation test passes

**Phase 2: Self-Contained Examples**
- [x] Create test for 02-data-processing (02-data-processing.sh)
- [x] Create test for 06-filtering workflows (06-filtering.sh)
- [x] Create test for 07-sampling (07-sampling.sh)
- [x] Verify all self-contained tests pass

**Phase 3: Input-Dependent Examples**
- [x] Create test for 01-basic-pipeline (01-basic-pipeline.sh)
- [x] Create test for 03-loop-simple (03-loop-simple.sh)
- [x] Verify input-dependent tests pass

**Phase 4: Complex Examples**
- [x] Create test for 04-loop-conditional (04-loop-conditional.sh)
- [x] Create test for 05-parallel-execution (05-parallel-execution.sh)
- [x] Create test for 08-advanced-combinations (08-advanced-combinations.sh)
- [x] Verify complex tests pass

**Phase 5: Debugging Examples**
- [x] Create test for 09-debugging (09-debugging.sh)
- [x] Handle any special error conditions or debugging outputs
- [x] Verify debugging tests pass

### Final Verification
- [x] All tests passing (`tests/run-tests.sh`)
- [x] Code reviewed and refactored
- [x] Implementation complete

## Notes

**Testing Strategy:**
- Use existing tests/run-tests.sh infrastructure (no bats needed)
- Focus on stdout verification with exact string matching
- Include exit code verification for error cases
- Test each command example shown in README "Examples" sections

**File Naming Convention:**
- Test files: `XX-example-name.sh` (descriptive names matching examples)
- Follow lexicographic ordering for predictable execution
- No task prefixes in test names (tests renamed for clarity)

**Special Considerations:**
- Some examples are self-contained (have generators)
- Some examples require external input 
- Complex examples may have multiple sub-workflows
- Debugging examples may intentionally show error states

**Expected Scope:**
- 9 main example directories to test
- ~15-20 individual test scripts (some examples have multiple scenarios)
- All README.md files updated to use "Examples" section