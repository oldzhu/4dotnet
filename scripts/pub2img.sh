#/bin/bash
# the script assume it run from the same folder as the the release vm image
# $1 local publish path
# $2 target folder name

if [ $# != 2 ]; then
	echo "[usage]$(basename $0) [local publish path] [target folder name] "
        exit 0;
fi

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

mkdir -p $SCRIPTPATH/tmpfs

if [ -f $SCRIPTPATH/rootfs.ext2 ]; then
        sudo mount $SCRIPTPATH/rootfs.ext2 $SCRIPTPATH/tmpfs
elif [ -f $SCRIPTPATH/rootfs.ext4 ]; then
        sudo mount $SCRIPTPATH/rootfs.ext4 $SCRIPTPATH/tmpfs
fi

sudo mkdir -p $SCRIPTPATH/tmpfs/root/$2
sudo cp -u -v $1/* $SCRIPTPATH/tmpfs/root/$2
sudo umount $SCRIPTPATH/tmpfs
rm -rf $SCRIPTPATH/tmpfs
#source $SCRIPTPATH/syncsrc.sh
