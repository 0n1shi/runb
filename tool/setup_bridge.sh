#!/bin/bash

set -eu

# prepare variables
BRIDGE_NAME="runb-bridge"
BRIDGE_IP="10.0.0.1"
BRIDGE_NETMASK="24"

# make a bridge and set ip address
echo -n ">> making bridge ... "
brctl addbr $BRIDGE_NAME
ip addr add "$BRIDGE_IP/$BRIDGE_NETMASK" dev $BRIDGE_NAME
ip link set $BRIDGE_NAME up
echo "done."

# set table for forwarding
echo -n ">> setting up nat table ... "
iptables --table nat --flush
iptables --table nat --append POSTROUTING --source 10.0.0.0/24 --jump MASQUERADE
iptables --append FORWARD --out-interface runb-bridge --match conntrack --ctstate RELATED,ESTABLISHED --jump ACCEPT
iptables --append FORWARD --in-interface runb-bridge --out-interface runb-bridge --jump ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "done."


