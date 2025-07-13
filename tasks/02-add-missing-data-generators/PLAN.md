# Add Missing Data Generators - Implementation Plan

## Task Overview
Add data generator scripts to examples that currently rely on external input data, making them self-contained and easier to demonstrate. Focus on the most critical generators first: data processing, then filtering examples.

## Test-Driven Development Plan

### Red-Green-Refactor Cycles

**Cycle 1: Data Processing Generator**
1. **Red**: Write test for `examples/02-data-processing/01-generate.sh` - verify it creates sample text data
2. **Green**: Create minimal generator that produces basic text output  
3. **Refactor**: Enhance to generate varied text (cases, punctuation, repeated words)
4. **Red**: Write test for proper file renaming (01-clean.sh → 02-clean.sh, etc.)
5. **Green**: Rename existing files to accommodate new generator
6. **Refactor**: Verify complete pipeline works end-to-end

**Cycle 2: Number Router Generator**
1. **Red**: Write test for `examples/06-filtering/conditional/number-router/01-generate.sh`
2. **Green**: Create generator that outputs mix of positive/negative numbers
3. **Refactor**: Optimize number distribution for effective routing demonstration

**Cycle 3: Text Router Generator**  
1. **Red**: Write test for `examples/06-filtering/conditional/text-router/01-generate.sh`
2. **Green**: Create generator that outputs mixed case text
3. **Refactor**: Add varied text patterns for comprehensive routing demo

**Cycle 4: Additional Filtering Generators**
1. **Red**: Write tests for skip-empty and valid-data generators
2. **Green**: Create basic generators for each filtering scenario
3. **Refactor**: Enhance with realistic data patterns

## Implementation Progress

### Completed Tasks
- [ ] Plan created and reviewed
- [ ] Test framework set up

### Task-Specific Implementation Steps
- [x] **Cycle 1a**: Test for data-processing generator creation
- [x] **Cycle 1b**: Create `examples/02-data-processing/01-generate.sh`
- [x] **Cycle 1c**: Test for file renaming (clean.sh, normalize.sh, count.sh)
- [x] **Cycle 1d**: Rename existing files (01→02, 02→03, 03→04)
- [x] **Cycle 1e**: Test complete data processing pipeline
- [x] **Cycle 2a**: Test for number-router generator creation
- [x] **Cycle 2b**: Create `examples/06-filtering/conditional/number-workflow/01-generate.sh`
- [x] **Cycle 2c**: Test number routing functionality
- [x] **Cycle 3a**: Test for text-router generator creation  
- [x] **Cycle 3b**: Create `examples/06-filtering/conditional/text-workflow/01-generate.sh`
- [x] **Cycle 3c**: Test text routing functionality
- [x] **Cycle 4a**: Test for skip-empty generator
- [x] **Cycle 4b**: Create `examples/06-filtering/filter/skip-empty-workflow/01-generate.sh`
- [x] **Cycle 4c**: Test for valid-data generator
- [x] **Cycle 4d**: Create `examples/06-filtering/filter/valid-data/01-generate.sh`
- [x] **Cycle 4e**: Test all filtering examples work end-to-end

### Final Verification
- [x] All tests passing (`tests/run-tests.sh`)
- [x] Code reviewed and refactored
- [x] Implementation complete

## Notes
- Focus on data-processing generator first as it's the most fundamental
- Each generator should produce realistic, varied data for effective demonstrations
- Test files will use naming pattern: `XX-add-missing-data-generators-YY-test-description.sh`
- Ensure all examples work without external input after implementation