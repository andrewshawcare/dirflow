# Filtering and Conditional Execution Example

This example demonstrates conditional processing using `.filter` and `.conditional` control files for data validation and routing.

## Structure
```
06-filtering/
├── filter/
│   ├── valid-data/                    # Self-contained filter workflow
│   │   ├── 01-generate.sh             # Generate numeric test data
│   │   ├── 01-validate.sh             # Validate input format
│   │   └── 02-process.sh              # Process valid data
│   └── skip-empty-workflow/           # Self-contained empty filter workflow
│       ├── 01-generate.sh             # Generate test data with empties
│       └── filter/
│           ├── .filter                # Skip empty inputs
│           ├── 01-check.sh            # Check for content
│           └── 02-count.sh            # Count characters
├── conditional/
│   ├── number-workflow/               # Self-contained number routing workflow
│   │   ├── 01-generate.sh             # Generate positive numbers
│   │   └── router/
│   │       ├── .conditional           # Route based on number value
│   │       ├── positive/
│   │       │   └── 01-square.sh       # Square positive numbers
│   │       └── negative/
│   │           └── 01-abs.sh          # Get absolute value
│   └── text-workflow/                 # Self-contained text routing workflow
│       ├── 01-generate.sh             # Generate mixed case text
│       └── router/
│           ├── .conditional           # Route based on text content
│           ├── uppercase/
│           │   └── 01-lower.sh        # Convert to lowercase
│           └── lowercase/
│               └── 01-upper.sh        # Convert to uppercase
└── README.md
```

## How it works

### Filter Examples
- **valid-data**: Self-contained workflow that generates numeric data and processes it through validation
- **skip-empty-workflow**: Self-contained workflow that generates test data (including empties) and filters out empty lines

### Conditional Examples  
- **number-workflow**: Self-contained workflow that generates positive numbers and routes them to squaring
- **text-workflow**: Self-contained workflow that generates mixed-case text and routes based on case

## Usage
```bash
# Self-contained workflows (no external input needed)
./dirflow.sh examples/06-filtering/filter/valid-data
./dirflow.sh examples/06-filtering/filter/skip-empty-workflow
./dirflow.sh examples/06-filtering/conditional/number-workflow
./dirflow.sh examples/06-filtering/conditional/text-workflow

# Alternative: test with custom data
echo "123" | ./dirflow.sh examples/06-filtering/filter/valid-data
echo "hello" | ./dirflow.sh examples/06-filtering/filter/skip-empty-workflow
echo "5" | ./dirflow.sh examples/06-filtering/conditional/number-workflow
echo "HELLO" | ./dirflow.sh examples/06-filtering/conditional/text-workflow
```

## Expected Outputs

**Valid data workflow** (self-contained):
```
Processed: 123 -> 246
Processed: 456 -> 912
Processed: 789 -> 1578
Processed: 42 -> 84
```

**Skip-empty workflow** (self-contained):
```
Non-empty content detected: 'First line of content

Second line after empty


Third line after multiple empties
Final line'
```

**Number workflow** (self-contained):
```
Positive 15 squared = 225
Positive 42 squared = 1764
Positive 7 squared = 49
Positive 100 squared = 10000
```

**Text workflow** (self-contained):
```
Converted to lowercase: hello world
Converted to lowercase: this is sample text
Converted to lowercase: with mixed case letters
Converted to lowercase: for demonstration purposes
```