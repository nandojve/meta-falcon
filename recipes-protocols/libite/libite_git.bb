SUMMARY = "Library ITE"
DESCRIPTION = "That missing frog DNA you've been looking for."
HOMEPAGE = "https://github.com/troglobit/libite"
LICENSE = "BSD & MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e0c1210b4e72155725ba8e860729bfc0"

SRCREV = "0a57f2128fef7d1be6a2fa5b5666fb3f94c48163"
SRC_URI = "git://gerrit.peregrine.com.br/open.source/pim-sm/libite.git;branch=master;protocol=ssh"

S = "${WORKDIR}/git"

inherit autotools pkgconfig
