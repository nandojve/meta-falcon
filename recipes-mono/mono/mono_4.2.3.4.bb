require recipes-mono/mono/mono-4.xx.inc
require recipes-mono/mono/mono-gplv2.inc
require recipes-mono/mono/${PN}-base.inc
require recipes-mono/mono/mono-${PV}.inc

PACKAGES += "${PN}-profiler "
FILES_${PN}-profiler += " ${datadir}/mono-2.0/mono/profiler/*"

