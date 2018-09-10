FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = "file://fstab.append"

do_install_append () {
    cat ${S}/fstab.append >> ${D}${sysconfdir}/fstab
}
