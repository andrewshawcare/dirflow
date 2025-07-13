# Data Processing Pipeline Example

This example demonstrates practical text processing using dirflow to clean, transform, and analyze data.

## Structure
```
02-data-processing/
├── 01-generate.sh   # Generates sample text data for processing
├── 02-clean.sh      # Removes empty lines and trims whitespace
├── 03-normalize.sh  # Converts to lowercase and removes punctuation
├── 04-count.sh      # Counts word frequency
└── README.md
```

## How it works
1. **01-generate.sh** - Generates sample text data with varied content for processing demonstration
2. **02-clean.sh** - Cleans up the input by removing empty lines and trimming whitespace
3. **03-normalize.sh** - Normalizes text by converting to lowercase and removes punctuation
4. **04-count.sh** - Counts word frequency and sorts by most common

## Usage
```bash
# Self-contained execution with generated data
./dirflow.sh examples/02-data-processing

# Process custom text
echo -e 'Hello World!\nThis is a test.\n\nHello again!' | ./dirflow.sh examples/02-data-processing

# Process a file
cat textfile.txt | ./dirflow.sh examples/02-data-processing
```

## Expected Output
```
Word frequency analysis:
processing: 4
words: 2
mixed: 2
for: 2
demonstration: 2
and: 2
with: 1
will: 1
varied: 1
too: 1
this: 1
text: 1
symbols: 1
some: 1
sample: 1
repeat: 1
purposes: 1
punctuation: 1
numbers: 1
more: 1
lines: 1
line: 1
like: 1
it: 1
is: 1
included: 1
in: 1
final: 1
empty: 1
content: 1
contains: 1
case: 1
be: 1
are: 1
123: 1
```

This example shows how dirflow can be used for real-world text processing tasks, with each stage building on the previous one's output.