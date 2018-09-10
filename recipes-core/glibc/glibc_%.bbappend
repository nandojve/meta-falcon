RRECOMMENDS_${PN} += "${@bb.utils.contains("DISTRO", "falcon", "glibc-locale-factory-default", "", d)}"
