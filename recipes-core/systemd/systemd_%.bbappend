FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "\
    file://0101-Export-message_append_cmdline.patch \
    file://0102-systemd-Make-pam-compile-shared-library.patch \
    file://0103-tmpfiles.d-Fix-FALCON-distro-start.patch \
    file://systemd-remount-fs.service \
    file://io-scheduler.service \
    file://mount-volatile.append \
    file://create-home-volatile.append \
    file://add-noexec-option-to-tmp-dir.conf \
"

PACKAGECONFIG = "\
    journal-upload \
    gcrypt \
    microhttpd \
    elfutils \
    resolved \
    networkd \
    machined \
    quotacheck \
    hostnamed \
    myhostname \
    timedated \
    timesyncd \
    localed \
    kdbus \
    logind \
    randomseed \
    polkit \
    pam \
    iptc \
    coredump \
    bzip2 \
    lz4 \
    xz \
    zlib \
"

do_install_append () {
    install -Dm 0644 ${WORKDIR}/systemd-remount-fs.service ${D}${systemd_unitdir}/system/systemd-remount-fs.service
    install -Dm 0644 ${WORKDIR}/io-scheduler.service ${D}${systemd_unitdir}/system/io-scheduler.service

    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
              ${D}${systemd_unitdir}/system/*.service

    cat ${WORKDIR}/mount-volatile.append >> ${D}${sysconfdir}/tmpfiles.d/00-create-volatile.conf
    cat ${WORKDIR}/create-home-volatile.append >> ${D}${sysconfdir}/tmpfiles.d/00-create-volatile.conf

    # Do install/remove
    ln -s ${systemd_unitdir}/system/io-scheduler.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/io-scheduler.service
    rm ${D}${systemd_unitdir}/system/sysinit.target.wants/systemd-journal-flush.service

    # Disable journal to forward message to syslog daemon
    sed -i -e 's/.*ForwardToSyslog.*/ForwardToSyslog=no/' ${D}${sysconfdir}/systemd/journald.conf

    # Add systemd Unit options
    install -Dm 0600 ${WORKDIR}/add-noexec-option-to-tmp-dir.conf ${D}${sysconfdir}/systemd/system/tmp.mount.d/options.conf
}

FALCON-SYSTEMD-RECOMMENDS = "${PN}-initramfs ${PN}-binfmt ${PN}-container ${PN}-extra-utils"
RRECOMMENDS_${PN} += "${@bb.utils.contains("DISTRO", "falcon", "${FALCON-SYSTEMD-RECOMMENDS}", "", d)}"
