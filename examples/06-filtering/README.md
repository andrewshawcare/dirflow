# Filtering and Conditional Execution Example

This example demonstrates conditional processing using `.filter` and `.conditional` control files for data validation and routing.

## Structure
```
06-filtering/
├── filter/
│   ├── valid-data/
│   │   ├── .filter          # Only process valid data
│   │   ├── 01-validate.sh   # Validate input format
│   │   └── 02-process.sh    # Process valid data
│   └── skip-empty/
│       ├── .filter          # Skip empty inputs
│       ├── 01-check.sh      # Check for content
│       └── 02-count.sh      # Count characters
├── conditional/
│   ├── number-router/
│   │   ├── .conditional     # Route based on number value
│   │   ├── positive/
│   │   │   └── 01-square.sh # Square positive numbers
│   │   └── negative/
│   │       └── 01-abs.sh    # Get absolute value
│   └── text-router/
│       ├── .conditional     # Route based on text content
│       ├── uppercase/
│       │   └── 01-lower.sh  # Convert to lowercase
│       └── lowercase/
│           └── 01-upper.sh  # Convert to uppercase
└── README.md
```

## How it works

### Filter Examples
- **valid-data**: Only processes input that matches a pattern (numbers)
- **skip-empty**: Skips processing if input is empty, passes through otherwise

### Conditional Examples  
- **number-router**: Routes positive numbers to squaring, negative to absolute value
- **text-router**: Routes uppercase text to lowercase conversion, vice versa

## Usage
```bash
# Test valid data filter
echo "123" | ./dirflow.sh examples/06-filtering/filter/valid-data
echo "abc" | ./dirflow.sh examples/06-filtering/filter/valid-data

# Test empty filter
echo "hello" | ./dirflow.sh examples/06-filtering/filter/skip-empty
echo "" | ./dirflow.sh examples/06-filtering/filter/skip-empty

# Test number routing
echo "5" | ./dirflow.sh examples/06-filtering/conditional/number-router
echo "-3" | ./dirflow.sh examples/06-filtering/conditional/number-router

# Test text routing
echo "HELLO" | ./dirflow.sh examples/06-filtering/conditional/text-router
echo "world" | ./dirflow.sh examples/06-filtering/conditional/text-router
```

## Expected Outputs

**Valid data filter**: Processes "123", skips "abc"
**Empty filter**: Processes "hello", passes through empty input
**Number router**: Squares 5 → 25, gets absolute of -3 → 3
**Text router**: "HELLO" → "hello", "world" → "WORLD"