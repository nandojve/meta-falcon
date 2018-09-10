#!/bin/sh

export PATH=/sbin:/bin:/usr/sbin:/usr/bin

do_mount_fs() {
    test -d "$2" || mkdir -p "$2"

    if [[ $1 == /dev/* ]]; then
        if mount "$1" "$2"; then
            logger -plocal0.info "Mounted device $1 to $2"
        else
            logger -plocal0.error "Fail to mount device $1 to $2"
        fi
    else
        grep -q "$1" /proc/filesystems || return
        if mount -t "$1" "$1" "$2"; then
            logger -plocal0.info "Mounted filesystem $1 to $2"
        else
            logger -plocal0.error "Fail to mount filesystem $1 to $2"
        fi
    fi
}

do_mknod() {
    test -e "$1" || mknod "$1" "$2" "$3" "$4"
}

# Create default directories
mkdir -p /proc
mkdir -p /var/run
mkdir -p /var/run/lock

mount -t proc proc /proc
do_mount_fs tmpfs /run
do_mount_fs sysfs /sys
do_mount_fs devtmpfs /dev
do_mount_fs devpts /dev/pts
do_mount_fs tmpfs /dev/shm

do_mknod /dev/console c 5 1
do_mknod /dev/null c 1 3
do_mknod /dev/zero c 1 5

do_mount_fs debugfs /sys/kernel/debug
do_mount_fs /dev/mmcblk0p7 /mnt/files

# Start rsyslogd daemon
logrotate /etc/logrotate.rsyslog
rsyslogd

# Run firmware upgrade script
recover

# Stop rsyslogd daemon
RSYSLOGPID=`cat /var/run/rsyslogd.pid`
kill -TERM $RSYSLOGPID
while [ -e /proc/$RSYSLOGPID ]; do sleep 1; done
sync
if umount /mnt/files; then
    echo "Umounted /mnt/files"
fi

reboot -f
#exec sh </dev/console >/dev/console 2>/dev/console
