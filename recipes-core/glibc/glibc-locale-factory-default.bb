SUMMARY = "LOCALE Factory Default"
LICENSE = "CLOSED"

DEPENDS = "glibc glibc-locale"

SRC_URI = "file://locale.conf"

inherit factory-default

FACTORY_DEFAULT_URI_${PN} = "locale.conf"

do_install() {
    install -Dm 644 ${WORKDIR}/locale.conf ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/locale.conf
}
