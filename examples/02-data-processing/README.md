# Data Processing Pipeline Example

This example demonstrates practical text processing using dirflow to clean, transform, and analyze data.

## Structure
```
02-data-processing/
├── 01-clean.sh      # Removes empty lines and trims whitespace
├── 02-normalize.sh  # Converts to lowercase and removes punctuation
├── 03-count.sh      # Counts word frequency
└── README.md
```

## How it works
1. **01-clean.sh** - Cleans up the input by removing empty lines and trimming whitespace
2. **02-normalize.sh** - Normalizes text by converting to lowercase and removing punctuation
3. **03-count.sh** - Counts word frequency and sorts by most common

## Usage
```bash
# Process sample text
echo -e 'Hello World!\nThis is a test.\n\nHello again!' | ./dirflow.sh examples/02-data-processing

# Process a file
cat textfile.txt | ./dirflow.sh examples/02-data-processing
```

## Expected Output
```
Word frequency analysis:
hello: 2
world: 1
this: 1
test: 1
is: 1
again: 1
a: 1
```

This example shows how dirflow can be used for real-world text processing tasks, with each stage building on the previous one's output.