SUMMARY = "TACACS+ protocol client library and PAM module in C"
DESCRIPTION = "This PAM module support authentication, authorization (account management) and accounting (session management) performed using TACACS+ protocol designed by Cisco."
HOMEPAGE = "https://github.com/jeroennijhof/pam_tacplus"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d8e20eece214df8ef953ed5857862150"

SRCREV = "8dddbec2940f99fa4867d6b6a92d8ba10206915e"
SRCBRANCH = "fix-travis-ci"
SRC_URI = "git://gerrit.peregrine.com.br/open.source/pam-tacplus.git;branch=${SRCBRANCH};protocol=ssh"

S = "${WORKDIR}/git"

DEPENDS += " \
    libpam \
"

inherit autotools

export LDFLAGS = "-L${STAGING_LIBDIR} ${TOOLCHAIN_OPTIONS}"
export CFLAGS += "-I${S}/libtac/include ${TOOLCHAIN_OPTIONS} -std=gnu11"
export CROSS_COMPILE = "${TARGET_PREFIX}"

EXTRA_OECONF += "--enable-pamdir=${base_libdir}/security"

FILES_${PN} += "${base_libdir}/security/*"
FILES_${PN}-dbg += "${libdir}/security/.debug/*"
FILES_${PN}-staticdev += "${libdir}/*.la ${base_libdir}/security/*.la"

RDEPENDS_${PN} += "openssl"
