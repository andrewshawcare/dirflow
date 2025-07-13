# Conditional Loop Example

This example demonstrates advanced loop types that depend on conditions: `while`, `until`, and `do-while`.

## Structure
```
04-loop-conditional/
├── while/
│   ├── .loop            # Loop while condition is true
│   ├── 01-input.sh      # Process input number
│   └── 02-double.sh     # Double the number
├── until/
│   ├── .loop            # Loop until condition becomes true
│   ├── 01-input.sh      # Process input number
│   └── 02-increment.sh  # Add 1 to number
├── do-while/
│   ├── .loop            # Run at least once, continue while condition true
│   ├── 01-input.sh      # Process input number
│   └── 02-decrement.sh  # Subtract 1 from number
└── README.md
```

## How it works

### While Loop (`while/`)
- Continues while the number is less than 100
- Doubles the number each iteration
- Stops when number >= 100

### Until Loop (`until/`)
- Runs at least once, then stops when number >= 10
- Increments by 1 each iteration

### Do-While Loop (`do-while/`)
- Always runs at least once
- Continues while number > 0
- Decrements by 1 each iteration

## Examples
```bash
# Test while loop - doubles until >= 100
echo "3" | ./dirflow.sh examples/04-loop-conditional/while

# Test until loop - increments until >= 10
echo "7" | ./dirflow.sh examples/04-loop-conditional/until

# Test do-while loop - decrements while > 0
echo "5" | ./dirflow.sh examples/04-loop-conditional/do-while
```

## Expected Outputs

**While loop** (starting with 3):
```
192
```

**Until loop** (starting with 7):
```
10
```

**Do-while loop** (starting with 5):
```
0
```