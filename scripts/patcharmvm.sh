#!/bin/bash
#$1 vm path

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH

#if [ $# -eq 0 ]; then
#	relpath=$HOME/vm_releases/$(date +"%d-%m-%Y")
#else
#	relpath=$1
#fi

runtimepath=$(find $HOME/buildroot/output/build -maxdepth 1  -name dotnetruntime-\* -type d -print -quit)
patch -N -d $runtimepath/src/coreclr/jit -p0 -u -b emitarm.cpp -i $HOME/4dotnet/package/dotnetcore/dotnetruntime/emitarm.cpp.mypatch
#set -e
pushd $HOME/buildroot

export PATH=`echo $PATH|tr -d ' '`
rm -rf $runtimepath/artifacts
make dotnetruntime-rebuild
rm -r $HOME/buildroot/output/build/dotnethello-1.0/localcache
make dotnethello-rebuild
popd

#mkdir -p $relpath/arm/tmpfs
#sudo mount $relpath/arm/rootfs.ext2 $relpath/arm/tmpfs
#sudo cp -u -v $HOME/buildroot/output/target/root/dotnethello/* $relpath/arm/tmpfs/root/dotnethello
#sudo umount $relpath/arm/tmpfs
#rm -rf $relpath/arm/tmpfs
mkdir -p $SCRIPTPATH/tmpfs
sudo mount $HOME/buildroot/output/images/rootfs.ext2 $SCRIPTPATH/tmpfs
sudo cp -u -v $HOME/buildroot/output/target/root/dotnethello/* $SCRIPTPATH/tmpfs/root/dotnethello

# fix the illegal instruction when run clrstack in arm
sudo cp -v $HOME/buildroot/output/target/root/dotnethello/{System.Collections.Immutable.dll,System.Reflection.Metadata.dll} $SCRIPTPATH/tmpfs/root/.dotnet/sos

sudo umount $SCRIPTPATH/tmpfs
rm -rf $SCRIPTPATH/tmpfs
