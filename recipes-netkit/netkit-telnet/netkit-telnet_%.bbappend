FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://telnet@.service file://telnet.socket"

inherit systemd

SYSTEMD_SERVICE_${PN} = "telnet.socket"

do_install_append () {
    install -Dm 644 ${WORKDIR}/telnet@.service ${D}${systemd_unitdir}/system/telnet@.service
    install -Dm 644 ${WORKDIR}/telnet.socket ${D}${systemd_unitdir}/system/telnet.socket
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SBINDIR@,${sbindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
               ${D}${systemd_unitdir}/system/*.service
}
