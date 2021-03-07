#!/bin/sh
#$1 vm path

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH

if [ $# -eq 0 ]; then
	relpath=$HOME/vm_releases/$(date +"%d-%m-%Y")
else
	relpath=$1
fi

patch -N -d $HOME/buildroot/output/build/dotnetruntime-origin_main/src/coreclr/jit -p0 -u -b emitarm.cpp -i $HOME/4dotnet/package/dotnetcore/dotnetruntime/emitarm.cpp.mypatch
pushd $HOME/buildroot
make dotnetruntime-rebuild
rm -r $HOME/buildroot/output/build/dotnethello-1.0/localcache
make dotnethello-rebuild
popd

sudo mount $relpath/arm/rootfs.ext $relpath/arm/tmpfs
sudo cp -v $HOME/buildroot/output/target/root/dotnethello $relpath/arm/tmpfs/root/dotnethello
sudo umount $relpath/arm/tmpfs
rm -rf $relpath/arm/tmpfs
