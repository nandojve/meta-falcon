SUMMARY = "Multiple Spanning Tree Protocol daemon"
LICENSE = "CLOSED"

DEPENDS = "gpon-libconfig zeromq json-c libpam systemd"

SRCBRANCH = "master"
SRCREV = "e4f0ba5a48649a3253f8b353c87c965e12aafc50"
SRC_URI = "git://github.com/mstpd/mstpd.git;branch=${SRCBRANCH};protocol=ssh"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

EXTRA_OECONF = "--sysconfdir=${sysconfdir}"

EXTRA_OEMAKE = " \
    SRCDIR=${S} \
    DESTDIR=${D} \
    CFLAGS='-I${S} -I${S}/include \
    ${@base_conditional('SITEINFO_ENDIANESS', 'le', '', '-DBIG_ENDIAN', d)}' \
    LDFLAGS=-lgponconfig -lpam -lpam_misc -lzmq -ljson-c -lsystemd \
"

do_configure() {
    autoreconf --verbose --install --force --exclude=autopoint -I m4 ${S} -W portability -visf
    ${S}/configure --prefix=${prefix} --host=${TARGET_SYS} --build=${BUILD_SYS} ${EXTRA_OECONF}
}

FILES_${PN} += "${base_libdir}"

RDEPENDS_${PN} = " \
    gpon-libconfig \
    zeromq \
    json-c \
    libpam \
    \
    python-core \
"

INSANE_SKIP_${PN} = "ldflags"
