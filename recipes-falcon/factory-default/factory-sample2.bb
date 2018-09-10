SUMMARY = "FACTORY DEFAULT Sample 2"
LICENSE = "CLOSED"

SRC_URI = "\
    file://sample-file-1.txt \
    file://sample-file-3.txt \
    file://sample-file-5.txt \
"

inherit factory-default

FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/${PN}"
FACTORY_DEFAULT_URI_${PN} = "sample-file-1.txt;sample-file-3.txt;sample-file-5.txt"

do_install() {
    install -Dm 644 ${WORKDIR}/sample-file-1.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/sample-file-1.txt
    install -Dm 644 ${WORKDIR}/sample-file-3.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/sample-file-3.txt
    install -Dm 644 ${WORKDIR}/sample-file-5.txt ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/sample-file-5.txt
}
