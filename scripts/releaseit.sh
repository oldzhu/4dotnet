#!/bin/sh
#$1 arm or arm64
#$2 buildroot folder

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH

relpath=$HOME/vm_releases/$(date +"%d-%m-%Y")

if [ $1="arm" ]; then
	mkdir -p $relpath/arm
	cat >$relpath/arm/start-qemu.sh <<EOF
#!/bin/sh
SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")
echo \$SCRIPTPATH

\$SCRIPTPATH/qemu-system-arm -M vexpress-a9 -smp 2 -m 1024 -nographic -kernel \$SCRIPTPATH/zImage -dtb \$SCRIPTPATH/vexpress-v2p-ca9.dtb -drive file=\$SCRIPTPATH/rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 rootwait root=/dev/mmcblk0" -net nic,model=lan9118 -net user,hostfwd=tcp::2222-:22
EOF
	cp -v $HOME/buildroot/output/host/bin/qemu-system-arm $relpath/arm
	cp -v $HOME/buildroot/output/host/images/{rootfs.ext2,vexpress-v2p-ca9.dtb,zImage} $relpath/arm
	$SCRIPTPATH/patcharmvm.sh
	mkdir -p $relpath/arm/tmpfs
	sudo mount $relpath/arm/rootfs.ext $relpath/arm/tmpfs
	sudo rsync -av -m --include-from=$SCRIPTPATH/includes.txt --exclude='*' $2/output $relpath/arm/tmpfs/root/buildroot/output/
	sudo umount $relpath/arm/tmpfs
	rm -rf $relpath/arm/tmpfs
fi

if [ $1="arm64" ]; then
	mkdir -p $relpath/arm64
	cat >$relpath/arm64/start-qemu.sh <<EOF
#!/bin/sh
SCRIPT=\$(readlink -f "\$0")
SCRIPTPATH=\$(dirname "\$SCRIPT")
echo \$SCRIPTPATH

\$SCRIPTPATH/emu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 2 -m 2048 -kernel \$SCRIPTPATH/Image -append "rootwait root=/dev/vda console=ttyAMA0" -netdev user,id=eth0,hostfwd=tcp::2222-:22 -device virtio-net-device,netdev=eth0 -drive file=\$SCRIPTPATH/rootfs.ext4,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0
EOF
	cp -v $HOME/buildroot/output/host/bin/qemu-system-aarch64 $relpath/arm64
        cp -v $HOME/buildroot/output/host/images/{Image,rootfs.ext4} $relpath/arm64
	mkdir -p $relpath/arm64/tmpfs
        sudo mount $relpath/arm/rootfs.ext4 $relpath/arm64/tmpfs
        sudo rsync -av -m --include-from=$SCRIPTPATH/includes.txt --exclude='*' $2/output $relpath/arm64/tmpfs/root/buildroot/output/
        sudo umount $relpath/arm64/tmpfs
fi

