DESCRIPTION = "An unladen web framework for building APIs and app backends."
HOMEPAGE = "http://projects.unbit.it/uwsgi/"
SECTION = "net"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=33ab1ce13e2312dddfad07f97f66321f"

DEPENDS = "e2fsprogs python-pip yajl"

#SRCREV="af17ba57394afe3caaa607390619ee45161d04d2"
SRCREV="af44211739136e22471a2897383f34586284bf86"
SRC_URI = "git://github.com/unbit/uwsgi.git;branch=uwsgi-2.0 \
    file://remove-rpath-2.04.patch \
    file://emperor.uwsgi.service \
    file://emperor.ini \
"

PV = "2.0.14+git${SRCPV}"

S = "${WORKDIR}/git"

inherit setuptools pkgconfig systemd

# [-Werror=misleading-indentation]
CFLAGS += "-Wno-misleading-indentation"

# prevent host contamination and remove local search paths
export UWSGI_REMOVE_INCLUDES = "/usr/include,/usr/local/include"

CLEANBROKEN = "1"

SYSTEMD_SERVICE_${PN} = "emperor.uwsgi.service"

do_install_append () {
    # Install uWSGI config files
    mkdir -p ${D}${sysconfdir}/uwsgi/vassals
    install -m 0644 ${WORKDIR}/emperor.ini ${D}${sysconfdir}/uwsgi/emperor.ini

    # Install systemd unit files
    install -Dm 0644 ${WORKDIR}/emperor.uwsgi.service ${D}${systemd_unitdir}/system/emperor.uwsgi.service
    sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
           -e 's,@BINDIR@,${bindir},g' \
           -e 's,@SYSCONFDIR@,${sysconfdir},g' \
              ${D}${systemd_unitdir}/system/emperor.uwsgi.service
}
