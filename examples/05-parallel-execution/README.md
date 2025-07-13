# Parallel Execution Example

This example demonstrates concurrent processing using the `.parallel` control file with different output combination strategies.

## Structure
```
05-parallel-execution/
├── concatenate/
│   ├── .parallel        # combine=concatenate (default)
│   ├── 01-fast.sh       # Quick processing
│   ├── 02-medium.sh     # Medium processing
│   └── 03-slow.sh       # Slower processing
├── merge/
│   ├── .parallel        # combine=merge (interleave)
│   ├── 01-letters.sh    # Generate letters
│   ├── 02-numbers.sh    # Generate numbers
│   └── 03-symbols.sh    # Generate symbols
├── first-last/
│   ├── first/
│   │   ├── .parallel    # combine=first
│   │   ├── 01-alpha.sh  # Process A
│   │   ├── 02-beta.sh   # Process B
│   │   └── 03-gamma.sh  # Process C
│   └── last/
│       ├── .parallel    # combine=last
│       ├── 01-alpha.sh  # Process A
│       ├── 02-beta.sh   # Process B
│       └── 03-gamma.sh  # Process C
└── README.md
```

## How it works

### Concatenate Strategy (`concatenate/`)
- All scripts run in parallel
- Outputs are joined in original lexicographic order
- Default behavior if no strategy specified

### Merge Strategy (`merge/`)
- Scripts run in parallel
- Outputs are interleaved line-by-line (round-robin)
- Useful for mixing different data streams

### First/Last Strategies (`first-last/`)
- **First**: Only uses output from first script (lexicographically)
- **Last**: Only uses output from last script (lexicographically)
- Other scripts still run but output is discarded

## Examples
```bash
# Test concatenate strategy
echo "data" | ./dirflow.sh examples/05-parallel-execution/concatenate

# Test merge strategy  
echo "input" | ./dirflow.sh examples/05-parallel-execution/merge

# Test first strategy
echo "test" | ./dirflow.sh examples/05-parallel-execution/first-last/first

# Test last strategy
echo "test" | ./dirflow.sh examples/05-parallel-execution/first-last/last
```

## Expected Outputs

**Concatenate**: Scripts run in parallel but output preserves order
**Merge**: Output lines are interleaved from all scripts
**First**: Only shows output from 01-alpha.sh
**Last**: Only shows output from 03-gamma.sh