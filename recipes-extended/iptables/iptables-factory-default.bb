SUMMARY = "IPTABLES Factory Default"
LICENSE = "CLOSED"

DEPENDS = "iptables"

SRC_URI = " \
    file://iptables.rules \
    file://ip6tables.rules \
    file://rules/empty-filter.rules \
    file://rules/empty-mangle.rules \
    file://rules/empty-nat.rules \
    file://rules/empty-raw.rules \
    file://rules/empty-security.rules \
"

inherit factory-default

FACTORY_DEFAULT_INS_${PN} = "${sysconfdir}/iptables"
FACTORY_DEFAULT_URI_${PN} = "iptables.rules;ip6tables.rules"

FACTORY_DEFAULT_APP_${PN}-v4rules = "${PN}-v4rules"
FACTORY_DEFAULT_INS_${PN}-v4rules = "${localstatedir}/lib/iptables"
FACTORY_DEFAULT_BKP_${PN}-v4rules = "false"
FACTORY_DEFAULT_URI_${PN}-v4rules = "\
    empty-filter.rules;empty-mangle.rules;empty-nat.rules;\
    empty-raw.rules;empty-security.rules"

FACTORY_DEFAULT_APP_${PN}-v6rules = "${PN}-v6rules"
FACTORY_DEFAULT_INS_${PN}-v6rules = "${localstatedir}/lib/ip6tables"
FACTORY_DEFAULT_BKP_${PN}-v6rules = "false"
FACTORY_DEFAULT_URI_${PN}-v6rules = "${FACTORY_DEFAULT_URI_${PN}-v4rules}"

# Define package to be installed, order is important because of childs directories
FACTORY_DEFAULT_PACKAGES = "${PN}-v4rules ${PN}-v6rules ${PN}"

do_install() {
    install -Dm 644 ${WORKDIR}/iptables.rules ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/iptables.rules
    install -Dm 644 ${WORKDIR}/ip6tables.rules ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/ip6tables.rules

    install -d ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-v4rules
    install -m 644 ${WORKDIR}/rules/*.rules ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-v4rules

    install -d ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-v6rules
    install -m 644 ${WORKDIR}/rules/*.rules ${D}${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-v6rules
}

FILES_${PN} = "${FACTORY_DEFAULT_BASE_DIR_APP}"
FILES_${PN}-v4rules = "${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-v4rules"
FILES_${PN}-v6rules = "${FACTORY_DEFAULT_BASE_DIR_APP}/${PN}-v6rules"

RRECOMMENDS_${PN} = "${PN}-v4rules ${PN}-v6rules"
