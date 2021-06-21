#!/bin/sh
#
#  Copyright (C) 2019 Alexander Petrovskiy <alexpe@nvidia.com>
#
#  SPDX-License-Identifier: GPL-3.0
#
#  Script to pack Linux OS rootfs tarball into ONIE installer
#

DELIM="__DATA__"
CSUMCMD=sha256sum
INSTDIR=./installers
DEFINST=mellanox


usage() {
        echo "Usage: $0 [-i installer] nosu-rootfs version"
        echo "  Supported installers:"
        for file in ./installers/*; do
            inst=`basename $file`
            if [ "$inst" = "$DEFINST" ]; then
	            echo "  - `basename $file` [default]"
            else
                echo "  - `basename $file`"
            fi
        done
        exit
}

fail() {
    [ "$1" != "" ] && echo $1
    exit 1
}

[ -d $INSTDIR ] || fail "Installers dir not found: $INSTDIR"

if [ $# -lt 2 ]; then
    usage
elif [ $# -eq 2 ]; then
    INSTALLER=$DEFINST
    OSIMG=$1
    VERSION=$2
elif [ $# -eq 4 ] && [ "$1" = "-i"  ]; then
    INSTALLER=$2
    OSIMG=$3
    VERSION=$4
else
    usage
fi

DATE=`date +%Y%m%d`
ONIEIMG="nosu-$VERSION-$INSTALLER-x86_64-${DATE}.bin"
ONIECSUM="nosu-$VERSION-$INSTALLER-x86_64-${DATE}.$CSUMCMD"

INSTPATH="$INSTDIR/$INSTALLER"
[ -f $INSTPATH ] || fail "Unsupported installer: $INSTALLER"
[ -f $OSIMG ] || fail "OS image is not available: $OSIMG"

echo "== Installer selected: $INSTALLER"
echo "== Packing OS image: $OSIMG"
CSUM=$($CSUMCMD -b $OSIMG | cut -d ' ' -f 1)
sed -u "{s/__CSUM__/$CSUM/g}" $INSTPATH > $ONIEIMG
echo >> $ONIEIMG
echo $DELIM >> $ONIEIMG
cat "$OSIMG" >> $ONIEIMG
$CSUMCMD -b $ONIEIMG > $ONIECSUM
echo "== ONIE installer is ready: $ONIEIMG (`du -sh $ONIEIMG | awk '{ print $1 }'`)"
