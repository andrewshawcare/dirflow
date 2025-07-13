# Advanced Combinations Example

This example demonstrates complex workflows using multiple control structures together, showing real-world pipeline scenarios.

## Structure
```
08-advanced-combinations/
├── loop-parallel/
│   ├── .loop            # Loop 3 times
│   ├── .parallel        # Process items in parallel each iteration
│   ├── 01-generate.sh   # Generate data
│   ├── 02-transform.sh  # Transform data
│   └── 03-collect.sh    # Collect results
├── data-processing-workflow/
│   ├── input/
│   │   ├── 01-load.sh   # Load data
│   │   └── 02-validate.sh # Validate format
│   ├── processing/
│   │   ├── .parallel    # Parallel processing
│   │   ├── 01-clean.sh  # Clean data
│   │   ├── 02-analyze.sh # Analyze data
│   │   └── 03-enrich.sh # Enrich data
│   └── output/
│       ├── .conditional # Route based on results
│       ├── success/
│       │   └── 01-save.sh # Save successful results
│       └── error/
│           └── 01-log.sh  # Log errors
├── iterative-refinement/
│   ├── .loop            # Loop until quality threshold met
│   ├── refinement/
│   │   ├── .parallel    # Parallel refinement processes
│   │   ├── 01-improve.sh # Improve quality
│   │   ├── 02-verify.sh  # Verify improvements
│   │   └── 03-score.sh   # Calculate quality score
│   └── 02-check.sh      # Check if done
└── README.md
```

## How it works

### Loop + Parallel (`loop-parallel/`)
- Combines `.loop` and `.parallel` in same directory
- Each loop iteration runs scripts in parallel
- Shows accumulation across parallel iterations

### Data Processing Workflow (`data-processing-workflow/`)
- Multi-stage pipeline with different controls at each stage
- Sequential input → Parallel processing → Conditional output
- Demonstrates real data processing patterns

### Iterative Refinement (`iterative-refinement/`)
- Loop runs fixed number of iterations (simplified)
- Each iteration uses parallel refinement processes  
- Shows combination of loops and parallel processing

## Examples
```bash
# Test loop + parallel combination
echo "initial data" | ./dirflow.sh examples/08-advanced-combinations/loop-parallel

# Test data processing workflow
echo "raw,data,here" | ./dirflow.sh examples/08-advanced-combinations/data-processing-workflow

# Test iterative refinement (3 iterations of parallel refinement)
echo "5" | ./dirflow.sh examples/08-advanced-combinations/iterative-refinement
```

## Expected Outputs

**Loop + Parallel**: 3 iterations, each with parallel processing of 3 scripts
**Data Workflow**: Sequential load/validate → Parallel clean/analyze/enrich → Conditional save/log
**Iterative Refinement**: 3 iterations of parallel refinement processes

These examples show how dirflow's control structures can be combined to create sophisticated processing pipelines for real-world scenarios.