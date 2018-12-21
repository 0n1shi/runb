#!/bin/bash

set -eu
set -x

CORE=$PWD/lib/core.sh

# get a directory which has a root file system.
if [ $# -lt 1 ]; then
    echo "you need to designate a directory which is root file system."
    exit
fi
CONTAINER_DIR=$1
CONTAINER_NAME="$(basename $0 | cut -d '.' -f 1)-$$"
CONTAINER_FS="$CONTAINER_DIR/rootfs"

# create network namespace
CONTAINER_NET_NS="$CONTAINER_NAME-ns"
ip netns add $CONTAINER_NET_NS
VETH="veth-$CONTAINER_NAME"
ETH="eth-$CONTAINER_NAME"

# settings
echo "nameserver 8.8.8.8" > $CONTAINER_FS/etc/resolv.conf

# cgroups
CGROUP_CONTROLLERS="cpu,memory,pids"
cgcreate -g "$CGROUP_CONTROLLERS:$CONTAINER_NAME"

# network
BRIDGE_NAME="runb-bridge"
ip link add name $VETH type veth peer name $ETH
brctl addif $BRIDGE_NAME $VETH
ip link set $VETH up
ip link set $ETH netns $CONTAINER_NET_NS
ip netns exec $CONTAINER_NET_NS ip address add 10.0.0.2/24 dev $ETH
ip netns exec $CONTAINER_NET_NS ip link set $ETH up
ip netns exec $CONTAINER_NET_NS ip route add default via 10.0.0.1

# clean up :)
trap "ip netns del $CONTAINER_NET_NS" EXIT

# make a new name space.
unshare \
    --pid \
    --uts \
    --ipc \
    --mount \
    --cgroup \
    --fork \
    bash $CORE $CONTAINER_DIR $CONTAINER_NAME
