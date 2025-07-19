#!/bin/bash -ex
# Web Directory Enumeration Script
# Usage: ./direnum.sh <target_url> [wordlist]

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <target_url> [wordlist]"
    echo "Example: $0 http://example.com"
    echo "Example: $0 http://example.com /usr/share/wordlists/dirb/common.txt"
    exit 1
fi

TARGET=$1
WORDLIST=${2:-"/usr/share/wordlists/dirb/common.txt"}

echo "Enumerating directories on $TARGET..."

# Check if wordlist exists
if [ ! -f "$WORDLIST" ]; then
    echo "Wordlist not found: $WORDLIST"
    echo "Using default dirb wordlist..."
    WORDLIST="/usr/share/wordlists/dirb/common.txt"
fi

# Run dirb
echo "Running dirb..."
dirb $TARGET $WORDLIST

# Run gobuster if available
if command -v gobuster >/dev/null 2>&1; then
    echo "Running gobuster..."
    gobuster dir -u $TARGET -w $WORDLIST -x php,html,txt,js
fi

echo "Directory enumeration completed for $TARGET"