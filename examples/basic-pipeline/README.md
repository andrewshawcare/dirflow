# Basic Pipeline Example

This example demonstrates the default sequential execution behavior of dirflow.

- All executable files in this directory are run in lexicographic order.
- Output from each script is piped to the next.
- No control files are present, so the pipeline acts as a simple chain.

## Files
- `01-input.sh`: Produces initial data (a list of numbers).
- `02-process.sh`: Sorts and doubles each number.
- `03-output.sh`: Displays the final result.

## Usage
```bash
dirflow examples/basic-pipeline
```

## Expected Output
```
34
84
198
```