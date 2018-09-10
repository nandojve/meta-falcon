FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI += " \
    file://0001-rtl817xdrv-Add-realtek-hostapd-sta-driver.patch;md5=0b2e9fa1a36cce14538ec014b8cbef9 \
    file://0002-rtl817xdrv-Add-options-into-hostap-driver-struct.patch;md5=6f24b64e0bcc6923cdf50d0e255351c9 \
    file://0003-rtl817xdrv-Add-entry-to-compile-driver.patch;md5=b4eb55c90341089bb354b57cedf5b4b8 \
    file://0004-rtl817xdrv-Add-Information-Element-WPS-IE-support.patch;md5=f11d31ec1589d4398cf961245099b983 \
    file://0005-rtl817xdrv-Add-bsd-defines-methods.patch;md5=98f82499a9b374c1575846b2d534133b \
    file://0006-rtl817xdrv-Skip-error-when-request-scan-of-neighbor-.patch;md5=dcf04a91240833eb9d22b7b7c475849c \
    file://0007-rtl817xdrv-Fix-bsd-driver-support.patch;md5=6d5bcb63314c2d84ada31420d63f8b4c \
    file://0008-rtl817xdrv-Add-defconfig-default-flags.patch;md5=6f092b88689aeafcdcc1fbc8bcb513fb \
    file://0009-rtl817xdrv-Add-rtl817xdrv-defconfig.patch;md5=91ea70844011e92989c817de42788639 \
"
