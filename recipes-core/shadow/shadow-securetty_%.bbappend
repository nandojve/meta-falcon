RRECOMMENDS_${PN} += "${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', '', 'shadow-securetty-factory-default', d)}"

BBCLASSEXTEND += "native nativesdk"
