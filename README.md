# dirflow - Directory Pipeline Executor

*Your filesystem is the pipeline*

## Core Functionality

**Basic Operation (no control files):**
- Traverses directories using `ls` lexicographic ordering
- Executes all executable files sequentially
- Pipes output from one executable to the next
- Treats directories as transparent groupings
- Non-executable files are ignored
- Hidden files/directories are skipped (except control files)
- Acts as identity function if no executables found

```bash
# Usage
dirflow /path/to/directory
echo "input" | dirflow .
```

## Implemented Control Structures

### 1. `.loop` - Iteration Control
Repeats execution of directory contents based on typed conditions.

**Control File Format:**
```bash
type=<loop_type>        # Required: for|while|until|do-while
condition=<shell_expr>  # Shell expression evaluated with output as stdin
count=<number>          # For 'for' loops only
```

**Loop Types:**
- `for`: Fixed iterations using `count`
- `while`: Continue while condition is true
- `until`: Run at least once, stop when condition becomes true  
- `do-while`: Run at least once, continue while condition is true

**Example:**
```bash
# .loop
type=while
condition="[ $(wc -l) -lt 100 ]"  # Loop while less than 100 lines
```

### 2. `.parallel` - Concurrent Execution
Executes all items at the same directory level in parallel.

**Control File Format:**
```bash
combine=<strategy>   # How to combine outputs: concatenate|first|last|merge
workers=<number>     # Max parallel workers (0 = unlimited)
```

**Combine Strategies:**
- `concatenate`: Join outputs in original lexicographic order (default)
- `first`: Use only the first item's output
- `last`: Use only the last item's output
- `merge`: Line-by-line round-robin interleaving

**Example:**
```bash
# .parallel  
combine=merge
workers=4
```

### 3. Combined `.loop` + `.parallel`
When both exist in the same directory:
- Loop provides outer iteration control
- Each iteration executes items in parallel
- Combined parallel output feeds to next iteration

## Proposed Control Structures

### 4. `.conditional` - Branching Logic
Routes execution to different paths based on conditions.

**Control File Format:**
```bash
type=<conditional_type>  # switch|case
condition=<shell_expr>   # Expression to evaluate

# For type=switch
on_true=<directory/>     # Path when condition is true
on_false=<directory/>    # Path when condition is false

# For type=case
branches=<name1>:<name2>:<name3>  # Branch names
<name1>=<condition>               # Condition for each branch
<name2>=<condition>
default=<directory/>              # Default path
```

**Example:**
```bash
# .conditional
type=switch
condition="grep -q ERROR"
on_true=error_handlers/
on_false=success_path/
```

### 5. `.filter` - Conditional Execution
Only processes directory contents if condition is met.

**Control File Format:**
```bash
type=when
condition=<shell_expr>   # Condition to check
on_skip=<behavior>      # identity|error|empty
```

**Example:**
```bash
# .filter
type=when  
condition="grep -q VALID"
on_skip=identity  # Pass through unchanged if condition fails
```

### 6. `.retry` - Error Recovery
Retries failed executions with configurable strategies.

**Control File Format:**
```bash
attempts=<number>        # Max retry attempts
delay=<seconds>         # Initial delay between retries
backoff=<strategy>      # exponential|linear|constant
on_failure=<behavior>   # continue|error|fallback/
```

**Example:**
```bash
# .retry
attempts=3
delay=2
backoff=exponential
on_failure=error
```

### 7. `.cache` - Memoization
Caches outputs based on input signatures.

**Control File Format:**
```bash
key=<method>        # md5|sha256|full
ttl=<seconds>       # Time to live (-1 = permanent)
storage=<path>      # Cache directory path
```

**Example:**
```bash
# .cache
key=md5
ttl=3600  # 1 hour
storage=/tmp/dirflow_cache/
```

### 8. `.sample` - Stochastic Processing
Randomly or systematically samples inputs for processing.

**Control File Format:**
```bash
type=<sample_type>      # random|every|first|last
probability=<float>     # For random sampling (0.0-1.0)
nth=<number>           # For systematic sampling
count=<number>         # For first/last sampling
```

**Example:**
```bash
# .sample
type=random
probability=0.1  # Process 10% of inputs randomly
```

### 9. `.barrier` - Synchronization Point
Collects multiple inputs before proceeding.

**Control File Format:**
```bash
type=collect
count=<number>      # Number of inputs to collect
timeout=<seconds>   # Max wait time (-1 = no timeout)
combine=<strategy>  # How to combine collected inputs
```

**Example:**
```bash
# .barrier
type=collect
count=3
timeout=30
combine=concatenate
```

### 10. `.stream` - Windowing Operations
Processes inputs in time or count-based windows.

**Control File Format:**
```bash
type=<window_type>      # tumbling|sliding|session
window_size=<number>    # Size for count-based windows
duration=<seconds>      # Duration for time-based windows
slide=<number>          # Slide interval for sliding windows
gap=<seconds>           # Gap duration for session windows
```

**Example:**
```bash
# .stream
type=tumbling
window_size=100  # Process in batches of 100
```

## Control Structure Precedence

When multiple control structures could apply:
1. **Directory-level controls apply to that directory's contents**
2. **Control files are mutually exclusive within a directory** (except `.loop` + `.parallel`)
3. **Subdirectories can have their own independent control files**
4. **Control files are automatically excluded from execution**

This design allows complex pipeline behaviors while maintaining clarity and predictability.