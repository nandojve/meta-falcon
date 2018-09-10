SUMMARY = "FACTORY DEFAULT Sample"
LICENSE = "CLOSED"
DESCRIPTION = "Show how create a recipe/append to add default configuration. This use factory-default engine and factory-default-config software. All trickers will be treat by factory-default class."

SRC_URI = "\
    file://sample-file-1.txt \
    file://sample-file-2.txt \
    file://sample-file-3.txt \
    file://sample-file-4.txt \
    file://sample-file-5.txt \
"

inherit factory-default

# Add package name information 3 times
# APP_x: Define package name
# INS_x: Define install directory
# URI_x: Define files to be copied sepyreted by ';'
FACTORY_DEFAULT_APP_${PN} = "${PN}-factory"
FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/${PN}"
FACTORY_DEFAULT_URI_${PN} = "sample-file-1.txt"

FACTORY_DEFAULT_APP_${PN}-tst1 = "${PN}-tst1"
FACTORY_DEFAULT_INS_${PN}-tst1 = "${sysconfdir}/${PN}/tst1"
FACTORY_DEFAULT_BKP_${PN}-tst1 = "false"
FACTORY_DEFAULT_URI_${PN}-tst1 = "sample-file-2.txt;sample-file-3.txt"

FACTORY_DEFAULT_APP_${PN}-tst2 = "${PN}-tst2"
FACTORY_DEFAULT_INS_${PN}-tst2 = "${sysconfdir}/${PN}-tst2"
FACTORY_DEFAULT_BKP_${PN}-tst2 = "false"
FACTORY_DEFAULT_URI_${PN}-tst2 = "sample-file-3.txt;sample-file-4.txt;sample-file-5.txt"

# Define package to be installed, order is important because of childs directories
FACTORY_DEFAULT_PACKAGES = "${PN}-tst1 ${PN}-tst2 ${PN}"

do_install() {
                                                 # Install at BASE_DIR_APP/<package name>/files
    install -Dm 644 ${WORKDIR}/sample-file-1.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}/sample-file-1.txt
    install -Dm 644 ${WORKDIR}/sample-file-2.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst1/sample-file-2.txt
    install -Dm 644 ${WORKDIR}/sample-file-3.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst1/sample-file-3.txt
    install -Dm 644 ${WORKDIR}/sample-file-3.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst2/sample-file-3.txt
    install -Dm 644 ${WORKDIR}/sample-file-3.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst2/sample-file-4.txt
    install -Dm 644 ${WORKDIR}/sample-file-3.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst2/sample-file-5.txt
}

# Define files to be packaged
FILES_${PN} = "${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}"
FILES_${PN}-tst1 = "${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst1"
FILES_${PN}-tst2 = "${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-tst2"

# Recommends accordly
RRECOMMENDS_${PN} = "${PN}-tst1 ${PN}-tst2 factory-sample2"
