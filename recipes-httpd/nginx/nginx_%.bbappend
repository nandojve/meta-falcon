FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit systemd

SYSTEMD_SERVICE_${PN} = "nginx.service"

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'ipv6', '--with-ipv6', '', d)}"

do_install_append() {
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SBINDIR@,${sbindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
              ${D}${systemd_unitdir}/system/*.service
}
