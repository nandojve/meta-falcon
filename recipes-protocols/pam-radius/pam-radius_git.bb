SUMMARY = "RADIUS authentication module"
DESCRIPTION = "This is the PAM to RADIUS authentication module. It allows any Linux, OSX or Solaris machine to become a RADIUS client for authentication and password change requests."
HOMEPAGE = "https://github.com/FreeRADIUS/pam_radius.git"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=cbbd794e2a0a289b9dfcc9f513d1996e"

SRCREV = "6bae92df885602b2558333bdb6d2db67d1365683"
SRC_URI = "git://gerrit.peregrine.com.br/open.source/pam-radius.git;branch=master;protocol=ssh \
    file://0001-Makefile-Fix-yocto-out-of-tree-build.patch \
"

S = "${WORKDIR}/git"

DEPENDS += " \
    libpam \
"

inherit autotools pkgconfig

EXTRA_OEMAKE = " \
    SRCDIR=${S}/src \
    BUILDIR=${WORKDIR}/build \
    CFLAGS='-fPIC -Isrc -DHIGHFIRST \
    ${@base_conditional('SITEINFO_ENDIANESS', 'le', '', '-DBIG_ENDIAN', d)}' \
"

do_install() {
    mkdir -p ${D}${base_libdir}/security
    cp ${WORKDIR}/build/*.so ${D}${base_libdir}/security

    mkdir -p ${D}${includedir}
    cp -avf ${S}/src/*.h ${D}${includedir}
}

do_compile() {
    oe_runmake ${EXTRA_OEMAKE} -f ${S}/Makefile
}

do_configure() {
    ${S}/configure --prefix=${prefix} --host=${TARGET_SYS} --build=${BUILD_SYS}
}

# Fix worng packing
PACKAGES = "${PN}-dbg ${PN} ${PN}-dev ${PN}-staticdev"

FILES_${PN} += "${base_libdir}/security/*.so"
FILES_${PN}-dev += "${includedir}"
