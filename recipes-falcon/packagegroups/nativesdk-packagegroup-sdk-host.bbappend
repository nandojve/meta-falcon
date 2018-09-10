# Add SDK complement
#
RDEPENDS_${PN} += " \
    nativesdk-gcc \
    nativesdk-cmake \
    nativesdk-meson \
    \
    nativesdk-glib-2.0-dev \
    nativesdk-ncurses-dev \
    \
    nativesdk-python-dev \
    nativesdk-python-setuptools \
    nativesdk-python3-dev \
    \
    nativesdk-perl-dev \
    nativesdk-perl-misc \
"

# Add boot-format tool into nativesdk-**-host when machine is olt8820plus
# or similar
#
RRECOMMENDS_${PN} += "\
    ${@bb.utils.contains('TUNE_FEATURES', 'ppce500v2', 'nativesdk-boot-format', '', d)} \
"
