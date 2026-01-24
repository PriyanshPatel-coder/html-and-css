#!/bin/bash

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_image> <target_size_in_kb>"
    echo "Example: $0 myphoto.png 250"
    exit 1
fi

INPUT_FILE="$1"
TARGET_SIZE_KB="$2"
BASENAME=$(basename "$INPUT_FILE")
FILENAME="${BASENAME%.*}"
OUTPUT_FILE="resized_${FILENAME}.jpg"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Resize logic using ImageMagick
# We convert to JPG to allow efficient size targeting
echo "Resizing '$INPUT_FILE' to approx ${TARGET_SIZE_KB}KB..."

convert "$INPUT_FILE" -strip -define jpeg:extent="${TARGET_SIZE_KB}kb" "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Success! Created '$OUTPUT_FILE'"
    # Show file sizes
    ORIG_SIZE=$(du -h "$INPUT_FILE" | cut -f1)
    NEW_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo "Original size: $ORIG_SIZE"
    echo "New size:      $NEW_SIZE"
else
    echo "Error: Failed to resize image."
fi
