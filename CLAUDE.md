# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

dirflow is a directory-based pipeline executor where the filesystem structure defines the execution flow. It's a bash-based tool that executes scripts sequentially or in parallel based on directory structure and control files.

**Core concept**: Your filesystem is the pipeline. Scripts are executed in lexicographic order with output piped between them, modified by control files.

## Key Commands

```bash
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
- Main entry point at `dirflow.sh`
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

- No traditional build/lint commands - this is a bash utility
- All executable scripts use `#!/bin/bash` shebang
- Examples serve as both documentation and functional tests
- Debug logging supports parallel execution safety
- Control files use shell variable syntax for configuration

## Testing

```bash
# Run all tests
tests/run-tests.sh

# Run examples manually
./dirflow.sh examples/01-basic-pipeline
echo "test data" | ./dirflow.sh examples/02-data-processing
```

Comprehensive test suite in `tests/` validates all examples. Each example directory contains a README.md with expected outputs.

## Communication Style

Use technical tone: precise, factual, minimal embellishment. Prioritize accuracy and clarity over verbosity.

## Philosophy

**Prefer simplicity over verbosity:**

- Write the minimal code/documentation needed to solve the problem
- Avoid redundant examples, explanations, or guidelines
- One clear pattern is better than multiple examples
- Code and documentation should be precise, not comprehensive
- When adding guidelines or rules, state the single clear principle, not examples of what not to do