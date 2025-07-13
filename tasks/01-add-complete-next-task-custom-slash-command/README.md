# Add complete-next-task custom slash command

## Problem

Currently, there's no automated way to systematically work through tasks in the `tasks/` folder using a test-driven development approach. The `/complete-next-task` command will automate the entire workflow from task selection to completion, including:

- Automatically selecting the next leaf task (traversing subtasks recursively)
- Generating implementation plans through interactive conversation
- Following red-green-refactor TDD methodology with executable tests
- Managing plan progress with checkboxes in `Plan.md` files
- Handling task completion, review, and cleanup

This eliminates manual task management overhead and ensures consistent TDD practices across all task implementations.

## Examples

### Example 1: Basic Task with Subtasks

When `tasks/01-fix-generate-file-naming/` contains a subtask `01-rename-files`, the command will:

1. Navigate to the leaf subtask `tasks/01-fix-generate-file-naming/01-rename-files/`
2. Create a `tests/` folder in that directory
3. Generate a test for the first file rename (e.g., verify `examples/07-sampling/first-n/01-passthrough.sh` exists)
4. Run the test (fails - red)
5. Make the minimal change: rename `01-generate.sh` to `01-passthrough.sh`
6. Run the test (passes - green)
7. Refactor if needed
8. Run the test (passes - refactor)
9. Move to next file in the rename list and repeat from step 3.

### Example 2: Plan Generation and Management

The command generates a `Plan.md` file like:

```markdown
# Task Implementation Plan

## Plan Tasks
- [ ] Create test for first file rename
- [ ] Run test and ensure it fails
- [ ] Implement simplest change that passes the test (without modifying the test)
- [ ] Run test and ensure it passes, otherwise uncheck and work on previous task
- [ ] Refactor if appropriate, and ensure test passes
- [ ] Create test for second file rename
- [ ] Run test and ensure it fails
- [ ] Implement simplest change that passes the test (without modifying the test)
- [ ] Run test and ensure it passes, otherwise uncheck and work on previous task
- [ ] Refactor if appropriate, and ensure test passes
- [ ] Verify all changes work correctly by running all tests
```

Each checkbox gets marked as tasks complete following the TDD cycle.

## Implementation Subtasks

1. **Design command architecture**
   - Define task selection algorithm (recursive leaf finding)
   - Design plan generation and conversation flow
   - Specify test creation and TDD workflow integration

2. **Implement task traversal logic**
   - Create function to find next top-level task
   - Implement recursive subtask navigation to find leaf nodes
   - Handle edge cases (no tasks, malformed task structure)

3. **Build plan generation system**
   - Implement interactive conversation for plan review
   - Create Plan.md file generation with checkbox format
   - Integrate with TodoWrite tool for plan task management

4. **Implement TDD workflow**
   - Create test file generation in `tests/` folders
   - Implement red-green-refactor cycle automation
   - Add test execution and validation logic

5. **Add task completion and cleanup**
   - Implement task review workflow
   - Create task folder deletion after approval
   - Add git commit functionality for completed work

## Success Criteria

- Successfully identifies the next leaf task through recursive traversal
- Creates appropriate test files in `tests/` folders within task directories
- Follows complete red-green-refactor TDD cycle for each implementation step
- Generates proper `Plan.md` files with checkboxes that track completion
- Handles task completion, user review, and cleanup (deletion + commit) correctly
- Integrates seamlessly with existing tools like TodoWrite
- Works with any existing testing frameworks found in task folders, defaulting to simplest approach

## Dependencies

- No integration with existing slash command infrastructure required
- Should adopt existing testing frameworks/tools if found in task folders, otherwise use simplest available
- Must integrate directly with existing tools like TodoWrite rather than creating custom alternatives
- Requires git functionality for committing completed work
- Test files should be placed in `tests/` folders within task directories for consistency