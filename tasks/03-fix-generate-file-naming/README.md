# Fix Generate File Naming

## Problem

Several files in the examples directory are named with "generate" but don't actually generate data from scratch. Instead, they passthrough or process existing input data, which is misleading for users learning the system.

## Current Misleading Files

### Files to Rename

1. **`examples/07-sampling/first-n/01-generate.sh`** → **`01-passthrough.sh`**
   - Current behavior: Passes through input data with logging
   - Does not generate any new data

2. **`examples/07-sampling/low-probability/01-generate.sh`** → **`01-process.sh`**
   - Current behavior: Logs low-probability event, passes through input
   - Does not generate any new data

3. **`examples/08-advanced-combinations/loop-parallel/01-generate.sh`** → **`01-timestamp.sh`**
   - Current behavior: Processes input data and adds timestamp information
   - Does not generate new data from scratch

### True Generators (Keep As-Is)

- **`examples/01-basic-pipeline/01-generate.sh`** ✓
  - Actually generates numeric sequences (1-10 or based on input)
  - This is the correct pattern for generate files

## Implementation Subtasks

### tasks/

#### 01-rename-files/
- Rename the three misleading generate files to reflect their actual function
- Update any internal references or dependencies

#### 02-update-documentation/
- Update README.md files in affected example directories
- Update usage examples to reflect new file names
- Ensure expected outputs still match with new names

#### 03-test-examples/
- Run all affected examples to ensure they still work after renaming
- Verify output remains consistent
- Test with various input scenarios

## Success Criteria

- All files named `*generate*` actually generate data from scratch
- Documentation accurately reflects file functionality
- All examples continue to work as expected
- Users can clearly understand what each file does from its name

## Dependencies

This task should be completed before adding new data generators to maintain consistency in naming patterns.