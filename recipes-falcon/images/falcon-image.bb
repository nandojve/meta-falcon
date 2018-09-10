DESCRIPTION = "Peregrine Embedded Platform (FALCON) image. Image with \
    FALCON support that includes everything within core-image-falcon plus \
    meta-toolchain, development headers and libraries to form a \
    standalone SDK."
LICENSE = "CLOSED"

DEPENDS = "gptfdisk-native parted-native dosfstools-native mtools-native"

inherit core-image extrausers

IMAGE_FEATURES += " \
    ssh-server-openssh \
"

IMAGE_INSTALL += " \
    packagegroup-base \
    packagegroup-falcon \
    packagegroup-falcon-devtools \
"

DEBUG_BUILD ?= "0"
DEBUG_FLAGS = "-ggdb3 -O0 -fno-omit-frame-pointer"
DEBUG_OPTIMIZATION = "-ggdb3 -O0 -fno-omit-frame-pointer"

IMAGE_GEN_DEBUGFS ?= "0"
IMAGE_FSTYPES_DEBUGFS = "tar.gz"

# How to make the HASH: 'sudo mkpasswd -m sha-512 root peregrine'
USER_ROOT_PASSWD = "$6$peregrine$kpvdRVAsU6MxOKGhDS3XG5s371IHqXe/x1.baY3AGDwG4PRkQ9WMz0AwhSBzHDLFoSrENXfe/rPOgG7TvS8y./"
EXTRA_USERS_PARAMS = "usermod -p '${USER_ROOT_PASSWD}' root;"

# Default users home
USERS_HOME = "/tmp/home"
USERS_SHELL = "/bin/bash"
USERS_GROUP = "-G systemd-journal"

USER_ADMIN_NAME = "admin"
# Default password: admin
# How to make the HASH: 'mkpasswd -m sha-512 admin peregrine'
# mkpasswd was instaled from 'sudo apt-get install whois'
USER_ADMIN_PASSWD = "$6$peregrine$hBHUxM/OCVLwS1hRiWTejhPzelO3oBPpsoLO.4j4UVF2TO5zRSgMsy5LEVvtyJ6GeaCcvz7D10.U702dRtXW9/"
USER_ADMIN_PARAMS = "-p '${USER_ADMIN_PASSWD}' -u 1000 -d ${USERS_HOME} -m -r -s ${USERS_SHELL} ${USERS_GROUP}"
EXTRA_USERS_PARAMS += "useradd ${USER_ADMIN_PARAMS} ${USER_ADMIN_NAME};"

USER_SUPPORT_NAME = "support"
# Default password: support
# How to make the HASH: 'mkpasswd -m sha-512 support peregrine'
USER_SUPPORT_PASSWD = "$6$peregrine$1.TOH9TWtALOxL/0vWWDjCijBNfBicrieEIdyx3k6pMGl79UWZnlpa9BhTu8CxIf67g7JR/MJeMzc1Fwdmnb7/"
USER_SUPPORT_PARAMS = "-p '${USER_SUPPORT_PASSWD}' -u 1002 -d ${USERS_HOME} -m -r -s '/usr/bin/support.sh' ${USERS_GROUP}"
EXTRA_USERS_PARAMS += "useradd ${USER_SUPPORT_PARAMS} ${USER_SUPPORT_NAME};"

# Use PAM to accept root login. Root logins without 2FA only if debug-tweaks is enabled
ROOTFS_POSTPROCESS_COMMAND += '${@bb.utils.contains_any("IMAGE_FEATURES", [ 'debug-tweaks' ], "ssh_enable_root_password_login; ", "ssh_enable_root_2FA_login; ",d)}'

#####
# Validate RegEx with: http://regexraptor.net/
#####

#
# Enable openssh root logins
#
ssh_enable_root_password_login () {
    for config in sshd_config sshd_config_readonly; do
        if [ -e ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config ]; then
            sed -i 's/^[#[:space:]]*ChallengeResponseAuthentication[[:space:]|no|yes]*$/ChallengeResponseAuthentication yes/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            sed -i 's/^[#[:space:]]*PermitRootLogin[[:space:]|no|yes]*$/PermitRootLogin yes/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            sed -i 's/^[#[:space:]]*PasswordAuthentication[[:space:]|no|yes]*$/PasswordAuthentication no/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            sed -i 's/^[#[:space:]]*PermitEmptyPasswords[[:space:]|no|yes]*$/PermitEmptyPasswords no/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
        fi
    done
}
#
# Disable openssh root logins
#
ssh_enable_root_2FA_login () {
    for config in sshd_config sshd_config_readonly; do
        if [ -e ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config ]; then
            sed -i 's/^[#[:space:]]*ChallengeResponseAuthentication[[:space:]|no|yes]*$/ChallengeResponseAuthentication yes/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            sed -i 's/^[#[:space:]]*PermitRootLogin[[:space:]|no|yes]*$/PermitRootLogin no/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            sed -i 's/^[#[:space:]]*PasswordAuthentication[[:space:]|no|yes]*$/PasswordAuthentication no/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
            sed -i 's/^[#[:space:]]*PermitEmptyPasswords[[:space:]|no|yes]*$/PermitEmptyPasswords no/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
        fi
    done
}
