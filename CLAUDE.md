# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

dirflow is a directory-based pipeline executor where the filesystem structure defines the execution flow. It's a bash-based tool that executes scripts sequentially or in parallel based on directory structure and control files.

**Core concept**: Your filesystem is the pipeline. Scripts are executed in lexicographic order with output piped between them, modified by control files.

## Key Commands

```bash
# Make dirflow executable (required first step)
chmod +x dirflow.sh

# Basic execution
./dirflow.sh /path/to/directory

# With input piped in
echo "input" | ./dirflow.sh examples/01-basic-pipeline

# Testing examples
./dirflow.sh examples/01-basic-pipeline
echo "5" | ./dirflow.sh examples/01-basic-pipeline
echo "Hello World!" | ./dirflow.sh examples/02-data-processing
```

## Architecture

### Core Script: dirflow.sh
- Main entry point at `/Users/andrew/dirflow/dirflow.sh`
- Bash script with strict error handling (`set -e`, `set -o pipefail`)
- Traverses directories lexicographically, executing scripts and piping output
- Built-in debug logging system with timestamp and location tracking

### Control Files System
Control files modify execution behavior and are sourced as shell scripts:

- **`.loop`** - Iteration control (for/while/until/do-while types)
- **`.parallel`** - Concurrent execution with configurable output combination strategies
- **`.conditional`** - Branch to different directories based on runtime conditions  
- **`.filter`** - Skip processing based on conditions
- **`.sample`** - Probabilistic or count-based sampling
- **`.debug`** - Debug logging configuration (enabled, input_log, output_log paths)

Control files can be combined for complex behaviors (e.g., `.loop` + `.parallel`).

### Directory Structure
```
dirflow.sh                 # Main executable
examples/                  # 9 comprehensive example workflows
├── 01-basic-pipeline/     # Sequential execution fundamentals
├── 02-data-processing/    # Text processing pipeline  
├── 03-loop-simple/        # Basic iteration with fixed count
├── 04-loop-conditional/   # while/until/do-while loop types
├── 05-parallel-execution/ # Concurrent processing strategies
├── 06-filtering/          # Conditional execution and routing
├── 07-sampling/           # Probabilistic and systematic sampling
├── 08-advanced-combinations/ # Complex multi-control workflows
└── 09-debugging/          # Debug logging examples
```

### Script Execution Model
1. Scripts execute in lexicographic order within directories
2. Output pipes between consecutive scripts
3. Control files modify this flow (loops, parallel execution, conditionals)
4. Debug logging tracks input/output at each stage with timestamps
5. Parallel execution uses PID suffixes for unique log files

## Development Notes

- No traditional build/test/lint commands - this is a bash utility
- All executable scripts use `#!/bin/bash` shebang
- Examples serve as both documentation and functional tests
- Debug logging supports parallel execution safety
- Control files use shell variable syntax for configuration

## Testing

Run the examples to verify functionality:
```bash
# Test basic pipeline
./dirflow.sh examples/01-basic-pipeline

# Test with various inputs
echo "test data" | ./dirflow.sh examples/02-data-processing
echo "10" | ./dirflow.sh examples/03-loop-simple
```

Each example directory contains a README.md with expected outputs for verification.