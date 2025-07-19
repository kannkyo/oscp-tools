#!/bin/bash

# http-scan.sh - HTTP directory and file scanning tool using feroxbuster
# Usage: ./http-scan.sh <ip> [port]
# 
# Arguments:
#   ip   - Target IP address (required)
#   port - Target port number (optional, defaults to 80)

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <ip> [port]"
    echo "  ip   - Target IP address (required)"
    echo "  port - Target port number (optional, defaults to 80)"
    exit 1
fi

# Assign arguments to variables
ip="$1"
port="${2:-80}"  # Default to 80 if second argument not provided

# Validate IP address format (basic validation)
if ! [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "Error: Invalid IP address format: $ip"
    exit 1
fi

# Validate port number
if ! [[ $port =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
    echo "Error: Invalid port number: $port"
    exit 1
fi

# Construct target URL
target_url="http://${ip}:${port}"

echo "Starting HTTP scan on ${target_url}"
echo "=================================="

# Check if feroxbuster is available
if ! command -v feroxbuster &> /dev/null; then
    echo "Error: feroxbuster is not installed or not in PATH"
    echo "Please install feroxbuster to use this script"
    exit 1
fi

# Define wordlist paths (common locations)
common_wordlist="/usr/share/seclists/Discovery/Web-Content/common.txt"
rockyou_wordlist="/usr/share/wordlists/rockyou.txt"

# Alternative paths for wordlists
if [ ! -f "$common_wordlist" ]; then
    common_wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
fi

if [ ! -f "$common_wordlist" ]; then
    common_wordlist="/usr/share/dirb/wordlists/common.txt"
fi

if [ ! -f "$rockyou_wordlist" ]; then
    rockyou_wordlist="/usr/share/wordlists/rockyou.txt.gz"
fi

echo "Scan 1: Using common.txt wordlist (200 responses only)"
echo "----------------------------------------------------"

# First scan: feroxbuster with common.txt, filter for 200 responses only
if [ -f "$common_wordlist" ]; then
    echo "Using wordlist: $common_wordlist"
    feroxbuster -u "$target_url" -w "$common_wordlist" -s 200 -t 50 -x php,html,txt,js,xml,pdf
else
    echo "Warning: common.txt wordlist not found at expected locations"
    echo "Trying built-in feroxbuster wordlist..."
    feroxbuster -u "$target_url" -s 200 -t 50 -x php,html,txt,js,xml,pdf
fi

echo ""
echo "Scan 2: Using rockyou.txt wordlist"
echo "-----------------------------------"

# Second scan: feroxbuster with rockyou.txt
if [ -f "$rockyou_wordlist" ]; then
    echo "Using wordlist: $rockyou_wordlist"
    if [[ "$rockyou_wordlist" == *.gz ]]; then
        # Handle gzipped rockyou.txt
        zcat "$rockyou_wordlist" | head -10000 | feroxbuster -u "$target_url" --stdin -t 50 -x php,html,txt,js,xml,pdf
    else
        # Use first 10000 lines of rockyou.txt to avoid excessive scan time
        head -10000 "$rockyou_wordlist" | feroxbuster -u "$target_url" --stdin -t 50 -x php,html,txt,js,xml,pdf
    fi
else
    echo "Warning: rockyou.txt wordlist not found at expected locations"
    echo "Skipping rockyou.txt scan..."
fi

echo ""
echo "HTTP scan completed for ${target_url}"