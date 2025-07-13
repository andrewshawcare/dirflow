# Conditional Routing Examples

This directory contains self-contained conditional routing workflows that demonstrate how to route data to different processing paths based on runtime conditions.

## Structure
```
conditional/
├── number-workflow/               # Complete number routing workflow
│   ├── 01-generate.sh             # Generates positive numbers
│   └── router/
│       ├── .conditional           # Routes based on number sign
│       ├── positive/
│       │   └── 01-square.sh       # Squares positive numbers
│       └── negative/
│           └── 01-abs.sh          # Gets absolute value of negatives
├── text-workflow/                 # Complete text routing workflow
│   ├── 01-generate.sh             # Generates mixed-case text
│   └── router/
│       ├── .conditional           # Routes based on text case
│       ├── uppercase/
│       │   └── 01-lower.sh        # Converts uppercase to lowercase
│       └── lowercase/
│           └── 01-upper.sh        # Converts lowercase to uppercase
└── README.md
```

## How it works

### Number Workflow
1. **01-generate.sh** - Creates positive numbers for demonstration
2. **router/.conditional** - Evaluates the first line and routes to:
   - **positive/** - If number is positive (squares the numbers)
   - **negative/** - If number is negative (gets absolute value)

### Text Workflow  
1. **01-generate.sh** - Creates text with mixed case letters
2. **router/.conditional** - Evaluates the first line and routes to:
   - **uppercase/** - If first line contains uppercase letters (converts to lowercase)
   - **lowercase/** - If first line is all lowercase (converts to uppercase)

## Usage
```bash
# Self-contained workflows
./dirflow.sh examples/06-filtering/conditional/number-workflow
./dirflow.sh examples/06-filtering/conditional/text-workflow

# Test with custom input
echo "5" | ./dirflow.sh examples/06-filtering/conditional/number-workflow
echo "-3" | ./dirflow.sh examples/06-filtering/conditional/number-workflow
echo "HELLO" | ./dirflow.sh examples/06-filtering/conditional/text-workflow
echo "world" | ./dirflow.sh examples/06-filtering/conditional/text-workflow
```

## Expected Outputs

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

These examples demonstrate how `.conditional` control files enable dynamic routing based on data content, creating flexible processing pipelines.