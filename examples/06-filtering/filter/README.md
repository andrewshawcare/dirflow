# Filter Examples

This directory contains self-contained filter workflows that demonstrate how to conditionally process or skip data based on input validation.

## Structure
```
filter/
├── valid-data/                    # Complete data validation workflow
│   ├── 01-generate.sh             # Generates numeric test data
│   ├── 01-validate.sh             # Validates and labels input
│   └── 02-process.sh              # Processes validated data
├── skip-empty-workflow/           # Complete empty-line filtering workflow
│   ├── 01-generate.sh             # Generates data with empty lines
│   └── filter/
│       ├── .filter                # Skips empty input
│       ├── 01-check.sh            # Checks for content presence
│       └── 02-count.sh            # Counts characters in content
└── README.md
```

## How it works

### Valid Data Workflow
1. **01-generate.sh** - Creates numeric data for processing
2. **01-validate.sh** - Labels valid numbers as "Valid number: X"  
3. **02-process.sh** - Processes valid numbers (doubles them)

### Skip-Empty Workflow
1. **01-generate.sh** - Creates test data including empty lines
2. **filter/.filter** - Skips processing if input is empty
3. **filter/01-check.sh** - Detects and reports non-empty content
4. **filter/02-count.sh** - Counts characters in the content

## Usage
```bash
# Self-contained workflows
./dirflow.sh examples/06-filtering/filter/valid-data
./dirflow.sh examples/06-filtering/filter/skip-empty-workflow

# Test with custom input
echo "123" | ./dirflow.sh examples/06-filtering/filter/valid-data
echo "abc" | ./dirflow.sh examples/06-filtering/filter/valid-data  # Will be filtered out
echo "hello" | ./dirflow.sh examples/06-filtering/filter/skip-empty-workflow
echo "" | ./dirflow.sh examples/06-filtering/filter/skip-empty-workflow  # Will be skipped
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

These examples demonstrate how `.filter` control files enable data validation and conditional processing, ensuring only appropriate data flows through the pipeline.