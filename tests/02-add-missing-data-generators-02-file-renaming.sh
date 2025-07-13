#!/bin/bash
#
# Test: File Renaming for Data Processing Pipeline
# Verifies that existing files are properly renamed to accommodate new generator
#

set -e

BASE_DIR="/Users/andrew/dirflow/examples/02-data-processing"

echo "Testing file renaming in data processing pipeline..."

# Test 1: New file structure should exist
EXPECTED_FILES=("01-generate.sh" "02-clean.sh" "03-normalize.sh" "04-count.sh")
for file in "${EXPECTED_FILES[@]}"; do
    if [ ! -f "$BASE_DIR/$file" ]; then
        echo "FAIL: Expected file $file does not exist"
        exit 1
    fi
done

# Test 2: Old file structure should not exist (conflicting numbered files)
OLD_FILES=("01-clean.sh" "02-normalize.sh" "03-count.sh")
for file in "${OLD_FILES[@]}"; do
    if [ -f "$BASE_DIR/$file" ]; then
        echo "FAIL: Old file $file should have been renamed but still exists"
        exit 1
    fi
done

# Test 3: Files should be executable
for file in "${EXPECTED_FILES[@]}"; do
    if [ ! -x "$BASE_DIR/$file" ]; then
        echo "FAIL: File $file is not executable"
        exit 1
    fi
done

# Test 4: Content verification - check that files have expected processing content
if ! grep -qi "clean" "$BASE_DIR/02-clean.sh"; then
    echo "FAIL: 02-clean.sh doesn't appear to contain cleaning logic"
    exit 1
fi

if ! grep -q "tr.*upper.*lower\|tolower\|lowercase" "$BASE_DIR/03-normalize.sh"; then
    echo "FAIL: 03-normalize.sh doesn't appear to contain normalization logic"
    exit 1
fi

if ! grep -qi "count" "$BASE_DIR/04-count.sh"; then
    echo "FAIL: 04-count.sh doesn't appear to contain counting logic"
    exit 1
fi

echo "PASS: File renaming completed correctly"
echo "Pipeline now has proper sequence: 01-generate → 02-clean → 03-normalize → 04-count"