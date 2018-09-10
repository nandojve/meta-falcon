DESCRIPTION = "Peregrine Embedded Platform (FALCON) image."
LICENSE = "CLOSED"

require recipes-core/images/core-image-minimal.bb

IMAGE_FEATURES += " \
    ssh-server-openssh \
"

IMAGE_INSTALL += " \
    mtd-utils \
"
