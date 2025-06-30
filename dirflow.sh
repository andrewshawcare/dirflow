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

set -e
set -o pipefail

# Debug logging helper
debug_log() {
    local dir="$1" phase="$2" data="$3" filename="$4"
    [ -f "$dir/.debug" ] || return 0
    
    . "$dir/.debug"
    [ "${enabled:-false}" = "true" ] || return 0
    
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local log_file=""
    local location="$dir"
    
    # Use full path if filename is provided
    [ -n "$filename" ] && location="$dir/$filename"
    
    case "$phase" in
        input)  log_file="${input_log:-debug_input.log}" ;;
        output) log_file="${output_log:-debug_output.log}" ;;
        *) return 0 ;;
    esac
    
    # Handle parallel execution with PID suffix
    [ "${DIRFLOW_PARALLEL:-}" = "true" ] && log_file="${log_file%.log}.$$.log"
    
    # Use absolute path relative to the directory being processed
    [ "${log_file:0:1}" != "/" ] && log_file="$dir/$log_file"
    
    # Safe logging - don't break pipeline on log failures
    mkdir -p "$(dirname "$log_file")"
    {
        echo "[$timestamp] [$location] $phase: $data"
    } >> "$log_file" 2>/dev/null || true
}

# Process a single directory
dirflow() {
    local dir="${1:-.}"
    local data=""
    [ ! -t 0 ] && data=$(< /dev/stdin)
    
    # Debug input logging
    debug_log "$dir" "input" "$data"
    
    # .sample - stochastic filtering at directory level
    if [ -f "$dir/.sample" ]; then
        . "$dir/.sample"
        case "${type:-random}" in
            random)
                echo "$data" | awk -v p="${probability:-0.5}" 'BEGIN{srand()} rand()>p{exit 1}' || {
                    echo "$data"; return
                }
                ;;
            first)
                [ $(echo "$data" | wc -l) -le "${count:-10}" ] && { echo "$data"; return; }
                ;;
        esac
    fi
    
    # .loop - iteration control
    if [ -f "$dir/.loop" ]; then
        . "$dir/.loop"
        local i=0
        while : ; do
            # Store data to avoid consuming it during condition evaluation
            local temp_data="$data"
            
            case "${type:-}" in
                for)     [ $i -ge "${count:-1}" ] && break ;;
                while)   echo "$temp_data" | sh -c "$condition" || break ;;
                until)   [ $i -gt 0 ] && echo "$temp_data" | sh -c "$condition" && break ;;
                do-while) [ $i -gt 0 ] && ! echo "$temp_data" | sh -c "$condition" && break ;;
                *)       [ $i -gt 0 ] && break ;;
            esac
            
            data="$(echo "$temp_data" | dirflow_items "$dir")"
            i=$((i+1))
            [ $i -ge 1000 ] && break  # Safety limit
        done
        debug_log "$dir" "output" "$data"
        echo "$data"
    else
        data="$(echo "$data" | dirflow_items "$dir")"
        debug_log "$dir" "output" "$data"
        echo "$data"
    fi
}

# Process items in a directory
dirflow_items() {
    local dir="$1"
    local data="$(cat)"
    
    # .filter - gate pattern
    if [ -f "$dir/.filter" ]; then
        . "$dir/.filter"
        echo "$data" | sh -c "$condition" || {
            case "${on_skip:-identity}" in
                error) return 1 ;;
                empty) echo "" ;;
                *)     echo "$data" ;;
            esac
            return
        }
    fi
    
    # .conditional - branching
    if [ -f "$dir/.conditional" ]; then
        . "$dir/.conditional"
        if echo "$data" | sh -c "$condition"; then
            echo "$data" | dirflow "$dir/${on_true:-/dev/null}"
        else
            echo "$data" | dirflow "$dir/${on_false:-/dev/null}"
        fi
        return
    fi
    
    # Get items (skip hidden)
    local items="$(ls -a "$dir" | grep -v '^\.' | sort)"
    [ -z "$items" ] && { echo "$data"; return; }
    
    # .parallel or sequential
    if [ -f "$dir/.parallel" ]; then
        . "$dir/.parallel"
        dirflow_parallel "$dir" "$data" "$items"
    else
        for item in $items; do
            [ -L "$dir/$item" ] && continue
            if [ -d "$dir/$item" ]; then
                data="$(echo "$data" | dirflow "$dir/$item")"
            elif [ -x "$dir/$item" ]; then
                debug_log "$dir" "input" "$data" "$item"
                data="$(echo "$data" | "$dir/$item")"
                debug_log "$dir" "output" "$data" "$item"
            fi
        done
        echo "$data"
    fi
}

# Parallel execution
dirflow_parallel() {
    local dir="$1" data="$2" items="$3"
    local tmp="/tmp/dirflow.$$" n=0
    
    mkdir -p "$tmp"
    trap "rm -rf $tmp" EXIT
    
    # Launch jobs
    export DIRFLOW_PARALLEL=true
    for item in $items; do
        [ -L "$dir/$item" ] && continue
        if [ -d "$dir/$item" ]; then
            echo "$data" | dirflow "$dir/$item" > "$tmp/$n" &
        elif [ -x "$dir/$item" ]; then
            debug_log "$dir" "input" "$data" "$item"
            echo "$data" | "$dir/$item" > "$tmp/$n" &
        else
            continue
        fi
        n=$((n+1))
        # Worker limit
        [ "${workers:-0}" -gt 0 ] && [ $(jobs -r | wc -l) -ge "${workers:-0}" ] && wait
    done
    unset DIRFLOW_PARALLEL
    
    wait  # Wait for all
    
    # Combine outputs
    local output=""
    case "${combine:-concatenate}" in
        first) output="$(cat "$tmp/0" 2>/dev/null)" ;;
        last)  output="$(cat "$tmp/$((n-1))" 2>/dev/null)" ;;
        merge) output="$(paste "$tmp"/* | tr '\t' '\n')" ;;
        *)     output="$(cat "$tmp"/*)" ;;
    esac
    
    export DIRFLOW_PARALLEL=true
    debug_log "$dir" "output" "$output"
    unset DIRFLOW_PARALLEL
    echo "$output"
}

# Main
dirflow "$@"