#!/bin/bash -ex
# Hash Identifier and Cracker
# Usage: ./hashcrack.sh <hash> [wordlist]

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <hash> [wordlist]"
    echo "Example: $0 5d41402abc4b2a76b9719d911017c592"
    echo "Example: $0 5d41402abc4b2a76b9719d911017c592 /usr/share/wordlists/rockyou.txt"
    exit 1
fi

HASH=$1
WORDLIST=${2:-"/usr/share/wordlists/rockyou.txt"}

echo "Analyzing hash: $HASH"

# Identify hash type based on length and format
HASH_LENGTH=${#HASH}

echo "Hash length: $HASH_LENGTH"

case $HASH_LENGTH in
    32)
        if [[ $HASH =~ ^[a-f0-9]{32}$ ]]; then
            echo "Likely MD5 hash"
            HASH_TYPE="md5"
            HASHCAT_MODE="0"
        fi
        ;;
    40)
        if [[ $HASH =~ ^[a-f0-9]{40}$ ]]; then
            echo "Likely SHA1 hash"
            HASH_TYPE="sha1"
            HASHCAT_MODE="100"
        fi
        ;;
    64)
        if [[ $HASH =~ ^[a-f0-9]{64}$ ]]; then
            echo "Likely SHA256 hash"
            HASH_TYPE="sha256"
            HASHCAT_MODE="1400"
        fi
        ;;
    96)
        if [[ $HASH =~ ^[a-f0-9]{96}$ ]]; then
            echo "Likely SHA384 hash"
            HASH_TYPE="sha384"
            HASHCAT_MODE="10800"
        fi
        ;;
    128)
        if [[ $HASH =~ ^[a-f0-9]{128}$ ]]; then
            echo "Likely SHA512 hash"
            HASH_TYPE="sha512"
            HASHCAT_MODE="1700"
        fi
        ;;
    *)
        echo "Unknown hash format or length"
        echo "Trying common hash identifiers..."
        ;;
esac

# Try john the ripper
if command -v john >/dev/null 2>&1; then
    echo "Attempting to crack with John the Ripper..."
    echo "$HASH" > /tmp/hash.txt
    john --wordlist=$WORDLIST /tmp/hash.txt || true
    john --show /tmp/hash.txt || true
fi

# Try hashcat if available and hash type identified
if command -v hashcat >/dev/null 2>&1 && [ ! -z ${HASHCAT_MODE+x} ]; then
    echo "Attempting to crack with hashcat..."
    echo "$HASH" > /tmp/hash.txt
    hashcat -m $HASHCAT_MODE /tmp/hash.txt $WORDLIST --force || true
fi

echo "Hash analysis completed"