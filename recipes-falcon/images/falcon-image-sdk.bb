DESCRIPTION = "Peregrine Embedded Platform (FALCON) image. Image with \
    FALCON support that includes everything within core-image-falcon plus \
    meta-toolchain, development headers and libraries to form a \
    standalone SDK."
LICENSE = "CLOSED"

require falcon-image.bb

IMAGE_FEATURES += " \
    debug-tweaks \
    dev-pkgs \
    dbg-pkgs \
    ptest-pkgs \
    staticdev-pkgs \
    \
    eclipse-debug \
    \
    tools-debug \
    tools-profile \
    tools-sdk \
    tools-testapps \
"

IMAGE_INSTALL += " \
    kernel-devsrc \
"

SDKIMAGE_FEATURES += "${IMAGE_FEATURES}"
SDKIMAGE_INSTALL += "${IMAGE_INSTALL}"
