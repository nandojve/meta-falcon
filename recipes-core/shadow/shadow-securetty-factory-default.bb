SUMMARY = "PAM root SecureTTY Factory Default"
LICENSE = "CLOSED"

inherit factory-default

SRC_URI = "file://securetty"

FACTORY_DEFAULT_URI_${PN} = "securetty"

do_install() {
    # Install current (default) configuration
    install -Dm 600 ${WORKDIR}/securetty ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/securetty
}
