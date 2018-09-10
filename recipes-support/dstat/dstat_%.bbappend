FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://dstat.service \
    file://dstat.timer \
"

inherit systemd

SYSTEMD_SERVICE_${PN} = "dstat.timer"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -Dm 0644 ${WORKDIR}/dstat.service ${D}${systemd_unitdir}/system/dstat.service
        install -Dm 0644 ${WORKDIR}/dstat.timer ${D}${systemd_unitdir}/system/dstat.timer

        sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
               -e 's,@BINDIR@,${bindir},g' \
                  ${D}${systemd_unitdir}/system/dstat.service
    fi
}

FILES_${PN} += "${systemd_unitdir}"
