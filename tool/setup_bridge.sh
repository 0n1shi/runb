#!/bin/bash

set -eu

BRIDGE_NAME="runb-bridge"
BRIDGE_IP="10.0.0.1"
BRIDGE_NETMASK="24"

brctl addbr $BRIDGE_NAME
ip addr add "$BRIDGE_IP/$BRIDGE_NETMASK"
ip link set $BRIDGE_NAME up

iptables --table nat --flush
iptables --table nat --append POSTROUTING --source 10.0.0.0/24 --jump MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
