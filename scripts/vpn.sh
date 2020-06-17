#!/usr/bin/env bash
IP_PREFIX=${1-"10.61"}
GATEWAY_PREFIX="192.168"

gateway=$(netstat -rn | grep -E "$GATEWAY_PREFIX.*en0" | awk '{ print $2 }' | grep "$GATEWAY_PREFIX" | uniq)
interface=$(ifconfig | grep "$IP_PREFIX" -B1 | grep flags | sed "s/: .*//")

echo interface: "$interface"
echo gateway: "$gateway"

if [ -z "$interface" ] || [ -z "$gateway" ]; then
  echo "Need both interface and gateway. Quit."
  exit 1
fi

read -p "Modify route table? [y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo
  sudo route -nv add -net 10 -interface "$interface"
  sudo route change default "$gateway"
fi
