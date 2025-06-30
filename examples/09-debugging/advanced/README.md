# Advanced Debug Control Example

This example demonstrates advanced usage of the `.debug` control file with custom log file paths and more complex processing logic.

## Files

- `.debug` - Advanced debug control configuration with custom log paths
- `01-validate.sh` - Input validation script (numbers vs text)
- `02-transform.sh` - Conditional transformation script
- `debug/` - Custom directory for debug log files

## Debug Control Format

```bash
# Advanced debug configuration with custom log file paths
enabled=true
input_log="debug/pipeline_input.log"
output_log="debug/pipeline_output.log"
```

This creates custom log files in the `debug/` subdirectory instead of the default locations.

## Processing Logic

The scripts demonstrate more complex conditional processing:

1. **01-validate.sh**: Determines if input is numeric or text data
2. **02-transform.sh**: Applies different transformations based on validation result

## Usage

```bash
# Run advanced debug example with text input
echo "hello world" | ./dirflow.sh examples/09-debugging/advanced

# Run with numeric input
echo "42" | ./dirflow.sh examples/09-debugging/advanced
```

## Expected Output

**Text Input ("hello world"):**

Console Output:
```
Text data: hello world | uppercase
```

**Numeric Input ("42"):**

Console Output:
```
Valid number: 42 | squared
```

## Debug Log Files

**debug/pipeline_input.log:**
```
[2025-06-30 11:17:54] [examples/09-debugging/advanced] input: hello world
[2025-06-30 11:17:54] [examples/09-debugging/advanced/01-validate.sh] input: hello world
[2025-06-30 11:17:54] [examples/09-debugging/advanced/02-transform.sh] input: Text data: hello world
```

**debug/pipeline_output.log:**
```
[2025-06-30 11:17:54] [examples/09-debugging/advanced/01-validate.sh] output: Text data: hello world
[2025-06-30 11:17:54] [examples/09-debugging/advanced/02-transform.sh] output: Text data: hello world | uppercase
[2025-06-30 11:17:54] [examples/09-debugging/advanced] output: Text data: hello world | uppercase
```

## Key Features

- **Custom log paths**: Configure debug files in any directory structure
- **Complex processing**: Demonstrates conditional logic and data type handling
- **Script-level traceability**: Full path tracking for each processing step
- **Directory organization**: Clean separation of logs from processing scripts
- **Flexible configuration**: Shows how to adapt debug logging to different workflows