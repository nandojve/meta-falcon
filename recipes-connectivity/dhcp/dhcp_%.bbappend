# look for files in the layer first
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://dhclient.service \
    file://dhclient6.service \
    file://dhclient6.conf \
    file://dhcp-client \
    file://dhcpd6.conf \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SYSTEMD_PACKAGES += "${PN}-client"
SYSTEMD_SERVICE_${PN}-client = "dhclient.service dhclient6.service"
SYSTEMD_AUTO_ENABLE_${PN}-client = "${@bb.utils.contains('MACHINE_FEATURES', 'falcon-l3', 'disable', 'enable', d)}"

do_install_append () {
    # Install dhcp-* config files
    install -Dm 0644 ${WORKDIR}/dhcp-client ${D}${sysconfdir}/default/dhcp-client
    install -Dm 0644 ${WORKDIR}/dhclient6.conf ${D}${sysconfdir}/dhcp/dhclient6.conf
    install -Dm 0644 ${WORKDIR}/dhcpd6.conf ${D}${sysconfdir}/dhcp/dhcpd6.conf

    # Install systemd unit files
    install -Dm 0644 ${WORKDIR}/dhclient.service ${D}${systemd_unitdir}/system/dhclient.service
    install -Dm 0644 ${WORKDIR}/dhclient6.service ${D}${systemd_unitdir}/system/dhclient6.service
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BASE_SBINDIR@,${base_sbindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SBINDIR@,${sbindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
           -e 's,@LOCALSTATEDIR@,${localstatedir},g' \
              ${D}${systemd_unitdir}/system/*.service
}

FILES_${PN}-client += "${sysconfdir}/default/dhcp-client"
FILES_${PN}-client += "${sysconfdir}/dhcp/dhclient6.conf"
FILES_${PN}-client += "${systemd_unitdir}/system/dhclient*.service"

FILES_${PN}-server += "${sysconfdir}/dhcp/dhcpd6.conf"

RRECOMMENDS_${PN}-client += "dhcp-factory-default"
RRECOMMENDS_${PN}-server += "dhcp-factory-default"
RRECOMMENDS_${PN}-relay += "dhcp-factory-default"
