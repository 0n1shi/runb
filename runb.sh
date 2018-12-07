#!/bin/bash

set -eu

unshare \
    --ipc \
    --mount \
    --net \
    --pid \
    --uts \
    --user \
    --cgroup \
    --fork \
    /bin/bash "$@"
