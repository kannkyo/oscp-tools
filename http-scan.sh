#!/bin/bash

# http-scan.sh - HTTP directory and file scanning tool using feroxbuster
# Usage: ./http-scan.sh <ip> [port]

ip="$1"
port="${2:-80}"
target_url="http://${ip}:${port}"

echo "Starting HTTP scan on ${target_url}"

# Scan with common.txt wordlist
common_wordlist="/usr/share/seclists/Discovery/Web-Content/common.txt"
if [ -f "$common_wordlist" ]; then
    feroxbuster -u "$target_url" -w "$common_wordlist" -s 200 -x php,html,txt,js,xml,pdf
else
    feroxbuster -u "$target_url" -s 200 -x php,html,txt,js,xml,pdf
fi

# Scan with rockyou.txt wordlist
rockyou_wordlist="/usr/share/wordlists/rockyou.txt"
if [ -f "$rockyou_wordlist" ]; then
    head -10000 "$rockyou_wordlist" | feroxbuster -u "$target_url" --stdin -x php,html,txt,js,xml,pdf
elif [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
    zcat "/usr/share/wordlists/rockyou.txt.gz" | head -10000 | feroxbuster -u "$target_url" --stdin -x php,html,txt,js,xml,pdf
fi

echo "HTTP scan completed for ${target_url}"