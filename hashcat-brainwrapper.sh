#!/bin/sh
# A simple wrapper to hashcat to connect a hashcat client to a brain server
# This script assumes that you only have one container called hashcat-brain
# and that you are only running one hashcat brain server.
#
# Run it like you would hashcat, just pass the brain server password as the
# first argument e.g.
# ./hashcat-brainwrapper.sh <password> -m6211 hashcat_ripemd160_aes.tc wordlist.txt

hashcat=$(which hashcat)
container=$(docker ps --format '{{.ID}}\t{{.Image}}'|grep "hashcat-brain"|head -n1|cut -f1)
server=$(docker port $container|cut -d\  -f3|cut -d: -f1)
port=$(docker port $container|cut -d\  -f3|cut -d: -f2)
$hashcat --brain-client --brain-host $server --brain-port $port --brain-password $@
