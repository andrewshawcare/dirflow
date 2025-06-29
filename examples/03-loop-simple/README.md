# Simple Loop Example

This example demonstrates basic loop functionality using the `.loop` control file with a fixed iteration count.

## Structure
```
03-loop-simple/
├── .loop            # Loop control file (type=for, count=3)
├── 01-input.sh      # Reads input or generates data
├── 02-increment.sh  # Adds 1 to each number
├── 03-output.sh     # Formats the result
└── README.md
```

## How it works
1. **Loop Control** - The `.loop` file specifies 3 iterations using `type=for`
2. **01-input.sh** - Reads initial data or generates starting number
3. **02-increment.sh** - Increments each number by 1
4. **03-output.sh** - Shows the current iteration result

Each iteration runs the entire pipeline (scripts 01-03), with output from one iteration becoming input to the next.

## Usage
```bash
# Run with default starting value (0)
./dirflow.sh examples/03-loop-simple

# Run with custom starting value
echo "10" | ./dirflow.sh examples/03-loop-simple
```

## Expected Output
Default (starting with 0):
```
3
```

With input "10":
```
13
```

This example shows how loops can accumulate data across iterations, with each iteration's output becoming the next iteration's input.