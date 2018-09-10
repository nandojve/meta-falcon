# Merge machine and distro options to create a basic machine task/package
#
# Copyright (C) 2018 Peregrine CIA LTDA

SUMMARY = "Peregrine Embedded Platform (FALCON) Package Group"
DESCRIPTION = "The set of packages required to have FALCON Distro"
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
    ${@bb.utils.contains("MACHINE_FEATURES", "falcon-nas", "packagegroup-falcon-nas", "",d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "falcon-upnp", "packagegroup-falcon-upnp", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "falcon-voip", "packagegroup-falcon-voip", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "falcon-zigbee", "packagegroup-falcon-zigbee", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "falcon-pppoe", "packagegroup-falcon-pppoe", "", d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-l3', 'packagegroup-falcon-router-l3', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-cpe', 'packagegroup-falcon-router-cpe', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-webgui', 'packagegroup-falcon-webconfig', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-pbx', 'packagegroup-falcon-pbx', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-docker', 'packagegroup-falcon-docker', '',d)} \
    \
    packagegroup-falcon-devtools \
    packagegroup-falcon-router \
    packagegroup-falcon-storage \
    packagegroup-falcon-webserver \
    '

#
# packagegroup-falcon contain stuff needed for base system (machine related)
#
RDEPENDS_packagegroup-falcon = "\
    packagegroup-falcon-router \
    packagegroup-falcon-storage \
    \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-pbx', 'packagegroup-falcon-pbx', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-docker', 'packagegroup-falcon-docker', '',d)} \
    \
    ${@bb.utils.contains("DISTRO_FEATURES", "systemd", "quota", "",d)} \
    tzdata \
    firmware-version \
    htop \
    tar \
    fuse \
    lsof \
    watchdog \
    "

SUMMARY_packagegroup-falcon-nas = "Network-attached storage (NAS) support"
RDEPENDS_packagegroup-falcon-nas = "\
    packagegroup-falcon-storage \
    packagegroup-falcon-webserver \
    \
    vsftpd \
    samba \
    "

RRECOMMENDS_packagegroup-falcon-nas = "\
    packagegroup-core-nfs \
    "

SUMMARY_packagegroup-falcon-upnp = "Universal Plug & Play uPnP support"
RDEPENDS_packagegroup-falcon-upnp = "\
    gupnp-igd \
    gupnp-av \
    gupnp-dlna \
    "

SUMMARY_packagegroup-falcon-voip = "Voice over IP (VoIP) support"
RDEPENDS_packagegroup-falcon-voip = "\
    "

SUMMARY_packagegroup-falcon-pbx = "Open Source PBX and telephony support"
RDEPENDS_packagegroup-falcon-pbx = "\
    asterisk \
    bcg729 \
    "

SUMMARY_packagegroup-falcon-zigbee = "Zigbee support"
RDEPENDS_packagegroup-falcon-zigbee = "\
    packagegroup-falcon-webserver \
    "

SUMMARY_packagegroup-falcon-pppoe = "Point-to-Point Protocol over Ethernet (PPPoE) support"
RDEPENDS_packagegroup-falcon-pppoe = "\
    rp-pppoe \
    "

SUMMARY_packagegroup-falcon-devtools = "Development Tools support"
RDEPENDS_packagegroup-falcon-devtools = "\
    mmc-utils \
    mtd-utils \
    valgrind \
    vim \
    tree \
    tcpdump \
    i2c-tools \
    dosfstools \
    ntfs-3g-ntfsprogs \
    "

SUMMARY_packagegroup-falcon-router = "Router Tools support"
RDEPENDS_packagegroup-falcon-router = "\
    ${@bb.utils.contains("DISTRO_FEATURES", "ipsec", "ipsec-tools", "", d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-l3', 'packagegroup-falcon-router-l3', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-cpe', 'packagegroup-falcon-router-cpe', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-webgui', 'packagegroup-falcon-webconfig', '',d)} \
    \
    bridge-utils \
    dhcp-client \
    dhcp-server \
    bind \
    iproute2 \
    iptables \
    quagga \
    radvd \
    net-snmp \
    net-snmp-server \
    ntp \
    netkit-telnet \
    tftp-hpa \
    wget \
    curl \
    rsyslog \
    \
    python-pycurl \
    "

SUMMARY_packagegroup-falcon-router-l3 = "Router/Switch L3 Tools support"
RDEPENDS_packagegroup-falcon-router-l3 = "\
    dhcp-relay \
    mstpd \
    lldpd \
    "

SUMMARY_packagegroup-falcon-router-cpe = "Customer Premises Equipment (CPE) Tools support"
RDEPENDS_packagegroup-falcon-router-cpe = "\
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-nas', 'packagegroup-falcon-nas', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-upnp', 'packagegroup-falcon-upnp', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-voip', 'packagegroup-falcon-voip', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-zigbee', 'packagegroup-falcon-zigbee', '',d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'falcon-pppoe', 'packagegroup-falcon-pppoe', '', d)} \
    \
    openvpn \
    "

SUMMARY_packagegroup-falcon-storage = "Storage Tools support"
RDEPENDS_packagegroup-falcon-storage = "\
    btrfs-tools \
    parted \
    gptfdisk \
    util-linux-fdisk \
    util-linux-fstrim \
    util-linux-cfdisk \
    util-linux-sfdisk \
    "

SUMMARY_packagegroup-falcon-webserver = "Web Server support"
RDEPENDS_packagegroup-falcon-webserver = "\
    nginx \
    uwsgi \
    sqlite3 \
    "

SUMMARY_packagegroup-falcon-webconfig = "Web Page configuration support"
RDEPENDS_packagegroup-falcon-webconfig = "\
    packagegroup-falcon-webserver \
    "

SUMMARY_packagegroup-falcon-docker = "Linux container runtime support"
RDEPENDS_packagegroup-falcon-docker = "\
    docker \
    docker-registry \
    \
    python-docker-registry-core \
    "
