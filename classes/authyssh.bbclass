DESCRIPTION = "Authy-ssh 2FA (Two Factor Authentication) REST api"
LICENSE = "CLOSED"

inherit extrausers

#
# Add root user to two-factor group to be used in ssh connections
#
EXTRA_USERS_PARAMS = "\
    groupadd two-factor; \
    usermod -a -G two-factor root; \
"

IMAGE_INSTALL += "authy-ssh"

#
# Add Two-Factor Authentication ForceCommand to sshd_config* during image construction
#
rootfs_add_2fa_forcecommand () {
    for config in sshd_config sshd_config_readonly; do
        if [ -e ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config ]; then
            echo ""  >> ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            echo "#" >> ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            echo "# Add Two-Factor Authentication ForceCommand to \
sshd_config* during image construction" >> ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            echo "#" >> ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            echo "match Group two-factor" >> ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            echo "    ForceCommand ${bindir}/authy-ssh login" >> ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config

            sed -i -e 's,@INSTALL_DIR@,${bin_dir},g' \
                       ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
        fi
     done
}

ROOTFS_POSTINSTALL_COMMAND += "${@bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', '', 'rootfs_add_2fa_forcecommand', d)}"
