#!/bin/bash -ex
# Steganography Analysis Tool
# Usage: ./stegano.sh <image_file>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <image_file>"
    echo "Example: $0 image.jpg"
    echo "Example: $0 image.png"
    exit 1
fi

IMAGE=$1

if [ ! -f "$IMAGE" ]; then
    echo "Image file not found: $IMAGE"
    exit 1
fi

echo "Analyzing image for steganography: $IMAGE"

# File information
echo "=== File Information ==="
file "$IMAGE"

# EXIF data analysis
echo "=== EXIF Data ==="
if command -v exiftool >/dev/null 2>&1; then
    exiftool "$IMAGE"
else
    echo "exiftool not available, install with: sudo apt-get install exiftool"
fi

# Strings analysis
echo "=== Strings Analysis ==="
strings "$IMAGE" | grep -E "(flag|password|key|secret|CTF|http|ftp)" | head -20 || echo "No interesting strings found"

# Binwalk analysis
echo "=== Binwalk Analysis ==="
if command -v binwalk >/dev/null 2>&1; then
    binwalk "$IMAGE"
    echo "Extracting embedded files..."
    binwalk -e "$IMAGE" || echo "No files to extract"
else
    echo "binwalk not available, install with: sudo apt-get install binwalk"
fi

# Steghide analysis (for JPEG images)
if [[ "$IMAGE" =~ \.(jpg|jpeg)$ ]]; then
    echo "=== Steghide Analysis (JPEG) ==="
    if command -v steghide >/dev/null 2>&1; then
        echo "Trying to extract hidden data with steghide (no password)..."
        steghide extract -sf "$IMAGE" -xf "${IMAGE}_extracted.txt" -p "" 2>/dev/null || echo "No hidden data found or password required"
        
        if [ -f "${IMAGE}_extracted.txt" ]; then
            echo "Extracted data:"
            cat "${IMAGE}_extracted.txt"
        fi
    else
        echo "steghide not available, install with: sudo apt-get install steghide"
    fi
fi

# LSB analysis
echo "=== LSB Analysis ==="
if command -v zsteg >/dev/null 2>&1; then
    zsteg "$IMAGE"
else
    echo "zsteg not available, install with: gem install zsteg"
fi

# Check for hidden ZIP/RAR files
echo "=== Archive Detection ==="
head -c 50 "$IMAGE" | hexdump -C | grep -E "(50 4b|52 61 72 21)" && echo "Possible ZIP/RAR archive detected!" || echo "No archive headers found"

echo "Steganography analysis completed for $IMAGE"
echo ""
echo "Additional tools to try:"
echo "1. Online tools: https://aperisolve.fr/"
echo "2. StegSolve.jar"
echo "3. foremost $IMAGE"
echo "4. hexdump -C $IMAGE | less"