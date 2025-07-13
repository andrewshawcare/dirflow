# Add a test for each example

## Problem

There are no tests in the tests folder; Each new test file should align 1-to-1 with each example, ensuring the example runs as expected and documented in the associated README.md; Each test should run the example and confirm the output is as expected with the provided input; Just stick to the results (i.e. outcomes); Testing should always be without mocks and test behaviour (e.g. capabilities, outcomes), not implementation.

## Examples

- `examples/01-basic-pipeline` should have a test named `01-basic-pipeline.sh` which should test both usage examples
- README.md files should be structured to have a section named "Examples" with each example comprised of a command and expected output
- Test files should have a test for each example, ensuring the expected output is what is produced
- Tests should verify stdout primarily, but can verify exit codes and stderr for erroneous execution

## Success Criteria

1. Every example directory (01-basic-pipeline through 09-debugging) has a corresponding test file in tests/
2. All README.md files have been updated to use "Examples" section (instead of "Usage")
3. Each test file contains one test per example command shown in the README
4. All tests pass when run
5. Tests verify actual stdout output matches documented expected output
6. Error case tests verify appropriate exit codes/stderr where applicable

## Subtasks

1. Audit and standardize README.md files - Convert "Usage" sections to "Examples" sections with proper command/output format
2. Create basic test infrastructure - Set up any shared testing utilities or patterns needed
3. Create tests for self-contained examples - Start with examples that don't require external input
4. Create tests for input-dependent examples - Examples that require specific input
5. Create tests for complex/conditional examples - Advanced examples with multiple scenarios
6. Create tests for debugging examples - Special case examples
7. Validate complete test suite - Run all tests and ensure they pass consistently

## Dependencies

Current repository state is sufficient. Evaluate bats as a testing framework (but if too complex, stick with simple scripts).