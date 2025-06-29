# dirflow - Directory Pipeline Executor

*Your filesystem is the pipeline*

## Overview

dirflow executes scripts sequentially or in parallel based on directory structure and control files:
- Traverses directories in lexicographic order
- Pipes output between executable files
- Control files (`.loop`, `.parallel`, `.filter`, etc.) modify execution behavior

```bash
# Usage
./dirflow.sh /path/to/directory
echo "input" | ./dirflow.sh examples/01-basic-pipeline
```

## Control Files

- **`.loop`** - Iteration control (for/while/until/do-while)
- **`.parallel`** - Concurrent execution with output strategies
- **`.conditional`** - Branch to different directories based on conditions
- **`.filter`** - Skip processing based on conditions  
- **`.sample`** - Probabilistic or count-based sampling

Control files can be combined (e.g., `.loop` + `.parallel`).

## Examples

The `examples/` directory contains 8 comprehensive examples demonstrating dirflow's capabilities:

### 1. [Basic Pipeline](examples/01-basic-pipeline/README.md)
Sequential execution fundamentals. Generates numbers 1-10 (or custom limit), squares each number, and formats as a table. Demonstrates core dirflow behavior with data flowing between scripts.

### 2. [Data Processing](examples/02-data-processing/README.md) 
Practical text processing pipeline. Cleans input text, normalizes case/punctuation, and generates word frequency analysis. Shows real-world data transformation patterns.

### 3. [Simple Loop](examples/03-loop-simple/README.md)
Basic iteration with fixed count. Runs 3 iterations, incrementing input by 1 each time. Demonstrates how loops accumulate data across iterations using the `.loop` control file.

### 4. [Conditional Loops](examples/04-loop-conditional/README.md)
Advanced loop types in separate subdirectories:
- **while/**: Doubles numbers until ≥100 (3→6→12→24→48→96→192)
- **until/**: Increments until ≥10 (7→8→9→10)  
- **do-while/**: Decrements while >0 (5→4→3→2→1→0)

### 5. [Parallel Execution](examples/05-parallel-execution/README.md)
Concurrent processing with different output combination strategies:
- **concatenate/**: Preserves lexicographic order despite parallel execution
- **merge/**: Interleaves output lines from all scripts
- **first-last/**: Uses only first or last script output

### 6. [Filtering](examples/06-filtering/README.md)
Conditional execution and routing examples:
- **filter/**: Process only valid data (numbers vs text, non-empty vs empty)
- **conditional/**: Route data based on conditions (positive/negative numbers, uppercase/lowercase text)

### 7. [Sampling](examples/07-sampling/README.md)
Probabilistic and systematic data sampling:
- **random/**: 50% probability processing for load testing
- **low-probability/**: 10% probability for rare event simulation
- **first-n/**: Count-based sampling (≤3 lines pass through, >3 lines process)

### 8. [Advanced Combinations](examples/08-advanced-combinations/README.md)
Complex workflows combining multiple control structures:
- **loop-parallel/**: 3 iterations with parallel processing each iteration
- **data-processing-workflow/**: Multi-stage pipeline (sequential→parallel→conditional)
- **iterative-refinement/**: Parallel refinement processes across iterations

Each example includes working executable scripts, control files, and detailed README.md documentation with usage instructions and expected outputs.

## Quick Start

```bash
# Make dirflow executable
chmod +x dirflow.sh

# Try the examples
./dirflow.sh examples/01-basic-pipeline
echo "5" | ./dirflow.sh examples/01-basic-pipeline
echo "Hello World!" | ./dirflow.sh examples/02-data-processing
```