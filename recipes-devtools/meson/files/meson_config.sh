#!/bin/bash

if [ ! -e $1 ]; then
    echo "Invalid source file, example: meson_config.sh /opt/falcon/16.2/environment-setup-ppce500v2-falcon-linux-gnuspe"
    exit 1
fi

CROSS_FILE=`echo $1 | awk -F "-" '{print $3}'`

if [ -z $CROSS_FILE ]; then
    echo "Invalid source file, example: meson_config.sh /opt/falcon/16.2/environment-setup-ppce500v2-falcon-linux-gnuspe"
    exit 1
fi

source $1

CC="gcc"
CXX="g++"
LD="ld"
AR="ar"

rm -rf build
meson build --cross-file $OECORE_NATIVE_SYSROOT/usr/share/meson/cross/$CROSS_FILE
