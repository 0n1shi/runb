#!/bin/bash
# https://github.com/opencontainers/runc/blob/master/libcontainer/SPEC.md

set -eu
#set -x

if [ $# -lt 2 ]; then
    echo "you need to designate a directory which has a root file system."
    exit 1
fi

# Initialization
GUID=$(id -g)
CONTAINER_DIR=$1
CONTAINER_NAME=$2
CGROUP_CONTROLLERS="cpu,memory,pids"
CONTAINER_NET_NS="$CONTAINER_NAME-ns"
ROOT_FS_DIR=$CONTAINER_DIR/rootfs
OLD_ROOT_FS_DIR=$ROOT_FS_DIR/.old_rootfs
SET_CAPS="cap_net_raw,cap_net_bind_service,cap_audit_read,cap_audit_write,cap_dac_override,cap_setfcap,cap_setpcap,cap_setgid,cap_setuid,cap_mknod,cap_chown,cap_fowner,cap_fsetid,cap_kill,cap_sys_chroot"
DROP_CAPS="cap_net_broadcast,cap_sys_module,cap_sys_rawio,cap_sys_pacct,cap_sys_admin,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_audit_control,cap_mac_override,cap_mac_admin,cap_net_admin,cap_syslog,cap_dac_read_search,cap_linux_immutable,cap_ipc_lock,cap_ipc_owner,cap_sys_ptrace,cap_sys_boot,cap_lease,cap_wake_alarm,cap_block_suspend"

# cgroup
cgclassify -g "$CGROUP_CONTROLLERS:$CONTAINER_NAME" $$

# make file system
mkdir -p $ROOT_FS_DIR/proc          && mount -t proc    -o noexec,nosuid,nodev                                      proc    $ROOT_FS_DIR/proc
mkdir -p $ROOT_FS_DIR/dev           && mount -t tmpfs   -o noexec,strictatime,mode=755                              tmpfs   $ROOT_FS_DIR/dev
mkdir -p $ROOT_FS_DIR/dev/shm       && mount -t tmpfs   -o noexec,nosuid,nodev,mode=1777,size=65536k                tmpfs   $ROOT_FS_DIR/dev/shm
mkdir -p $ROOT_FS_DIR/dev/mqueue    && mount -t mqueue  -o noexec,nosuid,nodev                                      mqueue  $ROOT_FS_DIR/dev/mqueue
mkdir -p $ROOT_FS_DIR/dev/pts       && mount -t devpts  -o noexec,nosuid,newinstance,ptmxmode=0666,mode=620,gid=5   devpts  $ROOT_FS_DIR/dev/pts
mkdir -p $ROOT_FS_DIR/sys           && mount -t sysfs   -o noexec,nosuid,nodev,ro                                   sysfs   $ROOT_FS_DIR/sys

# make special device files
mknod -m 666 $ROOT_FS_DIR/dev/null      c 1 3
mknod -m 666 $ROOT_FS_DIR/dev/zero      c 1 5
mknod -m 666 $ROOT_FS_DIR/dev/full      c 1 7
mknod -m 666 $ROOT_FS_DIR/dev/tty       c 5 0
mknod -m 666 $ROOT_FS_DIR/dev/ptmx      c 5 2
mknod -m 666 $ROOT_FS_DIR/dev/random    c 1 8
mknod -m 666 $ROOT_FS_DIR/dev/urandom   c 1 9

# terminal
touch $ROOT_FS_DIR/dev/pts/ptmx && mount --bind /dev/pts/ptmx $ROOT_FS_DIR/dev/pts/ptmx

# I/O
ln -s /proc/self/fd $ROOT_FS_DIR/dev/fd
ln -s /proc/self/fd/0 $ROOT_FS_DIR/dev/stdin
ln -s /proc/self/fd/1 $ROOT_FS_DIR/dev/stdout
ln -s /proc/self/fd/2 $ROOT_FS_DIR/dev/stderr


# etc
hostname runB

# change rootfs by chroot
exec ip netns exec $CONTAINER_NET_NS capsh --inh="$SET_CAPS" --drop="$DROP_CAPS" --uid="$UID" --gid="$GUID" --chroot="$ROOT_FS_DIR" -- -c "/bin/bash"
