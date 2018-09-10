SUMMARY = "User/Group Factory Default"
LICENSE = "CLOSED"

inherit factory-default

FACTORY_DEFAULT_BKP_${PN} = "true"
FACTORY_DEFAULT_URI_${PN} = "passwd;passwd-;shadow;shadow-;group;group-"

# Do fake install for invoke first boot backup and create db
do_install() {
    mkdir -p ${D}${FACTORY_DEFAULT_BASE_DIR_APP}

    touch ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/passwd
    touch ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/passwd-
    touch ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/shadow
    touch ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/shadow-
    touch ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/group
    touch ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/group-
}
