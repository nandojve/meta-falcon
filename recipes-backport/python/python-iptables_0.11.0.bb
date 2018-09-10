SUMMARY = "Python bindings for iptables"
HOMEPAGE = "https://pypi.python.org/pypi/python-iptables"
SECTION = "devel/python"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://NOTICE;md5=a5053747d02fe1f4fd00ad25869b095b"

DEPENDS = "iptables"

SRC_URI = "https://github.com/ldx/python-iptables/archive/v${PV}.tar.gz"
SRC_URI[md5sum] = "3343e577f75a1dbd74f5f7dc56bf5475"
SRC_URI[sha256sum] = "294d962a3b013826c2c6d863a1124b9accd8bb10a9933496d85613774b01564f"

S = "${WORKDIR}/${PN}-${PV}"

inherit setuptools

RDEPENDS_${PN} = "iptables"
