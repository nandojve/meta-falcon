SUMMARY = "PAM security Factory Default"
LICENSE = "CLOSED"

inherit factory-default

SRC_URI = "file://access.conf"

FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/security"
FACTORY_DEFAULT_URI_${PN} = "access.conf"

do_install() {
    # Install current (default) configuration
    install -Dm 600 ${WORKDIR}/access.conf      ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/access.conf
}
