SUMMARY = "DHCP Factory Default"
LICENSE = "CLOSED"

DEPENDS = "dhcp"

SRC_URI = "file://dhcp-client file://dhcp-server file://dhcp-relay"

inherit factory-default

FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/default"
FACTORY_DEFAULT_URI_${PN} = "dhcp-client;dhcp-server;dhcp-relay"

do_install() {
    install -Dm 644 ${WORKDIR}/dhcp-client ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/dhcp-client
    install -Dm 644 ${WORKDIR}/dhcp-server ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/dhcp-server
    install -Dm 644 ${WORKDIR}/dhcp-relay ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/dhcp-relay
}
