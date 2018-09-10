SUMMARY = "A pure Python implementation of systemd's service notification protocol (sd_notify)"
HOMEPAGE = "https://pypi.python.org/pypi/sdnotify"
SECTION = "devel/python"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=cc572ccc4b18a4b7d13be5d01bc8213e"

SRCNAME = "sdnotify"

SRC_URI = "https://github.com/bb4242/${SRCNAME}/archive/v${PV}.tar.gz"
SRC_URI[md5sum] = "441c03e3a8eb24d50d61855156682c52"
SRC_URI[sha256sum] = "da4fa5e536c7239d1a8013b0d19cedbd7778740c2662b262c33cb68fcbb85772"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

do_install_append () {
    rm -rf ${D}${datadir}
}

RDEPENDS_${PN} = "\
    systemd \
    \
    python-core \
"
