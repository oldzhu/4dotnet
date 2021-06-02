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

mkdir -p $relpath

fileexts="-iname *.c -o -iname *.h -o -iname *.cpp -o -iname *.cs -o -iname *.s -o -iname *.dbg -o -iname *.pdb"
pushd $HOME

find buildroot/output/build -type f \( $fileexts \) -print > $HOME/includefiles.txt
cat >>$HOME/includefiles.txt <<EOF
buildroot/output/host
buildroot/output/images
4dotnet/scripts/pub2img.sh
4dotnet/scripts/syncsrc.sh
4dotnet/scripts/qemu-ifup
EOF

popd
if [ $1 = "arm" ]; then
	cat >>$HOME/includefiles.txt <<EOF
4dotnet/scripts/arm
EOF
	tar -C $HOME -cJvf $relpath/dotnet_arm_linux_vm_$dtpart.tar.xz -T $HOME/includefiles.txt
fi

if [ $1 = "arm64" ]; then
	cat >>$HOME/includefiles.txt <<EOF
4dotnet/scripts/arm64
EOF
	tar -C $HOME -cJvf $relpath/dotnet_arm64_linux_vm_$dtpart.tar.xz -T $HOME/includefiles.txt
fi

rm $HOME/includefiles.txt 

