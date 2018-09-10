FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

MACHINE_RADIO_DRIVER ?= "nl80211"

SRC_URI += "\
    file://defconfig \
    file://hostapd.conf \
    ${@bb.utils.contains('MACHINE_RADIO_DRIVER', 'rtl871xdrv', 'file://defconfig_rtl817xdrv', '', d)} \
"

DEVICE_NAME_ROUTER_AP = "ONT Wireless AP"
DEVICE_NAME_SISA_AP = "SISA Wireless AP"

DEVICE_NAME = "${@bb.utils.contains("MACHINE", "sisa", "${DEVICE_NAME_SISA_AP}", "${DEVICE_NAME_ROUTER_AP}", d)}"

do_configure_append() {
    install -m 0644 ${WORKDIR}/hostapd.conf ${B}/hostapd.conf

    install -m 0644 ${WORKDIR}/defconfig ${B}/defconfig
    if [ ${@bb.utils.contains("MACHINE_RADIO_DRIVER", "rtl871xdrv", "true", "", d)}  ]; then
        cat ${WORKDIR}/defconfig_rtl817xdrv >> ${B}/defconfig
    fi

    for file in defconfig hostapd.conf; do
        sed -i -e 's,@DEVICE_NAME@,${DEVICE_NAME},g' \
               -e 's,@MODEL_NAME@,${MACHINE},g' \
               -e 's,@RADIO_DRIVER@,${MACHINE_RADIO_DRIVER},g' \
                    ${B}/$file
    done
}

RRECOMMENDS_${PN} += "hostapd-factory-default"

PACKAGE_ARCH = "${MACHINE_ARCH}"
