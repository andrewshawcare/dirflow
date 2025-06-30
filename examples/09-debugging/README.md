# Debug Control Examples

The `.debug` control file enables input/output logging for pipeline development and troubleshooting. This directory contains examples showing both basic and advanced usage patterns.

## Overview

The debug control logs all data flowing into and out of each script in your pipeline, with timestamps and full script paths for complete traceability.

### Debug Control Format

```bash
# Basic configuration (uses default log files)
enabled=true

# Advanced configuration (custom log file paths)
enabled=true
input_log="custom/input.log"
output_log="custom/output.log"
```

## Examples

### [Basic Example](basic/README.md)
Demonstrates fundamental debug logging with default settings:
- Simple `.debug` configuration (`enabled=true`)
- Default log files (`debug_input.log`, `debug_output.log`)
- Sequential processing through three scripts
- Clear script-level traceability

**Usage:** `./dirflow.sh examples/09-debugging/basic`

### [Advanced Example](advanced/README.md) 
Shows advanced features with custom configuration:
- Custom log file paths in subdirectory (`debug/pipeline_*.log`)
- Complex conditional processing logic
- Input validation and type-specific transformations
- Organized directory structure

**Usage:** `./dirflow.sh examples/09-debugging/advanced`

## Debug Log Format

Debug logs use a consistent format showing timestamp, script path, phase, and data:

```
[TIMESTAMP] [FULL/SCRIPT/PATH] PHASE: DATA
```

**Example:**
```
[2025-06-30 11:16:08] [examples/09-debugging/basic] input: test-data
[2025-06-30 11:16:08] [examples/09-debugging/basic/01-start.sh] input: test-data
[2025-06-30 11:16:08] [examples/09-debugging/basic/01-start.sh] output: Processing: test-data
```

## Key Features

- **Script-level traceability**: Full path shows exactly which script processed data
- **Non-intrusive**: Debug logging doesn't affect pipeline execution or output
- **Parallel-safe**: Unique log files for concurrent execution (with PID suffixes)
- **Configurable paths**: Custom log file locations and names
- **Composable**: Works with all other dirflow controls (`.loop`, `.parallel`, etc.)

## When to Use Debug Logging

- **Pipeline development**: Understanding data flow during implementation
- **Troubleshooting**: Identifying where data transformation issues occur
- **Performance analysis**: Tracking data changes across processing steps
- **Complex workflows**: Debugging interactions between multiple controls
- **Production monitoring**: Logging specific pipeline executions for audit trails