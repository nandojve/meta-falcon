SUMMARY = "FACTORY DEFAULT CONFIG"
LICENSE = "CLOSED"

SRC_URI = "file://factory-default.service \
    file://factory-default-backup.service \
    file://factory-default.sh \
    file://factory-default-backup.sh \
"

inherit factory-default-base systemd

SYSTEMD_SERVICE_${PN} = "factory-default.service factory-default-backup.service"

do_install () {
    # Install main process
    install -Dm 0744 ${WORKDIR}/factory-default.sh ${D}${bindir}/${FACTORY_DEFAULT_BASE_SRV}
    install -Dm 0744 ${WORKDIR}/factory-default-backup.sh ${D}${bindir}/${FACTORY_DEFAULT_BASE_BKP}

    # Install systemd unit files
    install -Dm 0644 ${WORKDIR}/factory-default.service ${D}${systemd_unitdir}/system/factory-default.service
    install -Dm 0644 ${WORKDIR}/factory-default-backup.service ${D}${systemd_unitdir}/system/factory-default-backup.service
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
           -e 's,@FACTORY_DEFAULT_DIR@,${FACTORY_DEFAULT_BASE_DIR},g' \
              ${D}${systemd_unitdir}/system/*.service
}

FILES_${PN} = "${FACTORY_DEFAULT_BASE_DIR} ${bindir} ${systemd_unitdir}"

RDEPENDS_${PN} = "xmlstarlet bash"
