RDEPENDS_packagegroup-base-wifi_append = " \
    ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'iw', '',d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'hostapd', '',d)} \
"

RDEPENDS_packagegroup-base-ext2_append = " \
    ${@bb.utils.contains('COMBINED_FEATURES', 'ext2', 'e2fsprogs-tune2fs', '',d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'ext2', 'e2fsprogs-badblocks', '',d)} \
"
