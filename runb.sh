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

# make a new name space.
unshare \
    --pid \
    --uts \
    --ipc \
    --net \
    --mount \
    --cgroup \
    --fork \
    bash $CORE $CONTAINER_DIR
