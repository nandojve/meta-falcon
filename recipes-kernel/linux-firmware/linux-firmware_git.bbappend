PACKAGES =+ "${PN}-rtl8188eu"
LICENSE_${PN}-rtl8188eu = "Firmware-rtlwifi_firmware"
FILES_${PN}-rtl8188eu = "/lib/firmware/rtlwifi/rtl8188e*.bin"
RDEPENDS_${PN}-rtl8188eu += "${PN}-rtl-license"

PACKAGES =+ "${PN}-88w8897"
LICENSE_${PN}-88w8897 = "Firmware-Marvell"
FILES_${PN}-88w8897 = "/lib/firmware/mwlwifi/88W8897.bin"
RDEPENDS_${PN}-88w8897 += "${PN}-marvell-license"
