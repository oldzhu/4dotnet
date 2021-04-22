#!/bin/bash
# the script assume it run from the same folder as the the release vm image 

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

if [ $# -eq 0 ]; then 
	dotnetcoreversion=\$(dotnet --info |awk -F: '/Version/{i++}i==3{print $2; exit}')
	commithash=\$(dotnet --info |awk -F: '/Commit/{i++}i==2{print $2; exit}')
elif [ $# -eq 2 ]; then
	dotnetcoreversion=$1
	commithash=$2
else
	echo "usage:$(basename $0) [version] [commithash]"
	exit 0;
fi

dotnetcoreversion="$(echo -e "${dotnetcoreversion}" | sed -e 's/^[[:space:]]*//')"
majorversion="$(echo -e "${dotnetcoreversion}" | awk -F. '{print $1;exit}')"
echo $majorversion
mkdir -p $SCRIPTPATH/mytmpsrc
pushd $SCRIPTPATH/mytmpsrc

if [ $majorversion -gt 3 ]; then
	git clone -n https://github.com/dotnet/runtime.git
	pushd $SCRIPTPATH/mytmpsrc/runtime
	git checkout $commithash
else
#       found for version 3.x.x, the commithash in .version is for the release at 
#	https://github.com/dotnet/core-setup which is not the commithash for https://github.com/dotnet/coreclr
#	so switch to download the sourcez from https://github.com/dotnet/coreclr/archive/refs/tags/v3.x.x.tar.gz
#       git clone -n https://github.com/dotnet/coreclr.git
#       pushd $SCRIPTPATH/mytmpsrc/coreclr
	pushd $SCRIPTPATH/mytmpsrc/
	wget https://github.com/dotnet/coreclr/archive/refs/tags/v$dotnetcoreversion.tar.gz
	tar -xzvf v$dotnetcoreversion.tar.gz
fi 
popd

#wget ${srcdownloadlink}

popd

mkdir -p $SCRIPTPATH/tmpfs
if [ -f $SCRIPTPATH/rootfs.ext2 ]; then 
	sudo mount $SCRIPTPATH/rootfs.ext2 $SCRIPTPATH/tmpfs
elif [ -f $SCRIPTPATH/rootfs.ext4 ]; then
	sudo mount $SCRIPTPATH/rootfs.ext4 $SCRIPTPATH/tmpfs
fi

sudo mkdir -p $SCRIPTPATH/tmpfs/__w/1/s/src/coreclr
if [ $majorversion -eq 5 ]; then
	sudo cp -r -u -v $SCRIPTPATH/mytmpsrc/runtime/src/coreclr/src/ $SCRIPTPATH/tmpfs/__w/1/s/src/coreclr/
elif [ $majorversion -eq 6 ]; then
	sudo cp -r -u -v $SCRIPTPATH/mytmpsrc/runtime/src/coreclr/  $SCRIPTPATH/tmpfs/__w/1/s/src/
else
	sudo cp -r -u -v $SCRIPTPATH/mytmpsrc/coreclr-$dotnetcoreversion/src/ $SCRIPTPATH/tmpfs/__w/1/s/
fi
sudo umount $SCRIPTPATH/tmpfs

rm -rf $SCRIPTPATH/tmpfs
rm -rf $SCRIPTPATH/mytmpsrc
