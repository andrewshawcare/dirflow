# Data Processing Example

This example demonstrates a simple data cleaning and transformation pipeline using dirflow.

- Each script performs a different transformation step in sequence.

## Files
- `01-clean.sh`: Removes empty lines from input.
- `02-uppercase.sh`: Converts input to uppercase.
- `03-count.sh`: Counts the number of lines.

## Usage
```bash
echo -e "foo\n\nbar\nbaz\n" | dirflow examples/data-processing
```

## Expected Output
```
3
```
