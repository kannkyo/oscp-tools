#!/bin/bash -ex
# CTF Tools Installation Script
# This script installs common CTF tools

set -e

echo "Installing CTF tools..."

# Update package list
sudo apt-get update

# Install basic dependencies
sudo apt-get install -y \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    binutils \
    gdb \
    nmap \
    netcat \
    socat \
    john \
    hashcat \
    steghide \
    exiftool \
    binwalk \
    foremost \
    hexedit \
    xxd \
    strings \
    ltrace \
    strace \
    radare2 \
    sqlmap \
    nikto \
    dirb \
    gobuster

# Install pwntools
pip3 install --user pwntools

# Install other useful Python tools
pip3 install --user \
    requests \
    beautifulsoup4 \
    scapy \
    cryptography \
    pycryptodome \
    z3-solver

echo "CTF tools installation completed!"