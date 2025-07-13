# Add Missing Data Generators

## Problem

Several examples in the dirflow project rely on external input data or start with processing steps instead of data generation. This makes them less self-contained and harder to demonstrate without providing sample data.

## Examples Missing Data Generators

### 1. Data Processing Pipeline
- **Location**: `examples/02-data-processing/`
- **Current**: Starts with `01-clean.sh` (expects external text input)
- **Need**: `01-generate.sh` to create sample text data with various cases, punctuation, etc.

### 2. Filtering Examples
- **Location**: `examples/06-filtering/conditional/number-router/`
- **Current**: Expects external numeric input
- **Need**: `01-generate.sh` to create mixed positive/negative numbers

- **Location**: `examples/06-filtering/conditional/text-router/`
- **Current**: Expects external text input
- **Need**: `01-generate.sh` to create mixed uppercase/lowercase text

- **Location**: `examples/06-filtering/filter/skip-empty/`
- **Current**: Expects input with empty lines
- **Need**: `01-generate.sh` to create data with some empty lines

- **Location**: `examples/06-filtering/filter/valid-data/`
- **Current**: Expects mixed valid/invalid data
- **Need**: `01-generate.sh` to create sample data with validation scenarios

## Implementation Subtasks

### tasks/

#### 01-data-processing-generator/
- Create `examples/02-data-processing/01-generate.sh`
- Generate sample text with mixed cases, punctuation, repeated words
- Shift existing files (01-clean.sh → 02-clean.sh, etc.)

#### 02-number-router-generator/
- Create `examples/06-filtering/conditional/number-router/01-generate.sh`
- Generate mix of positive and negative numbers
- Ensure good distribution for demonstrating routing

#### 03-text-router-generator/
- Create `examples/06-filtering/conditional/text-router/01-generate.sh`
- Generate mix of uppercase and lowercase text
- Include various text patterns for routing demonstration

#### 04-skip-empty-generator/
- Create `examples/06-filtering/filter/skip-empty/01-generate.sh`
- Generate data with some empty lines interspersed
- Demonstrate filtering behavior with empty content

#### 05-valid-data-generator/
- Create `examples/06-filtering/filter/valid-data/01-generate.sh`
- Generate mix of valid and invalid data patterns
- Include various validation scenarios

#### 06-update-documentation/
- Update README.md files in all affected directories
- Update file numbering after adding generators
- Ensure usage examples reflect new self-contained nature

#### 07-test-examples/
- Test all modified examples work end-to-end without external input
- Verify output quality and consistency
- Ensure filtering/routing behavior works as expected

## Success Criteria

- All examples can run without external input data
- Generated data demonstrates the intended functionality effectively
- Documentation clearly explains the self-contained nature
- Examples produce meaningful, predictable output for learning

## Dependencies

Should be completed after task 01-fix-generate-file-naming to maintain consistent naming patterns.