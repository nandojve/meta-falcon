RRECOMMENDS_${PN} += "shadow-factory-default"
RRECOMMENDS_${PN} += "shadow-pamd-factory-default"
RRECOMMENDS_${PN} += "shadow-security-factory-default"
RRECOMMENDS_${PN} += "shadow-securetty"

PAM_PLUGINS += " \
    pam-plugin-access \
    pam-plugin-cracklib \
    pam-plugin-listfile \
    pam-plugin-succeed-if \
"
