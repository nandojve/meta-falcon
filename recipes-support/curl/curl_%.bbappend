PACKAGESTOADD = "libssh2 smb smtp telnet tftp ldap ldaps proxy rtsp ssl"
PACKAGECONFIG =+ "${@bb.utils.contains("DISTRO", "falcon", "${PACKAGESTOADD}", "", d)}"
