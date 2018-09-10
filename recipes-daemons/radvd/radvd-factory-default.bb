SUMMARY = "RADVD Factory Default"
LICENSE = "CLOSED"

DEPENDS = "radvd"

SRC_URI = "file://radvd.conf"

inherit factory-default

FACTORY_DEFAULT_URI_${PN} = "radvd.conf"

do_install() {
    install -Dm 644 ${WORKDIR}/radvd.conf ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/radvd.conf
}

