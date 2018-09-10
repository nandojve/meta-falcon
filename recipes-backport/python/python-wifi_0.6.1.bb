DESCRIPTION = "Provides access to Linux Wireless Extensions"
HOMEPAGE = "http://pythonwifi.wikispot.org/"
SECTION = "devel/python"
LICENSE = "LGPLv2+ & GPLv2+"
LICENSE_${PN}-examples = "GPLv2+"
LIC_FILES_CHKSUM = "file://${S}/README;beginline=54;endline=54;md5=431d00dbfa3f3faf34cfad0f4b551c3f"
LIC_FILES_CHKSUM_${PN}-examples = "file://${S}/README;beginline=55;endline=55;md5=431d00dbfa3f3faf34cfad0f4b551c3f"

RDEPENDS_${PN} = "python-ctypes python-datetime"

SRC_URI = "https://git.tuxfamily.org/pythonwifi/pythonwifi.git/snapshot/pythonwifi-${PV}.tar.bz2"
SRC_URI[md5sum] = "38c8156b67932cd25c9c325980d1366a"
SRC_URI[sha256sum] = "571247c431f5b8a1bcc5caec69621f8b5937c0893cbae79f2ac8efa202c46bc4"

inherit setuptools

S = "${WORKDIR}/pythonwifi-${PV}"

do_install_append() {
    install -d ${D}${docdir}/${PN}
    mv ${D}${datadir}/README ${D}${docdir}/${PN}
    mv ${D}${datadir}/docs/* ${D}${docdir}/${PN}

    install -d ${D}${sbindir}
    mv ${D}${datadir}/examples/* ${D}${sbindir}

    rm -rf ${D}${docdir}s
}

PACKAGES += "${PN}-examples ${PN}-examples-doc"

FILES_${PN}-examples = "${sbindir}"
FILES_${PN}-examples-doc = "${datadir}/examples"
