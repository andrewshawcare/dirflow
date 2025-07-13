# Create Task

Create a new structured task in the `tasks/` directory through an interactive conversation.

**Think carefully** about the task structure and plan the interactive conversation before beginning. Read the current task template from `templates/task/README.md` to understand what information needs to be gathered, then guide through an interactive conversation to collect all necessary details.

**IMPORTANT**: Do not make any file changes until the task is fully defined through our conversation. Plan the task creation process first.

Once the task is fully defined, it will be automatically:
- Added to the `tasks/` folder with proper numbering (e.g., `tasks/03-new-task-name/`)
- Created using the task template with all gathered information
- Reviewed against the current template to identify potential improvements

## Usage

```
/create-task
```

The command will:
1. Read the task template to determine what questions to ask
2. Start an interactive conversation based on the template structure
3. Create the task files when all information is gathered
4. Review the template for potential improvements

This ensures the command stays synchronized with any template changes.