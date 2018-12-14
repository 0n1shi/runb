#!/bin/bash

set -eu
set -x

CORE=$PWD/lib/core.sh

# get a directory which has a root file system.
if [ $# -lt 2 ]; then
    echo "you need to designate a directory which is root file system."
    exit
fi
CONTAINER_DIR="$1/$2"
CONTAINER_NAME=$2
CONTAINER_NET_NS="$CONTAINER_NAME-ns"

# create network namespace
ip netns add $CONTAINER_NET_NS
VETH="veth-$CONTAINER_NAME"
ETH="eth-$CONTAINER_NAME"

# create veth
ip link add name $VETH type veth peer name $ETH
ip link set $VETH netns $CONTAINER_NET_NS

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
