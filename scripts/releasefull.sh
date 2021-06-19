#!/bin/bash

#$1 arm or arm64

if [ $# != 1 ]; then
	echo "[usage]$(basename $0) [arm|arm64]"
	exit 0;
fi

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

BUILDROOTPATH=$SCRIPTPATH/../../buildroot
dtpart=$(date +"%d-%m-%Y")
relpath=$HOME/vm_releases
#linuxversion="5.12.4"

mkdir -p $relpath

fileexts="-iname *.c -o -iname *.h -o -iname *.cpp -o -iname *.cs -o -iname *.s -o -iname *.dbg -o -iname *.pdb"
ex1=/test
ex2=test/
ex3=tests/

#$SCRIPTPATH/build_debug_hostqemu.sh

pushd $HOME

find buildroot/output/build -type f \( $fileexts \) -print|grep -v $ex1|grep -v $ex2|grep -v $ex3 > $HOME/includefiles.txt
linuxbuilddir=`find buildroot/output/build/ -maxdepth 1 -type d -iname linux-[0-9]*`
cat >>$HOME/includefiles.txt <<EOF
buildroot/output/host
buildroot/output/images
$linuxbuilddir/vmlinux
4dotnet/scripts/pub2img.sh
4dotnet/scripts/syncsrc.sh
4dotnet/scripts/qemu-ifup
EOF

popd

if [ $1 = "arm" ]; then
	cat >>$HOME/includefiles.txt <<EOF
4dotnet/scripts/arm
EOF
	#$SCRIPTPATH/patcharmvm.sh	
	tar -C $HOME -cJvf $relpath/dotnet_arm_linux_vm_$dtpart.tar.xz -T $HOME/includefiles.txt
	pushd $relpath
	split -n 2 -d dotnet_arm_linux_vm_$dtpart.tar.xz dotnet_arm_linux_vm_$dtpart.tar.xz.
	popd
fi

if [ $1 = "arm64" ]; then
	cat >>$HOME/includefiles.txt <<EOF
4dotnet/scripts/arm64
EOF
	tar -C $HOME -cJvf $relpath/dotnet_arm64_linux_vm_$dtpart.tar.xz -T $HOME/includefiles.txt
	pushd $relpath
	split -n 2 -d dotnet_arm64_linux_vm_$dtpart.tar.xz dotnet_arm64_linux_vm_$dtpart.tar.xz.
	popd
fi

rm $HOME/includefiles.txt 

