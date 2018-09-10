# This bbclass provides basic functionality for factory-default settings.
# This bbclass is intended to be inherited by factory-default.bbclass.

# The following functions basically have similar logic.
# *) Perform necessary checks before invoking the actual command
# *) Invoke the actual command with flock
# *) Error out if an error occurs.

DEPENDS = "xmlstarlet-native"

FACTORY_DEFAULT_BASE_DIR = "${sysconfdir}/factory-default"
FACTORY_DEFAULT_BASE_DIR_APP = "${sysconfdir}/factory-default/${PN}"
FACTORY_DEFAULT_BASE_DB = "factory-default-db.xml"
FACTORY_DEFAULT_BASE_SRV = "factory-default.sh"
FACTORY_DEFAULT_BASE_BKP = "factory-default-backup.sh"

# Note that before invoking these functions, make sure the global variable
# PSEUDO is set up correctly.

# NOTE: xargs remove leading & trail [[:space:]]

perform_factory_default_new_db_check () {
    local rootdir=`echo $1 | xargs`
    local dbfile="$rootdir${FACTORY_DEFAULT_BASE_DIR}/${FACTORY_DEFAULT_BASE_DB}"

    if [ ! -f $dbfile ]; then
        bbnote "factory-default: Performing new db with [$rootdir]"
        mkdir -p `dirname $dbfile`
        touch $dbfile
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $dbfile
        echo "<factory-default version=\"1.0\"/>" >> $dbfile
        echo "" >> $dbfile
    fi
}

perform_factory_default_add_approot () {
    local approot=`echo $1 | xargs`
    local insroot=`echo $2 | xargs`
    local bkproot=`echo $3 | xargs`
    local rootdir=`echo $4 | xargs`
    local dbfile="$rootdir${FACTORY_DEFAULT_BASE_DIR}/${FACTORY_DEFAULT_BASE_DB}"

    bbnote "factory-default [${PN}]: Performing add root with [$approot] [$insroot] [$bkproot] [$dbfile]"

    # Add /factory-default/application[recipe] if not exists
    xml sel -t -c "/factory-default/application[@name='${PN}']" $dbfile >> /dev/null
    if [ "$?" = "1" ]; then
        xml ed --inplace \
            -s "/factory-default" -t elem -n applicationTMP -v "" \
            -i "//applicationTMP" -t attr -n name -v "${PN}" \
            -r "//applicationTMP" -v application \
            $dbfile
    fi

    # Add/Update /factory-default/application[name=recipe]/package[name=pkg]
    xml sel -t -c "/factory-default/application[@name='${PN}']/package[@name='$approot']" $dbfile >> /dev/null
    if [ "$?" = "1" ]; then
        xml ed --inplace \
            -s "//application[@name='${PN}']" -t elem -n packageTMP -v "" \
            -i "///packageTMP" -t attr -n name -v "$approot" \
            -i "///packageTMP" -t attr -n dir -v "$insroot" \
            -i "///packageTMP" -t attr -n backup -v "$bkproot" \
            -r "///packageTMP" -v package \
            $dbfile
    else
        xml ed --inplace \
            -u "/factory-default/application[@name='${PN}']/package[@name='$approot']/@dir" -v "$insroot" \
            $dbfile
    fi
}

perform_factory_default_add_default () {
    local approot=`echo $1 | xargs`
    local insroot=`echo $2 | xargs`
    local entry=`echo $3 | xargs`
    local rootdir=`echo $4 | xargs`
    local dbfile="$rootdir${FACTORY_DEFAULT_BASE_DIR}/${FACTORY_DEFAULT_BASE_DB}"

    bbnote "factory-default [${PN}]: Performing add resource with [$approot] [$insroot] [$entry] [$dbfile]"

    # Add /factory-default/application[name=recipe]/package[name=pkg]/resource[name=entry]
    xml sel -t -c "/factory-default/application[@name='${PN}']/package[@name='$approot']/resource[@name='$entry']" $dbfile >> /dev/null
    if [ "$?" = "1" ]; then
        xml ed --inplace \
            -s "//application[@name='${PN}']/package[@name='$approot']" \
            -t elem -n resourceTMP -v "" \
            -i "////resourceTMP" -t attr -n name -v "$entry" \
            -r "////resourceTMP" -v resource \
            $dbfile
    fi
}

perform_factory_default_del_approot () {
    local rootdir=`echo $1 | xargs`
    local dbfile="$rootdir${FACTORY_DEFAULT_BASE_DIR}/${FACTORY_DEFAULT_BASE_DB}"

    bbnote "factory-default [${PN}]: Performing del at [$dbfile]"

    if [ -f $dbfile ]; then
         xml ed --inplace \
            -d "/factory-default/application[@name='${PN}']" \
            $dbfile
    fi
}
