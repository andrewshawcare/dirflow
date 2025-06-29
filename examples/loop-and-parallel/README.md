# Loop and Parallel Example

This example demonstrates how to combine `loop.control` and `parallel.control` files in a directory.

- The `loop.control` file sets up 2 iterations.
- The `parallel.control` file specifies all items are executed in parallel and outputs are concatenated.
- Each script outputs a different letter.

## Files
- `01-echo-a.sh`: Outputs `a`.
- `02-echo-b.sh`: Outputs `b`.
- `03-echo-c.sh`: Outputs `c`.
- `loop.control`: Sets up a for loop with 2 iterations.
- `parallel.control`: Sets up parallel execution with concatenate strategy.

## Usage
```bash
dirflow examples/loop-and-parallel
```

## Expected Output
```
a
b
c
a
b
c
```
(Output order may vary due to parallelism)
