SUMMARY = "AVAHI Factory Default"
LICENSE = "CLOSED"

DEPENDS = "avahi"

SRC_URI = "file://hosts \
    file://avahi-daemon.conf \
    file://http.service \
    file://sftp-ssh.service \
    file://ssh.service \
"

inherit factory-default

FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/avahi"
FACTORY_DEFAULT_URI_${PN} = "hosts;avahi-daemon.conf"

FACTORY_DEFAULT_APP_${PN}-services = "${PN}-services"
FACTORY_DEFAULT_INS_${PN}-services = "${sysconfdir}/avahi/services"
FACTORY_DEFAULT_BKP_${PN}-services = "false"
FACTORY_DEFAULT_URI_${PN}-services = "http.service;sftp-ssh.service;ssh.service"

# Define package to be installed, order is important because of childs directories
FACTORY_DEFAULT_PACKAGES = "${PN}-services ${PN}"

do_install() {
    install -Dm 644 ${WORKDIR}/hosts ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/hosts
    install -Dm 644 ${WORKDIR}/avahi-daemon.conf ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/avahi-daemon.conf

    install -Dm 644 ${WORKDIR}/http.service ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-services/http.service
    install -Dm 644 ${WORKDIR}/sftp-ssh.service ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-services/sftp-ssh.service
    install -Dm 644 ${WORKDIR}/ssh.service ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-services/ssh.service
}

FILES_${PN}-services = "${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-services"

RRECOMMENDS_${PN} = "${PN}-services"
