# Complete Next Task

Automatically complete the next task using test-driven development methodology.

**Think carefully** about the task implementation and plan the TDD workflow before beginning. Find the next leaf task through recursive traversal, then guide through an interactive conversation to create a detailed implementation plan.

**IMPORTANT**: This command will make actual changes to the codebase. Plan thoroughly and get user approval for the implementation approach before proceeding.

The command automatically:
- Finds the next leaf task (traverses subtasks recursively using dirflow patterns)
- Copies the plan template into the task directory
- Creates a customized implementation plan through interactive conversation
- Executes the plan using test-driven development (red-green-refactor cycles)
- Tracks progress with checkboxes in PLAN.md
- Handles completion, review, git commit, and cleanup

## Usage

```
/complete-next-task
```

The command will:
1. **Find next leaf task**: Use `ls tasks/ | sort` pattern to find first task, then recursively navigate to find leaf task (no subdirectories with README.md)
2. **Copy plan template**: Copy `templates/plan/` contents into the selected task directory
3. **Interactive planning**: Read task README.md and create customized PLAN.md through conversation
4. **Execute TDD workflow**: 
   - Create test scripts in `tests/` folder
   - Follow red-green-refactor cycles
   - Run `tests/run-tests.sh` to verify progress
   - Mark checkboxes in PLAN.md as cycles complete
5. **Review and commit**: Show completed work, get user approval, commit changes including task folder, then delete task folder

## Task Selection Logic

Uses dirflow's lexicographic ordering patterns:
- `ls tasks/ | grep -v '^\.' | sort` to get next task
- Recursive check: if task contains subdirectories with README.md files, traverse deeper
- Work on first leaf task found (no further subtasks)

## Test-Driven Development Workflow

1. **Red**: Write a failing test in `tests/XX-test-name.sh`
2. **Green**: Implement minimal code to make the test pass
3. **Refactor**: Improve the code while keeping tests passing
4. **Verify**: Run `tests/run-tests.sh` to ensure all tests pass
5. **Track**: Mark checkbox in PLAN.md and move to next cycle

## File Structure After Execution

```
tasks/XX-task-name/
├── README.md         # Original task definition
├── PLAN.md          # Implementation plan with progress checkboxes
└── tests/           # Test suite
    ├── run-tests.sh  # Test runner (from template)
    ├── 01-test-first-thing.sh
    └── 02-test-second-thing.sh
```

This ensures systematic, test-driven completion of all tasks with proper documentation and progress tracking.