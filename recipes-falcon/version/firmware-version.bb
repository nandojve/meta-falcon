DESCRIPTION = "Firmware version"
LICENSE = "CLOSED"

SRC_URI = "file://empty.version"

S = "${WORKDIR}"

GERRIT_STRATEGY ?= "yocto"
BUILD_NUMBER ?= "${PR}"
FIRMWARE_VERSION ?= "1.0.${BUILD_NUMBER}"

do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install () {
    install -Dm 644 ${S}/empty.version ${D}${sysconfdir}/firmware.version

    if [ "${GERRIT_STRATEGY}" != "stable" ]; then
        echo "${FIRMWARE_VERSION}-${GERRIT_STRATEGY}" > ${D}${sysconfdir}/firmware.version
    else
        echo "${FIRMWARE_VERSION}" > ${D}${sysconfdir}/firmware.version
    fi
}
