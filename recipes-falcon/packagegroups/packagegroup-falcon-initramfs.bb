# Merge machine and distro options to create a basic machine task/package
#
# Copyright (C) 2018 Peregrine SA

SUMMARY = "Peregrine Embedded Platform (FALCON) Package Group InitRAMfs"
DESCRIPTION = "The set of packages required to have FALCON Distro for initramfs"
LICENSE = "Closed"

#
# packages which content depend on MACHINE_FEATURES need to be MACHINE_ARCH
#
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    ${PN} \
    \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'pcbios', 'efi' ], '${PN}-live', '${PN}-golden',d)} \
    '

#
# packagegroup-falcon contain stuff needed for base system (machine related)
#
RDEPENDS_packagegroup-falcon-initramfs = "\
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'pcbios', 'efi' ], '${PN}-live', '${PN}-golden',d)} \
    "

SUMMARY_packagegroup-falcon-initramfs-golden = "FALCON-Golden image dependencies"
RDEPENDS_packagegroup-falcon-initramfs-golden = "\
    initramfs-boot \
    \
    packagegroup-falcon-storage \
    packagegroup-base-ext2 \
    packagegroup-base-vfat \
    \
    mmc-utils \
    mtd-utils \
    tar \
    \
    firmware-upgrade \
    \
    rsyslog-initramfs-config \
    "

SUMMARY_packagegroup-falcon-initramfs-live = "FALCON-Live image dependencies"
RDEPENDS_packagegroup-falcon-initramfs-live = "\
    initramfs-live-boot \
    initramfs-live-install \
    initramfs-live-install-efi \
    "
