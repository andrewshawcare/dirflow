# Basic Debug Control Example

This example demonstrates the basic usage of the `.debug` control file for logging input/output data during pipeline execution.

## Files

- `.debug` - Basic debug control configuration
- `01-start.sh` - Initial data processing script
- `02-process.sh` - Data transformation script  
- `03-finalize.sh` - Final processing script

## Debug Control Format

```bash
# Simple debug configuration - uses default log files
enabled=true
```

This creates:
- `debug_input.log` - Input data to each processing step
- `debug_output.log` - Output data from each processing step

## Usage

```bash
# Run basic debug example
./dirflow.sh examples/09-debugging/basic

# Run with custom input
echo "test-data" | ./dirflow.sh examples/09-debugging/basic
```

## Expected Output

**Console Output:**
```
Processing: test-data -> processed -> completed
```

**Debug Log Files:**

`debug_input.log`:
```
[2025-06-30 11:16:08] [examples/09-debugging/basic] input: test-data
[2025-06-30 11:16:08] [examples/09-debugging/basic/01-start.sh] input: test-data
[2025-06-30 11:16:08] [examples/09-debugging/basic/02-process.sh] input: Processing: test-data
[2025-06-30 11:16:08] [examples/09-debugging/basic/03-finalize.sh] input: Processing: test-data -> processed
```

`debug_output.log`:
```
[2025-06-30 11:16:08] [examples/09-debugging/basic/01-start.sh] output: Processing: test-data
[2025-06-30 11:16:08] [examples/09-debugging/basic/02-process.sh] output: Processing: test-data -> processed
[2025-06-30 11:16:08] [examples/09-debugging/basic/03-finalize.sh] output: Processing: test-data -> processed -> completed
[2025-06-30 11:16:08] [examples/09-debugging/basic] output: Processing: test-data -> processed -> completed
```

## Key Features

- **Script-level traceability**: Each log entry shows the exact script that processed the data
- **Default log files**: Simple configuration with standard file names
- **Sequential execution**: Clear progression through each processing step
- **Non-intrusive**: Debug logging doesn't affect pipeline execution or output