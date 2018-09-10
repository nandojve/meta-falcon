FILESEXTRAPATHS_prepend_class-nativesdk := "${THISDIR}/files:"

SRC_URI_append_class-nativesdk = "\
    file://meson_config.sh \
    file://ppce500v2 \
"

do_install_append_class-nativesdk () {
    install -Dm 0555 ${WORKDIR}/meson_config.sh ${D}${bindir}/meson_config.sh
    install -Dm 0644 ${WORKDIR}/ppce500v2 ${D}${datadir}/meson/cross/ppce500v2
}
