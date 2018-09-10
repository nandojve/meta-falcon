FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://initramfs-rsyslog.conf \
    file://initramfs-logrotate.rsyslog.append \
"

DEPENDS += "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "systemd", "", d)}"

EXTRA_OECONF += "${@bb.utils.contains("DISTRO_FEATURES", "systemd", "--enable-imjournal --enable-omjournal", "", d)}"

do_install_append() {
    install -Dm 644 ${WORKDIR}/initramfs-rsyslog.conf ${D}${sysconfdir}/initramfs-rsyslog.conf
    install -Dm 644 ${WORKDIR}/initramfs-logrotate.rsyslog.append ${D}${sysconfdir}/initramfs-logrotate.rsyslog.append
}

PACKAGES =+ "${PN}-initramfs-config"

FILES_${PN}-initramfs-config = "${sysconfdir}/initramfs-*"

RRECOMMENDS_${PN} += "${@bb.utils.contains("DISTRO", "falcon", "rsyslog-factory-default", "", d)}"

pkg_postinst_${PN}-initramfs-config() {
    #!/bin/sh -e
    mv $D${sysconfdir}/initramfs-rsyslog.conf $D${sysconfdir}/rsyslog.conf

    cat $D${sysconfdir}/initramfs-logrotate.rsyslog.append >> $D${sysconfdir}/logrotate.rsyslog
    rm $D${sysconfdir}/initramfs-logrotate.rsyslog.append
}
