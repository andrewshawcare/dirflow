# Basic Pipeline Example

This example demonstrates the core functionality of dirflow: sequential execution of scripts with data flowing between them.

## Structure
```
01-basic-pipeline/
├── 01-generate.sh    # Generates sample data
├── 02-process.sh     # Transforms the data
├── 03-format.sh      # Formats the output
└── README.md
```

## How it works
1. **01-generate.sh** - Creates a list of numbers from 1-10
2. **02-process.sh** - Squares each number 
3. **03-format.sh** - Formats as a nice table

## Usage
```bash
# Run the pipeline
./dirflow.sh examples/01-basic-pipeline

# Or with input
echo "5" | ./dirflow.sh examples/01-basic-pipeline
```

## Expected Output
```
Number | Square
-------|-------
1      | 1
2      | 4
3      | 9
4      | 16
5      | 25
6      | 36
7      | 49
8      | 64
9      | 81
10     | 100
```

This example shows dirflow's fundamental behavior: executable files are run in lexicographic order, with output piped between them.