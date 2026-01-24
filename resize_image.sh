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

# Get current size in KB
CURRENT_SIZE_BYTES=$(stat -c%s "$INPUT_FILE")
CURRENT_SIZE_KB=$((CURRENT_SIZE_BYTES / 1024))

echo "Current size: ${CURRENT_SIZE_KB}KB"
echo "Target size:  ${TARGET_SIZE_KB}KB"

if [ "$CURRENT_SIZE_KB" -le "$TARGET_SIZE_KB" ]; then
    echo "Note: Image is already smaller than or equal to target size."
    echo "Optimizing without increasing size..."
    # If already smaller, we just strip metadata and keep quality high, 
    # but ImageMagick might still fluctuate. We'll use a safer approach:
    convert "$INPUT_FILE" -strip "$OUTPUT_FILE"
    
    # Check if it still increased (sometimes stripping metadata isn't enough to offset default JPG quality)
    NEW_SIZE_BYTES=$(stat -c%s "$OUTPUT_FILE")
    if [ "$NEW_SIZE_BYTES" -gt "$CURRENT_SIZE_BYTES" ]; then
        echo "Source was highly compressed. Re-compressing to match original size..."
        convert "$INPUT_FILE" -strip -define jpeg:extent="${CURRENT_SIZE_KB}kb" "$OUTPUT_FILE"
    fi
else
    echo "Reducing '$INPUT_FILE' to approx ${TARGET_SIZE_KB}KB..."
    convert "$INPUT_FILE" -strip -define jpeg:extent="${TARGET_SIZE_KB}kb" "$OUTPUT_FILE"
fi

if [ $? -eq 0 ]; then
    echo "Success! Created '$OUTPUT_FILE'"
    # Show file sizes
    ORIG_SIZE_DISPLAY=$(du -h "$INPUT_FILE" | cut -f1)
    NEW_SIZE_DISPLAY=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo "Original size: $ORIG_SIZE_DISPLAY"
    echo "New size:      $NEW_SIZE_DISPLAY"
else
    echo "Error: Failed to resize image."
fi
