#!/bin/bash

set -eu -x
SHELL="/bin/sh"

# get a directory which has a root file system.
if [ $# -lt 1 ]; then
    echo "you need to designate a directory which is root file system."
    exit
fi
ROOT_FS_DIR=$1

unshare \
    --ipc \
    --mount \
    --net \
    --pid \
    --uts \
    --user \
    --cgroup \
    --fork \
    $PWD/runb_core.sh $ROOT_FS_DIR
