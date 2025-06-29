# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

dirflow is a directory pipeline executor that treats the filesystem as the pipeline. Single bash script (`dirflow.sh`) with control files that modify execution behavior.

## Architecture

- **Core**: `dirflow.sh` - single bash script with all logic
- **Control files**: `.loop`, `.parallel`, `.filter`, `.conditional`, `.sample`
- **Pipeline definition**: Directory structure and executable files
- **Execution**: Lexicographic order, pipes between executables

## Usage

```bash
./dirflow.sh /path/to/directory
echo "input" | ./dirflow.sh examples/01-basic-pipeline
chmod +x dirflow.sh
```

## Examples

8 comprehensive examples in `examples/01-basic-pipeline/` through `examples/08-advanced-combinations/`. Each includes working scripts, control files, and README.md documentation.

## Critical Development Notes

### Control File Syntax (Common Issues)
- **Loop conditions**: Use `"read num && [ \$num -lt 100 ]"` not `"[ $(cat) -lt 100 ]"`
- **Variable escaping**: Use `\$var` in conditions to prevent early expansion  
- **Conditional paths**: Resolved relative to control file directory
- **Stdin consumption**: Avoid `$(cat)` which consumes stdin twice

### Implementation Details
- All control structures fully implemented and tested
- Safety limit: 1000 iterations maximum
- Control files automatically excluded from execution
- Single bash script for portability

### Testing
```bash
# Validate all examples
for i in {01..08}; do ./dirflow.sh examples/$i-*/; done
```