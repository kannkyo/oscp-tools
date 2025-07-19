# OSCP Tools - Scripts Collection

This directory contains shell scripts commonly used in CTF competitions and penetration testing.

## Available Scripts

### install.sh
Installation script for common CTF tools and dependencies.
- Installs essential packages for binary analysis, web testing, and cryptography
- Sets up pwntools and other Python tools
- Usage: `./install.sh`

### portscan.sh
Network port scanning utility.
- Performs comprehensive port scans using nmap
- Supports custom port ranges
- Usage: `./portscan.sh <target_ip> [port_range]`

### direnum.sh
Web directory enumeration tool.
- Uses dirb and gobuster for directory discovery
- Supports custom wordlists
- Usage: `./direnum.sh <target_url> [wordlist]`

### revshell.sh
Reverse shell payload generator.
- Generates various types of reverse shell commands
- Supports bash, netcat, python, php, perl, and ruby
- Usage: `./revshell.sh <local_ip> <local_port> [shell_type]`

### hashcrack.sh
Hash identification and cracking tool.
- Identifies common hash types (MD5, SHA1, SHA256, etc.)
- Attempts cracking with John the Ripper and hashcat
- Usage: `./hashcrack.sh <hash> [wordlist]`

### binexp.sh
Binary analysis and exploitation helper.
- Analyzes binaries for security features and vulnerabilities
- Identifies dangerous functions and potential exploits
- Usage: `./binexp.sh <binary_file>`

### stegano.sh
Steganography analysis tool.
- Analyzes images for hidden data
- Uses multiple tools: exiftool, binwalk, steghide, zsteg
- Usage: `./stegano.sh <image_file>`

## Prerequisites

Before using these scripts, ensure you have the necessary tools installed:

```bash
# Run the installation script
./scripts/install.sh

# Additional tools for specific scripts
sudo apt-get install steghide exiftool binwalk
gem install zsteg
```

## Notes

- All scripts include error handling with `set -e`
- Scripts are designed to be educational and should be used responsibly
- Some scripts require elevated privileges for installation
- Always verify script contents before execution

## Contributing

When adding new scripts:
1. Follow the existing naming convention
2. Include proper shebang: `#!/bin/bash -ex`
3. Add usage instructions and error handling
4. Update this README with script description