#!/bin/bash
#
# Test: Verify all example README.md files use "Examples" section instead of "Usage"
#

set -e

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Testing README.md standardization..."

# List of all example directories
EXAMPLE_DIRS=(
    "01-basic-pipeline"
    "02-data-processing" 
    "03-loop-simple"
    "04-loop-conditional"
    "05-parallel-execution"
    "06-filtering"
    "07-sampling"
    "08-advanced-combinations"
    "09-debugging"
)

FAILED_CHECKS=0

# Check each example README.md
for example_dir in "${EXAMPLE_DIRS[@]}"; do
    readme_path="$PROJECT_ROOT/examples/$example_dir/README.md"
    
    if [ ! -f "$readme_path" ]; then
        echo "FAIL: README.md not found for $example_dir"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        continue
    fi
    
    # Check if it has "Usage" section (should not have)
    if grep -q "^## Usage" "$readme_path"; then
        echo "FAIL: $example_dir still uses 'Usage' section instead of 'Examples'"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
    
    # Check if it has "Examples" section (should have)
    if ! grep -q "^## Examples" "$readme_path"; then
        echo "FAIL: $example_dir missing 'Examples' section"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
done

if [ $FAILED_CHECKS -eq 0 ]; then
    echo "PASS: All README.md files use 'Examples' section correctly"
    exit 0
else
    echo "FAIL: $FAILED_CHECKS README.md files need standardization"
    exit 1
fi