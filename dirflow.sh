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

set -e
set -o pipefail

# Process a single directory
dirflow() {
    local dir="${1:-.}"
    local data="$(cat)"
    
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
            case "${type:-}" in
                for)     [ $i -ge "${count:-1}" ] && break ;;
                while)   echo "$data" | sh -c "$condition" || break ;;
                until)   [ $i -gt 0 ] && echo "$data" | sh -c "$condition" && break ;;
                do-while) [ $i -gt 0 ] && ! echo "$data" | sh -c "$condition" && break ;;
                *)       [ $i -gt 0 ] && break ;;
            esac
            data="$(echo "$data" | dirflow_items "$dir")"
            i=$((i+1))
            [ $i -ge 1000 ] && break  # Safety limit
        done
        echo "$data"
    else
        echo "$data" | dirflow_items "$dir"
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
                data="$(echo "$data" | "$dir/$item")"
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
    for item in $items; do
        [ -L "$dir/$item" ] && continue
        if [ -d "$dir/$item" ]; then
            echo "$data" | dirflow "$dir/$item" > "$tmp/$n" &
        elif [ -x "$dir/$item" ]; then
            echo "$data" | "$dir/$item" > "$tmp/$n" &
        else
            continue
        fi
        n=$((n+1))
        # Worker limit
        [ "${workers:-0}" -gt 0 ] && [ $(jobs -r | wc -l) -ge "$workers" ] && wait
    done
    
    wait  # Wait for all
    
    # Combine outputs
    case "${combine:-concatenate}" in
        first) cat "$tmp/0" 2>/dev/null ;;
        last)  cat "$tmp/$((n-1))" 2>/dev/null ;;
        merge) paste "$tmp"/* | tr '\t' '\n' ;;
        *)     cat "$tmp"/* ;;
    esac
}

# Main
dirflow "$@"