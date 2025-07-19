#!/bin/bash -ex
# Port Scanner Script
# Usage: ./portscan.sh <target_ip> [port_range]

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <target_ip> [port_range]"
    echo "Example: $0 192.168.1.1"
    echo "Example: $0 192.168.1.1 1-1000"
    exit 1
fi

TARGET=$1
PORT_RANGE=${2:-"1-65535"}

echo "Scanning $TARGET for open ports in range $PORT_RANGE..."

# Basic nmap scan
echo "Running nmap scan..."
nmap -sS -O -sV -p $PORT_RANGE $TARGET

# Additional common port scan
echo "Running quick common ports scan..."
nmap -sS -F $TARGET

echo "Port scan completed for $TARGET"