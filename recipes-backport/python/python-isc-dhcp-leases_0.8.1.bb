DESCRIPTION = "Small python module for reading /var/lib/dhcp/dhcpd.leases \
 from isc-dhcp-server"
HOMEPAGE = "https://github.com/MartijnBraam/python-isc-dhcp-leases"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=83cfa4715a89874c528329d3c2a493b1"

SRC_URI = "https://github.com/MartijnBraam/python-isc-dhcp-leases/archive/0.8.1.tar.gz"
SRC_URI[md5sum] = "00f49b5c4b28d1cf9ebee5f57f4cacc1"
SRC_URI[sha256sum] = "6b76149427a10ccc155193e83c455ec61acf3ea798a32e2e1d14f4b3a78597bc"

S = "${WORKDIR}/${PN}-${PV}"

inherit setuptools

RDEPENDS_${PN} += "dhcp-server"
