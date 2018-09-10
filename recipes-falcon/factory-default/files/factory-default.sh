#!/bin/bash

#ROOT="/home/<USER>/peregrine/rootfs/<machine>/rootfs"
ROOT=""
#XML_EXEC="xmlstarlet"
XML_EXEC="xml"
FACTORY_DIR="$ROOT/etc/factory-default"
FACTORY_DB="$FACTORY_DIR/factory-default-db.xml"

APPLICATIONS=`$XML_EXEC sel -t -v "count(//application)" $FACTORY_DB`

for app in `seq 1 $APPLICATIONS`;
do
    APP_NAME=`$XML_EXEC sel -t -v "//application[$app]/@name" $FACTORY_DB`
    echo "Application [$APP_NAME]"
    PACKAGES=`$XML_EXEC sel -t -v "count(//application[$app]/package)" $FACTORY_DB`
    for pkg in `seq 1 $PACKAGES`;
    do
        PKG_NAME=`$XML_EXEC sel -t -v "//application[$app]/package[$pkg]/@name" $FACTORY_DB`
        PKG_DIR=`$XML_EXEC sel -t -v "//application[$app]/package[$pkg]/@dir" $FACTORY_DB`
        echo "    Package [$PKG_NAME] Dir [$PKG_DIR]"
        RESOURCES=`$XML_EXEC sel -t -v "count(//application[$app]/package[$pkg]/resource)" $FACTORY_DB`
        for res in `seq 1 $RESOURCES`;
        do
            RES_NAME=`$XML_EXEC sel -t -v "//application[$app]/package[$pkg]/resource[$res]/@name" $FACTORY_DB`
            echo "        Resource [$RES_NAME]"

            if [ $APP_NAME = $PKG_NAME ]; then
                RES_FILE_ORI=$FACTORY_DIR/$APP_NAME/$RES_NAME
            else
                RES_FILE_ORI=$FACTORY_DIR/$APP_NAME/$PKG_NAME/$RES_NAME
            fi
            if [ ! -d $ROOT$PKG_DIR ]; then
                echo "mkdir -p $ROOT$PKG_DIR"
                mkdir -p $ROOT$PKG_DIR
            fi
            CMD="cp $RES_FILE_ORI $ROOT$PKG_DIR"
            echo $CMD
            $CMD
        done
    done
done
