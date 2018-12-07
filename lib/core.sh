#!/bin/bash

set -eu
set -x

if [ $# -lt 1 ]; then
    echo "you need to designate a directory which has a root file system."
    exit 1
fi
CONTAINER_DIR=$1
ROOT_FS_DIR=$CONTAINER_DIR/rootfs

mount -t proc proc $ROOT_FS_DIR/proc

chroot $ROOT_FS /bin/sh
