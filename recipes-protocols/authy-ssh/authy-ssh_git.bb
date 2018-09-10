DESCRIPTION = "Easy two-factor authentication for ssh servers"
HOMEPAGE = "https://github.com/authy/authy-ssh"
SECTION = "net"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=33ab1ce13e2312dddfad07f97f66321f"

DEPENDS = "openssh"

SRCREV = "724b74be20895208f663b0d774f0918da0f34981"
SRC_URI = "git://github.com/authy/authy-ssh.git;protocol=https;branch=master \
    file://authy-ssh.conf \
"

S = "${WORKDIR}/git"

do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install () {
    install -Dm 755 ${S}/authy-ssh ${D}${bindir}/authy-ssh
    install -Dm 644 ${WORKDIR}/authy-ssh.conf ${D}${bindir}/authy-ssh.conf
}

RDEPENDS_${PN} += "openssh-sshd curl"
