#!/bin/bash
# the script assume it run from the same folder as the the release vm image 

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

if [ $# -eq 0 ]; then 
	dotnetcoreversion=`dotnet --info |awk -F: '/Version/{i++}i==3{print $2; exit}'`
	commithash=`dotnet --info |awk -F: '/Commit/{i++}i==2{print $2; exit}'`
elif [ $# -eq 2 ]; then
	dotnetcoreversion=$1
	commithash=$2
else
	echo "usage:$(basename $0) [version] [commithash]"
	exit 0;
fi

dotnetcoreversion="$(echo -e "${dotnetcoreversion}" | sed -e 's/^[[:space:]]*//')"
majorversion="$(echo -e "${dotnetcoreversion}" | awk -F. '{print $1;exit}')"

mkdir -p $SCRIPTPATH/mytmpsrc
pushd $SCRIPTPATH/mytmpsrc

if [ $majorversion -gt 3 ]; then
	git clone -n https://github.com/dotnet/runtime.git
	pushd $SCRIPTPATH/mytmpsrc/runtime
else
	git clone -n https://github.com/dotnet/coreclr.git
	pushd $SCRIPTPATH/mytmpsrc/coreclr
fi 
git checkout $commithash
popd

#wget ${srcdownloadlink}

popd

mkdir -p $SCRIPTPATH/tmpfs
if [ -f $SCRIPTPATH/rootfs.ext2 ]; then 
	sudo mount $SCRIPTPATH/rootfs.ext2 $SCRIPTPATH/tmpfs
elif [ -f $SCRIPTPATH/rootfs.ext4 ]; then
	sudo mount $SCRIPTPATH/rootfs.ext4 $SCRIPTPATH/tmpfs
fi

sudo mkdir -p $SCRIPTPATH/tmpfs/__w/1/s/src
sudo cp -r -u -v $SCRIPTPATH/mytmpsrc/coreclr/src/ $SCRIPTPATH/tmpfs/__w/1/s/src/
sudo umount $SCRIPTPATH/tmpfs

rm -rf $SCRIPTPATH/tmpfs
rm -rf $SCRIPTPATH/mytmpsrc
