# Parallel Execution Example

This example demonstrates the use of the `parallel.control` file to execute directory items concurrently.

- The `parallel.control` file specifies `merge` as the combine strategy and 3 workers.
- Each script outputs a different string.

## Files
- `01-echo-foo.sh`: Outputs `foo`.
- `02-echo-bar.sh`: Outputs `bar`.
- `03-echo-baz.sh`: Outputs `baz`.
- `parallel.control`: Sets up parallel execution with merge strategy.

## Usage
```bash
dirflow examples/parallel-execution
```

## Expected Output
```
foo
bar
baz
```
(Output order may vary due to parallelism)
