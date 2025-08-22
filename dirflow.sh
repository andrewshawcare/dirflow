#!/bin/bash
#
# dirflow - Directory Pipeline Executor
# Your filesystem is the pipeline
#
# Control files (sourced as shell scripts):
#   .loop        - Iteration control (type, condition, count)
#   .parallel    - Concurrent execution (combine, workers)
#   .conditional - Branching based on condition (condition, on_true, on_false)
#   .filter      - Skip processing if condition fails (condition, on_skip)
#   .sample      - Random/systematic sampling (type, probability, count)
#   .debug       - Debug logging (enabled, input_log, output_log)

# --- Configuration and Setup ---
set -e
set -o pipefail

# --- Main Functions ---

# Processes a directory, handling control files and executing items.
dirflow() {
    local dir="${1-.}"
    local input_data
    # Read from stdin if available, otherwise start with empty data.
    [ ! -t 0 ] && input_data=$(cat) || input_data=""

    debug_log "$dir" "input" "$input_data"

    # Handle control files which can modify execution flow or data.
    # Each handler function is responsible for its own control file.
    # Note: Order of handlers matters.
    # The sample handler can short-circuit the pipeline.
    if ! handle_sample "$dir" "$input_data"; then
        # The sample was "caught" and should be returned as-is, skipping the rest of the pipeline.
        echo "$input_data"
        return
    fi
    
    local output_data
    if [ -f "$dir/.loop" ]; then
        output_data=$(handle_loop "$dir" "$input_data")
    else
        output_data=$(process_items "$dir" "$input_data")
    fi

    debug_log "$dir" "output" "$output_data"
    echo "$output_data"
}

# Processes all items (files/subdirectories) in a given directory.
process_items() {
    local dir="$1"
    local input_data="$2"

    # Handle control files that apply to the whole set of items.
    handle_filter "$dir" "$input_data" || { echo "$input_data"; return; }
    if handle_conditional "$dir" "$input_data"; then
        return
    fi
    
    # Find and sort items. Using find is robust for names with spaces.
    local items
    items=$(find "$dir" -maxdepth 1 -mindepth 1 -not -name '.*' -exec basename {} \; | sort)

    if [ -z "$items" ]; then
        echo "$input_data"
        return
    fi

    # Execute items sequentially or in parallel.
    if [ -f "$dir/.parallel" ]; then
        process_parallel "$dir" "$input_data" "$items"
    else
        process_sequentially "$dir" "$input_data" "$items"
    fi
}

# --- Control File Handlers ---

# Handles .sample file for stochastic processing.
# Returns 0 if processing should continue.
# Returns 1 if the data was "sampled" and the pipeline should short-circuit.
handle_sample() {
    local dir="$1" data="$2"
    [ ! -f "$dir/.sample" ] && return 0 # Continue

    . "$dir/.sample"
    case "${type:-random}" in
        random)
            # awk will exit with 0 to continue, or 1 to be sampled.
            if echo "$data" | awk -v p="${probability:-0.5}" 'BEGIN{srand()} rand() > p {exit 1}'; then
                return 0 # awk exited 0, so continue.
            else
                return 1 # awk exited 1, so sample (short-circuit).
            fi
            ;;
        first)
            if [ "$(echo "$data" | wc -l)" -le "${count:-10}" ]; then
                return 1 # Line count is within the limit, so sample (short-circuit).
            else
                return 0 # Line count is over the limit, so continue processing.
            fi
            ;;
    esac
}

# Handles .loop file for iterative processing.
handle_loop() {
    local dir="$1" data="$2"
    . "$dir/.loop"

    local i=0
    local temp_data="$data"
    while :; do
        # Check loop termination condition
        case "${type:-for}" in
            for)     [ $i -ge "${count:-1}" ] && break ;;
            while)   ! (echo "$temp_data" | sh -c "${condition:-true}") && break ;;
            until)   [ $i -gt 0 ] && echo "$temp_data" | sh -c "${condition:-false}" && break ;;
            do-while) [ $i -gt 0 ] && ! (echo "$temp_data" | sh -c "${condition:-true}") && break ;;
            *)       [ $i -gt 0 ] && break ;; # Default to single run
        esac

        # Process items for this iteration
        temp_data=$(process_items "$dir" "$temp_data")

        i=$((i+1))
        [ $i -ge 1000 ] && { >&2 echo "Loop safety limit (1000) reached."; break; }
    done
    echo "$temp_data"
}

# Handles .filter file to gate processing.
handle_filter() {
    local dir="$1" data="$2"
    [ ! -f "$dir/.filter" ] && return 0

    . "$dir/.filter"
    if ! (echo "$data" | sh -c "$condition"); then
        case "${on_skip:-identity}" in
            error) return 1 ;;
            empty) echo "" ;;
            *)     echo "$data" ;;
        esac
        return 1 # Indicate that processing should stop
    fi
    return 0 # Indicate that processing should continue
}

# Handles .conditional file for branching.
handle_conditional() {
    local dir="$1" data="$2"
    [ ! -f "$dir/.conditional" ] && return 1 # Not handled

    . "$dir/.conditional"
    if echo "$data" | sh -c "$condition"; then
        echo "$data" | dirflow "$dir/${on_true:-/dev/null}"
    else
        echo "$data" | dirflow "$dir/${on_false:-/dev/null}"
    fi
    return 0 # Handled
}

# --- Item Processing ---

# Executes a single item, either a script or a subdirectory.
process_item() {
    local item_path="$1"
    local input_data="$2"
    local dir="$3" # For debug logging context
    local item_name="$4" # For debug logging context

    if [ -d "$item_path" ]; then
        echo "$input_data" | dirflow "$item_path"
    elif [ -x "$item_path" ]; then
        debug_log "$dir" "input" "$input_data" "$item_name"
        local output_data
        output_data=$(echo "$input_data" | "$item_path")
        debug_log "$dir" "output" "$output_data" "$item_name"
        echo "$output_data"
    else
        # If the item is not a directory or an executable script (e.g., README.md),
        # pass the data through to the next item in the pipeline.
        echo "$input_data"
    fi
}

# Processes items sequentially.
process_sequentially() {
    local dir="$1" data="$2" items="$3"

    local current_data="$data"
    # Use while-read loop to correctly handle filenames with spaces.
    while IFS= read -r item; do
        local item_path="$dir/$item"
        [ -L "$item_path" ] && continue # Skip symlinks

        current_data=$(process_item "$item_path" "$current_data" "$dir" "$item")
    done < <(echo "$items")
    echo "$current_data"
}

# Processes items in parallel.
process_parallel() {
    local dir="$1" data="$2" items="$3"
    . "$dir/.parallel" # Source combine strategy and worker count

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT # Cleanup tmp dir on exit

    export DIRFLOW_PARALLEL=true
    local n=0
    while IFS= read -r item; do
        local item_path="$dir/$item"
        [ -L "$item_path" ] && continue

        # Run item processing in the background, redirecting output to a temp file.
        process_item "$item_path" "$data" "$dir" "$item" > "$tmp_dir/$n" &

        n=$((n+1))
        # Limit number of concurrent workers if specified.
        if [ "${workers:-0}" -gt 0 ] && [ "$(jobs -r | wc -l)" -ge "$workers" ]; then
            wait -n # Wait for any job to finish
        fi
    done < <(echo "$items")

    wait # Wait for all remaining background jobs to finish
    unset DIRFLOW_PARALLEL

    # Combine results from temp files based on the chosen strategy.
    local output
    case "${combine:-concatenate}" in
        first) output=$(cat "$tmp_dir/0" 2>/dev/null) ;;
        last)  output=$(cat "$tmp_dir/$((n-1))" 2>/dev/null) ;;
        merge) output=$(paste "$tmp_dir"/* | tr '\t' '\n') ;;
        *)     for i in $(seq 0 $((n-1))); do cat "$tmp_dir/$i"; done ;;
    esac

    echo "$output"
}

# --- Utility Functions ---

# Logs debug messages if .debug file is present and enabled.
debug_log() {
    local dir="$1" phase="$2" data="$3" filename="$4"
    [ ! -f "$dir/.debug" ] && return 0

    # Source configuration from .debug file
    . "$dir/.debug"
    [ "${enabled:-false}" = "true" ] || return 0

    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    local log_file
    case "$phase" in
        input)  log_file="${input_log:-debug_input.log}" ;;
        output) log_file="${output_log:-debug_output.log}" ;;
        *) return 0 ;;
    esac

    # Add PID suffix for parallel execution to avoid race conditions.
    [ -n "${DIRFLOW_PARALLEL:-}" ] && log_file="${log_file%.log}.$$.log"

    # Prepend dir path if log_file is not an absolute path.
    [ "${log_file:0:1}" != "/" ] && log_file="$dir/$log_file"

    local location="$dir"
    [ -n "$filename" ] && location="$dir/$filename"

    # Log safely, creating directory if needed and ignoring logging errors.
    mkdir -p "$(dirname "$log_file")"
    echo "[$timestamp] [$location] $phase: $data" >> "$log_file" 2>/dev/null || true
}

# --- Script Entrypoint ---
main() {
    # If a directory is passed as an argument, use it. Otherwise, default to current dir.
    local target_dir="${1:-.}"
    dirflow "$target_dir"
}

main "$@"