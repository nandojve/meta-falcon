SUMMARY = "rsyslog Factory Default"
LICENSE = "CLOSED"

inherit factory-default

SRC_URI = "file://rsyslog.conf"

FACTORY_DEFAULT_URI_${PN} = "rsyslog.conf"

do_install() {
    # Install current (default) configuration
    install -Dm 644 ${WORKDIR}/rsyslog.conf  ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/rsyslog.conf
}
