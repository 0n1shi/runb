#!/bin/bash

set -eu

if [ $# -ge 1 ]; then
    echo "number of arguments >= 1"
else
    echo "number of arguments < 1"
fi
