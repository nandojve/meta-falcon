FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "valgrind"

SRC_URI_append = "\
    file://lldpd.service \
"

do_install_append () {
    install -Dm 0644 ${WORKDIR}/lldpd.service ${D}${systemd_unitdir}/system/lldpd.service
}
