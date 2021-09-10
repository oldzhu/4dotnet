#!/bin/bash
# $1 local publish path
# $2 target folder name
# $3 path to vm rootfs

if [ $# != 3 ]; then
	echo "[usage]$(basename $0) [local publish path] [target folder name] [path to rootfs]"
        exit 0;
fi

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH
echo $3
mkdir -p $SCRIPTPATH/tmpfs

if [ -f $3/rootfs.ext2 ]; then
        sudo mount $3/rootfs.ext2 $SCRIPTPATH/tmpfs
	sudo mkdir -p $SCRIPTPATH/tmpfs/root/$2
	sudo cp -u -v $1/* $SCRIPTPATH/tmpfs/root/$2
	sudo umount $SCRIPTPATH/tmpfs
elif [ -f $3/rootfs.ext4 ]; then
        sudo mount $3/rootfs.ext4 $SCRIPTPATH/tmpfs
	sudo mkdir -p $SCRIPTPATH/tmpfs/root/$2
	sudo cp -u -v $1/* $SCRIPTPATH/tmpfs/root/$2
	sudo umount $SCRIPTPATH/tmpfs
fi

sudo rm -rf $SCRIPTPATH/tmpfs
#source $SCRIPTPATH/syncsrc.sh
