SUMMARY = "PIM-SM Routing Daemon"
HOMEPAGE = "http://troglobit.com/pimd.html"
LICENSE = "MIT & MROUTED"
LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=94f108f91fab720d62425770b70dd790 \
    file://LICENSE.mrouted;md5=7d868f4a6efe4b767c66c2b08ae5ee34 \
"

SRCREV = "bcc91d3df1b23162db8d4eea72c9bcbb0535ca62"
SRC_URI = "git://gerrit.peregrine.com.br/open.source/pim-sm.git;branch=master;protocol=ssh \
    file://0001-Makefile-Fix-yocto-out-of-tree-build.patch \
    file://0002-configure-Fix-yocto-out-of-tree-build.patch \
"

S = "${WORKDIR}/git"

DEPENDS += " \
    libite \
"

inherit autotools pkgconfig

EXTRA_OEMAKE = " \
    SRCDIR=${S} \
    DESTDIR=${D} \
    CFLAGS='-I${S} -I${S}/include \
    ${@base_conditional('SITEINFO_ENDIANESS', 'le', '', '-DBIG_ENDIAN', d)}' \
    LDFLAGS=-lite \
"

# QA Issue: After gcc-6.2 qa release this error. Can be fixed disabling strip at compile time
INSANE_SKIP_${PN} = "ldflags"

do_install() {
    install -D ${WORKDIR}/build/pimd ${D}${bindir}/pimd
    install -Dm 644 ${S}/pimd.conf ${D}${sysconfdir}/pimd.conf
}

do_compile() {
    oe_runmake -f ${S}/Makefile
}

do_configure() {
    ${S}/configure
}
