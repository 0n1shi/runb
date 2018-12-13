#!/bin/bash

set -eu
set -x

CORE=$PWD/lib/core.sh

# get a directory which has a root file system.
if [ $# -lt 2 ]; then
    echo "you need to designate a directory which is root file system."
    exit
fi
CONTAINER_DIR=$1
CONTAINER_NAME=$2
CONTAINER_NET_NS="$CONTAINER_NAME-ns"

ip netns add $CONTAINER_NET_NS
ip link add name "veth-$CONTAINER_NAME" type veth peer name eth0
ip link set eth0 netns $CONTAINER_NET_NS

# make a new name space.
unshare \
    --pid \
    --uts \
    --ipc \
    --net \
    --mount \
    --cgroup \
    --fork \
    bash $CORE $CONTAINER_DIR $CONTAINER_NAME
