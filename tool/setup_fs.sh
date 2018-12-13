#!/bin/bash

set -eu

# description: print error message aand exit program
# return: 
# arg 1: message
perror_exit() {
    echo -e "\n$1" >&2
    exit 1
}

echo -n ">> checking argments..."
if [ $# -lt 2 ]; then
    perror_exit "you need to designate container directory name and image name"
fi
echo "done."

echo -n ">> checking if this is running on the root permission..."
if ! [ $EUID -eq 0 ]; then
    perror_exit "you need run this script as a root"
fi
echo "done."

CONTAINER_DIR="$PWD/$1"
IMAGE_NAME="$2"
ROOT_FS="$CONTAINER_DIR/rootfs"

echo -n ">> creating a directory for..."
mkdir -p $ROOT_FS
echo "done."

echo -n ">> cheking if docker is installed..."
IS_DOCKER_INSTALLED=$(command -v docker)
if [ -z $IS_DOCKER_INSTALLED ]; then
    rm -rf $CONTAINER_DIR
    perror_exit "you need to install docker."
fi
echo "done."

echo -n ">> creating container an image..."
docker export $(docker create $IMAGE_NAME) | tar -C $ROOT_FS -xvf - > /dev/null
echo "done."

echo ">> file system is successfully created."
