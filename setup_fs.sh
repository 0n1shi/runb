#!/bin/bash

set -eu

# description: print error message aand exit program
# return: 
# arg 1: message
perror_exit() {
    echo "$1" >&2
    exit 1
}

if [ $# -lt 1 ]; then
    perror_exit "you need to designate container name"
fi

CONTAINER_DIR="$(pwd)/$1"
ROOT_FS="$CONTAINER_DIR/rootfs"

mkdir -p $ROOT_FS

IS_DOCKER_INSTALLED=$(command -v docker)
if [ ! -z $IS_DOCKER_INSTALLED ]; then
    perror_exit "you need to install docker."
fi

echo "success"
