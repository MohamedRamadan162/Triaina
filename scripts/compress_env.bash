#!/bin/bash

# Set the working directory to the current directory where the script is located
ROOT_DIR="$(dirname "$0")/.."     # The parent directory of the directory where the script resides
OUTPUT_TAR="secrets_files.tar.gz" # Name of the output tar.gz file

# Change to the directory where the script resides
cd "$ROOT_DIR" || exit 1

# Find files matching the patterns and add them to the tar.gz file
find . \( -name "*.env" -o -name "secret.auto.tfvars" -o -name "*-secret.yaml" \) 2>/dev/null | tar -czf "$OUTPUT_TAR" -T -

# Check if the tar.gz file was created
if [ -f "$OUTPUT_TAR" ]; then
    echo "All matching files have been added to $OUTPUT_TAR."
else
    echo "No matching files were found."
fi
