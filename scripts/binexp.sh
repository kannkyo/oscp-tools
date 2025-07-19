#!/bin/bash -ex
# Binary Analysis and Exploitation Helper
# Usage: ./binexp.sh <binary_file>

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <binary_file>"
    echo "Example: $0 ./vulnerable_binary"
    exit 1
fi

BINARY=$1

if [ ! -f "$BINARY" ]; then
    echo "Binary file not found: $BINARY"
    exit 1
fi

echo "Analyzing binary: $BINARY"

# File information
echo "=== File Information ==="
file "$BINARY"

# Binary information
echo "=== Binary Information ==="
if command -v checksec >/dev/null 2>&1; then
    checksec --file="$BINARY"
elif command -v gdb >/dev/null 2>&1; then
    echo "Basic security analysis:"
    readelf -l "$BINARY" | grep -E "GNU_STACK|GNU_RELRO" || true
fi

# Strings analysis
echo "=== Interesting Strings ==="
strings "$BINARY" | grep -E "(flag|password|key|secret|admin|root|sql|http|ftp)" | head -20 || echo "No interesting strings found"

# Function analysis
echo "=== Functions ==="
if command -v objdump >/dev/null 2>&1; then
    objdump -t "$BINARY" | grep -E "(main|system|exec|gets|strcpy|scanf|printf)" | head -10 || echo "No dangerous functions found"
fi

# Check for common vulnerabilities
echo "=== Vulnerability Analysis ==="
echo "Checking for dangerous functions..."
if strings "$BINARY" | grep -E "(gets|strcpy|sprintf|scanf|strcat)" >/dev/null; then
    echo "WARNING: Found potentially dangerous functions!"
    strings "$BINARY" | grep -E "(gets|strcpy|sprintf|scanf|strcat)"
else
    echo "No obvious dangerous functions found"
fi

# Basic disassembly
echo "=== Basic Disassembly (main function) ==="
if command -v objdump >/dev/null 2>&1; then
    objdump -d "$BINARY" | grep -A 20 "<main>:" || echo "Could not disassemble main function"
fi

echo "Binary analysis completed for $BINARY"
echo ""
echo "Next steps:"
echo "1. Run with GDB: gdb $BINARY"
echo "2. Create pattern: python3 -c \"print('A'*100)\""
echo "3. Find crash point and analyze stack"