SUMMARY = "HOSTAPD Factory Default"
LICENSE = "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/hostapd:"

DEPENDS = "hostapd"

SRC_URI = "\
    file://hostapd.conf \
    file://hostapd.accept \
    file://hostapd.deny \
    file://hostapd.wpa_psk \
"

inherit factory-default

FACTORY_DEFAULT_URI_${PN} = "hostapd.conf;hostapd.accept;hostapd.deny;hostapd.wpa_psk"

do_install() {
    install -Dm 644 ${WORKDIR}/hostapd.conf ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/hostapd.conf
    install -Dm 644 ${WORKDIR}/hostapd.accept ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/hostapd.accept
    install -Dm 644 ${WORKDIR}/hostapd.deny ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/hostapd.deny
    install -Dm 644 ${WORKDIR}/hostapd.wpa_psk ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/hostapd.wpa_psk
}
