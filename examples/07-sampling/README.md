# Sampling Example

This example demonstrates stochastic processing using the `.sample` control file for probabilistic and systematic data sampling.

## Structure
```
07-sampling/
├── random/
│   ├── .sample          # Random sampling with 50% probability
│   ├── 01-generate.sh   # Generate test data
│   └── 02-process.sh    # Process sampled data
├── low-probability/
│   ├── .sample          # Random sampling with 10% probability
│   ├── 01-generate.sh   # Generate test data
│   └── 02-process.sh    # Process sampled data
├── first-n/
│   ├── .sample          # Sample first N items
│   ├── 01-generate.sh   # Generate test data
│   └── 02-process.sh    # Process sampled data
└── README.md
```

## How it works

### Random Sampling (`random/`)
- Uses `type=random` with `probability=0.5` (50% chance)
- Each run may or may not execute the pipeline
- Demonstrates basic stochastic behavior

### Low Probability (`low-probability/`)
- Uses `type=random` with `probability=0.1` (10% chance)
- Shows how to adjust sampling rates
- Most runs will skip processing

### First N Sampling (`first-n/`)
- Uses `type=first` with `count=3`
- Only processes if input has 3 or fewer lines
- Demonstrates count-based sampling

## Examples
```bash
# Test random sampling (50% chance) - run multiple times
for i in {1..5}; do 
    echo "Test $i" | ./dirflow.sh examples/07-sampling/random
    echo "---"
done

# Test low probability sampling (10% chance) - run many times
for i in {1..10}; do 
    echo "Test $i" | ./dirflow.sh examples/07-sampling/low-probability
    echo "---"
done

# Test first-n sampling - with few lines (should pass through)
echo -e "line1\nline2" | ./dirflow.sh examples/07-sampling/first-n

# Test first-n sampling - with many lines (should process)
echo -e "line1\nline2\nline3\nline4\nline5" | ./dirflow.sh examples/07-sampling/first-n
```

## Expected Outputs

**Random sampling**: Sometimes processes, sometimes doesn't
**Low probability**: Rarely processes (1 in 10 times on average)
**First-n**: Passes through when input has few lines, processes when many lines

This demonstrates how sampling can be used for:
- Load testing with probabilistic traffic
- Data sampling for analysis
- Conditional processing based on data size