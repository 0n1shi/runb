#!/bin/bash

set -eu

ip link set runb-bridge down
brctl delbr runb-bridge
echo ">> completed deletion."
