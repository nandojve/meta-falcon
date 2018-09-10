SUMMARY = "FACTORY DEFAULT Class"
LICENSE = "CLOSED"

inherit factory-default-base

# factory-default-config provides the default factory default files in the
# target sysroot
FILESEXTRAPATHS_prepend := "${THISDIR}/${DISTRO}:"

DEPENDS_append = " ${FACTORY_DEFAULT_DEPENDS}"
FACTORY_DEFAULT_DEPENDS = "factory-default-config"
FACTORY_DEFAULT_DEPENDS_class-cross = ""
FACTORY_DEFAULT_DEPENDS_class-native = ""
FACTORY_DEFAULT_DEPENDS_class-nativesdk = ""

FACTORY_DEFAULT_APP_${PN} ?= "${PN}"
FACTORY_DEFAULT_INS_${PN} ?= "${sysconfdir}"
FACTORY_DEFAULT_BKP_${PN} ?= "false"
FACTORY_DEFAULT_PACKAGES ?= "${PN}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = "${FACTORY_DEFAULT_PACKAGES}"
FILES_${PN} ?= "${FACTORY_DEFAULT_BASE_DIR_APP}"

BBCLASSEXTEND = "native nativesdk"

# This preinstall function can be run in four different contexts:
#
# a) Before do_install
# b) At do_populate_sysroot_setscene when installing from sstate packages
# c) As the preinst script in the target package at do_rootfs time
# d) As the preinst script in the target package on device as a package upgrade
#
factory_default_add_preinst () {
    SYSROOT=""

    if test "x$D" != "x"; then
        # Installing into a sysroot
        SYSROOT="$D"

        # user/group lookups should match useradd/groupadd --root
        export PSEUDO_PASSWD="$SYSROOT:${STAGING_DIR_NATIVE}"
    fi

    # If we're not doing a special SSTATE/SYSROOT install
    # then set the values, otherwise use the environment
    if test "x$UA_SYSROOT" = "x"; then
        # Installing onto a target
        # Add factory-default defined only for this package
        FACTORY_DEFAULT_APP="${FACTORY_DEFAULT_APP}"
        FACTORY_DEFAULT_INS="${FACTORY_DEFAULT_INS}"
        FACTORY_DEFAULT_BKP="${FACTORY_DEFAULT_BKP}"
        FACTORY_DEFAULT_URI="${FACTORY_DEFAULT_URI}"
    else
        # Only install onto a target
        return 0
    fi

    if [ "$FACTORY_DEFAULT_BKP" != "false" ] && [ "$FACTORY_DEFAULT_BKP" != "true" ] ; then
        # Wrong definition or incomplete implementation, see recipes with more packages than default FACTORY_DEFAULT_APP_${PN}
        return -1
    fi

    # Perform dependencies additions first, since factory-default additions may depend
    # on these
    perform_factory_default_new_db_check "$SYSROOT"

    if test "x`echo $FACTORY_DEFAULT_APP | tr -d '[:space:]'`" != "x"; then
        perform_factory_default_add_approot "$FACTORY_DEFAULT_APP" "$FACTORY_DEFAULT_INS" "$FACTORY_DEFAULT_BKP" "$SYSROOT"

        if test "x`echo $FACTORY_DEFAULT_URI | tr -d '[:space:]'`" != "x"; then
            # Invoke multiple instances of add actory-default for parameter lists
            # separated by ';'
            entry=`echo "$FACTORY_DEFAULT_URI" | cut -d ';' -f 1`
            remaining=`echo "$FACTORY_DEFAULT_URI" | cut -d ';' -f 2-`
            while test "x$entry" != "x"; do
                perform_factory_default_add_default "$FACTORY_DEFAULT_APP" "$FACTORY_DEFAULT_INS" "$entry" "$SYSROOT"
                if test "x$entry" = "x$remaining"; then
                    break
                fi
                entry=`echo "$remaining" | cut -d ';' -f 1`
                remaining=`echo "$remaining" | cut -d ';' -f 2-`
            done
        fi
    fi
}

factory_default_add_sysroot () {
    # Pseudo may (do_install) or may not (do_populate_sysroot_setscene) be running 
    # at this point so we're explicit about the environment so pseudo can load if 
    # not already present.
    export PSEUDO="${FAKEROOTENV} PSEUDO_LOCALSTATEDIR=${STAGING_DIR_TARGET}${localstatedir}/pseudo ${STAGING_DIR_NATIVE}${bindir}/pseudo"
    # Explicitly set $D since it isn't set to anything
    # before do_install
    D=${STAGING_DIR_TARGET}

    # Tell the system to use the environment vars
    UA_SYSROOT=1

    for pkg in "${@get_all_pkgs(d)}"
    do
        # Add resources defined for all recipe packages
        FACTORY_DEFAULT_APP="${@get_all_var(d, 'factory_default_app', '$pkg')}"
        FACTORY_DEFAULT_INS="${@get_all_var(d, 'factory_default_ins', '$pkg')}"
        FACTORY_DEFAULT_BKP="${@get_all_var(d, 'factory_default_bkp', '$pkg')}"
        FACTORY_DEFAULT_URI="${@get_all_cmd(d, 'factory_default_uri', '$pkg')}"

        factory_default_add_preinst
    done
}

factory_default_add_sysroot_sstate () {
    if [ "${BB_CURRENTTASK}" = "package_setscene" -o "${BB_CURRENTTASK}" = "populate_sysroot_setscene" ]; then
        factory_default_add_sysroot
    fi
}

factory_default_del_sysroot_sstate () {
    if test "x${STAGING_DIR_TARGET}" != "x"; then
        if [ "${BB_CURRENTTASK}" = "configure" -o "${BB_CURRENTTASK}" = "clean" ]; then
            export PSEUDO="${FAKEROOTENV} PSEUDO_LOCALSTATEDIR=${STAGING_DIR_TARGET}${localstatedir}/pseudo ${STAGING_DIR_NATIVE}${bindir}/pseudo"

            perform_factory_default_del_approot "${STAGING_DIR_TARGET}"
        fi
    fi
}

SSTATECLEANFUNCS = "factory_default_del_sysroot_sstate"
SSTATECLEANFUNCS_class-cross = ""
SSTATECLEANFUNCS_class-native = ""
SSTATECLEANFUNCS_class-nativesdk = ""

do_install[prefuncs] += "${SYSROOTFUNC}"
SYSROOTFUNC = "factory_default_add_sysroot"
SYSROOTFUNC_class-cross = ""
SYSROOTFUNC_class-native = ""
SYSROOTFUNC_class-nativesdk = ""
SSTATEPREINSTFUNCS += "${SYSROOTPOSTFUNC}"
SYSROOTPOSTFUNC = "factory_default_add_sysroot_sstate"
SYSROOTPOSTFUNC_class-cross = ""
SYSROOTPOSTFUNC_class-native = ""
SYSROOTPOSTFUNC_class-nativesdk = ""

FACTORY_DEFAULT_SETSCENEDEPS = "pseudo-native:do_populate_sysroot_setscene"
FACTORY_DEFAULT_SETSCENEDEPS_class-cross = ""
FACTORY_DEFAULT_SETSCENEDEPS_class-native = ""
FACTORY_DEFAULT_SETSCENEDEPS_class-nativesdk = ""
do_package_setscene[depends] += "${FACTORY_DEFAULT_SETSCENEDEPS}"
do_populate_sysroot_setscene[depends] += "${FACTORY_DEFAULT_SETSCENEDEPS}"

# Recipe parse-time sanity checks
def update_factory_default_after_parse(d):
    factory_default_packages = d.getVar('FACTORY_DEFAULT_PACKAGES', True)

    if not factory_default_packages:
        raise bb.build.FuncFailed("%s inherits factory-default but doesn't set FACTORY_DEFAULT_PACKAGES" % d.getVar('FILE', False))

    for pkg in factory_default_packages.split():
        if not d.getVar('FACTORY_DEFAULT_APP_%s' % pkg, True) and not d.getVar('FACTORY_DEFAULT_INS_%s' % pkg, True) and not d.getVar('FACTORY_DEFAULT_URI_%s' % pkg, True) and not d.getVar('FACTORY_DEFAULT_BKP_%s' % pkg, True):
            bb.fatal("%s inherits factory-default but doesn't set FACTORY_DEFAULT_APP, FACTORY_DEFAULT_INS, FACTORY_DEFAULT_URI and/or FACTORY_DEFAULT_BKP for package %s" % (d.getVar('FILE', False), pkg))

python __anonymous() {
    if not bb.data.inherits_class('nativesdk', d) \
        and not bb.data.inherits_class('native', d):
        update_factory_default_after_parse(d)
}

# Return package vector from FACTORY_DEFAULT_PACKAGES in this recipe
def get_all_pkgs(d):
    import string

    factory_default_packages = d.getVar('FACTORY_DEFAULT_PACKAGES', True) or ""
    return factory_default_packages.split()

# Return a single FACTORY_DEFAULT_[APP|INS|BKP] string which includes the
# parameter for FACTORY_DEFAULT_PACKAGES in this recipe
def get_all_var(d, cmd_type, pkg):
    import string

    param_type = cmd_type.upper() + "_%s"
    params = []
    param = d.getVar(param_type % pkg, True)
    if param:
        params.append(param)

    return params

# Return a single FACTORY_DEFAULT_URI formatted string which includes the
# parameters for all FACTORY_DEFAULT_PACKAGES in this recipe
def get_all_cmd(d, cmd_type, pkg):
    import string
    
    param_type = cmd_type.upper() + "_%s"
    params = []
    param = d.getVar(param_type % pkg, True)
    if param:
        params.append(param)

    return "; ".join(params)

# Adds the preinst script into generated packages
fakeroot python populate_packages_prepend () {
    def update_factory_default_package(pkg):
        bb.debug(1, 'adding factory-default calls to preinst for %s' % pkg)

        """
        factory-default preinst is appended here because pkg_preinst may be
        required to execute on the target. Not doing so may cause
        factory-default preinst to be invoked twice, causing unwanted warnings.
        """
        preinst = d.getVar('pkg_preinst_%s' % pkg, True) or d.getVar('pkg_preinst', True)
        if not preinst:
            preinst = '#!/bin/sh\n'
        preinst += 'bbnote () {\n\techo "NOTE: $*"\n}\n'
        preinst += 'bbwarn () {\n\techo "WARNING: $*"\n}\n'
        preinst += 'bbfatal () {\n\techo "ERROR: $*"\n\texit 1\n}\n'
        preinst += 'perform_factory_default_new_db_check () {\n%s}\n' % d.getVar('perform_factory_default_new_db_check', True)
        preinst += 'perform_factory_default_add_approot () {\n%s}\n' % d.getVar('perform_factory_default_add_approot', True)
        preinst += 'perform_factory_default_add_default () {\n%s}\n' % d.getVar('perform_factory_default_add_default', True)
        preinst += d.getVar('factory_default_add_preinst', True)
        d.setVar('pkg_preinst_%s' % pkg, preinst)

        # RDEPENDS setup
        rdepends = d.getVar("RDEPENDS_%s" % pkg, True) or ""
        rdepends += ' ' + d.getVar('MLPREFIX', False) + 'factory-default-config'
        d.setVar("RDEPENDS_%s" % pkg, rdepends)

    # Add the factory-default preinstall scripts and RDEPENDS requirements
    # to packages specified by FACTORY_DEFAULT_PACKAGES
    if not bb.data.inherits_class('nativesdk', d) \
        and not bb.data.inherits_class('native', d):
        factory_default_packages = d.getVar('FACTORY_DEFAULT_PACKAGES', True) or ""
        for pkg in factory_default_packages.split():
            update_factory_default_package(pkg)
}

# Use the following to extend the factory-default with custom functions
FACTORY_DEFAULT_EXTENSION ?= ""

inherit ${FACTORY_DEFAULT_EXTENSION}
