FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://iptables-flush \
    file://iptables.service \
    file://ip6tables.service \
    file://ipv4_forwarding.conf \
    file://ipv6_forwarding.conf \
"

inherit systemd

SYSTEMD_SERVICE_${PN} = "iptables.service ip6tables.service"

do_install_append() {
    install -Dm 755 ${WORKDIR}/iptables-flush ${D}${systemd_unitdir}/scripts/iptables-flush
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
           -e 's,@LOCALSTATEDIR@,${localstatedir},g' \
              ${D}${systemd_unitdir}/scripts/iptables-flush

    install -Dm 644 ${WORKDIR}/iptables.service ${D}${systemd_unitdir}/system/iptables.service
    install -Dm 644 ${WORKDIR}/ip6tables.service ${D}${systemd_unitdir}/system/ip6tables.service
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SBINDIR@,${sbindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
           -e 's,@SYSTEMD_DIR@,${systemd_unitdir},g' \
              ${D}${systemd_unitdir}/system/*.service

    install -Dm 644 ${WORKDIR}/ipv4_forwarding.conf ${D}${sysconfdir}/sysctl.d/ipv4_forwarding.conf
    install -Dm 644 ${WORKDIR}/ipv6_forwarding.conf ${D}${sysconfdir}/sysctl.d/ipv6_forwarding.conf
}

FILES_${PN} += "${sysconfdir} ${systemd_unitdir}"

RDEPENDS_${PN} += "bash"
RRECOMMENDS_${PN} += "iptables-factory-default"
