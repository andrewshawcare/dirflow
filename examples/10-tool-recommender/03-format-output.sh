#!/bin/bash
#
# Format Output in Required CSV Format
# Converts matched tools into the specified CSV format
#

set -e

# Read analysis results from previous stage
INPUT=$(cat)

# Extract matched tools from JSON
MATCHED_TOOLS=$(echo "$INPUT" | jq -c '.matched_tools[]?' 2>/dev/null || echo "")

# Function to escape CSV fields (handle commas and quotes)
escape_csv_field() {
    local field="$1"
    # Replace any commas with semicolons to avoid CSV parsing issues
    echo "$field" | sed 's/,/;/g' | sed 's/"/'"'"'/g'
}

# Process each matched tool and output in CSV format
while read -r tool; do
    if [ -n "$tool" ] && [ "$tool" != "null" ]; then
        # Extract fields from JSON
        ID=$(echo "$tool" | jq -r '.id // ""')
        NAME=$(echo "$tool" | jq -r '.name // ""')
        URL=$(echo "$tool" | jq -r '.url // ""')
        DESCRIPTION=$(echo "$tool" | jq -r '.description // ""')
        NECESSITY=$(echo "$tool" | jq -r '.necessity // "optional"')
        RATIONALE=$(echo "$tool" | jq -r '.rationale // "No specific rationale provided"')
        
        # Escape fields for CSV safety
        ID=$(escape_csv_field "$ID")
        NAME=$(escape_csv_field "$NAME")
        URL=$(escape_csv_field "$URL")
        DESCRIPTION=$(escape_csv_field "$DESCRIPTION")
        NECESSITY=$(escape_csv_field "$NECESSITY")
        RATIONALE=$(escape_csv_field "$RATIONALE")
        
        # Output in required CSV format: {ID},{NAME},{URL},{DESCRIPTION},{SELECTION_NECESSITY},{SELECTION_RATIONALE}
        echo "$ID,$NAME,$URL,$DESCRIPTION,$NECESSITY,$RATIONALE"
    fi
done < <(echo "$MATCHED_TOOLS")

# Note: If no matched tools, no output is produced (as required)