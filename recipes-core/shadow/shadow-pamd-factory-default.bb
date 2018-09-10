SUMMARY = "Linux-PAM pam.d Factory Default"
LICENSE = "CLOSED"

inherit factory-default

SRC_URI = " \
    file://common-account \
    file://login \
    file://su \
"

FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/pam.d"
FACTORY_DEFAULT_URI_${PN} = "common-account;login;su"

do_install() {
    # Install current (default) configuration
    install -Dm 600 ${WORKDIR}/common-account   ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/common-account
    install -Dm 600 ${WORKDIR}/login            ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/login
    install -Dm 600 ${WORKDIR}/su               ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/su
}
