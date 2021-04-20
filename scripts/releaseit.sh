#!/bin/bash

#$1 arm or arm64

if [ $# != 1 ]; then
	echo "[usage]$(basename $0) [arm|arm64]"
	exit 0;
fi

#set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH

relpath=$HOME/vm_releases/$(date +"%d-%m-%Y")

if [ $1 = "arm" ]; then
	mkdir -p $relpath/arm
	cat >$relpath/arm/start-qemu.sh <<EOF
#!/bin/sh
SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")
echo \$SCRIPTPATH

\$SCRIPTPATH/qemu-system-arm -M vexpress-a9 -smp 2 -m 1024 -nographic -kernel \$SCRIPTPATH/zImage -dtb \$SCRIPTPATH/vexpress-v2p-ca9.dtb -drive file=\$SCRIPTPATH/rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0" -net nic,model=lan9118 -net user,hostfwd=tcp::2222-:22
EOF
	cat >$relpath/arm/syncsrc.h <<EOF
#!/bin/bash
# the script assume it run from the same folder as the the release vm image

SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")

if [ \$# -eq 0 ]; then
        dotnetcoreversion=`dotnet --info |awk -F: '/Version/{i++}i==3{print \$2; exit}'`
	commithash=`dotnet --info |awk -F: '/Commit/{i++}i==2{print \$2; exit}'`
elif [ \$# -eq 2 ]; then
        dotnetcoreversion=\$1
        commithash=\$2
else
        echo "usage:\$(basename \$0) [version] [commithash]"
        exit 0;
fi

dotnetcoreversion="\$(echo -e "\${dotnetcoreversion}" | sed -e 's/^[[:space:]]*//')"
majorversion="\$(echo -e "\${dotnetcoreversion}" | awk -F. '{print \$1;exit}')"

mkdir -p \$SCRIPTPATH/mytmpsrc
pushd \$SCRIPTPATH/mytmpsrc

if [ \$majorversion -gt 3 ]; then
        git clone -n https://github.com/dotnet/runtime.git
        pushd $SCRIPTPATH/mytmpsrc/runtime
	git checkout \$commithash
	popd
else
        wget https://github.com/dotnet/coreclr/archive/refs/tags/v\$dotnetcoreversion.tar.gz
        tar -xzvf v\$dotnetcoreversion.tar.gz
fi
popd

mkdir -p \$SCRIPTPATH/tmpfs
sudo mount \$SCRIPTPATH/rootfs.ext2 \$SCRIPTPATH/tmpfs

sudo mkdir -p \$SCRIPTPATH/tmpfs/__w/1/s
if [ \$majorversion -eq 5 ]; then
        sudo mkdir -p \$SCRIPTPATH/tmpfs/__w/1/s/src/coreclr
	sudo cp -r -u -v \$SCRIPTPATH/mytmpsrc/runtime/src/coreclr/src/ \$SCRIPTPATH/tmpfs/__w/1/s/src/coreclr
elif [ \$majorversion -eq 6 ]; then
	sudo cp -r -u -v $SCRIPTPATH/mytmpsrc/runtime/src/coreclr/  $SCRIPTPATH/tmpfs/__w/1/s/src/
else
        sudo cp -r -u -v \$SCRIPTPATH/mytmpsrc/coreclr-\$dotnetcoreversion/src/ \$SCRIPTPATH/tmpfs/__w/1/s/
fi
sudo umount \$SCRIPTPATH/tmpfs
rm -rf \$SCRIPTPATH/tmpfs
rm -rf \$SCRIPTPATH/mytmpsrc
EOF
        cat >$relpath/arm/pub2img.h <<EOF
#/bin/bash
# the script assume it run from the same folder as the the release vm image
# $1 local publish path
# $2 target folder name

if [ \$# != 2 ]; then
        echo "[usage]\$(basename \$0) [local publish path] [target folder name] "
        exit 0;
fi

SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")
echo \$SCRIPTPATH

mkdir -p \$SCRIPTPATH/tmpfs
sudo mount \$SCRIPTPATH/rootfs.ext2 \$SCRIPTPATH/tmpfs

sudo mkdir -p \$SCRIPTPATH/tmpfs/root/\$2
sudo cp -u -v \$1/* $SCRIPTPATH/tmpfs/root/\$2
sudo umount \$SCRIPTPATH/tmpfs
EOF
	chmod +x $relpath/arm/start-qemu.sh
	chmod +x $relpath/arm/syncsrc.sh
	chmod +x $relpath/arm/pub2img.sh
	cp -u -v $HOME/buildroot/output/host/bin/qemu-system-arm $relpath/arm
	cp -u -v $HOME/buildroot/output/images/{rootfs.ext2,vexpress-v2p-ca9.dtb,zImage} $relpath/arm
	$SCRIPTPATH/patcharmvm.sh
	mkdir -p $relpath/arm/tmpfs
	sudo mount $relpath/arm/rootfs.ext2 $relpath/arm/tmpfs
	sudo rsync -av -m --include-from=$SCRIPTPATH/includes.txt --exclude='*' $HOME/buildroot/output/ $relpath/arm/tmpfs/root/buildroot/output/
	sudo umount $relpath/arm/tmpfs
	rm -rf $relpath/arm/tmpfs
	tar -C $HOME -czvf $relpath/dotnet_arm_linux_vm_$(date +"%d-%m-%Y").tar.gz vm_releases/$(date +"%d-%m-%Y")/arm
fi

if [ $1 = "arm64" ]; then
	mkdir -p $relpath/arm64
	cat >$relpath/arm64/start-qemu.sh <<EOF
#!/bin/sh
SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")
echo \$SCRIPTPATH

\$SCRIPTPATH/qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 2 -m 2048 -kernel \$SCRIPTPATH/Image -append "rootwait root=/dev/vda console=ttyAMA0" -netdev user,id=eth0,hostfwd=tcp::2222-:22 -device virtio-net-device,netdev=eth0 -drive file=\$SCRIPTPATH/rootfs.ext4,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0
EOF
        cat >$relpath/arm64/syncsrc.h <<EOF
#!/bin/bash
# the script assume it run from the same folder as the the release vm image

SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")

if [ \$# -eq 0 ]; then
        dotnetcoreversion=`dotnet --info |awk -F: '/Version/{i++}i==3{print \$2; exit}'`
        commithash=`dotnet --info |awk -F: '/Commit/{i++}i==2{print \$2; exit}'`
elif [ \$# -eq 2 ]; then
        dotnetcoreversion=\$1
        commithash=\$2
else
        echo "usage:\$(basename \$0) [version] [commithash]"
        exit 0;
fi

dotnetcoreversion="\$(echo -e "\${dotnetcoreversion}" | sed -e 's/^[[:space:]]*//')"
majorversion="\$(echo -e "\${dotnetcoreversion}" | awk -F. '{print \$1;exit}')"

mkdir -p \$SCRIPTPATH/mytmpsrc
pushd \$SCRIPTPATH/mytmpsrc

if [ \$majorversion -gt 3 ]; then
        git clone -n https://github.com/dotnet/runtime.git
        pushd \$SCRIPTPATH/mytmpsrc/runtime
	git checkout \$commithash
	popd
else
        wget https://github.com/dotnet/coreclr/archive/refs/tags/v\$dotnetcoreversion.tar.gz
        tar -xzvf v\$dotnetcoreversion.tar.gz
fi
popd

mkdir -p \$SCRIPTPATH/tmpfs
sudo mount \$SCRIPTPATH/rootfs.ext4 \$SCRIPTPATH/tmpfs

sudo mkdir -p \$SCRIPTPATH/tmpfs/__w/1/s
if [ \$majorversion -eq 5 ]; then
        sudo mkdir -p \$SCRIPTPATH/tmpfs/__w/1/s/src/coreclr
        sudo cp -r -u -v \$SCRIPTPATH/mytmpsrc/runtime/src/coreclr/src/ \$SCRIPTPATH/tmpfs/__w/1/s/src/coreclr
elif [ \$majorversion -eq 6 ]; then
        sudo cp -r -u -v $SCRIPTPATH/mytmpsrc/runtime/src/coreclr/  $SCRIPTPATH/tmpfs/__w/1/s/src/
else
        sudo cp -r -u -v \$SCRIPTPATH/mytmpsrc/coreclr/src/ \$SCRIPTPATH/tmpfs/__w/1/s/
fi
sudo umount \$SCRIPTPATH/tmpfs
rm -rf \$SCRIPTPATH/tmpfs
rm -rf \$SCRIPTPATH/mytmpsrc
EOF
        cat >$relpath/arm64/pub2img.h <<EOF
#/bin/bash
# the script assume it run from the same folder as the the release vm image
# $1 local publish path
# $2 target folder name

if [ \$# != 2 ]; then
        echo "[usage]\$(basename \$0) [local publish path] [target folder name] "
        exit 0;
fi

SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")
echo \$SCRIPTPATH

mkdir -p \$SCRIPTPATH/tmpfs
sudo mount \$SCRIPTPATH/rootfs.ext4 \$SCRIPTPATH/tmpfs

sudo mkdir -p \$SCRIPTPATH/tmpfs/root/\$2
sudo cp -u -v \$1/* $SCRIPTPATH/tmpfs/root/\$2
sudo umount \$SCRIPTPATH/tmpfs
EOF

rm -rf \$SCRIPTPATH/tmpfs
	chmod +x $relpath/arm64/start-qemu.sh
	chmod +x $relpath/arm64/syncsrc.sh
	chmod +x $relpath/arm64/pub2img.sh
	cp -u -v $HOME/buildroot/output/host/bin/qemu-system-aarch64 $relpath/arm64
        cp -u -v $HOME/buildroot/output/images/{Image,rootfs.ext4} $relpath/arm64
	mkdir -p $relpath/arm64/tmpfs
        sudo mount $relpath/arm64/rootfs.ext4 $relpath/arm64/tmpfs
        sudo rsync -av -m --include-from=$SCRIPTPATH/includes.txt --exclude='*' $HOME/buildroot/output/ $relpath/arm64/tmpfs/root/buildroot/output/
        sudo umount $relpath/arm64/tmpfs
	rm -rf $relpath/arm64/tmpfs
	tar -C $HOME -czvf $relpath/dotnet_arm64_linux_vm_$(date +"%d-%m-%Y").tar.gz vm_releases/$(date +"%d-%m-%Y")/arm64
fi
