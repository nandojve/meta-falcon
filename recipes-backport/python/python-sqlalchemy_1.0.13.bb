DESCRIPTION = "Python SQL toolkit and Object Relational Mapper that gives \
application developers the full power and flexibility of SQL"
HOMEPAGE = "http://www.sqlalchemy.org/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d7dba1721bc8ce05d421f7279cb87971"
RDEPENDS_${PN} += "python-numbers"

SRC_URI = "https://github.com/zzzeek/sqlalchemy/archive/rel_1_0_13.tar.gz"
SRC_URI[md5sum] = "0fe88b1ee82e9d1277d65f17effabd06"
SRC_URI[sha256sum] = "92fea9e89b3379eb6d00288cfab218e30308e9d5f5d0912f49f90da1a2b6d7b8"
S = "${WORKDIR}/sqlalchemy-rel_1_0_13"

inherit setuptools
